---
name: iris-apple-identity
description: Locked Apple identity for Iris (bundle IDs, team G4U9RG5GL7, automatic signing), the NKN63DTRM4 trap, and where the values must live (project.yml, checked by audit C12)
metadata:
  type: project
---

Iris is signed with bundle ID `net.steve-s.iris` (tests `net.steve-s.iris.tests`), team `G4U9RG5GL7` (Stéphane SAULNIER, individual paid team), `CODE_SIGN_STYLE = Automatic`, no pinned profile or certificate. Designer: Stéphane SAULNIER; `ProdX0xSs` is only a potential brand, never an Apple identity or bundle prefix. Locked on 2026-09-11 (README section "Apple Signing" and § 13).

`NKN63DTRM4` is NOT a team: it is the personal identifier in the common name of the "Apple Development" certificates; the team is the certificate's OU field. Using it as DEVELOPMENT_TEAM made Xcode show a missing team.

**Why:** the values used to live only in Xcode's Signing & Capabilities (i.e. the generated `.pbxproj`) while `project.yml` carried `com.prodx0x.iris` and `NKN63DTRM4`, so every `xcodegen generate` erased the user's fix.

**How to apply:** change identity only in `project.yml`, then `xcodegen generate`; `python3 Tools/audit.py` check C12 fails on any divergence. Never put Apple credentials in the repo. Device builds now sign for real (`generic/platform=iOS`, no `CODE_SIGNING_ALLOWED=NO`); the iPhone 14 Pro "iPhone Steve." (devicectl id CD9242BD-9650-52C9-BBA6-A30490C6DFA8) accepts `devicectl device install app` and still carries an old `com.prodx0x.iris` install. See [[iris-project-setup]].
