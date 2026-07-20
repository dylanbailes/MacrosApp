# Visual Design Specification
### Premium Macro & Nutrition Tracker — Dark Mode System
Prepared for: UI Team · Design Lead Review

---

## 0. Reference Analysis

**What the current build gives us:** true-black canvas, three-tile macro row (protein/carbs/fat with color-coded numerals), a single calorie progress bar, a floating pill-shaped bottom nav with a circular active state. This is a solid skeleton — the job now is to give it a *point of view*, not just a coat of paint.

**What the references tell us to take, and what to leave:**

| Reference | What we borrow | What we reject |
|---|---|---|
| **Nothing OS** | Dot-matrix (Ndot) numerals as a signature type layer, transparency/glyph honesty, red-on-black restraint | Literal transparent-back hardware motifs, dot-grid as wallpaper |
| **Linear** | Density without clutter, hairline structure instead of shadow, keyboard/speed-first interaction logic | Purple brand hue (off-brief), glassy gradients everywhere |
| **Arc Browser** | Playful, confident micro-interactions on *one* primary action | Multi-color gradient chrome — too loud for an athletic data app |
| **MacroFactor** | Expenditure/weight-trend chart language: soft gradient fill, flux bands, range-tab selectors | Clinical, spreadsheet-heavy layout |
| **Hevy** | Fast-log affordance, big tappable targets, workout-app confidence | Bright multi-accent card borders |
| **Apple Health** | Calm data storytelling, rounded metric cards, restrained iconography | Ring-chart cliché (used narrowly, not everywhere) |

**Signature move:** the uploaded `NOTHING_otf.ttf` (Ndot dot-matrix face) becomes the app's single boldest choice — reserved *exclusively* for hero numerals (today's calories, streak days, check-in countdown). Everything else stays quiet so that numeral treatment reads as premium rather than gimmicky.

---

## 1. Design Language

**Principle: Calm chrome, loud data.** The interface itself — nav, buttons, cards, backgrounds — stays desaturated black/white/gray. Color is a resource spent only on things the athlete needs to *read*: macros, trends, status. This is what separates "dark mode app" from "premium dark mode app."

Five words that govern every decision: **fast, dense, calm, precise, alive.**

- **Fast** — nothing sits between the user and logging. The primary action is always one thumb-reach away.
- **Dense** — screens carry real information (MacroFactor-level), but grouped so density never reads as clutter.
- **Calm** — no competing saturated colors, no decorative motion, no mascot illustrations.
- **Precise** — tabular numerals, consistent grid, hairline structure — the app should feel *engineered*, like a good multimeter.
- **Alive** — small, deliberate moments of delight (count-up numerals, the log button's glow) so daily use doesn't feel clinical.

---

## 2. Color Palette

### 2.1 Base (true black system, OLED-first)

| Token | Hex | Use |
|---|---|---|
| `void.bg` | `#000000` | App background, true black |
| `surface.01` | `#0D0D0F` | Standard cards, tiles |
| `surface.02` | `#16161A` | Nested elements, pressed/active rows |
| `surface.03` | `#202024` | Modals, sheets, toasts |
| `hairline` | `rgba(255,255,255,0.08)` | 1px borders/dividers everywhere |
| `text.primary` | `#F5F5F2` | Headlines, hero numerals (warm off-white, not clinical pure white) |
| `text.secondary` | `#9A9A9E` | Body copy, sub-labels |
| `text.tertiary` | `#5C5C60` | Meta, timestamps |
| `text.disabled` | `#38383A` | Inactive state |

### 2.2 Brand Accent

| Token | Hex | Use |
|---|---|---|
| `accent.signal` | `#FF1E3C` | Primary CTA, Log button, streaks, live/recording dot, critical alerts — **spend this color deliberately, never as decoration** |

### 2.3 Macro Semantics (kept distinct from brand red so "Fat" is never mistaken for an alert)

| Token | Hex | Use |
|---|---|---|
| `macro.protein` | `#3D8BFD` | Protein numerals, rings, chart lines |
| `macro.carbs` | `#FFB020` | Carbs numerals, rings, chart lines |
| `macro.fat` | `#FF6B5E` | Fat numerals, rings, chart lines (coral — warmer/pinker than signal red) |
| `energy.neutral` | `#F5F5F2` | Calorie ring/number — kept neutral so the three macro colors read clearly against it |

### 2.4 Data & Status

| Token | Hex | Use |
|---|---|---|
| `status.positive` | `#34D399` | Trend improving, streak maintained, goal hit |
| `status.negative` | `#FF1E3C` | Over target, missed check-in (reuses signal red — status and brand share meaning intentionally) |
| `status.holding` | `#9A9A9E` | Flat trend, "holding" state (mirrors MacroFactor's language) |

**Rule of thumb:** any given screen should show at most 3–4 saturated hues at once (macro colors + one status color). If a screen feels colorful, something's wrong — pull color out, not in.

---

## 3. Typography

### 3.1 Typeface roles

| Role | Face | Notes |
|---|---|---|
| **Display / Numerals** | **Ndot** (Nothing dot-matrix) | Reserved for hero stats only: today's calorie total, streak count, "days until check-in," weigh-in headline number. Never used below 24px — the dots disintegrate at small sizes. Never used for body text or labels. |
| **UI / Body** | **Inter** (variable, 400–700) | Everything else: headers, card titles, body copy, buttons, chart labels. Tabular (lining) figures enabled everywhere numbers appear in a list, so columns align — critical for a food-logging list. |

This is a deliberately narrow pairing: one characterful face used with total restraint, one disciplined workhorse. The boldness is spent once, on the numerals — everything around it stays quiet.

### 3.2 Type scale

| Style | Face / Weight | Size / Line-height | Usage |
|---|---|---|---|
| Display XL | Ndot | 56 / 60 | Dashboard hero calorie number |
| Display L | Ndot | 34 / 38 | Streak days, check-in countdown, weigh-in stat |
| Title | Inter SemiBold | 22 / 28 | Screen titles |
| Headline | Inter SemiBold | 17 / 22 | Card titles, list item primary text |
| Body | Inter Regular | 15 / 20 | Primary content, descriptions |
| Label | Inter Medium, +4% tracking, ALL CAPS | 13 / 16 | Micro-labels: "PROTEIN," "TODAY'S MACROS," section eyebrows |
| Caption | Inter Regular | 11 / 14 | Timestamps, meta, chart axis labels |

---

## 4. Elevation System

True black defeats conventional drop shadows — on `#000000`, a shadow simply doesn't render. Elevation is instead communicated through **luminance steps + hairline edges**, with shadow reserved only for content that truly floats above the page.

| Level | Surface | Border treatment | Shadow |
|---|---|---|---|
| 0 | `void.bg` | none | none |
| 1 | `surface.01` | 1px `hairline` | none |
| 2 | `surface.02` | 1px `hairline`, brighter (12% white) | none |
| 3 | `surface.03` (sheets, modals) | 1px top highlight `rgba(255,255,255,.06)` | `0 12px 32px rgba(0,0,0,.6)` |
| 4 | Scrims / overlays | — | full-bleed `rgba(0,0,0,.7)` + 20px backdrop blur |

**Signature glow:** the primary Log button carries a soft ambient `accent.signal` glow (24px blur, 20% opacity) at rest, intensifying briefly on press. This is the *only* element in the system permitted an atmospheric glow — it marks the single fastest path to the app's core action.

---

## 5. Border Radius

| Token | Value | Use |
|---|---|---|
| `radius.xs` | 6px | Chips, tags, small pills |
| `radius.sm` | 12px | Inputs, secondary buttons |
| `radius.md` | 20px | Standard cards, tiles |
| `radius.lg` | 28px | Hero cards, bottom sheet top corners |
| `radius.full` | pill | Primary CTA, bottom nav, macro capsule pills |

---

## 6. Spacing & Grid

**Base unit: 4px.** Scale: 4 / 8 / 12 / 16 / 20 / 24 / 32 / 40 / 48 / 64.

- Screen margin: 20px
- Card internal padding: 16–20px
- Gap between sibling cards: 12px
- Gap between sections: 32px
- Grid: content is full-bleed within a 20px gutter; stat tiles use a flexible 2- or 3-column grid (matches the existing 3-tile macro row); charts run edge-to-edge within their card's padding for maximum visual weight.

---

## 7. Component Styling

### 7.1 Cards
Surface 01, `radius.md`, 1px hairline border, no shadow at rest. On tap: scale to 0.98 and bump to Surface 02 for 120ms — the only feedback needed on true black; no shadow choreography.

### 7.2 Buttons

| Style | Fill | Text | Use |
|---|---|---|---|
| Primary | `accent.signal` solid, `radius.full` | White, Inter SemiBold | Log meal, confirm, save — one per screen |
| Secondary | `surface.02` + hairline | `text.primary` | Alternate actions |
| Ghost | Transparent | `text.secondary` | Cancel, tertiary nav |
| Icon | `surface.01` circle, 44×44 min tap target | icon only | Utility actions (edit, delete, settings) |

### 7.3 Search
A collapsed pill search field sits top-right of list screens (echoing the reference notes/music apps). Tapping expands to a full-screen overlay: `surface.04` scrim with 20px blur, autofocus, recent-search chips, and a horizontal quick-add row for frequent foods. Search UI stays in Inter — never Ndot.

### 7.4 Navigation
Floating pill bar, Surface 01 + blur, hovering above content with 16px margin. Four destinations: **Home / Log / Analytics / Profile.** The active tab gets `accent.signal` icon + label on a `surface.02` pill behind it. **Log breaks the bar** as a raised circular FAB in `accent.signal` with its ambient glow — the fastest-logging value made physically obvious in the chrome.

### 7.5 Charts
Direct line to MacroFactor/Apple Health: smooth monotone-cubic lines, soft gradient fill fading to transparent beneath, one hairline baseline (no gridlines), point markers appear only on scrub/hover. Metrics get their semantic color (weight = `text.primary`, expenditure = `accent.signal`, macro trends = their macro color). Range selection via pill tabs (1W / 1M / 3M / 6M / 1Y / ALL). "Flux range" bands (MacroFactor-style) render as a low-opacity fill behind the trend line to show estimate confidence.

### 7.6 Icons
Single-weight, 1.5px stroke, rounded caps, 24px grid, monochrome by default (`text.secondary`). Icons switch to `accent.signal` only in an active/selected state — never decoratively. No filled icon styles except the active nav glyph.

---

## 8. Motion

- **Duration:** 150–250ms for UI transitions; ease-out on entrance, ease-in on exit.
- **Press feedback:** spring-based scale (0.98) on tappable elements, paired with haptic where the platform allows.
- **Numeral count-up:** calorie/macro totals animate as an odometer count-up when a food is logged — a natural extension of the dot-matrix numeral treatment, and the app's clearest "alive" moment.
- **Reduced motion:** all of the above degrades gracefully to instant/opacity-only transitions when the system reduced-motion flag is set.
- Motion is never ambient or decorative — every animation is a response to a user action or a data change, nothing plays on a loop.

---

## 9. Empty States
Calm, single-line, and directive — never a mascot or cartoon illustration. A muted outline-style icon (matching the icon system, not a separate illustration style) sits above one line of guidance ("Log your first meal to see today's macros") and a primary CTA beneath it. The empty state should feel like an invitation, not an apology.

## 10. Loading States
Skeleton blocks at `surface.02` with a slow shimmer sweep (`rgba(255,255,255,.06)` moving gradient, ~1.5s loop) standing in for cards, list rows, and chart areas. Spinners are reserved only for small inline actions (pull-to-refresh, button-internal loading) — never for full content areas, which should always show their skeletal shape.

---

## 11. Visual Hierarchy

Dominance order, strongest to weakest: **numeral treatment (Ndot) → color (accent + macro hues) → type weight (SemiBold vs Regular) → size.** This means a small red SemiBold label can outrank a large gray Regular number — color and weight are being used to direct the eye before size does, which keeps dense screens legible instead of shouty.

---

## 12. Summary Token Sheet (quick reference)

```
COLOR
  void.bg          #000000
  surface.01       #0D0D0F
  surface.02       #16161A
  surface.03       #202024
  hairline         rgba(255,255,255,.08)
  text.primary     #F5F5F2
  text.secondary   #9A9A9E
  text.tertiary    #5C5C60
  accent.signal    #FF1E3C
  macro.protein    #3D8BFD
  macro.carbs      #FFB020
  macro.fat        #FF6B5E
  status.positive  #34D399

TYPE
  Display: Ndot           (24px+ only, numerals only)
  UI:      Inter          (400–700, tabular figures on)

RADIUS   6 / 12 / 20 / 28 / full
SPACING  4 / 8 / 12 / 16 / 20 / 24 / 32 / 40 / 48 / 64
MOTION   150–250ms, ease-out in / ease-in out, spring on press
```

---

*This spec covers visual identity only — component behavior, screen flows, and implementation are out of scope by design brief.*
