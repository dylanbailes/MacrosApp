# UI Polish Pass — Specification

> **Status:** Draft for review
> **Owner:** Product / Engineering
> **Last updated:** 2026-08-03
> **Request:** Fix all existing UI issues across the app — text fonts/sizes that feel wrong, unclear numbers, cards that feel off or overlap — until the app feels polished and complete, modeled on the Nothing design philosophy with accents where applicable. All widgets should be reusable and versatile.
> **No code changes accompany this document yet.** This spec is the pre-implementation contract; implementation begins after approval.

---

## 1. Context & Confirmed Problems

### 1.1 How the request was understood

This is a **visual + structural polish pass**, not a feature build. It covers typography, numerals, card/component consistency, spacing rhythm, layout/overflow, interaction affordances on desktop, and responsiveness — across **every screen** (Dashboard, Food Log, Search + log sheet, Analytics, Profile, Settings, Coach). At the end the app should feel *"fast, dense, calm, precise, alive"* (existing Visual Design Spec §1) with a coherent Nothing-style point of view.

### 1.2 Root causes found during context-gathering (all confirmed by the user)

| # | Issue | Evidence in code |
|---|---|---|
| 1 | **Font mismatch / fallback font** | `fontFamily: 'Inter'` hardcoded in `app_theme.dart` (elevated/text/outlined button themes), `app_bottom_nav_bar.dart`, `app_button.dart`, `app_toast.dart` — but **Inter is not bundled** (only `Nothing` + `Geist` are declared in `pubspec.yaml`), so buttons/nav/toasts silently render the platform fallback while everything else uses Geist. |
| 2 | **Dot-matrix font used below its legible floor** | `AppTextStyles.macroValue` (20px Ndot) and `cardMetricSmall` (20px Ndot); worst case: `analytics_hero_section.dart` `_WeeklyStatVertical` hardcodes `fontFamily: 'Nothing'` at **16px and 9px** — the dots disintegrate. Spec §3.1 says Ndot is ≥24px hero numerals only. |
| 3 | **Numbers unclear** | No comma grouping for thousands; inconsistent rounding; several numerals lack `FontFeature.tabularFigures()`; unit suffixes inconsistent across stats. |
| 4 | **Cards inconsistent** | Four overlapping shells — `AppCard`, `AppSurface`, `AppGlassContainer`, `AppInteractiveCard` — plus `AppMetricTile`/`AppStatDisplay` and two rings (`AppProgressRing`, `AnimatedMetricRing`). Similar content uses different radiuses/fills/paddings depending on which shell created it. |
| 5 | **Overlap / overflow** | Hero `IntrinsicHeight` two-column row can clip at narrower widths; long food names and stat rows risk overflow; no systematic overflow testing exists. |
| 6 | **Spacing rhythm off** | `AppSpacing` scale is consistent (4/8/12/16/20/24/32/40/48/64) but applied unevenly — 20px vs 32px vs 48px gaps appear in equivalent situations across screens. |

### 1.3 Existing design system (the target tokens — reuse, don't reinvent)

- **Colors:** `AppColors` — background `#000000`, surface `#0D0D0F`, surfaceElevated `#16161A`, surfaceGlass `#202024`, divider `rgba(255,255,255,.08)`, onPrimary `#F5F5F2`, textSecondary `#9A9A9E`, textTertiary `#5C5C60`, primary `#FF1E3C`, protein `#3D8BFD`, carbs `#FFB020`, fat `#FF6B5E`, success/weight `#34D399`, water `#22D3EE`, goal `#F59E0B`.
- **Fonts:** `kNothingFont` (dot-matrix, hero numerals ≥24px only) + `kGeistFont` (everything else, full weight range 100–900 bundled).
- **Radius:** `AppBorderRadius` 6 / 12 / 20 / 28 / pill.
- **Spacing:** `AppSpacing` 4 / 8 / 12 / 16 / 20 / 24 / 32 / 40 / 48 / 64.
- **Elevation:** luminance steps + hairlines; shadows only for floating layers (sheets, toasts, dialogs).
- **Motion:** 150–250ms, ease-out in / ease-in out; press scale ~0.97–0.98; count-up numerals; **reduce everything under the system reduced-motion flag**.

---

## 2. Interview Decisions (binding)

| Topic | Decision |
|---|---|
| Scope | **All screens, equal priority** (Dashboard, Log, Search+sheet, Analytics, Profile, Settings, Coach). |
| Typography system | **Consolidate to Geist + Nothing.** Delete the legacy `AppTypography`/Inter system; one source of truth (`AppTextStyles`). |
| 'Inter' fallback bug | **Replace every `'Inter'` reference with `kGeistFont`.** |
| Dot-matrix font | **Enforce the spec strictly** — Ndot only for hero/large numerals ≥24px; all 20px-and-below numbers use Geist tabular numerals. |
| Accent color | **Colorful data cards** — each metric card carries its semantic accent (water cyan, weight emerald, goal amber, macro hues), while chrome (backgrounds, headers, nav, borders) stays monochrome. Red stays the primary action/streak color. |
| Number formatting | **Strict data formatting** — tabular figures everywhere, comma-grouped thousands, sensible rounding, units always shown. |
| Widget architecture | **Consolidate + retire duplicates** — merge card/surface shells, delete unused rings/widgets, remove dead code. |
| Interaction | **Full desktop polish** — hover states, pointer cursors, keyboard focus rings, reduced-motion support, hover-scrub on charts. |
| Verification | **Both** — automated regression checks (typography tokens, overflow-at-sizes, number formatting, existing flows) **and** a runnable Windows build for visual review. |
| Chrome kit | **Yes** — build shared screen chrome widgets (screen header, section header, list row, empty state, chips, skeleton shapes); screens compose them. |
| Responsive | **Graceful at all sizes** — no overflow from ~640px wide up; max-width centered column on very wide monitors. |

---

## 3. Design Principles (applied, in priority order)

1. **Calm chrome, loud data.** Interfaces stay black/white/gray; color is spent on things the user must *read* (macro values, status, semantic accents).
2. **One voice in type.** Every glyph in the app is Geist except hero numerals ≥24px (Ndot). No stray font families, no runtime font fetching.
3. **Numbers are data.** Tabular figures, comma grouping, one decimal max, units always present, aligned columns in lists.
4. **One card, many variants.** A single card shell with explicit variants removes the "cards feel off" problem at its root.
5. **Consistent rhythm.** Section gaps 32px, sibling-card gaps 12px, list-row gaps 8px, screen margins 20px — everywhere, without exception.
6. **Desktop-native feel.** Hover, cursor, focus, and reduced-motion are first-class, not afterthoughts.

---

## 4. Typography Consolidation Plan

### 4.1 Replace all `'Inter'` references with `kGeistFont`

- `lib/core/theme/app_theme.dart` — elevated/text/outlined button `textStyle`s.
- `lib/core/widgets/app_bottom_nav_bar.dart`, `app_button.dart`, `app_toast.dart`.
- Sweep the whole repo for any remaining `fontFamily: 'Inter'` / `'Nothing'` misuse.

### 4.2 Remove the legacy system

- Delete `lib/core/constants/app_typography.dart` (`AppTypography`, Inter via `google_fonts`).
- Remove the now-unused `google_fonts` dependency from `pubspec.yaml` (verify zero remaining references first).
- Ensure `lib/core/theme/theme.dart` barrel exports only `AppTextStyles`.

### 4.3 Fix Ndot usage (strict ≥24px floor)

| Current | New |
|---|---|
| `macroValue` — **20px Ndot** | Geist SemiBold 20/24, tabular figures, macro semantic color (matches Blueprint §2.3: the tile value was always meant to be a semi-bold workhorse numeral, not Ndot). |
| `cardMetricSmall` — **20px Ndot** | Geist SemiBold 20/24 tabular (or remove if unused after consolidation). |
| `_WeeklyStatVertical` (analytics hero) — **16px/9px Ndot** | Geist Medium 15 value / Geist 9 caps label via a shared `AppStatDisplay`; never Ndot below 24px. |
| `numericDisplay` 40px, `displaySmall` 24px, `cardMetric` 24px | **Keep Ndot** — they meet the floor. |

**Final Ndot whitelist (only these):** Dashboard calorie hero (56px), streak numeral (34px), weigh-in headline (34px), day-summary calorie number (24px), sheet macro preview totals (40px), and any ≥24px card metric. Everything else is Geist.

### 4.4 Type-scale tidy-up (audit before finalizing)

Audit every `AppTextStyles` getter against the Visual Design Spec §3 scale. Expected changes: add a **tabular numeric body** helper (`Geist` + `FontFeature.tabularFigures()`), a **numeric unit** style (small unit suffix beside large numerals, e.g. "of 2,400 kcal"), and remove styles that become unused after consolidation (dead styles are deleted, not kept).

---

## 5. Number Formatting Spec (strict)

Implement shared formatters (unit-tested), e.g. in `lib/core/formatting/app_formatters.dart`:

| Rule | Example |
|---|---|
| Thousands comma-grouped | `2,050 kcal`, `1,234 g` |
| Calories/whole grams: integers | `165 kcal`, `180g` |
| Decimal macros: 1 decimal max, trailing `.0` dropped | `31.5g`, `27g` |
| Per-100g values: 1 decimal max | `2.4g` |
| Tabular figures on **every** numeral | `FontFeature.tabularFigures()` |
| Units always present (kcal / g / L / days / %) | — |
| Zero is a normal state | show `0`, not `—` (start-of-day is normal, per Blueprint §2.3) |
| Time: `h:mm AM/PM` | `8:30 AM` |
| Percent: integer, explicit sign where meaningful | `+8% vs yesterday` |
| Goal fractions: `n/7` | `2/7` |

Apply consistently to: hero ring ("2,140 of 2,400 kcal"), macro tiles ("142 / 180g"), log rows (right-aligned tabular calorie), day summary, weekly stats (Avg Calories "2,050", Avg Protein "142g", Goal Days "2/7", Streak "1"), analytics axes/labels, profile/settings stats.

---

## 6. Color & Accent Application

- **Chrome (monochrome):** backgrounds, cards' default fills, headers, nav, borders, icons (default `textSecondary`).
- **Semantic accents (colorful data cards):**
  - Protein/Carbs/Fat tiles → their macro colors (value numeral + 3px progress bar).
  - Water card → cyan (`#22D3EE`) icon + value + mini-progress.
  - Weight card → emerald (`#34D399`).
  - Goal/Streak card → amber (`#F59E0B`).
  - Calories hero ring → **neutral** (`energyNeutral`) so the macro row below reads clearly.
  - Status overrides: over-target → red; improving/positive → green.
- **Red (`#FF1E3C`) is reserved** for: primary CTA / Log FAB, active streak numeral, alerts, destructive actions.
- **Rule of thumb:** ≤3–4 saturated hues per screen; when a screen feels colorful, pull color out, not in.

---

## 7. Component Library — Consolidation & New Chrome Kit

### 7.1 Card/surface consolidation (one shell)

**`AppCard`** becomes the single surface shell with variants:
`standard` (surface + hairline, radius.md), `row` (radius.sm, tighter padding), `hero` (radius.lg), `interactive` (press scale 0.98 + surface bump + optional ambient glow for the primary action), `static`. Props: `variant`, `backgroundColor`, `padding`, `borderRadius`, `border`, `onTap`, `accentColor`, `child`.

- **Retire:** `AppSurface`, `AppGlassContainer`, `AppInteractiveCard` — migrate all callers (`streak_card.dart`, `weekly_calories_chart.dart`, `metric_carousel.dart`, etc.) to `AppCard`.
- **Rings:** keep `AppProgressRing` as the generic ring; **retire `AnimatedMetricRing`** (verify usage first; if used, migrate).
- **Metric tiles:** keep `AppMetricTile` (3-tile macro row) and `AppStatDisplay` (generic stat card w/ semantic accent). Retire any internal duplicates.

### 7.2 New chrome kit (shared, in `core/widgets/`)

| Widget | Purpose | Absorbs today's |
|---|---|---|
| `AppScreenHeader` | Title + optional subtitle + trailing actions (back button, settings gear, date navigator) | Log page's private `_LogHeaderDelegate`, `DashboardHeader`, Food Search header, Analytics/Profile/Settings headers |
| `AppSectionHeader` (exists — standardize) | Label + optional trailing action + optional inline subtotal | `app_section_header.dart`, meal-section subtotals ("BREAKFAST · 420 kcal") |
| `AppListRow` | Unified row: leading glyph 40×40, title, subtitle/meta, trailing tabular value + macro dots; `onTap`/`onDelete`/swipe-edit hooks | `log_food_row.dart`, `food_search_result_row.dart`, `recent_meals_list.dart` rows |
| `AppEmptyState` | Icon + title + hint + optional CTA | Inline empty blocks in `log_page.dart`, `food_search_page.dart` |
| `AppChip` | Pill chip (selected/unselected/disabled); used for servings, meals, range tabs, filters | `_SelectableChip` in `log_food_sheet.dart`, meal chips, search category chips |
| `AppSkeletonShapes` (extend) | One shape per async component (log row, tile, chart, card) | `app_skeleton.dart` |
| `AppDateNavigator` (exists) | Reused as-is | — |
| `AppToast` (exists) | Reused as-is (verify Geist + variant styles) | — |

Every screen composes these; a screen must not fork a one-off variant (Blueprint §0 rule).

### 7.3 Duplicate-dead-code sweep

After consolidation, grep and remove: unused text styles, unused widgets (`AppSurface`, `AppGlassContainer`, `AppInteractiveCard`, `AnimatedMetricRing`, `app_stat_display` if superseded), the legacy `AppTypography`, and the unreferenced `dashboard_stats_section.dart` + its now-dead `weekly_calories_chart.dart`/`weekly_macros_chart.dart`/`avg_calories_card.dart`/`goal_completion_card.dart` **only if confirmed unreferenced** (re-verify at implementation time; do not delete anything still routed).

---

## 8. Screen-by-Screen Fix List

### 8.1 Dashboard
- `AppScreenHeader` (greeting + date navigator + settings gear), consistent section gaps (32px), 20px margins.
- Hero section: replace `IntrinsicHeight` clipping risk with a layout that degrades gracefully; keep FittedBox on ring numerals; hero ring neutral, "2,140 of 2,400 kcal" caption tabular.
- Macro tiles: Geist SemiBold tabular values in macro colors; fixed 92px height so the row never staggers.
- Weekly overview: real 7-day data already wired — restyle stats via `AppStatDisplay` (Geist, no Ndot at 9px), consistent card padding.
- Streak card: amber accent, real values already wired.
- Metric carousel / water / weight / avg-calories cards: semantic accents, `AppCard` shell, no overflow at any width.
- Quick Actions, Recent Meals (`AppListRow`), empty-day states (`AppEmptyState`).

### 8.2 Food Log
- Sticky `AppScreenHeader` + `AppDateNavigator` (already present — restyle to kit).
- Day summary bar: 24px Ndot number OK; comma-grouped "of 2,400 kcal"; slim bar aligned to baseline.
- Meal sections: `AppSectionHeader` with subtotal; 8px row gaps; rows via `AppListRow` (tabular calories, time "8:30 AM", macro dots).
- Empty day → `AppEmptyState` with "Search foods" CTA.

### 8.3 Food Search + Log Sheet
- Header via kit; result rows via `AppListRow` (name + brand + quick-add `+`).
- `AppChip` for category filters; `AppEmptyState` for no-results; skeletons.
- Sheet: `AppChip` for serving + meal selection; stepper styling consistent; macro preview aligned (tabular), Ndot 40px for the kcal total is fine.

### 8.4 Analytics
- Range tabs via `AppChip`/segmented control (1W/1M/3M/6M/1Y); consistent left alignment under charts.
- Charts: hover tooltips, tabular axis labels, single hairline baseline (no gridlines) per spec §7.5; weigh-in headline Ndot 34px.
- Stat cards via `AppStatDisplay` with semantic accents; heatmap consistent spacing.

### 8.5 Profile & Settings & Coach
- `AppScreenHeader` + `AppSectionHeader`; list rows via `AppListRow`; switches/dialogs already themed — verify type uses Geist.
- Coach: `AppCard` for the entry card + chat rows; consistent empty/loading.

---

## 9. Desktop Interaction Polish

- **Hover:** pointer cursor + ~6% surface brighten on interactive cards, buttons, rows; no hover state on ghost buttons beyond an underline.
- **Focus rings:** visible 2px primary-colored rings for keyboard navigation on every interactive element; sane tab order; Escape dismisses sheets/dialogs (dialogs already).
- **Charts:** hover-scrub tooltips on all `fl_chart` instances (WeeklyCaloriesChart already does; port the pattern to analytics charts).
- **Reduced motion:** gate count-up, draw-in animations, shimmer, pulse, and glow behind `MediaQuery.disableAnimations` → degrade to instant/opacity-only.
- **Press feedback:** unify scale 0.97–0.98 spring on buttons + interactive cards via shared behavior.
- **Touch targets:** ≥44–48px for all interactive elements regardless of visual size.

---

## 10. Responsive Behavior

- **Breakpoints:** content stacks below 600px (hero already switches); no overflow exceptions at 640/900/1280/1600/1920 widths and 700–1000 heights.
- **Wide screens:** center content in a max-width column (~1200px for dashboard; 640px column for form-like screens per Blueprint) with visible black gutters — a stretched full-width pill/layout reads as broken.
- **Long content:** ellipsis on long food names; fixed-height rows; wrap for chips.
- **Verification:** widget tests that pump each screen at a matrix of sizes and assert no overflow exceptions.

---

## 11. Empty / Loading / Error States

- Empty states → `AppEmptyState` (icon, one-line guidance, CTA). No mascots/illustrations.
- Loading → skeletons matching real shapes (`AppSkeletonShapes`); spinners only for inline actions.
- Errors → consistent `AppCard` + retry affordance (existing `_LogPageError`, search `_ErrorState` — unify).
- All screens covered; no bare spinners for full content areas.

---

## 12. Motion

Keep the existing count-up + draw-in language; ensure timings 150–250ms, ease-out in / ease-in out; no ambient/looping decoration except the Log FAB's data-driven glow. Everything reduced-motion-safe.

---

## 13. Accessibility

- Screen-reader labels on all icon-only buttons and quick-add buttons (Blueprint §2.7).
- Announce numerals with units ("Protein, 142 of 180 grams").
- Contrast: keep textTertiary (`#5C5C60`) for meta only — never for primary content; verify small text is at least `textSecondary` where legibility matters.
- Focus order + visible focus on desktop.

---

## 14. Implementation Order (proposed phases)

0. **Font consolidation** — Inter→Geist everywhere; delete `AppTypography`; drop `google_fonts`; sweep.
1. **Type + numerals** — Ndot floor fixes; tabular helpers; `AppFormatters` + unit tests.
2. **Component consolidation** — single `AppCard`; retire card/ring duplicates; migrate callers.
3. **Chrome kit** — `AppScreenHeader`, `AppListRow`, `AppEmptyState`, `AppChip`, skeleton shapes; migrate screens.
4. **Dashboard pass** — 8.1.
5. **Log / Search / Sheet pass** — 8.2–8.3.
6. **Analytics pass** — 8.4.
7. **Profile / Settings / Coach pass** — 8.5.
8. **Interaction polish** — hover, focus, reduced motion, chart scrub.
9. **Responsive pass** — breakpoints + overflow tests.
10. **Validation + visual review** — see §15.

Phases 0–3 are prerequisites; 4–7 can be done screen-by-screen and reviewed incrementally.

---

## 15. Validation & Testing

- `flutter analyze` → **0 errors**, no new lints in touched files.
- `flutter test` → all existing tests pass (currently 28) plus **new tests**:
  - `AppFormatters` unit tests (comma grouping, rounding, units).
  - Typography guard tests: no `fontFamily: 'Inter'` anywhere; no Ndot style <24px used in widgets.
  - Overflow tests: pump every screen at 640×700, 900×700, 1280×800, 1600×1000 → no overflow exceptions.
  - Existing flow tests (log → search → sheet → dashboard wiring → date navigation) stay green.
- `flutter build windows --debug` → succeeds; **user visually reviews** the running app; iterate on feedback.
- Code review (deepseek-flash) at the end of each phase.

---

## 16. Non-Goals (explicitly out of scope)

- No new features, screens, or backend changes; no changes to logging logic or data flows.
- No light-mode theme.
- No changes to the Nothing-philosophy brand direction already established (colors/fonts stay as specified).
- No performance work beyond what the consolidation naturally removes.

---

*Spec ends. Awaiting approval before implementation.*
