#!/usr/bin/env python3
"""Layer audit for Iris (layer-auditor skill, checks C1, C2, C8, C9, C10, C12 plus dead-file and TODO scans).
C12 locks the Apple identity: project.yml (XcodeGen source of truth), the generated pbxproj and the sources must agree on the bundle identifiers and the development team.
Run from the project root: python3 Tools/audit.py [--write-file-map]
"""
import os, re, sys, subprocess

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
LAYERS = {
    "App": "App", "Domain": "Domain", "GameEngine": "GameEngine", "AR": "AR", "Audio": "Audio", "Haptics": "Haptics",
    "Navigation": "Presentation", "Features": "Presentation", "DesignSystem": "DesignSystem", "Tests": "Tests",
}
FORBIDDEN = {
    "Domain": {"SwiftUI", "UIKit", "ARKit", "AVFoundation", "AVFAudio", "Combine", "SwiftData", "CoreData", "QuartzCore"},
    "GameEngine": {"SwiftUI", "UIKit", "ARKit", "AVFoundation", "AVFAudio", "Combine", "SwiftData", "CoreData", "QuartzCore"},
    "DesignSystem": set(),
    "AR": {"SwiftUI"},
    "Audio": {"SwiftUI", "UIKit", "ARKit"},
    "Haptics": {"SwiftUI", "ARKit", "AVFoundation", "AVFAudio"},
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

# C12: Apple identity lock (README, "Apple Signing"). project.yml is the source of truth; the pbxproj is generated from it.
APP_BUNDLE_ID = "net.steve-s.iris"
TESTS_BUNDLE_ID = "net.steve-s.iris.tests"
TEAM_ID = "G4U9RG5GL7"
RETIRED_PREFIX = "com.prodx0x"
spec = open(os.path.join(ROOT, "project.yml")).read()
for expected in (f"bundleIdPrefix: net.steve-s\n", f"PRODUCT_BUNDLE_IDENTIFIER: {APP_BUNDLE_ID}\n", f"PRODUCT_BUNDLE_IDENTIFIER: {TESTS_BUNDLE_ID}\n",
                 f"DEVELOPMENT_TEAM: {TEAM_ID}\n", "CODE_SIGN_STYLE: Automatic\n"):
    if expected not in spec:
        findings["C12"].append(f"project.yml: missing `{expected.strip()}`")
if "PROVISIONING_PROFILE" in spec:
    findings["C12"].append("project.yml: a provisioning profile is pinned; automatic signing must stay unpinned")
pbx_path = os.path.join(ROOT, "Iris.xcodeproj", "project.pbxproj")
if os.path.exists(pbx_path):
    pbx = open(pbx_path).read()
    for value in re.findall(r"PRODUCT_BUNDLE_IDENTIFIER = \"?([^\";]+)\"?;", pbx):
        if value not in (APP_BUNDLE_ID, TESTS_BUNDLE_ID):
            findings["C12"].append(f"project.pbxproj: PRODUCT_BUNDLE_IDENTIFIER = {value} (regenerate with `xcodegen generate`)")
    for value in re.findall(r"DEVELOPMENT_TEAM = \"?([^\";]+)\"?;", pbx):
        if value != TEAM_ID:
            findings["C12"].append(f"project.pbxproj: DEVELOPMENT_TEAM = {value} (regenerate with `xcodegen generate`)")
    for value in re.findall(r"CODE_SIGN_STYLE = \"?([^\";]+)\"?;", pbx):
        if value != "Automatic":
            findings["C12"].append(f"project.pbxproj: CODE_SIGN_STYLE = {value}")
    if "PROVISIONING_PROFILE" in pbx:
        findings["C12"].append("project.pbxproj: a provisioning profile is pinned")
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
