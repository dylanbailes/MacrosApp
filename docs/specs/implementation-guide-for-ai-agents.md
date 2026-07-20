# Implementation Guide for AI Coding Agents
### Premium Macro & Nutrition Tracker — Flutter Build Rules
Prepared for: Qwen / Gemini Flash / GPT-OSS and any other agent generating code for this app
Governs: how the **Visual Design Specification** and **Product UI Blueprint** get turned into files, in what order, with what boundaries

---

## 0. Purpose & How to Use This Guide

The two upstream documents describe *what the app looks like* and *what it does*. Neither describes *how to organize the codebase, in what order to build it, or how to avoid stepping on another agent's work*. This document is that missing layer. It is written for an agent with no memory of prior sessions — every rule here should be independently followable from a cold start.

**Priority order when documents conflict:** Non-Negotiable Design Rules (Blueprint §7) > this guide > Blueprint component/screen specs > Visual Spec tokens. If this guide ever appears to contradict a Non-Negotiable Rule, the rule wins and the conflict should be flagged, not silently resolved.

**Before writing any code in a session:** read §1 (file governance) and §7/§9 (build order) below, then locate where in that order the current task falls before touching anything.

---

## 1. Source-of-Truth Documents & File Governance

### 1.1 The three documents, and where they live in the repo

| Document | Repo location | Status |
|---|---|---|
| Visual Design Specification | `/docs/specs/visual-design-specification.md` | Read-only reference |
| Product UI Blueprint | `/docs/specs/ui-blueprint.md` | Read-only reference |
| This guide | `/docs/specs/implementation-guide.md` | Read-only reference |

Copy the two source markdown files into `/docs/specs/` verbatim at project start. **No agent ever edits these three files as part of a feature task.** If a spec appears wrong, incomplete, or contradicts itself, that is a spec-gap to flag in a PR description or issue — never a silent in-code workaround (this mirrors Blueprint Rule 20).

### 1.2 Files you may edit freely

- Screen files (`lib/screens/**`) and their screen-unique sub-widgets.
- New component files, **only** when adding a genuinely new Component Library entry (see §1.3).
- Test files.
- `lib/navigation/app_router.dart`, when adding a new route that follows the existing transition model (§1.3 of the Blueprint).

### 1.3 Files you may only *extend*, never fork

- `lib/widgets/components/**` — the Component Library. If a screen seems to need a one-off variant of an existing component, **add a variant to that component's file** (with full states/props, matching how the Blueprint documents variants) rather than creating a copy-pasted sibling widget. This is Blueprint Rule 3, made literal: a second `MacroTileButBlue.dart` file is a rule violation regardless of how small the diff would otherwise be.
- `lib/theme/**` — see §1.4. Extending means adding a **named token**, never adding a raw value inline elsewhere.

### 1.4 Files you must never edit without an explicit spec-revision instruction

| File | Why it's locked |
|---|---|
| `lib/theme/app_colors.dart` | Every hex value in the app traces to this file. Editing it changes the whole app's palette silently. |
| `lib/theme/app_typography.dart` | Same reasoning for type scale. |
| `lib/theme/app_radius.dart`, `app_spacing.dart`, `app_elevation.dart`, `app_motion.dart` | Same reasoning for radius/spacing/elevation/motion constants. |
| `pubspec.yaml` font registration block (Ndot + Inter) | Font family names are referenced by string key throughout the theme layer; renaming breaks every consumer silently. |
| Any `*.g.dart` generated file | Regenerate via build_runner, never hand-edit. |

If a task genuinely requires a new token (e.g., a new status color), add it to the relevant theme file as a **new named constant** — do not repurpose or overwrite an existing token's value.

---

## 2. Code Organization

```
lib/
  theme/
    app_colors.dart          # Visual Spec §2 — ThemeExtension<AppColors>
    app_typography.dart      # Visual Spec §3 — text styles, Ndot + Inter
    app_radius.dart          # Visual Spec §5
    app_spacing.dart         # Visual Spec §6 — 4px scale constants
    app_elevation.dart       # Visual Spec §4 — 5 levels, shadow defs
    app_motion.dart          # Visual Spec §8 — durations, curves, allowlist
    app_theme.dart           # assembles the one ThemeData the app uses
    breakpoints.dart         # §5 of this guide
  widgets/
    primitives/              # Blueprint §2.1–2.2
      app_button.dart
      app_card.dart
      toggle_switch.dart
    components/               # Blueprint §2.3–2.16 — the Component Library
      macro_tile.dart
      calorie_hero.dart
      progress_ring.dart
      streak_countdown_numeral.dart
      ndot_count_up.dart      # shared animation utility, see §10
      bottom_nav_bar.dart     # includes the FAB
      log_row.dart
      search_bar.dart
      search_result_row.dart
      chip_segmented_control.dart
      toast.dart
      dialog.dart
      bottom_sheet.dart
      skeleton_loader.dart
      inline_spinner.dart
      charts/
        chart_skeleton.dart    # shared structural base, Blueprint §2.14
        calorie_trend_chart.dart
        macro_trend_chart.dart
        weight_trend_chart.dart
        logging_heatmap.dart
    system_states/
      empty_state.dart
      error_state.dart
      offline_banner.dart
  screens/
    dashboard/
      dashboard_screen.dart
      widgets/ai_coach_entry_card.dart
    food_log/
      food_log_screen.dart
      widgets/day_selector.dart
      widgets/section_header.dart
    food_search/
      food_search_screen.dart
    food_detail/
      food_detail_screen.dart
      widgets/serving_stepper.dart
    quick_add/
      quick_add_sheet.dart
    analytics/
      analytics_screen.dart
      widgets/stat_card.dart
    weight_tracking/
      weight_tracking_segment.dart
    ai_coach/
      ai_coach_screen.dart
      widgets/message_bubble.dart
    profile/
      profile_screen.dart
      widgets/avatar.dart
    settings/
      settings_screen.dart
      widgets/setting_row.dart
    onboarding/
      onboarding_screen.dart
  navigation/
    app_router.dart           # route table + transition model, Blueprint §1.3
  models/
  state/
  main.dart
```

**Rule:** `section_header.dart` is written once (used by Food Log and Settings, per Blueprint §3.10). If a second screen needs it, import it — do not redeclare it locally.

---

## 3. Naming Conventions

| Element | Convention | Example |
|---|---|---|
| File names | `snake_case.dart` | `macro_tile.dart` |
| Widget classes | `PascalCase`, matches Blueprint component name exactly | `MacroTile`, `CalorieHero`, `BottomNavBar` |
| Variant enums | `PascalCase` enum, values name the variant as written in the spec | `enum ButtonVariant { primary, secondary, ghost, icon, destructive }` |
| Token constants | `camelCase`, mirrors the spec's dotted token name | `AppColors.macroProtein` for `macro.protein`, `AppSpacing.xl` for the 32px step |
| Screen classes | `PascalCase` + `Screen` suffix | `DashboardScreen`, `FoodSearchScreen` |
| Screen-unique widgets | `PascalCase`, no generic names | `AiCoachEntryCard`, not `InsightCard` (ambiguous with AI Coach's own Insight Card, Blueprint §3.8) |
| Test files | mirror source path under `test/`, suffix `_test.dart` | `test/widgets/components/macro_tile_test.dart` |
| Golden test assets | `goldens/<component>/<variant>_<state>.png` | `goldens/macro_tile/protein_over_target.png` |

**Grep-ability rule:** every token constant name and every widget class name must be findable by searching the Visual Spec or Blueprint's own vocabulary. If an agent invents a name not traceable to either document (e.g., `kPrimaryRed` instead of `AppColors.accentSignal`), that is a naming violation — rename it before merging.

---

## 4. Theme & Token Usage

- There is exactly **one `ThemeData`**, assembled in `app_theme.dart`. Screens and widgets consume it via `Theme.of(context)` and custom `ThemeExtension` classes — never via imported raw constants scattered across files, and never via a second competing theme object.
- Tokens not natively expressible in Flutter's `ThemeData` (macro colors, elevation levels on true black, Ndot font role, motion durations) live in `ThemeExtension` subclasses (`AppColors`, `AppElevation`, `AppMotion`) registered on the theme, so `Theme.of(context).extension<AppColors>()!.macroProtein` is the only correct way to read them.
- **No `Color(0xFF...)`, no raw `EdgeInsets.all(17)`, no raw `Duration(milliseconds: 240)` outside `lib/theme/**`.** Every value used in a screen or component file must resolve to a named token. This is Blueprint Rule 1 enforced structurally, not by convention alone — a code reviewer (human or agent) should treat a raw literal in a widget file as a defect, not a style nit.
- Tabular figures (Visual Spec §3.1) are a `TextStyle` feature flag set once in `app_typography.dart` (`fontFeatures: [FontFeature.tabularFigures()]`) on every numeral-bearing style — never toggled ad hoc per screen.
- Ndot font usage is gated at the type-style level, not the call site: only the four styles that are allowed to use it (`displayXL`, `displayL`, and the two Streak/Countdown variants) reference the Ndot font family in `app_typography.dart`. There is no `useNdot: true` boolean parameter anywhere else in the codebase — if a component wants Ndot, it must use one of those four named styles, which structurally prevents Blueprint Rule 4 from being violated by a stray flag.

---

## 5. Responsive Breakpoints

| Breakpoint | Width | Behavior |
|---|---|---|
| `mobile` | `< 600` | Single column, full-bleed within 20px gutter (default for all screens). |
| `tablet` | `600 – 1024` | Content caps at 640px and centers, per screen-by-screen exceptions below. |
| `desktop` | `> 1024` | Same cap as tablet — this app does not reflow to multi-column at desktop widths (Blueprint §3.1); desktop is treated as "tablet with more empty margin," not a distinct layout. |

Implement via a single `Breakpoints` utility (`lib/theme/breakpoints.dart`) exposing `Breakpoints.of(context)` returning an enum, backed by `LayoutBuilder`/`MediaQuery` — never ad hoc `MediaQuery.of(context).size.width > 600` checks scattered per screen.

**Named exceptions to the 640px cap** (must be implemented as explicit per-screen overrides referencing the rule they override, not silently copied):

| Screen / element | Cap | Source |
|---|---|---|
| Charts (Analytics, Weight) | may exceed 640px, up to full available width | Blueprint §3.6 |
| Food Detail content column | 480px, not 640px | Blueprint §3.4 |
| Food Search modal panel (large viewports) | 560px, centered with visible backdrop | Blueprint §3.3 |
| Bottom Sheet | 480px | Blueprint §2.11 |
| Dialog | 320px mobile / 400px tablet+ | Blueprint §2.10 |
| Bottom Nav Bar | fixed max-width 420px, always centered, never stretches | Blueprint §2.5 |

**Rule:** if a new screen is added that isn't in the table above, it inherits the default 640px cap. Do not invent a new cap value without recording it in this table.

---

## 6. Widget Hierarchy & Composition Model

Every screen follows the same three-layer composition, top to bottom in the widget tree:

```
Scaffold
 └─ (screen-level Scaffold body — scroll view, sticky headers per screen spec)
     └─ Section widgets, composed ONLY from:
         1. Component Library widgets (lib/widgets/components/**), unmodified except via documented props/variants
         2. Screen-unique widgets (lib/screens/<screen>/widgets/**), used only within their own screen
         3. Primitives (lib/widgets/primitives/**) directly, only for trivial layout glue
 └─ BottomNavBar (persistent screens only — never on pushed/modal screens, Blueprint §2.5)
```

A component file itself follows the same internal shape as its Blueprint entry — one widget class exposing `variant`, `state`, and content props exactly as enumerated in the spec (e.g., `MacroTile(variant: MacroVariant.protein, isOverTarget: bool, ...)`), not a family of near-duplicate classes.

**Composition test before writing any screen widget code:** list every visual block in the screen's Blueprint "Screen hierarchy" diagram, and for each block, name which Component Library entry or screen-unique widget it maps to. Any block that doesn't map to an existing library entry is either (a) a screen-unique widget to build now, or (b) a signal a new Component Library entry is needed — never an inline one-off `Container` tree assembled directly in the screen file.

---

## 7. Component Creation Order

Build bottom-up. Nothing in a later tier should be started before its dependencies in earlier tiers exist, because later tiers import earlier ones directly.

**Tier 0 — Foundation (build first, blocks everything else)**
1. `app_colors.dart`, `app_typography.dart`, `app_radius.dart`, `app_spacing.dart`, `app_elevation.dart`, `app_motion.dart`, `breakpoints.dart`
2. `app_theme.dart` (assembles the above into one `ThemeData`)
3. Font registration in `pubspec.yaml` (Ndot + Inter variable font)

**Tier 1 — Primitives**
4. `app_button.dart` (all 5 variants + 4 states, Blueprint §2.1)
5. `app_card.dart` (all 5 variants + states, Blueprint §2.2)
6. `toggle_switch.dart` (Blueprint §3.10)

**Tier 2 — Shared animation utility (needed by four different Tier-3/4 components)**
7. `ndot_count_up.dart` — one shared widget implementing the odometer count-up (Visual Spec §8, Blueprint §2.3/§2.4/§2.16). Build once here; Macro Tile, Calorie Hero, and Streak/Countdown Numeral Block all consume it rather than reimplementing count-up logic independently.

**Tier 3 — High-reuse components (used across 3+ screens)**
8. `bottom_nav_bar.dart` (incl. FAB) — needed before *any* primary screen can be assembled
9. `log_row.dart` (all variants: Standard, Compact, Editable, Optimistic-pending)
10. `search_result_row.dart` (reused verbatim by Quick Add, Blueprint §3.5)
11. `chip_segmented_control.dart` (Range Tabs, filter chips, segmented control — one file, three configurations)
12. `progress_ring.dart` (generic/secondary variant, Blueprint §2.15)
13. `skeleton_loader.dart` + `inline_spinner.dart`

**Tier 4 — Screen-anchored but still library-level**
14. `calorie_hero.dart` (depends on Tier 2's count-up utility and `progress_ring` geometry)
15. `streak_countdown_numeral.dart`
16. `chart_skeleton.dart`, then `calorie_trend_chart.dart` → `macro_trend_chart.dart` → `weight_trend_chart.dart` → `logging_heatmap.dart` (in this order, since each later chart reuses structure from the first)
17. `search_bar.dart` (collapsed + expanded, including the shared-element morph)

**Tier 5 — Overlays**
18. `toast.dart`, `dialog.dart`, `bottom_sheet.dart`

**Tier 6 — System states**
19. `empty_state.dart`, `error_state.dart`, `offline_banner.dart`

**Tier 7 — Screen-unique widgets**
20. Built alongside their screen in §9, not before — `ai_coach_entry_card.dart`, `day_selector.dart`, `section_header.dart`, `serving_stepper.dart`, `message_bubble.dart`, `avatar.dart`, `setting_row.dart`.

---

## 8. Reusable Widget Manifest

| Blueprint § | Component | File | Class |
|---|---|---|---|
| 2.1 | Buttons | `primitives/app_button.dart` | `AppButton` |
| 2.2 | Card | `primitives/app_card.dart` | `AppCard` |
| 2.3 | Macro Tile | `components/macro_tile.dart` | `MacroTile` |
| 2.4 | Calorie Hero | `components/calorie_hero.dart` | `CalorieHero` |
| 2.5 | Bottom Nav + FAB | `components/bottom_nav_bar.dart` | `BottomNavBar` |
| 2.6 | List Item / Log Row | `components/log_row.dart` | `LogRow` |
| 2.7 | Search Bar / Result Row | `components/search_bar.dart`, `components/search_result_row.dart` | `SearchBar`, `SearchResultRow` |
| 2.8 | Chip / Segmented / Range Tabs | `components/chip_segmented_control.dart` | `ChipSegmentedControl` |
| 2.9 | Toast | `components/toast.dart` | `AppToast` |
| 2.10 | Dialog | `components/dialog.dart` | `AppDialog` |
| 2.11 | Bottom Sheet | `components/bottom_sheet.dart` | `AppBottomSheet` |
| 2.12 | Skeleton Loader | `components/skeleton_loader.dart` | `SkeletonLoader` |
| 2.13 | Inline Spinner | `components/inline_spinner.dart` | `InlineSpinner` |
| 2.14 | Chart skeleton | `components/charts/chart_skeleton.dart` | `ChartSkeleton` |
| 2.15 | Progress Ring (generic) | `components/progress_ring.dart` | `ProgressRing` |
| 2.16 | Streak/Countdown Numeral | `components/streak_countdown_numeral.dart` | `StreakCountdownNumeral` |
| 6.1 | Calorie Trend Chart | `components/charts/calorie_trend_chart.dart` | `CalorieTrendChart` |
| 6.2 | Macro Trend Chart | `components/charts/macro_trend_chart.dart` | `MacroTrendChart` |
| 6.3 | Weight Trend Chart | `components/charts/weight_trend_chart.dart` | `WeightTrendChart` |
| 6.6 | Logging Heatmap | `components/charts/logging_heatmap.dart` | `LoggingHeatmap` |
| §4.1 | Empty State | `system_states/empty_state.dart` | `EmptyState` |
| §4.3 | Error State | `system_states/error_state.dart` | `ErrorState` |
| §4.4 | Offline Banner | `system_states/offline_banner.dart` | `OfflineBanner` |

Screen-unique widgets (not part of the shared library — do not import across screen folders):

| Blueprint § | Widget | File |
|---|---|---|
| 3.1 | AI Coach Entry Card | `screens/dashboard/widgets/ai_coach_entry_card.dart` |
| 3.2, 3.10 | Section Header (shared between these two screens only) | `screens/food_log/widgets/section_header.dart` |
| 3.2 | Day Selector | `screens/food_log/widgets/day_selector.dart` |
| 3.4 | Serving Stepper | `screens/food_detail/widgets/serving_stepper.dart` |
| 3.6 | Stat Card | `screens/analytics/widgets/stat_card.dart` |
| 3.8 | Message Bubble | `screens/ai_coach/widgets/message_bubble.dart` |
| 3.9 | Avatar | `screens/profile/widgets/avatar.dart` |
| 3.10 | Setting Row | `screens/settings/widgets/setting_row.dart` |

If code review finds a screen-unique widget imported by a second screen, that's a signal to promote it into the Component Library (Tier per §7) with a full spec entry — not to leave it cross-imported from its original screen folder.

---

## 9. Screen Implementation Order

Ordered so that early screens force the most-reused components to exist first, and later screens are increasingly pure composition with few or no new components.

1. **Navigation shell** — `app_router.dart` + `BottomNavBar` wired to empty placeholder screens for all four tabs. Establishes the transition model (Blueprint §1.3) before any real screen content exists.
2. **Dashboard** — exercises Calorie Hero, Macro Tile ×3, Log Row (Compact), Progress Ring ×2, and the AI Coach Entry Card. Highest component yield of any single screen — build it first among real screens.
3. **Food Log** — exercises Log Row (Standard + swipe + Editable + Optimistic-pending), collapsed Search Bar, sticky headers, Day Selector, Section Header, Empty State.
4. **Food Search** — exercises expanded Search Bar, Search Result Row, Chip (filter variant), Skeleton (result-row variant), Empty State (no-results variant).
5. **Food Detail** — exercises Serving Stepper, mini Macro Trend Chart (bar variant), Chip (single-select), Dialog (delete confirmation).
6. **Quick Add** — pure composition: Bottom Sheet + reused Search Result Row + Ghost Button. No new library components expected.
7. **Analytics** — exercises Segmented Control, Range Tabs, the full chart family, Stat Card, Logging Heatmap.
8. **Weight Tracking segment** — reuses Weight Trend Chart, Streak/Countdown Numeral (weigh-in variant), Dialog (Input variant), Log Row (compact).
9. **AI Coach** — exercises Message Bubble (screen-unique) and the composer text field (reuses the Search Bar's pill shell without food-specific affordances).
10. **Profile** — mostly composition: Avatar (screen-unique), reused Progress Ring, reused Card.
11. **Settings** — exercises Setting Row, Toggle Switch, Section Header (reused from Food Log).
12. **Onboarding** — build last; the Blueprint explicitly scopes it as a placeholder flow (§1.1), and it uniquely has no chrome/nav dependencies on anything above.
13. **Cross-cutting states pass** — wire Offline Banner and Error State into every screen that fetches server data (Dashboard, Food Log, Food Search, Analytics per Blueprint §4.2/§4.4); this is deliberately a separate pass *after* all screens exist, so it's applied consistently rather than ad hoc per screen.
14. **Global QA pass** — run the full checklist in §11/§12 below across every screen at once, since several rules (max 3–4 saturated hues, one Primary Button per screen, one ring-chart per screen) are only meaningfully checkable once everything exists side by side.

---

## 10. Animation Architecture

- **Central constants:** every duration/curve used anywhere in the app is a named constant in `app_motion.dart` (e.g., `AppMotion.pressSpring`, `AppMotion.countUp`, `AppMotion.tabCrossfade`) — no inline `Duration(milliseconds: N)` in a widget file.
- **One shared count-up implementation:** `NdotCountUp` (Tier 2, §7) is the single implementation used by Calorie Hero, Macro Tile, and Streak/Countdown Numeral Block. Do not write a second odometer/tween implementation for any of these — if one needs a variation (e.g., ring-fill synchronized to the numeral, Blueprint §2.4), extend `NdotCountUp` with a callback/listenable other widgets can key off, don't fork it.
- **Ambient motion allowlist is closed:** per Blueprint Rule 6, exactly two things in the entire app are permitted to animate without a direct user action or data change — the FAB's behavior-triggered glow pulse (Blueprint §2.5) and the skeleton shimmer (Blueprint §2.12). Any `AnimationController` with `repeat()` outside `bottom_nav_bar.dart` and `skeleton_loader.dart` is a rule violation and should be caught in review before merge.
- **Reduced motion:** wrap the app in a single `MotionScope`/`InheritedWidget` reading `MediaQuery.of(context).disableAnimations` (and platform reduce-motion flags) once at the root, exposed to all components via `AppMotion.of(context).reduced`. Every animated component checks this flag and degrades to instant/opacity-only per Visual Spec §8 — implement this check inside the shared primitives (`AppButton` press, `AppCard` press, `NdotCountUp`) so individual screens never need to remember to handle it themselves.
- **Transition model** (Blueprint §1.3) lives entirely in `app_router.dart` as named `PageTransitionsBuilder`/custom route classes — cross-fade for tab-to-tab, slide-push with 30%-speed parallax for stack pushes, slide-up for modal/sheet. Screens never define their own transitions inline.
- **Re-trigger discipline:** count-up and ring/bar-fill animations must only fire on an actual data change, never on screen re-entry/rebuild with an unchanged value (Blueprint §5). Implement by keying the animation off value-diffing (e.g., `didUpdateWidget` comparing old/new value) rather than off `initState`/`build` alone.

---

## 11. Testing Checklist

**Per component (before it's considered done):**
- [ ] Widget test covers every variant listed in its Blueprint entry.
- [ ] Widget test covers every state listed (default, pressed, disabled, loading, error, empty, over-target, etc. as applicable).
- [ ] Golden test exists for each variant × state combination that has a distinct visual appearance.
- [ ] Touch target ≥ 48×48 verified for every tappable element, including icon-only buttons (Blueprint Rule 16).
- [ ] Every icon-only or gesture-only interaction has a `Semantics` label and, where the spec calls for it, an exposed custom accessibility action (e.g., swipe-to-delete also exposed as a semantic action, Blueprint §2.6).
- [ ] No literal color/spacing/radius/duration values in the component's source — grep for `Color(0x`, raw numeric `EdgeInsets`, and raw `Duration(` before marking done.
- [ ] If the component includes a hero numeral, confirm it uses `NdotCountUp` and the Ndot font only if it's one of the four whitelisted cases (Blueprint Rule 4).

**Per screen (before it's considered done):**
- [ ] Widget tree matches the exact "Screen hierarchy" order in its Blueprint section — verified against the diagram block by block.
- [ ] Responsive golden tests at mobile, tablet, and (where the screen has a documented desktop behavior) desktop widths.
- [ ] Empty, Loading, and Error states each render correctly where the screen defines them (§4 of the Blueprint) — a screen with "no empty state needed" (e.g., Dashboard) should have a comment/test documenting *why*, not silent absence.
- [ ] Exactly one Primary Button visible on screen at any given state (Blueprint Rule 5).
- [ ] No more than 3–4 saturated hues visible at once, counting macro tiles + chart lines + status colors together (Blueprint Rule 2).
- [ ] At most one ring-chart visible on the screen (Blueprint Rule 9).
- [ ] Navigation transition into and out of the screen matches §1.3 of the Blueprint.
- [ ] Bottom Nav Bar present and correctly active-stated on primary tabs; absent on pushed/modal screens (Blueprint §2.5).

**Global regression suite (run before any release, not per-PR):**
- [ ] Full pass through the 20 Non-Negotiable Design Rules (Blueprint §7) as a literal checklist against the running app, not just the diff.
- [ ] Reduced-motion mode: spot-check every animated component degrades to instant/opacity-only.
- [ ] Search grep across `lib/` for raw hex/duration/px literals outside `lib/theme/**` returns zero results.
- [ ] Search grep for any second `ThemeData(` construction outside `app_theme.dart` returns zero results.

---

## 12. Acceptance Criteria / Definition of Done

A component PR is mergeable only if:
1. It references the exact Blueprint section it implements in the PR description (e.g., "Implements §2.6 List Item / Log Row").
2. Every variant/state named in that section exists in code and is covered by a test.
3. It introduces no new token, duration, or breakpoint value outside `lib/theme/**`.
4. It does not duplicate an existing Component Library entry — if functionality overlaps an existing component, the PR extends that component's variants instead.

A screen PR is mergeable only if:
1. Its widget tree is traceable, block by block, to the Blueprint's "Screen hierarchy" diagram for that screen.
2. It composes only from Component Library entries, its own screen-unique widgets, and primitives (§6) — no inline one-off visual construction duplicating an existing pattern.
3. All applicable rows of the §11 "per screen" checklist pass.
4. It does not add a fifth bottom-nav destination, a second Primary Button, or any other violation of the 20 Non-Negotiable Rules, even locally within that one screen.

**A task is not "done because it looks right."** Visual similarity to the spec without traceable structure (right component, right token, right file location) fails review — the point of this guide is that any agent picking up the codebase cold can find where a given pixel came from.

---

## 13. Non-Negotiable Guardrails Quick Reference

For fast lookup during implementation — full text lives in Blueprint §7:

1. No hardcoded spacing/color/radius/type — tokens only.
2. Max 3–4 saturated hues visible per screen at once.
3. New needs → extend the Component Library, never a one-off inline build.
4. Ndot numerals: exactly 4 whitelisted cases, nowhere else.
5. One Primary Button per screen, maximum.
6. Ambient/looping motion: FAB glow pulse and skeleton shimmer only.
7. 4px spacing scale everywhere: 4/8/12/16/20/24/32/40/48/64.
8. 640px content cap on larger viewports, charts are the named exception.
9. One ring-chart per screen, maximum.
10. Destructive actions always require Dialog confirmation, never scrim-dismissible.
11. Toast = reversible/low-stakes only; Dialog = decision required; Bottom Sheet = browsing/optional task. Never swapped.
12. Every loading area gets a shape-matched Skeleton; no generic spinners for content areas; skip loading state entirely if it would resolve in under ~400ms.
13. Empty states: calm, single line, icon + CTA (or icon + line, no CTA if nothing to tap).
14. Bottom nav: exactly 4 slots, Log is the FAB, Weight nests in Analytics, AI Coach enters via a Dashboard card.
15. Every icon-only element and custom gesture has an accessible label/equivalent.
16. Minimum 48×48 touch target everywhere, via padding not visual bulk.
17. Dominance order for the eye: Ndot numeral → color → type weight → size. Status color always outranks a macro's own semantic color on conflict.
18. No new elevation/shadow style beyond the 5 defined levels (two named exceptions only: long-pressed Log Row, floating Toast).
19. Charts: Range Tabs for zoom/window, scrub for point detail, legend-tap for filtering — nothing else, ever.
20. This guide and the two upstream specs are the complete spec. Ambiguity gets raised and resolved by adding a rule, never decided silently per-PR.
