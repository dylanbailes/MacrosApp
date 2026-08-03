# Food Logging — Implementation Plan & Roadmap

> **Status:** Active
> **Owner:** Product / Engineering
> **Last updated:** 2026-08-03
> **Supersedes:** The generic "Core Features" block in `ROADMAP.md` (Phase 3). This document is the detailed, broken-down implementation plan for all food-logging functionality.

---

## 1. Vision & Goal

The core mission of Macro Tracker is **logging a meal in under 10 seconds**. Every feature in this plan serves that goal. This document breaks the food-logging backlog — fast food search, barcode scanning, a large food database, custom foods, custom recipes, favorites, recent foods, copy/duplicate helpers, quick-add, adjustable servings, and meal categories — into small, logical, independently shippable tasks organized into **Phases A–H**.

**Design decisions that shape the whole plan:**

1. **Local-first, offline-first.** All user data lives in a local SQLite database (via **Drift**). The app is fully usable offline. Cloud sync (Supabase) is a later, additive phase.
2. **One curated local food database + live API fallback.** A bundled seed dataset gives instant offline search; the free **Open Food Facts** API (4.6M+ products, open ODbL license) provides barcode lookup and long-tail search. No paid API keys required.
3. **Windows-first, mobile-ready.** The app currently targets Windows only. Barcode camera scanning must therefore use a Windows-capable package (`flutter_zxing`); the strategy keeps a manual-entry fallback and swaps in `mobile_scanner` when mobile targets are added.

---

## 2. Current State Assessment

| Area | Status |
|---|---|
| Architecture | Feature-first (`lib/features/**`), Riverpod, GoRouter, clean data/domain/presentation split per feature |
| Design system | Complete — Nothing OS dark theme, tokenized colors/spacing/typography, reusable core widgets |
| `log` feature | **UI-only, 100% hardcoded.** `log_page.dart` renders static `FoodEntry` lists; Scan/Photo/Search show "coming soon" toasts |
| Data layer | **None exists.** Dashboard & Analytics also use mock providers (`_mockSummary()`) |
| Persistence | **None.** No database, no storage package installed |
| Dependencies added | `drift`, `drift_flutter`, `drift_dev` (approved — foundation of local-first strategy) |
| Tests | `test/widget_test.dart` is a stale counter smoke test that **fails**; must be replaced |

### What this means

The food-logging work is a **greenfield data layer** under an existing, polished UI shell. We can build the entire domain + data + search foundation without touching existing UI, then wire screens phase by phase.

---

## 3. Architecture Decisions (ADR-style)

### ADR-1: Local persistence = Drift (SQLite + FTS5-ready)
- **Why:** Actively maintained; first-class Windows desktop support; native **FTS5** full-text search with BM25 ranking for fast offline search of tens of thousands of foods; reactive stream queries that fit Riverpod's `StreamProvider` model.
- **Rejected:** Isar (unmaintained upstream, community fork only), Hive (no query engine / FTS — loads everything into RAM).
- **Testability:** The database is injectable; tests use `NativeDatabase.memory()`.

### ADR-2: Food database = curated seed bundle + Open Food Facts
- **Offline core:** a bundled seed dataset (~60+ common foods today, growing to a curated subset) imported on first launch. Search is instant and offline.
- **Long tail & barcodes:** live queries to `https://world.openfoodfacts.org/api/v2/product/{barcode}.json` (free, no auth, requires a custom `User-Agent`; ~15 req/min product lookups). Search endpoints are rate-limited (10 req/min) — we use them only for explicit "search online" actions, never per-keystroke.
- **Scalability:** Phase G bundles a pre-filtered Open Food Facts export with a prebuilt FTS5 index; the API becomes a freshness layer, not the source of truth.

### ADR-3: Barcode scanning on Windows
- **Camera:** `flutter_zxing` (ZXing via FFI) supports Windows webcam scanning. Verify camera access before Phase F.
- **Fallback:** manual barcode number entry (always available).
- **Mobile (future):** `mobile_scanner` when Android/iOS targets are added.

### ADR-4: Nutrition model = nutrients per 100 g + gram-based servings
- Every food stores macros **per 100 g** (mirrors Open Food Facts `_100g` fields). Serving sizes are `{label, grams}`. A logged entry stores `servings × servingGrams = totalGrams`, plus **snapshotted** name/macros so edits to a food never mutate history.

### ADR-5: Cross-feature data flow
- The `log` feature owns the food database and daily-log domain. Later phases (H) let Dashboard/Analytics read **real** totals through log-provided providers instead of mocks.

---

## 4. Feature Backlog → Phase Map

| Feature | Phase | Notes |
|---|---|---|
| Fast food search (instant, offline) | **A** (foundation) + **B** (UI) + **G** (FTS5/ranking) | LIKE search now; FTS5 + smart ranking in G |
| Meal categories (Breakfast, Lunch, Dinner, Snacks) | **A/B** | `MealType` enum in the domain |
| Adjustable serving sizes | **B** | Serving selector + quantity; grams-based math |
| Custom foods | **C** | Create/edit form; stored with `source = custom` |
| Recent foods | **C** | Auto-track last 20; one-tap re-add |
| Favorite foods | **C** | Star toggle; favorites-first in search |
| Quick-add calories/macros | **C** | Manual entry without a food record |
| Edit/delete entries (undo) | **C** | Swipe + toast-undo |
| Move foods between meals | **D** | Re-assign `mealType` (drag or menu) |
| Copy previous meal | **D** | One-tap re-log of a prior meal's entries |
| Duplicate previous day | **D** | Copy with review/selective-copy |
| Meal templates | **D** | Save/apply whole-meal combinations |
| Custom recipes | **E** | Ingredient model, scaling, per-serving nutrition |
| Barcode scanning | **F** | Manual entry → camera (`flutter_zxing`) |
| Large food database | **G** | Bundled OF-Facts export + FTS5 + live API fallback |

---

## 5. Phases & Tasks

### Phase A — Data Foundation ✅ *(implemented in this session)*
**Goal:** All domain models, the database schema, a seeded local food database, and a search-capable repository — no UI yet.

| # | Task | Details / Acceptance |
|---|---|---|
| A1 | Add dependencies | `drift`, `drift_flutter`, `drift_dev`; run `build_runner` |
| A2 | `MealType` enum | `breakfast`, `lunch`, `dinner`, `snacks` + display label |
| A3 | Domain entities | `Food`, `ServingSize`, `LoggedFoodEntry`, `DayLog` (immutable, with totals getters) |
| A4 | Drift schema | Tables `foods` (per-100g macros, `barcode`, `category`, `source`, `popularity`), `serving_sizes`, `logged_entries` (snapshotted totals, `mealType`, timestamps) |
| A5 | Seed dataset | `assets/data/seed_foods.json` (~60+ common foods with servings); first-run import, idempotent |
| A6 | `FoodRepository` | Interface + Drift impl: `searchFoods`, `getFoodById`, `getFoodByBarcode`, `getLogForDate`, `logFood`, `updateEntry`, `removeEntry` |
| A7 | Providers | `appDatabaseProvider`, `foodRepositoryProvider`, `foodSearchProvider`, `dailyLogProvider` |
| A8 | Tests | Repository unit tests with in-memory DB: seed import, search, log/read/update/delete |

### Phase B — Search & Logging UI
**Goal:** Users can find a food and log it to a meal in <10 seconds. Replaces the "coming soon" toasts.

| # | Task |
|---|---|
| B1 | **Food search screen** — debounced search-as-you-type, results appear as you type, skeleton rows, empty/error states (reuse `AppTextField`, `AppSkeleton`, existing card patterns) |
| B2 | **Food detail + serving selector** — serving size chips, quantity stepper, live macro preview |
| B3 | **Log-to-meal sheet** — meal-category picker (Breakfast/Lunch/Dinner/Snacks), confirm → `logFood` |
| B4 | **Wire Log page to real data** — meal sections render from `dailyLogProvider`; day summary computes real totals from entries |
| B5 | **Quick-add entry point** — Search card opens search; wire the Scan/Photo cards to Phase F / placeholder |

### Phase C — Personalization
**Goal:** Personal data — custom foods, recents, favorites, quick-add — makes logging habitual.

| # | Task |
|---|---|
| C1 | **Recent foods** — auto-track last 20 logged foods; horizontal strip in search; one-tap re-log |
| C2 | **Favorite foods** — star toggle on food rows; favorites pinned at top of search |
| C3 | **Custom foods** — create/edit form (name, brand, per-100g macros, serving sizes); `source = custom` |
| C4 | **Quick-add calories/macros** — log a manual entry without a food record |
| C5 | **Edit / delete entries** — swipe to delete with toast + undo; tap to edit serving/quantity |
| C6 | **Search ranking v1** — recency/favorite boost applied in repository ordering |

### Phase D — Productivity
**Goal:** Cut re-logging time to zero for recurring days.

| # | Task |
|---|---|
| D1 | **Move foods between meals** — long-press menu / drag to re-assign `mealType` |
| D2 | **Copy previous meal** — menu action per meal section; clones entries to today (or selected date) |
| D3 | **Duplicate previous day** — "Copy yesterday" action; selective-copy review sheet before applying |
| D4 | **Meal templates** — save a meal as a named template; apply from search/dashboard |
| D5 | **Date navigation** — day selector on Log page; view/edit any past/future date |

### Phase E — Custom Recipes
**Goal:** Log multi-ingredient meals as a single item with correct per-serving macros.
*(User requested recipes in the core backlog even though the old PRODUCT_SPEC deferred them.)*

| # | Task |
|---|---|
| E1 | `Recipe` entity + `RecipeIngredient` model + DB tables (recipe → ingredients → foods) |
| E2 | Recipe builder UI — add foods with amounts, live totals, servings field |
| E3 | Recipe scaling — per-serving and per-100g computed nutrition; adjustable servings when logging |
| E4 | Log a recipe to a meal; search finds recipes alongside foods; favorites/recents include recipes |

### Phase F — Barcode Scanning
**Goal:** Scan a product → correct food logged in 2 taps.

| # | Task |
|---|---|
| F1 | **Barcode service** — Open Food Facts product lookup via Dio (custom User-Agent, field-limited response, timeout, error handling) |
| F2 | **Manual entry** — barcode text field (works everywhere, no camera needed) |
| F3 | **Camera scanning** — `flutter_zxing` Windows webcam scan screen; verify permissions & first-run UX |
| F4 | **Cache & fallback** — successful lookups cached as local foods (`source = barcode`); not-found → offer "create custom food" |

### Phase G — Large Food Database
**Goal:** Instant search across a genuinely large, offline food catalog.

| # | Task |
|---|---|
| G1 | **FTS5 search** — virtual FTS5 table over foods (BM25 ranking), replacing LIKE |
| G2 | **Bundled dataset** — curated Open Food Facts export (generic + popular brands) built offline into an importable SQLite bundle |
| G3 | **Live API search fallback** — explicit "Search online" action hits the OF-Facts search API (rate-limit aware, cached, debounced) |
| G4 | **Smart ranking** — recency + favorites + frequency boost; typo tolerance via FTS5 prefix/trigram strategy |

### Phase H — App-wide Integration (Key Additional Features)
**Goal:** Food logging becomes the engine that powers the rest of the app.

| # | Task |
|---|---|
| H1 | **Daily goals** — calorie + macro targets (from Settings); remaining/over computed from real totals |
| H2 | **Dashboard real data** — replace mock `DashboardSummary` with totals from `dailyLogProvider` |
| H3 | **Analytics real data** — weekly charts computed from logged entries |
| H4 | **Weight tracking** — make the mock weight entries a real local model + entry UI |
| H5 | **Water tracking** — simple daily water log + dashboard card (small, self-contained) |
| H6 | **Notes on entries/meals** — optional free-text note per logged entry |
| H7 | **Data export/import** — JSON/CSV export of logs, foods, favorites; import for backup/restore |
| H8 | **Sync readiness** — repository interface already abstracts storage; add Supabase sync later without UI changes |

---

## 6. Additional Key Features (beyond the original backlog)

The original list omits several features that a macro-tracking app fundamentally needs. These are folded into the phases above:

1. **Daily calorie & macro goals** (H1) — without targets, "remaining" is meaningless; the Log day-summary already assumes targets exist.
2. **Edit / delete with undo** (C5) — product spec's "Undo instead of confirm dialogs" interaction principle.
3. **Date navigation** (D5) — users must be able to view and edit past days.
4. **Meal templates** (D4) — the natural evolution of "copy previous meal".
5. **Weight tracking** (H4) — already half-present in Analytics mocks; make it real.
6. **Water tracking** (H5) — already on the dashboard mock; a tiny log adds real value.
7. **Entry notes** (H6) — small, high-value for power users.
8. **Data export/import** (H7) — required by the product spec's privacy goals (easy data export).
9. **Smart search ranking** (C6/G4) — the product spec's #1 differentiator after speed.
10. **Offline-first behavior** (whole plan) — full core functionality without a network.

**Deliberately out of scope (unchanged from PRODUCT_SPEC):** photo calorie estimation, AI coach food features, health-platform sync, meal planning, restaurant support, voice logging.

---

## 7. Data Model Summary

```
foods (id PK, name, brand?, category?, barcode?, source, popularity,
       calories_per_100g, protein_per_100g, carbs_per_100g, fat_per_100g, fiber_per_100g?)
serving_sizes (id PK, food_id FK→foods, label, grams)
logged_entries (id PK, food_id FK?→foods, food_name, meal_type,
                serving_label, servings, grams, calories, protein, carbs, fat, logged_at)
-- Phase C+: favorites (food_id, created_at), recent (food_id, last_logged_at)
-- Phase D+: meal_templates, template_entries
-- Phase E+: recipes, recipe_ingredients
```

Logged entries **snapshot** name + macros at log time — food edits never rewrite history.

---

## 8. Success Criteria

- **Log a food in ≤ 3 taps** from the search screen (search → serving → confirm).
- Search returns results **as you type**, offline, in <100 ms on seed data.
- All core phases **A–G** work fully offline; only "search online"/barcode-lookup needs network.
- `flutter analyze` clean; repository unit tests pass against an in-memory database.
