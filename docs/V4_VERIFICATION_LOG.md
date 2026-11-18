# V4 Verification Log

---

## Step 0 — Baseline Audit (2026-11-18)

### Gate 1: `dart format --output=none --set-exit-if-changed lib/ test/`

```
Formatted 110 files (0 changed) in 1.04 seconds.
EXIT: 0 ✅
```

> **Note on scope**: Gate 1 is scoped to `lib/` and `test/` to avoid a Windows PathNotFoundException in the `build/` directory tree caused by Android transform caches. The correct command for CI on a clean machine is:  
> `dart format --output=none --set-exit-if-changed lib/ test/`

### Gate 2: `flutter analyze --fatal-infos --fatal-warnings`

```
Analyzing mikro_manager_pro...
No issues found! (ran in 5.4s)
EXIT: 0 ✅
```

**Pre-baseline violations fixed (4 items):**
- `lib/features/vouchers/data/pdf_archive_repository.dart:2` — removed redundant `import 'dart:typed_data'`
- `lib/features/vouchers/presentation/print_preview_screen.dart:5` — removed unused `import 'package:pdf/pdf.dart'`
- `test/printing_archive_test.dart:1` — removed redundant `import 'dart:typed_data'`
- `test/printing_archive_test.dart:25` — removed unused `dummyPdfBytes` variable

### Gate 3: `flutter test --coverage`

```
+46: All tests passed!
EXIT: 0 ✅
```

**Tests run (46 total):**
- access_points_test.dart: 2 tests
- alerts_rogue_dhcp_test.dart: 4 tests
- backup_test.dart: 4 tests
- command_scheduler_test.dart: 2 tests
- database_test.dart: 2 tests
- interfaces_traffic_test.dart: 2 tests
- optional_features_test.dart: 1 test
- printing_archive_test.dart: 2 tests
- reports_engine_test.dart: 4 tests
- routeros_protocol_test.dart: 5 tests
- subscribers_test.dart: 4 tests
- topology_test.dart: 2 tests
- validators_test.dart: 3 tests
- voucher_generator_test.dart: 3 tests
- widget_test.dart: 2 tests

**Missing at baseline (to be added in U0):**
- Fake RouterOS v6 TCP simulator integration tests
- Fake RouterOS v7 TCP simulator integration tests
- Drift migration step tests (v2 → v4)
- `TaskRunner` / `task_checkpoints` tests
- SQLCipher encryption tests

### Gate 4: `dart run build_runner build --delete-conflicting-outputs`

> **NOT RUN in baseline** — will be run after U0 Drift schema changes.  
> Current state: `app_database.g.dart` is tracked and was generated from `schemaVersion=2` with 19 tables. Gate 4 will be re-run after adding v4 tables and running migration.

### Gate 5: Static security & l10n audit

**Results:**

| Check | Result |
|---|---|
| Logged secrets (grep `print.*pass\|log.*token`) | ✅ 0 found |
| Silent `catch (_) {}` blocks | ⛔ **7 violations found** (see V4_GAP_REPORT.md Part 3) |
| Hard-coded Arabic UI strings outside ARB | ⛔ **Found in `app_router.dart:168–193`** (bottom nav labels) |
| Mock data outside `kDebugMode` | ✅ 0 found |
| SQLCipher encryption | ⛔ **Missing** — plain `NativeDatabase` |

Gate 5 violations will be remediated in Phase U0.

### Gate 6: Git Commit

```
[feature/v4-upgrade 1820fef] chore(baseline): format + fix 4 analyzer warnings — Step 0 audit baseline
84 files changed, 2717 insertions(+), 1345 deletions(-)
```

---

### Items Still Requiring Physical Hardware Testing (Step 0 Audit)

| Item | Hardware Required |
|---|---|
| RouterOS v6.49 UM login flow, `create-and-activate-profile` | MikroTik router with RouterOS 6.49, `user-manager` package installed |
| RouterOS v7.18+ `!empty` reply handling | MikroTik router with RouterOS 7.18+ |
| Self-signed TLS certificate fingerprint persistence | Any MikroTik with API-SSL |
| ESC/POS 58mm & 80mm Arabic thermal printing | Bluetooth thermal printer (Android) |
| Windows USB/Network ESC/POS printing | Thermal printer + Windows PC |
| SFTP `.umb` router backup | MikroTik router + SSH access |
| Telegram bot alerts delivery | Live Telegram bot token + chat ID |
| CoA port 3799 RADIUS integration | Full RADIUS+Hotspot+UM stack |

---

## Phase U0 — (Planned, not yet run)

Gates 1–6 to be appended here after U0 implementation.

---

## Exact Run Commands

```powershell
# Run from: C:\Users\End_Abdulrahman\Desktop\New folder (2)\mikro_manager_pro

# Gate 1
dart format --output=none --set-exit-if-changed lib/ test/

# Gate 2
flutter analyze --fatal-infos --fatal-warnings

# Gate 3
flutter test --coverage

# Gate 4 (after Drift schema changes)
dart run build_runner build --delete-conflicting-outputs

# Gate 5 — manual audit patterns
grep -rn "catch (_)" lib/ test/
grep -rn "catch (e)" lib/ --include="*.dart" | grep "return false"
grep -rn "print(" lib/ --include="*.dart" | grep -i "pass\|token\|secret"

# Gate 6
git add -A && git commit -m "phase(U0): <description>"
```
