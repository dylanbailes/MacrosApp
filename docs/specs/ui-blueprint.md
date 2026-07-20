# Product UI Blueprint
### Premium Macro & Nutrition Tracker — Complete Screen & Component Specification
Prepared for: Flutter Engineering Team · Phase 2 (follows Visual Design Specification)

---

## 0. How to Use This Document

This document is the single source of truth for **what the app is and how it behaves**, screen by screen and component by component. It assumes the reader has the companion **Visual Design Specification** (colors, type scale, radii, spacing unit, elevation, motion timing) open alongside it — this document does not repeat those tokens, it *applies* them.

Structure, in reading order:

1. **Information Architecture** — the full screen map and navigation model.
2. **Component Library** — every reusable piece, defined once, in full. Screens below only ever *reference* these by name.
3. **Screen Blueprints** — one per screen, in the exact vertical order the user encounters it, composed from library components plus any screen-unique elements (which are specified in full where they appear).
4. **System States** — the canonical empty / loading / error / offline patterns, then how each screen applies them.
5. **Interaction Patterns** — global rules for tap, long-press, hover, keyboard, and every named animation/transition.
6. **Chart Specification** — one exact spec per chart type used anywhere in the app.
7. **Non-Negotiable Design Rules** — the constraints no future change may violate.

Componentizing first and referencing second is itself a design decision: it is the only way to guarantee the "Log" button looks and behaves identically on Dashboard, Food Log, and Quick Add. If a screen appears to need a one-off variant of a library component, that is a signal to add a variant to the library entry — never to fork a new component.

---

## 1. Information Architecture & Navigation Map

### 1.1 Full screen inventory

| # | Screen | Reached from | Nav level |
|---|---|---|---|
| 1 | **Onboarding** (placeholder flow) | App first launch | Pre-nav (full screen, no chrome) |
| 2 | **Dashboard** (Home) | Bottom nav | Primary tab |
| 3 | **Food Log** | Bottom nav | Primary tab |
| 4 | **Food Search** | Food Log "+", Dashboard quick action, nav Log FAB | Modal-style full-screen push |
| 5 | **Food Detail** | Food Search result tap, Food Log row tap | Push |
| 6 | **Quick Add** | Nav FAB long-press, Dashboard quick action | Bottom sheet |
| 7 | **Analytics** | Bottom nav | Primary tab |
| 8 | **Weight Tracking** | Analytics tab (segmented), Profile | Push (or nested tab — see 1.2) |
| 9 | **AI Coach** | Dashboard insight card, dedicated nav entry point (see 1.3) | Primary tab or push |
| 10 | **Profile** | Bottom nav | Primary tab |
| 11 | **Settings** | Profile → gear icon | Push |
| 12 | **Dialogs** (system-wide) | Triggered contextually | Overlay |
| 13 | **Bottom Sheets** (system-wide) | Triggered contextually | Overlay |

### 1.2 Primary navigation decision

The bottom nav bar (per Visual Spec §7.4) has exactly **four slots**: **Home / Log / Analytics / Profile**, with Log broken out as the raised FAB. This means **Weight Tracking** and **AI Coach** are not top-level tabs — they must nest:

- **Weight Tracking** lives as a **range-tab segment inside Analytics** ("Nutrition" / "Weight" segmented control at the top of the Analytics screen — see §3.7), not a separate tab. This keeps the four-slot nav honest rather than overloading it to five.
- **AI Coach** is surfaced as a **persistent entry point at the top of Dashboard** (a compact insight card that always occupies the same slot — see §3.1) and pushes to a full **AI Coach** screen. It is not a tab because it is a feature the user visits in short, targeted bursts (ask a question, read a suggestion), not a home base they live in.

This decision must not be silently re-litigated by an engineer adding a fifth nav icon. If product later decides Weight or Coach need tab-level prominence, that is a scope change requiring a spec revision, not an implementation-time call.

### 1.3 Navigation transition model

- **Tab-to-tab** (Home ↔ Log ↔ Analytics ↔ Profile): **cross-fade only**, 150ms, no slide — these are peers, not a stack, so directional motion would falsely imply hierarchy.
- **Push** (e.g., Food Search → Food Detail, Profile → Settings): standard **slide-in-from-right / slide-out-to-left**, 220ms ease-out on enter, ease-in on exit, with the outgoing screen dimming 10% and sliding left at 30% speed (parallax) to reinforce depth.
- **Modal full-screen push** (Food Search, opened from the FAB or a "+"): **slide-up-from-bottom**, 250ms, covers the tab bar entirely. Dismiss is either the back gesture/button (slide back down) or a completed action (log something → slide down + return to the screen that opened it, not necessarily Home).
- **Bottom sheet** (Quick Add, filters, confirmations): **slide-up over a scrim**, 200ms, tab bar and current screen remain visible and dimmed underneath at 60% opacity — reinforces that a sheet is a temporary layer, not a new destination.

---

## 2. Component Library

Every entry below is complete: purpose, appearance, variants, states, spacing, typography, sizing, icons, animation, interaction, and accessibility. Screens compose these; they do not redefine them.

### 2.1 Buttons

**Purpose:** Trigger a single primary, secondary, or tertiary action.

**Visual appearance:** Per Visual Spec §7.2 — Primary is solid `accent.signal` pill; Secondary is `surface.02` + hairline pill; Ghost is transparent text-only; Icon is a `surface.01` circle.

**Variants:** Primary · Secondary · Ghost · Icon · Destructive (Primary shape, but fill is a flat `#3A1015` dark-red surface with `accent.signal` text — reserved for irreversible actions like "Delete entry," never for logging actions, so a destructive action is never visually confusable with the Log button).

**States:**
- Default — as specified.
- Pressed — scale 0.97, held for the duration of the press (spring, 120ms settle).
- Disabled — 40% opacity, no press feedback, no haptic.
- Loading — label replaced by a 16px inline spinner (see §2.13), button stays the same width (no layout jump) by reserving label width in advance.

**Padding:** Horizontal 24px, vertical 14px (min tap height 48px including padding, per accessibility floor). Icon buttons: fixed 44×44, icon centered.

**Typography:** Inter SemiBold 15/20, no letter-spacing.

**Sizing:** Full-width by default when it is the primary action on a form or sheet; intrinsic (hug content) when placed inline in a row (e.g., a card header action).

**Icons:** Optional leading icon, 20px, 8px gap before label. Icon-only buttons never carry a label.

**Animation:** Press scale as above. Primary button additionally carries the ambient glow at rest (24px blur, `accent.signal` 20% opacity) which intensifies to 35% opacity over 150ms on press and relaxes back on release.

**Interaction:** Single tap fires the action. No long-press behavior on any button variant except where a screen explicitly defines one (e.g., FAB long-press, §2.5). Hover (desktop/pointer devices only) raises background brightness 6% and shows a pointer cursor; no hover state exists on Ghost buttons beyond an underline.

**Accessibility:** Minimum 48×48 touch target regardless of visual size (padding compensates for visually smaller buttons). Every icon-only button must carry a text label for screen readers even though no label renders on-screen. Disabled buttons are excluded from tab order but announced as "dimmed/unavailable" if focus lands nearby via swipe navigation.

**When to use:** Primary — one per screen, the single most important action. Secondary — alternate but valid action (e.g., "Skip" next to "Continue"). Ghost — cancel/dismiss, low-emphasis navigation. Icon — utility actions in a toolbar or card corner.

**When not to use:** Never place two Primary buttons on one screen (see Non-Negotiable Rules). Never use Ghost for a destructive action — destructive actions must be visually distinct, never the lowest-emphasis style, so the user cannot destroy data by accident via a casual-looking tap.

---

### 2.2 Card

**Purpose:** The base container for grouped content — the single most-reused surface in the app.

**Visual appearance:** `surface.01`, `radius.md` (20px), 1px `hairline` border, no shadow at rest (per Elevation Level 1).

**Variants:** Standard (vertical content stack) · Row (horizontal content, e.g., a food-log list item) · Hero (uses `radius.lg`/28px, reserved for the single most important card per screen — the calorie hero, the AI Coach summary card) · Interactive (adds the tap/press treatment below) · Static (informational only, no press feedback — used for legal text, disclaimers).

**States:** Default → on tap (Interactive variant only): scale to 0.98 and surface bumps to `surface.02` for 120ms, per Visual Spec §7.1. Long-press (where defined, e.g., Food Log rows): after 350ms, haptic tick + card lifts with a subtle `0 8px 20px rgba(0,0,0,.4)` shadow (an intentional, rare exception to "no shadow on black," justified because the card is genuinely floating above its siblings during a contextual-menu interaction) and a contextual action sheet appears.

**Padding:** 16–20px internal, scaled to content density (20px for hero/standalone cards, 16px for dense list-style cards).

**Typography:** Inherits from content — a card itself carries no fixed typography, only its slots do.

**Sizing:** Full-bleed within the 20px screen gutter by default. Cards in a horizontal scroll row (e.g., quick-add food chips) size to content with a fixed max-width to prevent one long name from breaking rhythm.

**Icons:** None inherent to the card shell.

**Animation:** Press/lift as described in States.

**Interaction:** Tap (Interactive variant) navigates or expands. Long-press (where defined) opens contextual actions. Swipe (Food Log rows only) reveals Edit/Delete — see §3.2.

**Accessibility:** Entire card is one semantic tap target (never nested tap targets smaller than 44px inside a card that is itself tappable — if a card needs an internal button too, e.g. a "..." menu, that inner icon button must have priority over the card's own tap zone and a hit-slop that doesn't overlap ambiguously).

**When to use:** Any grouped, self-contained unit of content.

**When not to use:** Don't wrap the entire screen body in one giant card — cards group *specific* related content; a full-screen wrapper card defeats the elevation system's purpose (nothing to contrast against).

---

### 2.3 Macro Tile

**Purpose:** Show one macro's consumed/target numbers at a glance in the 3-tile row pattern.

**Visual appearance:** Card (Standard variant), `radius.md`, sized to one-third of the row width minus gaps. Top: Label style micro-label ("PROTEIN") in `text.secondary`. Middle: large Inter SemiBold number in the macro's semantic color (e.g., `macro.protein` blue) with `text.tertiary` "/ 180g" target suffix in Body-weight, smaller size. Bottom: a thin 3px progress bar in the macro color at 20% track opacity, filled proportionally.

**Variants:** Protein · Carbs · Fat (color is the only difference — layout is identical across all three, which is what makes the row scannable).

**States:** Default · Over-target (number and bar switch to `status.negative` red regardless of the tile's normal macro color, because "over target" is a status the user must never miss, and status intentionally outranks macro-color semantics here) · Empty/zero (number renders as "0" in `text.tertiary`, bar empty, no special treatment beyond that — this is a normal start-of-day state, not an empty state pattern).

**Padding:** 16px internal.

**Typography:** Label: Label style (13/16, Inter Medium, +4% tracking, caps). Value: Headline-weight but at 20/24 (a size not in the base scale, intentionally between Headline and Title — reserved only for this tile so three tiles' numbers all fit one line at any macro value from 0–999g). Target suffix: Caption (11/14), `text.tertiary`.

**Sizing:** Fixed height 92px regardless of content, so the row never staggers.

**Icons:** None.

**Animation:** Value count-up (odometer-style, per Visual Spec §8) whenever the underlying number changes (a log is added/edited/deleted) — 400ms duration, ease-out. Progress bar fill animates in parallel, same duration.

**Interaction:** Tap opens Food Detail-style breakdown... actually tap opens a small popover/bottom sheet showing which logged foods contributed to that macro today (not a push — this is a peek, not a destination).

**Accessibility:** Each tile announces as one unit: "Protein, 142 of 180 grams, 79 percent of target."

**When to use:** Dashboard hero area, Analytics nutrition summary.

**When not to use:** Never use a Macro Tile to show a non-macro number (e.g., don't repurpose the shape for "steps" — create a distinct Stat Tile if that's ever needed, since color semantics would otherwise leak).

---

### 2.4 Calorie Hero / Progress Ring

**Purpose:** The single most important number on Dashboard — today's calories consumed vs. target.

**Visual appearance:** A large circular ring (Apple Health-derived, used narrowly per Visual Spec §0) with the Ndot Display XL numeral (56/60) centered inside showing calories consumed, and a small Inter Caption line beneath it ("of 2,400 kcal"). Ring track is `surface.02`; ring fill is `energy.neutral` (kept neutral so it never competes with the three macro colors sitting just below it in the hierarchy).

**Variants:** On-target (ring fill as described) · Over-target (ring fill switches to `status.negative`, and the ring "overshoots" visually by continuing a thin second lap in red past the 100% mark, capped at showing one full extra lap max, so extreme overconsumption doesn't produce a visually broken multi-wrap ring) · Under-logging-warning (used late in the day if very little has been logged — ring stays neutral but a small `status.holding` dot and caption "Nothing logged since 2pm" appears beneath, linking to Quick Add).

**States:** As variants above, plus a Loading state (ring track only, shimmer, no numeral) and Empty state (numeral shows "0", ring empty, caption reads "Log your first meal").

**Padding:** Ring diameter 180px, sits centered within a Hero card with 24px padding on all sides.

**Typography:** Numeral: Ndot Display XL. Caption: Inter Caption (11/14), `text.secondary`.

**Sizing:** Fixed 180px ring on mobile; scales to 220px on tablet (see §3.9 for breakpoint rules generally).

**Icons:** None on the ring itself.

**Animation:** Ring fill animates via a sweep (not a snap) from previous value to new value over 500ms ease-out whenever calories are logged, synchronized with the numeral count-up so both finish at the same instant.

**Interaction:** Tap opens a breakdown bottom sheet (meals logged today, in order, each row tappable to Food Detail).

**Accessibility:** Announces as "2,140 of 2,400 calories, 89 percent of daily target, on track."

**When to use:** Dashboard only. This is a hero — using it elsewhere dilutes its meaning.

**When not to use:** Never use the ring pattern for macros (macros use Macro Tiles' linear bars, per Visual Spec §11's "ring chart cliché" caution — one ring per screen, maximum).

---

### 2.5 Bottom Navigation Bar & FAB

**Purpose:** Primary app-level navigation, always present except during modal pushes and onboarding.

**Visual appearance:** Per Visual Spec §7.4 — floating pill, `surface.01` + 20px backdrop blur, 16px margin from screen edges and bottom safe area. Four icon+label slots (Home, Log, Analytics, Profile); Log is replaced by a raised circular FAB breaking the top edge of the bar.

**Variants:** Default (all four visible) · Compressed (labels hide, icons only — triggered automatically on scroll-down of long lists to reclaim vertical space, see §5) · Hidden (fully slides off-screen during full-screen modal pushes and onboarding).

**States:** Each of the three non-FAB slots: Inactive (`text.secondary` icon+label, no pill) · Active (`accent.signal` icon+label on a `surface.02` pill behind it, per Visual Spec §7.4). FAB: Rest (ambient glow, `accent.signal` solid circle, white plus icon) · Pressed (glow intensifies, scale 0.95) · Recording/processing (after tap, briefly shows a spinner in place of the plus icon while Quick Add sheet animates up).

**Padding:** Bar height 64px. FAB diameter 64px, breaking 20px above the bar's top edge.

**Typography:** Label: Caption (11/14), Inter Medium.

**Sizing:** Bar width: content-width, not full-bleed — centers with roughly 24px clearance from screen edges on mobile (a floating pill, not a full-width bar). On tablet/desktop widths, the bar does not stretch — it stays a fixed max-width (420px) and centers, because a full-width stretched pill at desktop widths would look like a broken layout, not a considered one.

**Icons:** 24px, single-weight 1.5px stroke (per icon system). FAB icon: 28px plus glyph, 2px stroke (slightly bolder — it's the one icon in the app permitted extra visual weight, matching its outsized functional importance).

**Animation:** Tab switch is instant icon/label color change + pill cross-fade, 150ms — no bounce (this is a utility, not a delight moment; delight is reserved for the FAB and numerals, per hierarchy in Visual Spec §11). FAB glow pulses very subtly (opacity 20%→26%→20%) on a slow 3s loop *only* when the user has not logged anything in the last 4+ hours during waking hours — this is the one permitted exception to "motion is never ambient" (Visual Spec §8), justified because it is data-driven (a real behavioral signal), not decorative, and stops the instant a log occurs.

**Interaction:** Tap on Home/Analytics/Profile: cross-fade tab switch. Tap on FAB: opens Food Search (full-screen push) — the fastest path to logging. Long-press on FAB (500ms, haptic): opens Quick Add bottom sheet instead — the fast path for a food the user logs often, skipping search entirely.

**Accessibility:** Each nav item is a distinct accessible element with role "tab" and state "selected"/"not selected." FAB is role "button," label "Log food," and long-press is exposed via a custom action ("Quick add") for screen-reader users who cannot perform a timed gesture.

**When to use:** Every primary screen.

**When not to use:** Never on Food Search, Food Detail, Settings, or any pushed/modal screen — those use a back arrow in a simple header instead, so the user always has one clear way to retreat from a non-home screen.

---

### 2.6 List Item / Log Row

**Purpose:** One logged food entry in Food Log or Dashboard's "Recent Meals."

**Visual appearance:** Card (Row variant), `radius.sm` (12px — slightly tighter than standard cards since these stack densely), hairline border. Left: small 40×40 rounded-square food-category glyph or thumbnail. Middle: food name (Headline, `text.primary`) + serving size/time (Caption, `text.tertiary`) stacked. Right: calorie number (Inter SemiBold, tabular figures, `text.primary`) stacked above a tiny 3-dot macro chip row (small colored dots for P/C/F proportion).

**Variants:** Standard · Compact (Dashboard "Recent Meals" truncates to 3 rows and drops the macro-dot row to save vertical space) · Editable (swipe-revealed state, see Interaction).

**States:** Default · Pressed (per Card base) · Swiped-open (row shifts left 96px, revealing Edit (surface.02, pencil icon) and Delete (destructive-red, trash icon) action buttons beneath) · Optimistic-pending (just logged, hasn't confirmed with backend — row renders at 70% opacity with a small inline spinner replacing the calorie number until confirmed, then cross-fades to full opacity).

**Padding:** 12px vertical, 16px horizontal internal.

**Typography:** As described above; all numerals tabular so calorie counts align in a column when rows stack.

**Sizing:** Fixed height 64px (Standard), 56px (Compact).

**Icons:** Category glyph (single-weight, matches icon system, `text.secondary` unless a real food photo thumbnail exists, in which case the photo replaces the glyph in the same 40×40 rounded-square mask).

**Animation:** Swipe-open reveal, spring-based, follows finger 1:1 during drag then either snaps open (past 40% threshold) or closed (spring back). New row insertion (after logging): slides in from top + fades in, 250ms.

**Interaction:** Tap → Food Detail (view/edit that specific entry). Swipe-left → reveals Edit/Delete. Long-press → same contextual action sheet as swipe (redundant path for accessibility/discoverability, since not everyone discovers swipe gestures).

**Accessibility:** Swipe actions are exposed as custom accessibility actions ("Edit," "Delete") so screen-reader users get them without needing the swipe gesture.

**When to use:** Any list of logged food entries.

**When not to use:** Not for search results (see §2.7, a distinct component with different information priority — search prioritizes name + quick-add, not calories-at-a-glance).

---

### 2.7 Search Bar & Search Result Row

**Purpose:** Find and add a food.

**Visual appearance (collapsed):** Pill, `surface.02`, hairline border, search-glyph + "Search foods" placeholder in `text.tertiary`, sits top-right of Food Log per Visual Spec §7.3.
**Visual appearance (expanded):** Full-screen overlay, `surface.03` background with 20px blur, autofocus text field pinned to top under the status bar, cancel/close (Ghost button) to its right.

**Result Row (distinct from Log Row):** Card (Row variant, Compact height 56px). Left: food name (Headline) + brand/source (Caption, `text.tertiary`) stacked. Right: a small round Icon-button "+" (surface.02 circle, 32px — smaller than the standard 44px icon button, intentionally, since it appears many times per screen in a dense list and a full 44px target here would force excessive row height) that quick-adds the default serving directly from the list without opening Food Detail.

**Variants:** Recent search chip (horizontal scroll row of pill chips above results, `radius.xs`, tap fills the search field with that term) · Quick-add row (frequent foods, shown before any query is typed) · Result row (post-query).

**States:** Empty query (shows Recent chips + Quick-add row only) · Typing (debounced 300ms, then live results) · No results (System Empty State, see §4) · Loading (skeleton rows, see §4).

**Padding:** Search field: 16px horizontal, 44px height. Result rows: 16px horizontal, 12px vertical.

**Typography:** Field placeholder/input: Body (15/20). Result name: Headline. Result meta: Caption.

**Sizing:** Full-width field. Result rows full-bleed within gutter.

**Icons:** Search glyph 20px leading the field. Quick-add "+" 18px glyph inside its 32px circle.

**Animation:** Collapse→expand: the pill morphs into the full-width field via a shared-element-style scale+position tween, 220ms (this specific transition is the one Arc-Browser-style "playful micro-interaction on one primary action" reference called for — reserved for this single moment in the app, per Visual Spec §0's caution against overusing it).

**Interaction:** Tap collapsed bar → expand. Type → debounced live search. Tap a result row → Food Detail. Tap "+" on a result row → optimistic quick-add (row briefly shows a checkmark pulse, then the overlay can be dismissed or the user continues searching — quick-add does not force-close search, so multi-item logging is fast).

**Accessibility:** Search field auto-announces "Search foods, edit text" on focus. Each quick-add "+" is independently labeled "Add [food name]" so it's actionable without ambiguity in a screen-reader swipe order.

**When to use:** Food Search screen exclusively for the expanded form; the collapsed pill appears on Food Log.

**When not to use:** Don't reuse Search Bar styling for any non-food search (e.g., a future "search settings" should get its own simpler inline field — this component's affordances are food-specific, notably the quick-add row).

---

### 2.8 Chip / Segmented Control / Range Tabs

**Purpose:** Mutually-exclusive selection among a small set of options (chart range, filter category, recent search term).

**Visual appearance:** Pill row, `radius.full`. Segmented control variant: all options visible at once in one continuous track (`surface.02` base), the active segment sits on a `surface.01`-on-`surface.02` inset highlight... to keep consistent with elevation logic, the **active** segment is actually the *brighter* one — rendered as a small `text.primary`-bordered pill floating over a dimmer unselected track, sliding between positions rather than cross-fading.

**Variants:** Range tabs (1W/1M/3M/6M/1Y/ALL, used on every chart) · Category filter chips (multi-select, food category filters in Search) · Recent-search chips (tap-to-fill, not a persistent selection state).

**States:** Selected · Unselected · Disabled (e.g., "ALL" range disabled if fewer than 2 weeks of data exist yet).

**Padding:** 12px horizontal, 8px vertical per chip/segment.

**Typography:** Label style but not caps-forced for range tabs specifically (they show "1W" etc. as given) — Inter Medium 13/16.

**Sizing:** Segmented control spans the width needed for its options, typically left-aligned under a chart, not full width (forcing a 6-option control to stretch full-width creates awkward touch targets — it hugs content and left-aligns under the chart it controls).

**Icons:** None, text-only.

**Animation:** Selection indicator slides (not fades) between positions, 180ms ease-out — this is the primary way the user perceives "control," so it must feel physically continuous, not like separate buttons lighting up.

**Interaction:** Tap selects (single-select variants deselect all siblings automatically). Multi-select filter chips toggle independently and show a small checkmark once selected.

**Accessibility:** Exposed as a radio-group (single-select) or a set of independent toggle buttons (multi-select filter chips), never as generic unlabeled buttons.

**When to use:** Any small (≤6 option) mutually exclusive or independent-toggle choice that must stay visible (not hidden in a dropdown).

**When not to use:** More than 6 options — use a bottom sheet list/picker instead (§2.11), since a segmented control that requires horizontal scrolling defeats its own purpose (all options should be visible without interaction).

---

### 2.9 Toast / Snackbar

**Purpose:** Confirm a transient, low-stakes action without interrupting flow (e.g., "Added to log," "Entry deleted — Undo").

**Visual appearance:** `surface.03` pill/rounded-rect, floats just above the bottom nav bar (or bottom-safe-area on modal screens with no nav), 1px top highlight per Elevation Level 3, drop shadow per that same level (this is one of the few permitted shadow instances — a toast is genuinely floating transiently above everything).

**Variants:** Confirmation (checkmark icon, `status.positive` accent) · Undo-able (adds a "Undo" Ghost-button-style text action on the right) · Error (small `status.negative` icon, used only for soft/recoverable errors — hard errors get a Dialog, not a toast, see §4).

**States:** Entering · Visible (auto-dismiss after 4s unless it has an Undo action, in which case 6s) · Exiting.

**Padding:** 16px horizontal, 12px vertical.

**Typography:** Body (15/20), `text.primary`. Undo action: Inter SemiBold, `accent.signal`.

**Sizing:** Hugs content, max-width 90% of screen width, centered horizontally.

**Icons:** 18px leading icon matching variant.

**Animation:** Slide up + fade in, 200ms ease-out on enter; slide down + fade out, 150ms ease-in on exit (or immediately if the user taps Undo).

**Interaction:** Non-blocking — user can keep interacting with the screen underneath. Tapping Undo reverses the action and immediately dismisses the toast. Swiping the toast down dismisses it early.

**Accessibility:** Announced via a live region so screen readers speak it without stealing focus from whatever the user was doing.

**When to use:** Any reversible, non-critical confirmation.

**When not to use:** Never for anything requiring a decision before proceeding (that's a Dialog) and never stacked — only one toast on screen at a time; a second toast queues rather than overlapping.

---

### 2.10 Dialog (Modal)

**Purpose:** Interrupt the user for a decision that must be made before continuing (confirm delete, irreversible action, required permission).

**Visual appearance:** Centered card, `surface.03`, `radius.lg`, over a full-bleed `rgba(0,0,0,.7)` scrim with 20px blur (Elevation Level 4). Title (Title style), body copy (Body style, `text.secondary`), then a horizontal button row (or stacked on narrow widths — see below).

**Variants:** Confirmation (two actions: Ghost "Cancel" + Primary or Destructive "Confirm") · Informational (single Primary "OK/Got it") · Input (rare — contains a single form field, e.g., renaming a saved meal).

**States:** Entering (scale from 0.95→1 + fade, 200ms) · Visible · Exiting (fade + scale to 0.97, 150ms).

**Padding:** 24px all sides.

**Typography:** Title: 22/28 SemiBold. Body: 15/20 Regular, `text.secondary`.

**Sizing:** Max-width 320px on mobile, centers with margin; max-width 400px on tablet/desktop (never full-width — a dialog that touches both screen edges reads as a full page, undermining its "interruption" framing).

**Icons:** Optional single centered icon above the title for high-emphasis warnings (e.g., destructive delete) — 32px, `status.negative` if destructive.

**Animation:** As described in States. Scrim fades in in parallel, 200ms.

**Interaction:** Tapping the scrim dismisses only for Informational dialogs (equivalent to "OK"); Confirmation dialogs require an explicit button tap (never dismiss-by-scrim-tap for anything destructive or decision-bearing, so an accidental tap can't confirm a delete).

**Accessibility:** Focus traps inside the dialog while open; scrim and underlying screen are marked inert to screen readers; Escape/back gesture triggers the Cancel/dismiss action, never the destructive one.

**When to use:** Destructive confirmations, critical permission requests, irreversible account actions.

**When not to use:** Never for routine confirmations (use a Toast) and never for browsing/selecting content (use a Bottom Sheet) — a Dialog's whole purpose is "stop and decide," so overusing it for low-stakes moments trains users to blindly dismiss it, defeating its purpose for the one moment it truly matters.

---

### 2.11 Bottom Sheet

**Purpose:** A temporary, dismissible layer for a focused task that doesn't warrant leaving the current screen (Quick Add, filters, a picker list, calorie-hero breakdown).

**Visual appearance:** `surface.03`, `radius.lg` top corners only, rises from the bottom over a scrim (Level 3/4 combination — scrim per Level 4, sheet surface per Level 3). A small `hairline`-colored drag-handle bar (32×4px, centered, `radius.xs`) sits at the top for affordance.

**Variants:** Fixed-height (content-sized, e.g., a short confirmation) · Scrollable (content taller than ~60% of screen, e.g., Quick Add's food list) · Expandable/draggable (starts at ~50% height, user can drag the handle up to nearly full-screen — used for Quick Add specifically, since its list can be long).

**States:** Entering (slide up, 200ms ease-out) · Visible · Dragging (follows finger 1:1, rubber-bands slightly past full-expand or below dismiss-threshold) · Exiting (slide down, 180ms ease-in, or instant-follow if dismissed via drag-down past threshold).

**Padding:** 20px horizontal, 16px top (below the handle), safe-area bottom inset always respected.

**Typography:** Optional Title (22/28) if the sheet needs a heading; otherwise content typography per its own component specs (e.g., Log Rows inside Quick Add use their own type rules).

**Sizing:** Full-width, height per variant above; max-width 480px and centered on tablet/desktop (a full-width sheet at desktop widths would feel like an error state).

**Icons:** None inherent; content-dependent.

**Animation:** As described in States.

**Interaction:** Drag handle up/down to expand/dismiss. Tap scrim to dismiss (safe here, unlike Dialogs, because bottom sheets are for browsing/optional tasks, not destructive decisions — if a specific sheet ever contains a destructive action within it, that action still requires its own Dialog confirmation layered on top).

**Accessibility:** Announced as a modal region on open; focus moves to the sheet's first interactive element; swipe-down-to-dismiss is paired with an explicit close (X) button for users who can't perform the gesture.

**When to use:** Quick Add, filters, chart breakdowns, pickers (unit selection, date selection).

**When not to use:** Never for a flow with more than ~2 steps or that the user might want to return to later — that belongs on a full pushed screen (e.g., don't cram the whole Food Detail edit flow into a sheet; Quick Add is a sheet because it is fundamentally single-step).

---

### 2.12 Skeleton Loader

**Purpose:** Communicate a content area's shape while data loads, per Visual Spec §10.

**Visual appearance:** Solid `surface.02` blocks matching the exact shape/size of the real content they stand in for (a skeleton Log Row is the same 64px height and internal proportions as a real Log Row), with a `rgba(255,255,255,.06)` shimmer band sweeping left-to-right on a 1.5s loop.

**Variants:** One skeleton variant per component that can load asynchronously: Skeleton Log Row, Skeleton Macro Tile, Skeleton Chart (a flat shimmering baseline shape), Skeleton Card (generic rounded block for AI Coach cards, etc.).

**States:** Looping (only state — skeletons never pause, they are replaced outright by real content, never cross-faded gradually element-by-element, to avoid a flickering half-loaded look).

**Padding/Sizing:** Identical to the real component it represents, always.

**Animation:** Shimmer sweep, 1.5s linear loop, per Visual Spec §10.

**Interaction:** None — skeletons are never tappable.

**Accessibility:** Announced as "Loading [content type]" rather than reading out the shimmer as visible text; real content replacement re-announces normally.

**When to use:** Any full content area on initial load or refresh (see §4 for exact placement per screen).

**When not to use:** Never for small inline actions (button-internal loading spinner instead, per Visual Spec §10) and never for actions expected to resolve in under ~400ms (too-brief skeletons flash and feel like a glitch — anything that fast should just resolve instantly with no loading state shown at all).

---

### 2.13 Inline Spinner

**Purpose:** Indicate a small, fast, in-place async action (button submitting, pull-to-refresh in progress).

**Visual appearance:** Thin (2px stroke) circular indeterminate spinner, `text.primary` on dark surfaces or white on `accent.signal` fills, 16–20px depending on host component.

**Variants:** Button-internal (replaces label) · Pull-to-refresh (appears at the top of a scroll view, see §5) · Row-pending (inside an optimistic Log Row, §2.6).

**States:** Spinning (only state).

**Animation:** Continuous rotation, 800ms per revolution, linear.

**Interaction:** None, purely informational.

**Accessibility:** Announced once as "Loading" on appearance, not repeatedly.

**When to use:** Per Visual Spec §10 — small inline actions only.

**When not to use:** Never for a full content area (use Skeleton instead).

---

### 2.14 Chart Components

Full behavioral spec lives in §6. Structurally, every chart is composed from: a **Range Tab** header (§2.8), an edge-to-edge **plot area** with a single hairline baseline (no gridlines), an optional **flux band** (low-opacity fill), a **primary line/bars**, and optional **point markers** that appear only on scrub. Charts are their own component family because — unlike Cards or Buttons — no two chart *instances* are visually interchangeable (a weight chart and a calorie-trend chart share structure but never share color meaning), so §6 treats each concrete chart as its own spec built from this shared skeleton.

---

### 2.15 Progress Ring (generic, non-hero)

**Purpose:** A smaller-scale ring used in Analytics/Profile for goal completion (e.g., "weekly logging streak," "protein-goal-hit days this week") where the Dashboard hero ring would be too dominant.

**Visual appearance:** Same visual language as §2.4 but at 64px diameter, Inter (not Ndot) numeral inside (SemiBold, 17/22) since Ndot is reserved exclusively for hero stats and this is a secondary metric.

**Variants:** Single-ring (one metric) · Concentric (max 2 rings, e.g., "days logged" outer + "goal streak" inner — never 3+ concentric rings, which becomes unreadable at this scale).

**States:** Default, Empty (0%, track only), Complete (100%, small checkmark badge overlays bottom-right corner).

**Padding:** 8px clearance from ring edge to any card border it sits inside.

**Typography:** As above.

**Sizing:** Fixed 64px; does not scale responsively (small secondary metrics don't need tablet-scale enlargement the way the hero does).

**Animation:** Sweep-fill on data change, 400ms.

**Interaction:** Tap opens a small tooltip/popover with the exact fraction ("5 of 7 days").

**Accessibility:** Announces the fraction and label together.

**When to use:** Analytics summary row, Profile stats.

**When not to use:** Dashboard (that's the hero ring's exclusive territory).

---

### 2.16 Streak / Countdown Numeral Block

**Purpose:** Display a small, high-emphasis number that is *not* the calorie hero but still earns Ndot treatment per Visual Spec §3.1 (streak days, check-in countdown, weigh-in headline number).

**Visual appearance:** Ndot Display L (34/38) numeral, `text.primary` (or `accent.signal` specifically for an active streak count, tying it to the brand color's "streaks" use per Visual Spec §2.2), with an Inter Caption label beneath ("day streak" / "days until check-in").

**Variants:** Streak (accent-colored) · Countdown (neutral `text.primary`) · Weigh-in headline (neutral, paired with a small up/down/flat trend glyph in the relevant status color).

**States:** Default, Milestone (streak hits a round number like 7/30/100 — numeral briefly (600ms, once) pulses scale 1→1.08→1 with a single soft glow flash, the *only* other place besides the Log button permitted a glow, and only as a one-time celebratory event, not ambient).

**Padding:** None inherent — sits inside whatever card hosts it (typically 20–24px card padding).

**Typography:** As above.

**Sizing:** Intrinsic to the numeral's digit count — container should not force a fixed width that causes awkward centering when digits change (e.g., streak going from 9 to 10 days).

**Icons:** Trend glyph (weigh-in variant only), 16px, status-colored.

**Animation:** Count-up on change (shared logic with Macro Tile/Calorie Hero — one shared "Ndot Count-Up" animation utility across the app, per Non-Negotiable Rules). Milestone pulse as described.

**Interaction:** Tap (Weight variant) opens Weight Tracking. Tap (Streak) opens a small info popover explaining streak rules. Countdown is typically non-interactive (informational only).

**Accessibility:** Announces plainly: "12 day streak" / "3 days until check-in."

**When to use:** Only the four cases named above — this is a small, curated whitelist, per Visual Spec §3.1's explicit restriction that Ndot never appears below 24px or on body/label text.

**When not to use:** Any number that isn't one of the four hero cases (macro grams, list calorie counts, chart axis labels — all of those stay Inter, always).

---

## 3. Screen Blueprints

### 3.1 Dashboard (Home)

**Purpose:** The daily landing screen. Answers, at a glance: "How am I doing today, and what should I do next?" Primary action: log a meal (via FAB) or open a suggested action from the AI Coach card.

**Screen hierarchy:**
```
Status Bar
↓
Page Header (date + greeting, settings-gear icon top-right shortcut)
↓
AI Coach Entry Card (compact, persistent)
↓
Calorie Hero (ring + Ndot numeral)
↓
Macro Overview (3-tile row: Protein / Carbs / Fat)
↓
Recent Meals (up to 3 Compact Log Rows + "View all" link to Food Log)
↓
Quick Actions (horizontal scroll: "Log Water," "Log Weight," "Log Weight Photo," etc. — small pill buttons, Secondary style)
↓
Weekly Snapshot (small secondary Progress Ring row: logging streak, goal-hit days)
↓
Bottom Navigation (Home active) + FAB
```

**Layout:** Screen margin 20px throughout. 32px gap between the sections listed above; 12px gap between sibling cards within a section (e.g., between the 3 macro tiles). Entire body scrolls vertically; Status Bar and Bottom Nav are the only sticky elements (Bottom Nav floats, per §2.5, rather than being a docked bar — it does not "stick" via scroll-locking, it is simply an overlay always present at a fixed screen position). Page Header scrolls away normally (not sticky) — Dashboard is short enough that re-exposing the header on scroll-up isn't necessary; contrast with Food Log, where the header *does* need sticky behavior (see §3.2).

**Responsive:** Mobile: single column, full-bleed sections as described. Tablet: content max-width caps at 640px and centers; Macro Overview becomes a touch more generous (each tile gets extra internal padding rather than growing wider unboundedly). Desktop (if ever supported): same 640px cap — this is fundamentally a mobile-first, single-column information density; desktop should not attempt a multi-column dashboard reflow, as that would require a genuinely different information architecture out of this spec's scope.

**Components used:** AI Coach Entry Card (screen-unique, described below), Calorie Hero (§2.4), Macro Tile ×3 (§2.3), Log Row (Compact variant, §2.6), Secondary Button (pill, §2.1) for Quick Actions, Progress Ring (generic, §2.15) ×2, Bottom Nav + FAB (§2.5).

**AI Coach Entry Card (screen-unique):** A Hero-radius Card, `surface.01`, containing: a small `accent.signal`-tinted sparkle/chat icon (24px) top-left, one line of Body-weight text summarizing the day's single most relevant insight ("Your protein has been low 3 days running — want a suggestion?"), and a trailing chevron. Full-card tap target → pushes to AI Coach screen. This card's content is dynamic but its *shape* never changes — always exactly one line of insight text, never a multi-line paragraph, so Dashboard's hierarchy never shifts based on coach content length (long insights truncate with an ellipsis; the full detail lives on the AI Coach screen itself).

---

### 3.2 Food Log

**Purpose:** A chronological, editable record of everything logged, grouped by day. Primary action: review/edit past entries, or jump into logging a new one.

**Screen hierarchy:**
```
Status Bar
↓
Sticky Header (screen title "Food Log" + collapsed Search pill, top-right)
↓
Day Selector (horizontal scroll strip of dates, current day centered/highlighted)
↓
Daily Calorie Summary bar (thin, compact — total consumed vs. target, no ring, just a number + slim linear bar; this is a lighter-weight echo of the Dashboard hero, not a duplicate of it)
↓
Meal Sections (Breakfast / Lunch / Dinner / Snacks — each a Section Header + stack of Log Rows)
↓
Bottom Navigation (Log active) + FAB
```

**Layout:** Screen margin 20px. Header is sticky (remains pinned while meal sections scroll beneath it) because this screen is scrolled through far more than Dashboard, and losing the search entry point or the ability to jump days would be a real cost. Day Selector is also sticky, directly beneath the header, forming a two-tier sticky stack. Gap between meal sections: 32px (section gap). Gap between rows within a section: 8px (tighter than the general 12px sibling-card gap, since these are visually a single continuous list, not discrete cards floating apart — achieved by removing the individual row's side margin so hairlines nearly touch, reinforcing "log," not "cards").

**Responsive:** Tablet: 640px max-width content column, centered; Day Selector strip gets more visible days at once (7 vs. 5 on mobile) since more horizontal room is available — this is a genuine responsive *count* change (not just spacing), which is called out explicitly here because it is the one place in the app where breakpoint changes the amount of content shown, not merely its layout.

**Components used:** Search Bar (collapsed, §2.7), Log Row (Standard + swipe-editable, §2.6), Section Header (Label-style eyebrow text, `text.tertiary`, e.g., "BREAKFAST · 420 kcal" — includes the section's own subtotal), Bottom Nav + FAB.

**Empty state:** If a selected day has zero entries: single Empty State block (per §4.1) sits where the meal sections would be, CTA "Log your first meal today" opening Food Search.

---

### 3.3 Food Search

**Purpose:** Find a specific food to log, fast. Primary action: land on a result and either quick-add it or open its detail to adjust serving size first.

**Screen hierarchy:**
```
Status Bar
↓
Expanded Search Header (autofocus field + Cancel)
↓
Category Filter Chips (multi-select, horizontal scroll) — visible always, above results
↓
[Empty-query state: Recent Search Chips row, then Quick-Add Frequent Foods row]
   — or —
[Query state: Result Rows list]
↓
(no bottom nav — full-screen modal push)
```

**Layout:** Screen margin 20px, except the search field itself which spans truly edge-to-edge inside its own 16px internal padding. Filter chips: 8px gap between chips, horizontal scroll, no wrap. Result rows: 8px gap, full-bleed within gutter (tight list rhythm, same reasoning as Food Log). No sticky elements beyond the search header itself, which is pinned because it must remain reachable to revise the query while scrolling long result sets.

**Responsive:** Tablet: 640px max content width, search field itself can optionally grow slightly wider than mobile but stays capped — this is one of very few screens where the modal itself might present as a centered, non-full-bleed panel on very large tablet/desktop viewports (max-width 560px, centered, with a visible dimmed backdrop on either side) since a full-bleed search modal at desktop width feels oversized relative to a component whose job is a tight, fast interaction.

**Components used:** Search Bar (expanded, §2.7), Chip (filter variant, §2.8), Search Result Row (§2.7), Skeleton (result-row variant, loading), Empty State (no-results variant, §4.1).

---

### 3.4 Food Detail

**Purpose:** View or adjust a specific food entry (serving size, meal assignment, time) before or after logging. Primary action: confirm/save the entry.

**Screen hierarchy:**
```
Status Bar
↓
Header (back arrow, food name as title, "..." overflow menu top-right for Delete)
↓
Food Photo / Category Illustration band (if available; otherwise omitted — see layout note)
↓
Serving Size Stepper (quantity + unit picker)
↓
Macro Breakdown (mini bar chart: cal/protein/carb/fat for the current serving, recalculates live as stepper changes)
↓
Meal Assignment row (Breakfast/Lunch/Dinner/Snack — Chip-style single-select) + Time picker row
↓
Primary Button ("Add to Log" or "Save Changes," full-width, pinned above safe area — NOT sticky mid-scroll, but always visible because this screen's content is short enough to fit without scrolling on most devices; on devices where it doesn't fit, it becomes a bottom-pinned sticky footer, never something the user must scroll to find)
```

**Layout:** Screen margin 20px. Photo/illustration band, when present, is the one full-bleed edge-to-edge element on the screen (240px height) — everything below returns to the standard 20px gutter. 24px gap between the Stepper, Macro Breakdown, and Meal/Time rows (a slightly larger-than-standard section gap, appropriate since this is a focused single-task screen, not a dense list).

**Responsive:** Tablet: content column caps at 480px (narrower than the general 640px cap — this screen is a form, and an overly wide form is harder to scan than a slightly narrower, more vertical one) and centers.

**Components used:** Stepper (screen-unique, described below), mini Chart (bar variant, §6.2), Chip (single-select, §2.8), Primary Button (§2.1), Icon Button (overflow menu, §2.1), Dialog (delete confirmation, triggered from overflow menu, §2.10).

**Stepper (screen-unique):** A pill-shaped row: minus Icon Button (32px, smaller than the 44px standard since it's flanked and doesn't need max target size given its low error-cost — a mis-tap just nudges the value by one unit) — numeral display (Inter SemiBold, tabular, tappable to open a numeric keypad Dialog for direct entry) — plus Icon Button. A separate adjacent Chip-style unit selector (g / oz / cup / serving, single-select) sits to the right. Changing either immediately re-triggers the Macro Breakdown's count-up animation.

---

### 3.5 Quick Add

**Purpose:** Log a frequently-eaten food in the fewest possible taps, bypassing full search. Primary action: tap a frequent-food row to log its last-used serving instantly.

**Screen hierarchy (bottom sheet content):**
```
Drag Handle
↓
Sheet Title ("Quick Add") + close (X) Icon Button
↓
Frequent Foods list (Result-Row-style, sorted by recency/frequency, each with a "+" quick-add — identical row component to Search Result Row, reused deliberately)
↓
"Search all foods instead" Ghost Button link at the bottom, opening full Food Search if nothing here fits
```

**Layout:** Sheet padding 20px horizontal, 16px top below handle. List rows: 8px gap, matching Food Log/Search rhythm. Sheet starts at ~50% screen height (Expandable/draggable variant per §2.11) and can be dragged to ~90%.

**Responsive:** Tablet: sheet max-width 480px, centered, same expandable behavior.

**Components used:** Bottom Sheet (expandable, §2.11), Search Result Row (reused, §2.7), Ghost Button (§2.1).

---

### 3.6 Analytics

**Purpose:** Understand trends over time — nutrition and weight — beyond today. Primary action: read/interpret a chart; secondary action: switch range or switch between Nutrition/Weight segments.

**Screen hierarchy:**
```
Status Bar
↓
Page Header ("Analytics")
↓
Segmented Control: "Nutrition" / "Weight" (top-level segment — see §1.2)
↓
[Nutrition segment:]
  Range Tabs (1W/1M/3M/6M/1Y/ALL)
  ↓
  Calorie Trend Chart (line + flux band)
  ↓
  Macro Trend Chart (3 overlaid lines, one per macro color, with a legend row)
  ↓
  Weekly Averages summary row (small stat cards: avg calories, avg protein, days-goal-hit)
  ↓
  Logging Heatmap (calendar-grid, intensity = adherence)
[Weight segment: see §3.7 — same screen, swapped body content below the Segmented Control]
↓
Bottom Navigation (Analytics active) + FAB
```

**Layout:** Screen margin 20px, except chart plot areas which run edge-to-edge within their own card's internal padding (per Visual Spec §6, charts get maximum visual weight). 32px gap between each major block (each chart, the averages row, the heatmap). Range Tabs are shared/sticky *within* the Nutrition segment only if the user scrolls past the first chart while wanting to re-range a second chart — actually, to avoid ambiguity: **each chart owns its own Range Tabs independently** (Calorie Trend and Macro Trend can be viewed at different ranges simultaneously) rather than one global range control governing both — this must not be "simplified" to a single shared control, since users legitimately want to compare, e.g., 1W calories against 6M weight trend.

**Responsive:** Tablet: 640px cap, but charts specifically are permitted to exceed that cap up to full available width (charts benefit from extra horizontal room for readability far more than text does) — this is the one explicit exception to the 640px content cap used elsewhere.

**Components used:** Segmented Control (§2.8), Range Tabs (§2.8), Line Chart (§6.1/6.2), Heatmap (§6.6), small Stat Card (a Card, Standard variant, containing a Label + one Inter SemiBold number — not a full Macro Tile, since these aren't macro-colored, they're neutral summary stats), Bottom Nav + FAB.

---

### 3.7 Weight Tracking

**Purpose:** Log and review body-weight trend over time, including MacroFactor-style estimated trend vs. raw daily entries. Primary action: log today's weight.

**Screen hierarchy (as the "Weight" segment within Analytics, per §1.2):**
```
[Segmented Control: Nutrition / Weight — "Weight" active]
↓
Weigh-In Headline (Streak/Countdown Numeral Block variant: current trend weight in Ndot Display L, + status glyph showing direction vs. last week)
↓
Range Tabs (1W/1M/3M/6M/1Y/ALL)
↓
Weight Trend Chart (raw entries as small point markers, trend line as the primary smoothed line, flux/confidence band behind it)
↓
Log Weight Primary Button (full-width, opens a simple numeric-entry Dialog, not a full push screen — weight entry is a single number, not worth a whole screen)
↓
Recent Entries list (compact rows: date, value, small delta vs. previous)
```

**Layout:** Same margin/gap conventions as Analytics generally (20px margin, 32px section gaps, edge-to-edge chart). The Weigh-In Headline is the one place on this segment permitted its Ndot treatment, mirroring the Calorie Hero's role on Dashboard — establishing that *each major tab* gets exactly one Ndot hero moment, never zero, never more than one.

**Responsive:** Same as Analytics.

**Components used:** Streak/Countdown Numeral Block (weigh-in headline variant, §2.16), Range Tabs (§2.8), Line Chart (weight variant, §6.3), Primary Button (§2.1), Dialog (Input variant, for numeric entry, §2.10), Log Row (compact, reused for "Recent Entries").

---

### 3.8 AI Coach

**Purpose:** A focused space to read personalized suggestions and ask follow-up questions about nutrition/progress. Primary action: read the current insight, optionally respond/ask a question.

**Screen hierarchy:**
```
Status Bar
↓
Header (back arrow, "Coach" title)
↓
Insight Card (Hero-radius card, current/most-recent suggestion, full detail — this is the expanded version of the Dashboard's one-line teaser)
↓
Conversation history (if the user has asked questions previously; renders as simple left/right-aligned message bubbles — user bubbles `surface.02` right-aligned, coach bubbles `surface.01` left-aligned, both `radius.md`, no avatars, since this is a utility conversation, not a social chat)
↓
Composer (text input pill + send Icon Button, pinned to bottom above safe area, always visible — sticky footer)
```

**Layout:** Screen margin 20px for cards/bubbles; composer spans full width with its own 16px horizontal inset. 16px gap between conversation bubbles (tighter than the general 32px section gap — this is conversational rhythm, not card rhythm). Conversation area scrolls independently above the pinned composer.

**Responsive:** Tablet: 640px cap, centered, same sticky composer behavior.

**Components used:** Card (Hero variant, for Insight Card), message bubble (screen-unique, described above — simple enough it doesn't need its own full library entry beyond this description, but must remain visually consistent if reused elsewhere), Search-Bar-style text field (borrowing the same pill input shell as §2.7 but without the food-specific quick-add affordances — a plain text composer), Icon Button (send).

---

### 3.9 Profile

**Purpose:** A personal summary hub — identity, high-level stats, and the entry point to Settings. Primary action: navigate to Settings, or review personal stats/goals.

**Screen hierarchy:**
```
Status Bar
↓
Page Header ("Profile" + gear Icon Button, top-right, → Settings)
↓
Identity block (avatar, name, member-since caption)
↓
Goals Summary card (current calorie/macro targets, tap → edit goals flow — out of scope beyond this entry point)
↓
Stats row (secondary Progress Rings: streak, weekly goal-hit rate — same component as Dashboard's Weekly Snapshot, reused, not redesigned)
↓
Weight shortcut card (small preview chart thumbnail + "View full history" → Analytics/Weight segment)
↓
Bottom Navigation (Profile active) + FAB
```

**Layout:** Standard 20px margin, 32px section gaps. Identity block is the one screen-unique layout: avatar 64px circle, centered horizontally, name (Title style) and caption (Caption style) centered beneath it — the only centered (non-left-aligned) text block in the entire app, appropriate for an identity/profile header specifically.

**Responsive:** Tablet: 640px cap, centered; identity block avatar can grow to 88px given more available vertical room.

**Components used:** Avatar (screen-unique — simple circular image/initials fallback, `surface.02` background with `text.primary` initials if no photo), Card (Standard, for Goals Summary and Weight shortcut), Progress Ring (generic, §2.15), Icon Button (gear), Bottom Nav + FAB.

---

### 3.10 Settings

**Purpose:** Account, notification, unit, and app-level preferences. Primary action: none singular — this is a utility list screen, navigated by scanning and selecting a specific row.

**Screen hierarchy:**
```
Status Bar
↓
Header (back arrow, "Settings" title)
↓
Grouped Setting Sections (Account / Preferences / Notifications / Data & Privacy / About), each a Section Header + stack of Setting Rows
↓
Sign Out (Destructive-style Ghost text button, isolated at the bottom with extra clearance above it so it's never mistaken for a normal row)
```

**Layout:** Standard 20px margin. Setting Rows use the same tight 8px inter-row rhythm as Food Log (a dense utility list, not cards). 32px gap between groups. No sticky header needed (Settings is not scrolled as extensively as Food Log, and losing the back arrow briefly is a low-cost tradeoff versus the complexity of another sticky header) — **exception:** if a Settings screen ever grows past ~2 screen-heights of content, revisit this and make the header sticky to match Food Log's precedent; do not let two similarly-long list screens diverge in behavior without a deliberate reason.

**Components used:** Section Header (reused from Food Log), Setting Row (screen-unique: label left, either a trailing chevron (→ push a sub-screen), a Toggle/Switch (inline boolean), or a trailing value + chevron (e.g., "Units: Metric →")), Ghost Button (Destructive-styled, for Sign Out).

**Toggle/Switch (screen-unique, minor component):** Standard pill switch, `surface.02` track off / `accent.signal` track on, white thumb, 150ms slide animation, full row is tappable (not just the switch itself) for a larger, easier target.

---

## 4. System States

These are canonical patterns, defined once, then invoked by name per screen.

### 4.1 Empty State (per Visual Spec §9)

Single-column, centered content within the relevant area (not necessarily the whole screen — e.g., Food Log's empty state fills just the meal-sections area, header/day-selector remain): a muted outline icon (48px, `text.tertiary`, drawn from the standard icon system, never a bespoke illustration), one line of Body-weight guidance text beneath it, then a Primary Button CTA. Never a mascot, never multi-paragraph copy.

Per-screen invocations:
- **Dashboard:** Effectively never fully empty (the ring/tiles always render, just at zero) — no dedicated empty state needed beyond the zero-value states already defined per-component.
- **Food Log (a given day, zero entries):** icon = fork/plate glyph, text "Log your first meal today," CTA "Log a meal" → Food Search.
- **Food Search (no results):** icon = search glyph, text "No foods found for '[query]'," CTA "Search again" (clears field, refocuses) rather than a navigating CTA.
- **Analytics (insufficient data for a range, e.g., "ALL" with only 3 days logged):** icon = chart-line glyph, text "Keep logging to see trends here," no CTA button (there's nothing to tap — the resolution is simply time/usage), so this is the one Empty State variant that omits the CTA entirely.
- **AI Coach (no insights yet):** icon = sparkle glyph, text "Log a few more days and I'll have something for you," no CTA (same reasoning as Analytics).

### 4.2 Loading State (per Visual Spec §10)

Skeletons matching exact real-content shape, per §2.12. Per-screen invocations: Dashboard shows Skeleton Calorie Hero + 3 Skeleton Macro Tiles + 3 Skeleton Log Rows on first paint. Food Log shows 5–6 Skeleton Log Rows. Food Search shows 4 Skeleton Result Rows once a query is in flight. Analytics shows Skeleton Chart blocks for each chart independently (so a fast-loading Calorie chart can render while Macro chart is still loading — charts never block each other).

### 4.3 Error State

A dedicated, non-Toast pattern for content that outright failed to load (distinct from the soft/recoverable Toast error variant, §2.9, which is for failed *actions*, not failed *loads*): centered within the content area, a `status.negative`-tinted warning-triangle icon (48px), one line of plain-language error text ("Couldn't load your data"), Caption-style technical detail optionally beneath in `text.tertiary` (never a raw stack trace/error code shown to the user directly — if a code is needed for support purposes, it lives behind a "Details" disclosure, collapsed by default), and a Secondary Button "Try again" that re-triggers the load (showing the Loading State while retrying).

### 4.4 Offline State

A persistent, dismissable-but-reappearing thin banner (not a toast, not a dialog — a distinct pattern) pinned directly beneath the Status Bar, above the Page Header: `surface.03` background, `status.holding` gray icon (a "no connection" glyph) + "You're offline — showing your last synced data" in Caption style. It does not block interaction; screens continue to show their last-cached content beneath it. Any action requiring network (logging a food that needs a search-server lookup, syncing weight) instead queues optimistically (per the Optimistic-pending Log Row state, §2.6) and syncs automatically on reconnect, at which point the banner dismisses itself (slide up + fade, 200ms) — the user is never asked to manually "retry" a queued action.

---

## 5. Interaction Patterns (Global)

- **Tap:** Universal primary interaction. Every tappable element gives immediate visual feedback within one frame (scale/surface-bump per its component spec) — there is never a tap with zero visible response, even if the resulting action takes time (in which case a Loading substate takes over, per component).
- **Long-press:** Reserved for exactly two things app-wide: (1) contextual actions on a Log Row (Edit/Delete), (2) the nav FAB opening Quick Add instead of Search. Long-press is never used as a hidden/undiscoverable-only path to a feature — anywhere long-press exists, an equivalent tap-based path also exists (swipe for the row, regular tap-then-navigate for the FAB), so nothing is exclusively gesture-gated.
- **Hover (pointer/desktop only):** Buttons and interactive cards lighten 6% and show a pointer cursor; this is the only hover feedback in the system — no hover-triggered tooltips or hover-to-reveal content, since the app is fundamentally touch-first and hover is a courtesy for pointer users, not a parallel interaction model.
- **Keyboard (desktop only):** Standard tab order follows visual top-to-bottom, left-to-right hierarchy per screen. Enter/Return activates the focused element. Escape closes the topmost Dialog/Sheet/expanded-Search and returns focus to whatever triggered it.
- **Page transitions / Navigation transitions:** Per §1.3 (cross-fade for tabs, slide-push for stack navigation, slide-up for modals/sheets).
- **FAB interactions:** Tap → Food Search (slide-up modal). Long-press (500ms + haptic) → Quick Add (bottom sheet). Ambient ~3s glow pulse only after 4+ hours without a log during waking hours, per §2.5.
- **Search expansion:** Collapsed pill → full-screen overlay via the shared-element morph described in §2.7, 220ms.
- **Card interactions:** Tap → navigate/expand (per card's own spec). Press → scale 0.98 + surface bump, 120ms. Long-press (Log Rows only) → contextual action sheet, 350ms threshold + haptic.
- **Progress animations:** Every numeral count-up and ring/bar fill runs 400–500ms ease-out and is triggered exclusively by a genuine data change (new log, edit, delete) — never replayed on simple screen re-entry/re-focus if the underlying value hasn't changed (re-triggering the animation on every tab revisit would cheapen it into decoration, which Visual Spec §8 explicitly prohibits).
- **Chart interactions:** See §6 for the full scrub/zoom/range spec.
- **Pull-to-refresh:** Available on Dashboard, Food Log, and Analytics (any screen with server-backed content that can change from another device/session). Standard rubber-band pull reveals the Inline Spinner (§2.13) at 64px pull distance, releases to trigger a refetch, all content sections show their Loading State (§4.2) in place during the refetch (not a full-screen blocking spinner — sections refresh independently as their data returns).
- **Skeleton loading:** Per §2.12/§4.2.

---

## 6. Chart Specification

All charts share the structural skeleton from §2.14 (hairline baseline only, no gridlines, point markers on scrub only, edge-to-edge plot area). Below is what's specific to each.

### 6.1 Calorie Trend Chart (Analytics → Nutrition)
Single smooth monotone-cubic line in `energy.neutral`, soft gradient fill fading to transparent beneath it. A thin horizontal reference line in `text.tertiary` marks the daily target; days above it beyond a small tolerance render their point marker (on scrub) in `status.negative`, days within tolerance in `status.positive` — the line itself stays neutral throughout (only the scrub-revealed point markers carry status color, keeping the resting-state chart calm per the "calm chrome, loud data" principle, while still rewarding closer inspection with meaningful color).

### 6.2 Macro Trend Chart (Analytics → Nutrition, and mini variant on Food Detail)
Three overlaid monotone-cubic lines, one per macro, each in its semantic color (`macro.protein`/`macro.carbs`/`macro.fat`), no fill beneath any of them (three overlapping gradient fills would muddy into visual noise — fill is reserved for single-line charts only). A small legend row (colored dot + label) sits directly above the plot area. The Food Detail mini variant is the same three lines compressed into a small (not full-width) bar-style comparison instead of a time-series line (since Food Detail has no time dimension — it's showing one serving's macro composition, not a trend), rendered as three short horizontal bars stacked with 4px gaps, each bar length proportional to that macro's calorie contribution.

### 6.3 Weight Trend Chart (Weight segment)
Raw daily entries render as small (6px) hollow point markers in `text.secondary`, always visible (not scrub-only, since seeing the scatter of raw entries against the smoothed trend is the entire point of this chart, per the MacroFactor reference). The smoothed trend line renders on top in `text.primary`, solid, with the flux/confidence band (`text.primary` at 8% opacity) filled behind it showing estimate uncertainty — exactly the "MacroFactor-style flux range" called for in Visual Spec §7.5.

### 6.4 Weekly Averages (Analytics summary row)
Not a chart in the line/bar sense — a row of Stat Cards (§3.6), each showing one static number for the selected range (avg calories, avg protein, days-goal-hit). No animation beyond the shared Ndot/Inter count-up on value change.

### 6.5 Monthly Trends
Same component as §6.1/6.2 at the "1M" Range Tab selection — this is not a separate chart type, it's a range state of the existing trend charts. Called out here only to confirm explicitly: there is no separate "monthly view" component to build.

### 6.6 Logging Heatmap (Analytics → Nutrition)
A calendar-grid of small (16×16px) rounded squares, one per day, laid out in week-rows (7 columns) going back through the selected range. Intensity = adherence: `surface.02` (no log that day) → increasing opacity of `status.positive` green as more of that day's targets were hit (not a single boolean, a 4-step opacity scale: 0%/33%/66%/100% adherence). No red/negative color in the heatmap — an off day simply renders as low-opacity green/gray, not as an alarming red, since a calendar of red squares would read as a scoreboard of failures rather than a gentle adherence pattern (this is a deliberate tone choice consistent with "calm data storytelling," Visual Spec §0/§1).

### 6.7 Progress Rings / Goals
Covered structurally in §2.4 (hero) and §2.15 (generic secondary) — no additional chart-specific behavior beyond what's specified there.

### 6.8 Comparison Charts
Where a screen needs to compare two ranges directly (e.g., "this week vs last week" — a plausible future Analytics addition, not in the current named screen list but specified here for completeness since "comparison charts" was explicitly requested): render as two Macro/Calorie Trend lines on the same plot, the current-range line at full opacity in its normal semantic color, the comparison-range line at 40% opacity in the same color with a dashed stroke — never a second solid line in a different hue, which would read as a fourth macro rather than a time-comparison of the same metric.

### 6.9 Scrolling, Filtering, Zooming, Selection Behavior (applies to all charts above)
- **Scrolling:** Charts do not scroll independently within their card — the Range Tabs control the *displayed* window (1W through ALL); there is no separate pinch/pan-to-scroll gesture layered on top, which would create two competing ways to change the visible range and confuse the primary Range Tab control's authority.
- **Filtering:** Only the Macro Trend legend supports filtering — tapping a legend dot toggles that macro's line on/off (useful for isolating one macro visually), dimming the hidden line's legend entry to 40% opacity rather than fully removing it from the legend (so it's clear it can be tapped back on).
- **Zooming:** No pinch-to-zoom on any chart — the Range Tabs are the exclusive zoom mechanism, keeping the interaction model identical and predictable across every chart in the app rather than some charts supporting a gesture others don't.
- **Selection/scrub behavior:** Single-finger drag along the plot area shows a vertical hairline cursor plus a small floating tooltip (`surface.03`, `radius.sm`, per Elevation Level 3 shadow) above the touch point showing the exact date + value(s) at that x-position. Releasing the drag dismisses the tooltip and cursor with a 150ms fade. This is the only place point markers appear on the Calorie/Macro trend lines (per §6.1); the Weight chart's raw-entry markers are the exception, always visible as noted in §6.3.

---

## 7. Non-Negotiable Design Rules

1. **Never hardcode spacing, color, radius, or type values.** Every screen and component must reference the tokens defined in the Visual Design Specification and this document's Component Library — no engineer-invented one-off pixel values.
2. **Never use more than 3–4 saturated hues visible on one screen at once** (per Visual Spec §2.4's rule of thumb) — this includes chart lines, macro tiles, and status colors combined, not counted separately.
3. **Always compose screens from Component Library entries.** If a screen seems to need something new, that "something" gets added to the library with a full spec (purpose/variants/states/etc.) before it's used anywhere — it is never built inline as a one-off.
4. **Ndot numerals are reserved exclusively for the whitelisted hero cases**: today's calorie total, streak days, check-in countdown, weigh-in headline. Nowhere else, ever, regardless of how "important" a future number feels — expanding this list requires a spec revision, not an implementation-time judgment call.
5. **Never place more than one Primary Button on a single screen.** Secondary/Ghost/Icon buttons may coexist freely, but only one action per screen may carry the visual weight of "the" primary action.
6. **Always animate state changes that reflect real data changes** (numeral count-ups, ring/bar fills, list insertions) — and *never* animate anything that isn't a response to a genuine user action or data change. Motion is never ambient or looping, with the sole named exceptions: the FAB's behaviorally-triggered glow pulse (§2.5) and the skeleton shimmer (§2.12), both of which are exceptions on record, not precedent for adding more.
7. **Maintain the 4px base spacing unit** (and its defined scale: 4/8/12/16/20/24/32/40/48/64) for every margin, padding, and gap in the app.
8. **Respect the distinct mobile/tablet/desktop rules defined per screen** — most content caps at 640px on larger viewports and centers rather than stretching; charts are the sole named exception permitted to exceed that cap.
9. **One ring-chart per screen, maximum**, and only where explicitly specified (Dashboard's Calorie Hero, Weight's Weigh-in isn't a ring but the Analytics/Profile secondary rings are) — rings are not a default way to show any percentage; most progress uses linear bars (Macro Tiles) instead, per the Apple Health reference's "used narrowly" caution.
10. **Destructive actions always require a Dialog confirmation**, are never triggered from a Ghost/low-emphasis button style alone, and are never dismissible by a casual scrim tap.
11. **Toasts are for reversible, low-stakes confirmations only**; anything requiring a user decision before proceeding is a Dialog; anything requiring browsing/an extended but non-committal task is a Bottom Sheet. These three overlay types are not interchangeable and must not be swapped for convenience.
12. **Every loading area shows a Skeleton matching its real content's exact shape** — never a generic centered spinner standing in for a whole content area, and never a skeleton for anything expected to resolve in under ~400ms.
13. **Empty states are calm, single-line, icon-plus-CTA** (or icon-plus-line with no CTA where there's genuinely nothing to tap) — never a mascot, never multi-paragraph copy, never an apologetic tone.
14. **The bottom nav has exactly four slots (Home/Log/Analytics/Profile) with Log broken out as the FAB.** Weight nests inside Analytics; AI Coach is entered via a persistent Dashboard card. Adding a fifth nav icon is an information-architecture change requiring spec revision, not an implementation-time addition.
15. **Every icon-only tappable element still carries an accessible text label**, and every custom gesture (swipe, long-press, drag) has a discoverable non-gesture equivalent exposed as an accessibility action.
16. **Minimum 48×48 touch target on every tappable element**, regardless of its visual size — padding, not visual bulk, achieves this.
17. **Color hierarchy is never violated:** status color (e.g., over-target red) always outranks a macro's own semantic color when the two would conflict (a red "over target" state always wins visually over a tile's normal blue/orange/coral). Numeral treatment (Ndot) → color → type weight → size is the fixed dominance order for directing the eye on every screen, per Visual Spec §11.
18. **No screen introduces a new elevation/shadow style outside the five levels defined in the Visual Design Specification.** The two named exceptions (long-pressed Log Row, floating Toast) are exhaustive, not precedent.
19. **Charts never gain interaction models beyond what's specified in §6.9** (Range Tabs for zoom/window, scrub for point detail, legend-tap for macro filtering) — no pinch-zoom, no independent chart-internal scrolling, ever, so every chart in the app behaves identically to a user's muscle memory.
20. **This document and the Visual Design Specification together are the complete spec.** Any implementation ambiguity not resolved by either document should be raised as a spec gap and resolved by adding a rule here — not silently decided per-engineer, per-screen, or per-PR.
