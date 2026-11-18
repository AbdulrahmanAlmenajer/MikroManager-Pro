# MikroManager Pro — V4 Gap Report

**Branch:** `feature/v4-upgrade`  
**Audit date:** 2026-11-18  
**Baseline commit:** `chore(baseline): format + fix 4 analyzer warnings — Step 0 audit baseline`

---

## Part 1 — Root Cause Diagnosis: Why User Manager Cards, Profiles & Reports Fail to Load

### Root Cause 1 — Single Monolithic Adapter with Version-Blind Fallback (`routeros_adapter.dart` lines 258–283)

The current `RouterOsBinaryAdapter.getUserManagerUsers()` tries `/user-manager/user/print` (v7 path) first, then silently falls back to `/tool/user-manager/user/print` (v6 path) **in the same call**. This is wrong for two reasons:

1. **RouterOS v6 `!trap` is treated as "try next path"** — when v7 path traps, the trap response has `isSuccess=false` so the fallback fires. But on a v7 router where UM is simply misconfigured (e.g. `enabled=no`), the second call to the v6 path also traps, and the method silently returns `[]` — the UI shows an empty list with no error message. **Zero silent failure rule violated.**

2. **Field name mismatch** — RouterOS v6 user objects use the key `username` (not `name`) for the login credential. The current code maps v6 responses with `username` key but then the UI/domain layer looks for `name`, so all v6 cards appear with blank usernames. The v7 adapter correctly uses `name`.

3. **No `!empty` handling** — RouterOS 7.18+ responds to `/user-manager/user/print` on an empty UM with a single `!empty` sentence (no `.tag`). The current `_processBuffer()` discards untagged sentences. The pending `Completer` for that tag never completes → **UI hangs until the 8-second timeout fires** → `RouterOsTimeoutException` shown as generic error.

4. **Missing `.proplist`** — Without `=.proplist=` the router sends every field. On large installations (1 000+ cards) this causes read-buffer growth and slow parsing on the main Dart isolate.

### Root Cause 2 — No Version Detection for UM (`routeros_adapter.dart` lines 258–338)

`_isV7` defaults to `true` and is never updated based on the actual `/system/resource` version string. The v6 paths `/tool/user-manager/…` are only reached on API-level failure, not on version detection. On a v6.49 router the first call tries the v7 path and traps, wastes a round-trip, then fetches v6 data but maps it with wrong field names.

### Root Cause 3 — Profile Activation Missing for v6 (`routeros_adapter.dart` lines 287–312)

`addUserManagerUser()` on v6 only calls `/tool/user-manager/user/add` but **never** calls `/tool/user-manager/user/create-and-activate-profile`. Without this second call the profile is not assigned in RouterOS v6, so created cards have no active profile and cannot authenticate. Cards appear in the list but all RADIUS auths fail.

### Root Cause 4 — Sessions & Reports Fetch Wrong Fields

`getUserManagerSessions()` fetches sessions with no `.proplist`, so v6 responses include fields like `from-time`/`till-time`/`uptime`/`user-ip`, while v7 uses `started`/`ended`/`user-address`. The domain layer (reports engine) only handles the v7 field names, so v6 session times always appear as `null` → estimated usage = 0.

### Root Cause 5 — No UM Health Check

There is no code to verify: (a) `user-manager` package installed, (b) `enabled=yes`/`use-profiles=yes`, (c) RADIUS config, (d) NAS entry, (e) customer scoping. Users see only a generic connection error with no actionable fix hint.

### Root Cause 6 — Silent Catch Blocks in Domain Layer

`userman_notifier.dart` lines 97–99, 112–114, 127–129 all use `catch (_) { return false; }` — zero-information swallowing. Any API exception is silently dropped; the UI never shows an error.

### Root Cause 7 — Drift DB Not SQLCipher-Encrypted

`app_database.dart` line 115 uses `NativeDatabase.createInBackground(file)` — a plain SQLite file. **Plan requirement: SQLCipher with key in `flutter_secure_storage`.** Currently voucher passwords (stored as JSON in `vouchersJson` column) are unencrypted on disk.

---

## Part 2 — V4.0 Requirement Gap Map

> Status legend: ✅ Done | 🟡 Partial | ❌ Missing | ⛔ Wrong

### U0 — Core Protocol & Infrastructure

| Requirement | Status | File(s) | Notes |
|---|---|---|---|
| `!empty` reply handling (ROS 7.18+) | ❌ Missing | `routeros_socket_client.dart` | Untagged `!empty` sentence discarded; Completer hangs |
| 1–5 byte length encode/decode | ✅ Done | `routeros_socket_client.dart:375–428` | Correct implementation |
| `.tag` multiplexing | ✅ Done | `routeros_socket_client.dart` | Tag counter + pending map |
| `.proplist` on print commands | ❌ Missing | `routeros_adapter.dart` | No `.proplist` on any command |
| Central command scheduler | 🟡 Partial | `routeros_command_scheduler.dart` | Has dedup + backoff; **missing**: single queue ordering, dynamic timeouts per command type, no `/cancel` on dispose for streams |
| Dynamic timeouts (8s login, 30–45s UM) | ❌ Missing | `routeros_socket_client.dart:63` | Fixed 8s for all commands |
| Auto `/cancel` on dispose for streaming cmds | 🟡 Partial | `routeros_socket_client.dart:231–239` | Cancel exists but `catch (_) {}` suppresses errors (silent failure) |
| Dart Isolate parsing for large lists | ❌ Missing | — | All parsing on main isolate |
| SQLCipher encryption for Drift DB | ❌ Missing | `app_database.dart:115` | Plain `NativeDatabase`, not SQLCipher |
| DB key in flutter_secure_storage | ❌ Missing | — | No encryption key management |
| Auto DB backup before migration | 🟡 Partial | `app_database.dart:80–88` | Backup exists but `catch (_) {}` swallows failure |
| `task_checkpoints` Drift table | ❌ Missing | — | Table not defined |
| `TaskRunner` with idempotent batch guard | ❌ Missing | — | No TaskRunner class |
| RouterOS version detection (exact major.minor) | 🟡 Partial | `session_controller.dart:116–120` | Major version parsed; minor never parsed; `_isV7` not propagated to adapter |
| Private-host detection + 8728 warning | ✅ Done | `validators.dart` + `router_login_screen.dart` | Implemented |
| Block plain 8728 on non-private unless confirmed | 🟡 Partial | `router_login_screen.dart` | Warning shown but not hard-blocked |
| Self-signed cert warning + fingerprint store | 🟡 Partial | Login screen shows warning, no fingerprint persistence | — |
| 30s lockout after 5 failed attempts | ✅ Done | `session_controller.dart:224–241` | Correct |
| Zero secrets in logs | ✅ Done | — | No `print` of password found |
| Zero silent `catch (_) {}` | ⛔ Wrong | Multiple files | See list below |

**Files with silent catch blocks (Gate 5 violations):**
- `userman_notifier.dart`: lines 97, 112, 127
- `session_controller.dart`: line 143 (role fetch)
- `routeros_socket_client.dart`: line 239 (`/cancel` failure swallowed)
- `app_database.dart`: line 88 (backup failure swallowed)
- `routeros_adapter.dart`: line 410 (`getInterfaceTraffic` REST)
- `vouchers_notifier.dart`: line 87 (`loadFromBatch`)
- `pdf_archive_repository.dart`: line 66 (file delete)

### U1 — User Manager Adapters

| Requirement | Status | File(s) | Notes |
|---|---|---|---|
| `UserManagerV6Adapter` class | ❌ Missing | — | Only a combined adapter exists |
| `UserManagerV7Adapter` class | ❌ Missing | — | — |
| v6: verify package installed via `/system/package/print` | ❌ Missing | — | — |
| v6: read customers via `/tool/user-manager/customer/print` | ❌ Missing | — | Hardcodes no customer |
| v6: `username` field (not `name`) | ⛔ Wrong | `routeros_adapter.dart:261–265` | Maps wrong field |
| v6: default missing counters to `0` | ❌ Missing | — | — |
| v6: profile+limitation from 3 endpoints | ❌ Missing | `routeros_adapter.dart:269–274` | Only fetches profile/print |
| v6: `create-and-activate-profile` on add | ❌ Missing | `routeros_adapter.dart:287–312` | Never called |
| v6: session fields (`from-time`, `user-ip`, etc.) | ❌ Missing | `routeros_adapter.dart:277–283` | No field mapping |
| v7: verify `enabled=yes` AND `use-profiles=yes` | ❌ Missing | — | — |
| v7: user-profile JOIN in Isolate | ❌ Missing | — | — |
| v7: `monitor` with `=once=` only on single-card view | 🟡 Partial | — | Not enforced |
| v7: DB print + optimize-db | ❌ Missing | — | — |
| 7-point UM Diagnostic Inspector | ❌ Missing | — | No diagnostic screen |
| `um_profiles_cache` Drift table | ❌ Missing | — | — |
| `um_diagnostics_log` Drift table | ❌ Missing | — | — |
| Fake RouterOS v6/v7 TCP Simulator | ❌ Missing | — | No `test/helpers/fake_routeros_server.dart` |
| Integration tests against v6+v7 simulator | ❌ Missing | — | — |

### U2 — Fleet & Dashboard

| Requirement | Status | File(s) | Notes |
|---|---|---|---|
| Multi-router fleet switcher | 🟡 Partial | `routers_screen.dart`, `routers_notifier.dart` | Exists but no strict `connectionId` isolation in queries |
| Dashboard with top bandwidth consumers | 🟡 Partial | `dashboard_screen.dart` | Basic stats only; no top-N bandwidth |
| `interface_daily` table | ✅ Done | `interface_daily_table.dart` | Exists |
| Daily snapshots | 🟡 Partial | `interfaces_traffic_notifier.dart` | Partial |

### U3 — Subscribers

| Requirement | Status | File(s) | Notes |
|---|---|---|---|
| Unified Hotspot+UM+PPPoE subscribers | 🟡 Partial | `subscribers_repository.dart` | Hotspot+PPPoE done; UM field mapping broken |
| Lazy loading 10 000+ rows | ❌ Missing | — | No pagination |
| Multi-select bulk actions | ❌ Missing | — | — |
| Full Profile & Limitation CRUD | ❌ Missing | — | Only read |
| Card Inquiry & Diagnosis screen | ✅ Done | `card_inquiry_screen.dart`, `card_diagnosis_notifier.dart` | Exists |

### U4 — Voucher Generator

| Requirement | Status | File(s) | Notes |
|---|---|---|---|
| `TaskRunner` batches of 50 with checkpoints | ❌ Missing | `vouchers_notifier.dart` | Batches of 50 exist but no Drift checkpoint/resume |
| Auto UM profile activation on batch add | ❌ Missing | `vouchers_repository.dart:97–103` | Calls `addUserManagerUser` without profile activation |
| 1-tap Quick Sell card | ❌ Missing | — | — |
| WhatsApp/SMS/Wi-Fi QR share | 🟡 Partial | `qr_flutter` present, no sharing | — |
| Template Gallery & Editor | ✅ Done | `template_gallery_screen.dart` | Exists |
| 3 credential modes | ✅ Done | `voucher_generator_engine.dart` | Done |
| `quick_sales_log` Drift table | ❌ Missing | — | — |

### U5 — Printing & Archive

| Requirement | Status | File(s) | Notes |
|---|---|---|---|
| A4 PDF printing | ✅ Done | `pdf_generator_helper.dart` | Done |
| ESC/POS 58/80mm Arabic raster | 🟡 Partial | `esc_pos_helper.dart` | Done but `blue_thermal_printer` not Windows-compatible |
| Protected PDF Archive | 🟡 Partial | `pdf_archive_repository.dart` | Stored but no encryption/password |
| Safe Expired Cards Cleaner with preview | ❌ Missing | — | — |
| Bulk CSV Import/Export | ❌ Missing | — | — |

### U6 — Reports & Resellers

| Requirement | Status | File(s) | Notes |
|---|---|---|---|
| Honest reports engine (stock vs estimated vs collected) | ✅ Done | `reports_repository.dart`, `usage_observations_table.dart` | Done and tested |
| Auto-import UM profile price | ❌ Missing | — | UM profile price not synced to `profile_prices` |
| Resellers Drift tables | ❌ Missing | — | `resellers`, `reseller_allocations`, `reseller_settlements` missing |
| Reseller PDF statement | ❌ Missing | — | — |

### U7–U12 — Should Phases

| Feature | Status | Notes |
|---|---|---|
| Simple Queues CRUD | ❌ Missing | — |
| `/tool/torch` with /cancel | ❌ Missing | — |
| DHCP Leases + Hosts + IP Binding | 🟡 Partial | IP Binding done; DHCP/Hosts missing |
| Network diagnostics (ping/traceroute/log) | ❌ Missing | — |
| MAC/IP Blacklist | ❌ Missing | — |
| Firewall templates preview+apply | ❌ Missing | — |
| Reboot (double confirm) | ❌ Missing | — |
| AP discovery + map | ✅ Done | `ap_devices_screen.dart`, `ap_repository.dart` |
| Users Map evidence ladder | ✅ Done | `topology_notifier.dart` |
| Topology map | ✅ Done | `network_topology_screen.dart` |
| Confirmed Alerts + quiet hours | ✅ Done | `alerts_repository.dart` |
| Telegram alerts | ✅ Done | `telegram_bot_service.dart` |
| Rogue DHCP alert | ✅ Done | `trusted_dhcp_servers_table.dart` |
| Encrypted App Backup | ✅ Done | `backup_repository.dart` |
| Router `.umb` via SFTP | ❌ Missing | `dartssh2` not in pubspec |
| `firewall_templates_log` table | ❌ Missing | — |
| `support_tickets` table | ❌ Missing | — |

### U13–U14 — Could Phases

All missing (correctly deferred until all Must+Should gates pass).

### U15 — Final QA

| Requirement | Status | Notes |
|---|---|---|
| ≥75% coverage on `core/network` + `domain` | ❌ Not measured yet | — |
| Unauthenticated redirect widget tests per route | 🟡 Partial | Only `/dashboard` tested |
| Security audit | ❌ Not run | — |
| APK/AAB + Windows MSIX builds | ❌ Not run | — |

---

## Part 3 — Security & Architecture Violations (Prioritised)

| # | Violation | Severity | File |
|---|---|---|---|
| 1 | Drift DB not SQLCipher-encrypted — voucher passwords on disk in plain JSON | 🔴 CRITICAL | `app_database.dart` |
| 2 | 7× silent `catch (_) {}` / `catch (e) { return false; }` blocks | 🔴 CRITICAL | Multiple — see list above |
| 3 | `blue_thermal_printer` has no Windows support (pub.dev: Android only) | 🔴 CRITICAL | `pubspec.yaml` |
| 4 | v6 UM field name mismatch (`username` vs `name`) causes blank UI | 🔴 CRITICAL | `routeros_adapter.dart` |
| 5 | `!empty` ROS 7.18+ reply causes indefinite hang | 🔴 CRITICAL | `routeros_socket_client.dart` |
| 6 | No `TaskRunner` / Drift checkpoint — batch crash loses partial work | 🔴 HIGH | `vouchers_repository.dart` |
| 7 | `_isV7` defaults `true`, never updated from actual version detection | 🔴 HIGH | `routeros_adapter.dart:81` |
| 8 | Missing `.proplist` on all print commands — slow on large sites | 🟠 HIGH | `routeros_adapter.dart` |
| 9 | 8s timeout applied to UM session fetches (should be 30–45s) | 🟠 HIGH | `routeros_socket_client.dart:63` |
| 10 | Hardcoded Arabic UI strings in nav bar labels — not in ARB | 🟠 MEDIUM | `app_router.dart:168–193` |
| 11 | `auditLoggerProvider` referenced before definition in `userman_notifier.dart` line 7 | 🟡 LOW | `userman_notifier.dart` |
| 12 | `resellers/*` and `task_checkpoints` tables missing from Drift schema | 🟡 LOW | `app_database.dart` |
| 13 | DB migration `catch (_) {}` swallows backup failure silently | 🟠 MEDIUM | `app_database.dart:88` |
| 14 | v6 `create-and-activate-profile` never called — created cards not active | 🔴 HIGH | `routeros_adapter.dart:287` |

---

## Package Audit

| Package | Version | Issue | Recommendation |
|---|---|---|---|
| `blue_thermal_printer` | ^1.1.3 | **Android only** — Windows/iOS unsupported; unmaintained (last pub update 2022) | Replace with `flutter_blue_plus` (BLE) + `thermal_printer_plugin` or use ESC/POS via USB/Network socket on Windows |
| `sqlite3_flutter_libs` | ^0.5.24 | `0.6.0+eol` available — migrate to SQLCipher variant (`sqlite3_flutter_libs` with SQLCipher or `drift_sqflite`) | Use `sqlcipher_flutter_libs` package for encryption |
| `flutter_riverpod` | ^2.5.1 | v3.5.0 available — breaking changes in v3; stay on ^2.6.x until all Should phases done | Pin to `^2.6.1` |
| `go_router` | ^14.2.7 | v18.1.4 available | Stay on 14.x — breaking nav API in 18 |
| `fl_chart` | ^0.69.0 | v1.3.1 available | Stay on 0.69.x |
| All others | Current | No critical issues | — |
