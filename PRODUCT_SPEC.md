# Product Specification

## Vision

Macro Tracker is a **premium macro and nutrition tracking application** designed specifically for gym enthusiasts, athletes, and data-driven individuals who want precise control over their nutrition.

The primary objective is **minimizing friction** while logging food. Every interaction should feel instant, every screen should be purposeful, and every feature should serve the core mission: making nutrition tracking effortless while providing best-in-class analytics.

### Core Differentiators

1. **Speed First**: Logging a meal should take under 10 seconds
2. **Analytics Excellence**: Deepest insights available in any nutrition app
3. **Premium Experience**: Nothing OS-inspired design that feels polished and modern
4. **Open Source**: Transparent, community-driven development
5. **Cross-Platform**: One app across Android, Windows, Web, and eventually iOS

---

## Core Principles

### 1. Speed is the Feature

- **Logging should take under 10 seconds** from opening the app to confirming a meal
- Every tap must have purpose; unnecessary screens are eliminated
- Search results appear as you type (no "search" button)
- Recent foods are one tap away
- Favorites are always accessible
- "Copy Yesterday" is a single action

### 2. Intelligent Defaults

- Search prioritizes **likely foods** instead of alphabetical order
- The application **learns user habits** over time
- Frequently logged foods appear at the top
- Meal times suggest based on historical patterns
- Portion sizes remember user preferences

### 3. Information Density Without Clutter

- Maximum data visible at a glance
- No hidden information behind unnecessary taps
- Smart use of typography hierarchy
- Subtle visual separators instead of heavy lines
- Contextual information shown when relevant

### 4. Clean Despite Complexity

- Advanced analytics available but not overwhelming
- Progressive disclosure of complex features
- Default view shows only what matters daily
- Power features accessible but not prominent

### 5. Intrinsic Motivation

- Progress visualization that inspires
- Streaks and consistency tracking
- Data-driven insights about personal patterns
- No spammy notifications or gamification gimmicks

---

## Target Users

### Primary: Gym Enthusiasts

**Characteristics:**
- Train 3+ times per week
- Track macros for performance or physique goals
- Comfortable with technology
- Value precision and data
- Willing to invest time in optimization

**Needs:**
- Fast logging between sets or meals
- Accurate macro breakdowns
- Progress tracking over time
- Goal adjustment based on results

### Secondary: Athletes

**Characteristics:**
- Competitive or serious recreational athletes
- Specific performance nutrition requirements
- May work with coaches or nutritionists
- Need detailed reporting

**Needs:**
- Precise macro timing
- Export capabilities for sharing
- Integration with training data
- Body composition tracking

### Tertiary: Power Users

**Characteristics:**
- Data enthusiasts who love tracking
- Enjoy analyzing patterns and trends
- Want maximum customization
- Appreciate advanced features

**Needs:**
- Deep analytics
- Custom reports
- Data export
- Advanced goal configurations

### NOT Target Users (Initially)

- Casual dieters seeking simple calorie counting
- Users wanting primarily social features
- People looking for workout tracking
- Those needing extensive recipe libraries

---

## Major Features

### Dashboard

**Purpose:** At-a-glance view of daily nutrition progress.

**Components:**
- Daily calorie summary with progress ring
- Macro breakdown cards (Protein, Carbs, Fat)
- Meal list for current day
- Quick add buttons for common actions
- Date selector with easy navigation
- Weekly average comparison
- Streak counter (days logged this month)
- Goal progress indicators

**Key Interactions:**
- Tap any macro card to see detailed breakdown
- Swipe left/right to change dates
- Pull down to refresh
- Long press on meal to edit/delete

---

### Meal Logging

**Purpose:** Fast, frictionless food entry.

**Components:**
- Food search bar with instant results
- Recent foods horizontal scroll list
- Favorites quick access
- Portion size selector with common options
- Custom quantity input
- Nutritional preview before confirming
- Meal type selector (Breakfast, Lunch, Dinner, Snack)
- Notes field (optional)

**Key Interactions:**
- Search activates immediately on focus
- Results update as you type
- Tap food → select portion → confirm (3 taps max)
- Swipe food item to add to favorites
- Voice input for hands-free logging (future)

**Smart Features:**
- Search ranking learns from user history
- Common foods bubble to top
- Similar foods suggested
- Recent meals from same time of day highlighted

---

### Food Search

**Purpose:** Find any food instantly.

**Components:**
- Search bar with clear button
- Results list with nutritional preview
- Category filters (optional)
- Brand vs generic toggle
- Serving size options
- Add custom food option

**Ranking Algorithm:**
1. User's frequently logged foods
2. Foods logged at similar times
3. Recently added foods
4. Popular database entries
5. Alphabetical (fallback)

**Database Sources:**
- USDA standard reference
- Community-contributed foods
- User's custom foods
- Brand name foods

---

### Favorites System

**Purpose:** One-tap access to regularly consumed foods.

**Features:**
- Unlimited favorites
- Organized by categories (optional)
- Quick add from dashboard
- Favorite combinations (meal templates)
- Import/export favorites

---

### Recent Foods

**Purpose:** Instant re-logging of recently consumed items.

**Features:**
- Last 20 foods logged
- Grouped by similarity
- Shows last logged timestamp
- One-tap re-add
- Automatically populated

---

### Meal Templates

**Purpose:** Log entire meals with one action.

**Features:**
- Save combinations of foods as templates
- Name templates (e.g., "Standard Breakfast")
- Adjust portions when applying
- Template categories
- Quick apply from dashboard
- Edit template contents

---

### Copy Yesterday

**Purpose:** Replicate previous day's meals instantly.

**Features:**
- One-tap copy all meals
- Selective copy (choose which meals)
- Review before confirming
- Adjust portions if needed
- Handles missing foods gracefully

---

### Analytics

**Purpose:** Deep insights into nutrition patterns.

**Components:**
- Weekly macro trends chart
- Monthly weight progression graph
- Calorie intake distribution
- Macro ratio pie chart
- Day-over-day comparison
- Meal timing analysis
- Food variety metrics
- Consistency score

**Chart Types:**
- Line charts for trends
- Bar charts for comparisons
- Pie/donut for ratios
- Heat maps for patterns
- Scatter plots for correlations

**Insights Generated:**
- Average daily calories (week/month)
- Most common meal times
- Top 5 most logged foods
- Weekend vs weekday patterns
- Goal adherence percentage

---

### Goal Tracking

**Purpose:** Set and monitor nutrition targets.

**Features:**
- Daily calorie goal
- Macro targets (grams or percentages)
- Weight goals (current, target, timeline)
- Goal presets:
  - Cut (deficit)
  - Bulk (surplus)
  - Maintain
  - Recomp
- TDEE calculator integration
- Automatic adjustment suggestions
- Goal history tracking
- Milestone celebrations

**TDEE Calculator Inputs:**
- Age
- Gender
- Height
- Weight
- Activity level
- Training frequency
- Goal type

---

### Settings

**Purpose:** Configure app behavior and preferences.

**Sections:**

**Profile:**
- Display name
- Email
- Profile photo (optional)
- Account management

**Goals:**
- Current calorie target
- Macro ratios
- Weight tracking
- Goal adjustments

**Preferences:**
- Units (metric/imperial)
- Default meal names
- Dashboard layout options
- Privacy settings

**Data:**
- Export data
- Import data
- Clear cache
- Delete account

**App:**
- Theme (dark mode only initially)
- Language (future)
- Notifications (future)
- About

---

## Future Features

These features are planned but explicitly NOT part of Version 1:

### Body Fat Estimation

**Description:** AI-powered body fat percentage estimation from photos.

**Capabilities:**
- Upload front/side body photos
- AI estimates body fat percentage
- Progress comparison overlays
- Trend tracking over time
- DEXA scan calibration option

**Timeline:** Phase 5

---

### Photo Calorie Estimation

**Description:** Log meals by taking photos.

**Capabilities:**
- Camera integration
- AI identifies foods in image
- Portion size estimation
- Multiple food detection
- Confidence scoring
- Manual correction option
- Learning from corrections

**Timeline:** Phase 5

---

### Health Integrations

**Description:** Sync with health platforms.

**Platforms:**
- Apple Health (iOS)
- Google Fit (Android)
- Fitbit
- Garmin Connect
- Oura Ring
- Withings

**Synced Data:**
- Weight measurements
- Body composition
- Activity levels
- Sleep data (for recovery insights)

**Timeline:** Phase 6

---

### Meal Planning

**Description:** Plan meals in advance.

**Capabilities:**
- Weekly meal planner calendar
- Drag-and-drop interface
- Recipe integration
- Shopping list generation
- Nutrition preview for planned days
- Plan templates
- Bulk planning tools

**Timeline:** Phase 6

---

### Recipes

**Description:** Create and manage custom recipes.

**Capabilities:**
- Recipe creation interface
- Ingredient calculator
- Serving size adjustment
- Recipe scaling
- Nutritional calculation per serving
- Recipe categories
- Import from URL
- Recipe sharing
- Cook time and instructions

**Timeline:** Phase 6

---

### Restaurant Support

**Description:** Extensive restaurant food database.

**Capabilities:**
- Chain restaurant menus
- Popular local restaurants
- Menu item nutritional info
- Customization options
- Recent orders quick access

**Timeline:** Phase 6+

---

### Wearables Support

**Description:** Companion apps for smartwatches.

**Platforms:**
- Wear OS
- watchOS

**Features:**
- Quick log from watch
- Glanceable progress
- Haptic feedback for milestones
- Voice commands
- Complications/widgets

**Timeline:** Phase 6

---

### Voice Logging

**Description:** Hands-free meal entry.

**Capabilities:**
- Natural language processing
- "Log 200g chicken breast and rice"
- Confirmation with voice
- Multi-language support

**Timeline:** Phase 5+

---

### Community Database

**Description:** User-contributed food verification system.

**Features:**
- Submit new foods
- Vote on accuracy
- Moderator approval workflow
- Contributor recognition
- Verification badges
- Regional foods

**Timeline:** Phase 7

---

## Non-Goals (Version 1)

The following features are **intentionally excluded** from Version 1 to maintain focus:

### Workout Tracking

**Reason:** Separate concern. Users can use dedicated workout apps. Focus on nutrition excellence first.

**Future:** Maybe Phase 10+ if there's strong demand.

---

### Water Tracking

**Reason:** Different tracking paradigm. Can be integrated via Apple Health/Google Fit later.

**Future:** Phase 10+ via health integrations.

---

### Notifications

**Reason:** Can feel spammy. Prioritize intrinsic motivation over external reminders. Users should open the app because they want to, not because they're prompted.

**Future:** Phase 8+ with careful, minimal implementation.

---

### Grocery Management

**Reason:** Completely different product category. This is a nutrition tracker, not a shopping app.

**Future:** Never. Out of scope.

---

### Complex Social Features

**Reason:** Increases complexity significantly. Privacy concerns. Distracts from core tracking experience.

**Future:** Phase 7+ with careful consideration.

---

### Meal Planning (V1)

**Reason:** Advanced feature. Validate core logging experience first. Many users don't need planning.

**Future:** Phase 6 after core features are solid.

---

### Recipe Builder (V1)

**Reason:** Complex UI/UX challenge. Secondary use case. Most users log individual foods.

**Future:** Phase 6.

---

### Intermittent Fasting Timer

**Reason:** Separate concern. Different user behavior pattern.

**Future:** Phase 10+ or never.

---

### Supplement Tracking

**Reason:** Niche use case. Most users track food only.

**Future:** Phase 10+.

---

### Macro Cycling

**Reason:** Advanced feature for specific users. Keep simple for V1.

**Future:** Phase 6+.

---

## Success Metrics

### Quantitative

| Metric | Target | Measurement |
|--------|--------|-------------|
| Time to log meal | < 10 seconds | User testing, analytics |
| Daily active users | 60% of registered | Analytics |
| Weekly retention | 70% | Analytics |
| Monthly retention | 50% | Analytics |
| Meals logged per day | 3.5 average | Analytics |
| App load time | < 1 second | Performance monitoring |
| Crash rate | < 0.1% | Crash reporting |
| Search success rate | > 90% | Analytics |

### Qualitative

| Aspect | Target | Measurement |
|--------|--------|-------------|
| Perceived speed | "Feels instant" | User surveys |
| Visual appeal | "Looks premium" | User surveys |
| Ease of use | "Intuitive" | User testing |
| Analytics value | "Insightful" | User feedback |
| Overall satisfaction | > 4.5/5 | App store ratings |

---

## Technical Requirements

### Performance

- Cold start: < 1 second
- Screen transitions: 60fps
- Search results: < 100ms
- API calls: < 500ms (with caching)
- Offline functionality: Full core features

### Platforms

| Platform | Priority | Notes |
|----------|----------|-------|
| Android | High | Primary platform |
| Windows | High | Desktop usage |
| Web | High | Accessibility, demo |
| Linux | Medium | Nice to have |
| iOS | Later | Requires Apple hardware |

### Accessibility

- Screen reader support
- Dynamic text sizing
- Touch targets ≥ 48x48dp
- Color contrast compliance (WCAG AA)
- Keyboard navigation (desktop/web)

### Privacy

- No selling of user data
- Minimal data collection
- Local-first architecture where possible
- Clear privacy policy
- GDPR compliance
- CCPA compliance
- Easy data export
- Easy account deletion

---

## Design Requirements

### Visual Style

- **Inspiration:** Nothing OS
- **Mode:** Dark only
- **Font:** Inter (Google Fonts)
- **Colors:** Monochromatic with subtle accents
- **Spacing:** 8pt grid system
- **Corners:** Rounded (8-16px radius)
- **Shadows:** Minimal, subtle
- **Animations:** Smooth, purposeful

### Interaction Principles

- Immediate feedback on all actions
- No loading spinners (use skeletons/shimmer)
- Optimistic updates where safe
- Undo instead of confirm dialogs
- Gestures where intuitive
- Haptic feedback (mobile)

---

## Release Criteria for Version 1.0

### Feature Completeness

- [ ] All Phase 1-3 milestones complete
- [ ] Dashboard fully functional
- [ ] Meal logging works flawlessly
- [ ] Food database populated
- [ ] Basic analytics working
- [ ] Goal tracking implemented
- [ ] Settings complete

### Quality Standards

- [ ] Zero critical bugs
- [ ] < 10 high-priority bugs
- [ ] Test coverage > 80%
- [ ] Performance benchmarks met
- [ ] Accessibility audit passed
- [ ] Security audit passed

### Documentation

- [ ] README complete
- [ ] ARCHITECTURE.md updated
- [ ] API documentation (if applicable)
- [ ] User guide/help section
- [ ] Privacy policy
- [ ] Terms of service

### Infrastructure

- [ ] CI/CD pipeline working
- [ ] Automated testing configured
- [ ] Crash reporting set up
- [ ] Analytics configured
- [ ] Build signing configured
- [ ] Store listings prepared

---

## Maintenance Notes

This document must be updated:
- When new features are added
- When product direction changes
- When user feedback indicates misalignment
- Quarterly for review

**Last Updated:** [Current Date]  
**Next Review:** [Quarterly Review Date]  
**Owner:** Product Team
