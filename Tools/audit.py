#!/usr/bin/env python3
"""Layer audit for Iris (layer-auditor skill, checks C1, C2, C8, C9, C10, C12 plus dead-file and TODO scans).
C12 locks the Apple identity AND the signing policy: project.yml (XcodeGen source of truth), the generated pbxproj and the
sources must agree on the bundle identifiers, the development team, and the mixed development/distribution signing validated
by Release Gates 4C and 4D (Docs/ReleaseGate4/10_RELEASE_SIGNING.md).
Run from the project root: python3 Tools/audit.py [--write-file-map]
"""
import os, re, sys, subprocess

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
LAYERS = {
    "App": "App", "Domain": "Domain", "GameEngine": "GameEngine", "AR": "AR", "Audio": "Audio", "Haptics": "Haptics",
    "Navigation": "Presentation", "Features": "Presentation", "DesignSystem": "DesignSystem", "Commerce": "Commerce",
    "Tests": "Tests",
}
# C1 also keeps StoreKit out of everything but the Commerce layer and the one interface file that presents Apple's
# own redemption sheet (Features/Paywall/OfferCodeRedemption.swift, checked by CommerceBoundaryTests).
FORBIDDEN = {
    "Domain": {"SwiftUI", "UIKit", "ARKit", "AVFoundation", "AVFAudio", "Combine", "SwiftData", "CoreData", "QuartzCore", "StoreKit"},
    "GameEngine": {"SwiftUI", "UIKit", "ARKit", "AVFoundation", "AVFAudio", "Combine", "SwiftData", "CoreData", "QuartzCore", "StoreKit"},
    "DesignSystem": {"StoreKit"},
    "AR": {"SwiftUI", "StoreKit"},
    "Audio": {"SwiftUI", "UIKit", "ARKit", "StoreKit"},
    "Haptics": {"SwiftUI", "ARKit", "AVFoundation", "AVFAudio", "StoreKit"},
    "Commerce": {"SwiftUI", "UIKit", "ARKit", "AVFoundation", "AVFAudio", "CoreData", "SwiftData"},
}
TYPE_DECL = re.compile(r"^(?:@\w+(?:\([^)]*\))?\s+)*(?:public |internal |private |fileprivate )?(?:final )?(struct|class|enum|protocol|actor)\s+(\w+)", re.M)

def swift_files():
    for base in LAYERS:
        for dirpath, _, files in os.walk(os.path.join(ROOT, base)):
            for f in files:
                if f.endswith(".swift"):
                    yield os.path.relpath(os.path.join(dirpath, f), ROOT)

def layer_of(path):
    return LAYERS[path.split(os.sep)[0]]

def strip_strings_and_comments(text):
    text = re.sub(r"//.*", "", text)
    text = re.sub(r'"""[\s\S]*?"""', '""', text)
    text = re.sub(r'"(?:\\.|[^"\\])*"', '""', text)
    return text

findings = {"C1": [], "C2": [], "C8": [], "C9": [], "TODO": [], "C10": [], "C12": []}
rows = []
files = sorted(swift_files())
for path in files:
    text = open(os.path.join(ROOT, path)).read()
    layer = layer_of(path)
    imports = set(re.findall(r"^import (\w+)", text, re.M))
    for banned in FORBIDDEN.get(layer, set()):
        if banned in imports:
            findings["C1"].append(f"{path}: imports {banned}")
    if layer == "DesignSystem":
        for token in ["GameSession", "Target(", "AppCoordinator", "GameViewModel"]:
            if token in text:
                findings["C1"].append(f"{path}: references {token}")
    decls = TYPE_DECL.findall(text)
    top_level = []
    for line in text.splitlines():
        m = TYPE_DECL.match(line)
        if m and not line.startswith((" ", "\t")):
            top_level.append(m.group(2))
    name = os.path.splitext(os.path.basename(path))[0]
    primary = name.split("+")[0]
    if top_level and primary not in top_level and not name.endswith("Tests") and "+" not in name and "Fixture" not in name and "Mock" not in name:
        findings["C2"].append(f"{path}: file name does not match a top-level type {top_level}")
    code = strip_strings_and_comments(text)
    if layer in ("Presentation", "DesignSystem"):
        if re.search(r"Color\((red|hex)", code) or re.search(r"\.font\(\.system\(size:", code) and layer == "Presentation" and "Rendering" not in path:
            findings["C8"].append(f"{path}: raw colour or font literal")
    if layer != "Tests":
        for m in re.finditer(r"\btry!\s", code):
            findings["C9"].append(f"{path}: try!")
        for m in re.finditer(r"\bas!\s", code):
            findings["C9"].append(f"{path}: as!")
        for m in re.finditer(r"fatalError\(", code):
            findings["C9"].append(f"{path}: fatalError")
        for m in re.finditer(r"[\w\)\]]\!(?=[\.\s,\)\]\}]|$)", code):
            snippet = code[max(0, m.start()-25):m.end()+5].replace("\n", " ")
            if "!=" in snippet[20:30]:
                continue
            findings["C9"].append(f"{path}: force unwrap near '{snippet.strip()}'")
    for m in re.finditer(r"\bTODO\b|\bFIXME\b", text):
        findings["TODO"].append(f"{path}")
    purpose = ""
    pm = re.search(r"^// Purpose: (.*)$", text, re.M)
    if pm:
        purpose = pm.group(1).strip()
    kind = top_level and TYPE_DECL.search(text) and TYPE_DECL.search(text).group(1) or "-"
    rows.append((path, kind, layer, purpose))

# --- C12 signing policy (pure, testable) ---
# Iris signs with a MIXED policy, established and proven by Release Gates 4C and 4D
# (Docs/ReleaseGate4/10_RELEASE_SIGNING.md). Anything outside it is a finding:
#   development — project-level configurations, the Iris target in Debug, both test configurations:
#       CODE_SIGN_STYLE = Automatic, CODE_SIGN_IDENTITY = Apple Development, NO provisioning profile pinned
#   distribution — the Iris application target in Release, and nowhere else:
#       CODE_SIGN_STYLE = Manual, CODE_SIGN_IDENTITY = Apple Distribution, DEVELOPMENT_TEAM = G4U9RG5GL7,
#       PROVISIONING_PROFILE_SPECIFIER = Iris App Store Connect Distribution
# `signing_findings` decides from settings alone — no file, no environment — so the policy can be exercised on
# synthetic configurations without touching project.yml or the generated project.
APP_BUNDLE_ID = "net.steve-s.iris"
TESTS_BUNDLE_ID = "net.steve-s.iris.tests"
TEAM_ID = "G4U9RG5GL7"
RETIRED_PREFIX = "com.prodx0x"
RELEASE_PROFILE = "Iris App Store Connect Distribution"
DEV_IDENTITY = "Apple Development"
DIST_IDENTITY = "Apple Distribution"

def classify_target(settings):
    """app, tests or project — read from what the configuration builds, never from its bundle identifier."""
    if "TEST_HOST" in settings or "BUNDLE_LOADER" in settings:
        return "tests"
    if "INFOPLIST_FILE" in settings or settings.get("PRODUCT_NAME") == "Iris":
        return "app"
    return "project"

def parse_build_configurations(pbx):
    """[(configuration name, settings)] for every XCBuildConfiguration of a pbxproj."""
    out = []
    for body, name in re.findall(r"isa = XCBuildConfiguration;(.*?)name = ([A-Za-z0-9_]+);", pbx, re.S):
        out.append((name, dict(re.findall(r'^\s*([A-Z_][A-Z0-9_]*) = "?([^";]*)"?;', body, re.M))))
    return out

def resolve_configurations(parsed):
    """Apply Xcode inheritance: a target setting wins, else the project-level value of the same configuration."""
    project_level = {name: s for name, s in parsed if classify_target(s) == "project"}
    resolved = []
    for name, settings in parsed:
        target = classify_target(settings)
        if target == "project":
            continue
        merged = dict(project_level.get(name, {}))
        merged.update(settings)
        resolved.append({"target": target, "config": name, "settings": merged})
    for name, settings in project_level.items():
        resolved.append({"target": "project", "config": name, "settings": dict(settings)})
    return resolved

def signing_findings(configurations, where="project.pbxproj"):
    """Pure policy decision over [{"target", "config", "settings"}]. Empty list means the policy holds."""
    out = []
    for entry in configurations:
        target, config, s = entry["target"], entry["config"], entry["settings"]
        label = f"{where}: {target}/{config}"
        style = s.get("CODE_SIGN_STYLE")
        identity = s.get("CODE_SIGN_IDENTITY")
        profile = s.get("PROVISIONING_PROFILE_SPECIFIER") or s.get("PROVISIONING_PROFILE")
        team = s.get("DEVELOPMENT_TEAM")
        bundle = s.get("PRODUCT_BUNDLE_IDENTIFIER")
        if target == "app" and config == "Release":
            if style != "Manual":
                out.append(f"{label}: CODE_SIGN_STYLE = {style}; App Store distribution requires Manual")
            if identity != DIST_IDENTITY:
                out.append(f"{label}: CODE_SIGN_IDENTITY = {identity}; App Store distribution requires {DIST_IDENTITY}")
            if profile != RELEASE_PROFILE:
                out.append(f"{label}: provisioning profile = {profile}; the only allowed profile is `{RELEASE_PROFILE}`")
            if team != TEAM_ID:
                out.append(f"{label}: DEVELOPMENT_TEAM = {team}; expected {TEAM_ID}")
        else:
            if style not in (None, "Automatic"):
                out.append(f"{label}: CODE_SIGN_STYLE = {style}; only the Iris Release configuration may leave Automatic")
            if identity not in (None, DEV_IDENTITY):
                out.append(f"{label}: CODE_SIGN_IDENTITY = {identity}; only the Iris Release configuration may leave {DEV_IDENTITY}")
            if profile:
                out.append(f"{label}: a provisioning profile is pinned ({profile}); only the Iris Release configuration may pin one")
            if team not in (None, TEAM_ID):
                out.append(f"{label}: DEVELOPMENT_TEAM = {team}; expected {TEAM_ID}")
        if target == "app" and bundle not in (None, APP_BUNDLE_ID):
            out.append(f"{label}: PRODUCT_BUNDLE_IDENTIFIER = {bundle}; expected {APP_BUNDLE_ID}")
        if target == "tests" and bundle not in (None, TESTS_BUNDLE_ID):
            out.append(f"{label}: PRODUCT_BUNDLE_IDENTIFIER = {bundle}; expected {TESTS_BUNDLE_ID}")
    return out
# --- end C12 signing policy ---

# C12: Apple identity lock (README, "Apple Signing"). project.yml is the source of truth; the pbxproj is generated from it.
spec = open(os.path.join(ROOT, "project.yml")).read()
for expected in (f"bundleIdPrefix: net.steve-s\n", f"PRODUCT_BUNDLE_IDENTIFIER: {APP_BUNDLE_ID}\n", f"PRODUCT_BUNDLE_IDENTIFIER: {TESTS_BUNDLE_ID}\n",
                 f"DEVELOPMENT_TEAM: {TEAM_ID}\n", "CODE_SIGN_STYLE: Automatic\n",
                 f"CODE_SIGN_IDENTITY: {DIST_IDENTITY}\n", "CODE_SIGN_STYLE: Manual\n",
                 f"PROVISIONING_PROFILE_SPECIFIER: {RELEASE_PROFILE}\n"):
    if expected not in spec:
        findings["C12"].append(f"project.yml: missing `{expected.strip()}`")
for value in re.findall(r"PROVISIONING_PROFILE_SPECIFIER: *(.+)", spec):
    if value.strip() != RELEASE_PROFILE:
        findings["C12"].append(f"project.yml: provisioning profile `{value.strip()}`; the only allowed profile is `{RELEASE_PROFILE}`")
if re.search(r"^\s*PROVISIONING_PROFILE:", spec, re.M):
    findings["C12"].append("project.yml: PROVISIONING_PROFILE pins a profile by UUID; pin by name with PROVISIONING_PROFILE_SPECIFIER")
pbx_path = os.path.join(ROOT, "Iris.xcodeproj", "project.pbxproj")
if os.path.exists(pbx_path):
    pbx = open(pbx_path).read()
    for value in re.findall(r"PRODUCT_BUNDLE_IDENTIFIER = \"?([^\";]+)\"?;", pbx):
        if value not in (APP_BUNDLE_ID, TESTS_BUNDLE_ID):
            findings["C12"].append(f"project.pbxproj: PRODUCT_BUNDLE_IDENTIFIER = {value} (regenerate with `xcodegen generate`)")
    for value in re.findall(r"DEVELOPMENT_TEAM = \"?([^\";]+)\"?;", pbx):
        if value != TEAM_ID:
            findings["C12"].append(f"project.pbxproj: DEVELOPMENT_TEAM = {value} (regenerate with `xcodegen generate`)")
    findings["C12"].extend(signing_findings(resolve_configurations(parse_build_configurations(pbx))))
else:
    findings["C12"].append("Iris.xcodeproj/project.pbxproj is missing: run `xcodegen generate`")
for path in files + ["project.yml", "Config/Info.plist"]:
    if RETIRED_PREFIX in open(os.path.join(ROOT, path)).read():
        findings["C12"].append(f"{path}: retired bundle prefix {RETIRED_PREFIX}")

# C10: file map vs disk
fm_path = os.path.join(ROOT, "Docs", "file-map.md")
mapped = set()
if os.path.exists(fm_path):
    for line in open(fm_path):
        m = re.match(r"\| `?([^|`]+?)`? \|", line)
        if m and m.group(1).endswith(".swift"):
            mapped.add(m.group(1).strip())
on_disk = set(files)
for missing in sorted(on_disk - mapped):
    findings["C10"].append(f"not in file-map.md: {missing}")
for stale in sorted(mapped - on_disk):
    findings["C10"].append(f"in file-map.md but not on disk: {stale}")

if "--write-file-map" in sys.argv:
    with open(fm_path, "w") as f:
        f.write("# File Map\n\nRegistry of every source file in the project. One row per file. Updated by every skill that creates or deletes a file. Search this table before creating anything.\n\n")
        f.write("| Path | Type | Layer | Purpose | Created by |\n|---|---|---|---|---|\n")
        for path, kind, layer, purpose in rows:
            f.write(f"| {path} | {kind} | {layer} | {purpose} | Claude (mission Iris) |\n")
    findings["C10"] = []
    print(f"file-map.md written with {len(rows)} rows")

total_fail = 0
for key, items in findings.items():
    status = "pass" if not items else ("warn" if key in ("C8", "TODO") else "fail")
    if status == "fail":
        total_fail += len(items)
    print(f"[{key}] {status} ({len(items)})")
    for item in items[:40]:
        print("   ", item)
print("files:", len(files))
sys.exit(1 if total_fail else 0)
