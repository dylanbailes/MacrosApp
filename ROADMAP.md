# Project Roadmap

This document outlines the complete development roadmap for Macro Tracker, organized into phases and milestones. Each milestone includes its purpose, features, dependencies, and completion status.

---

## Phase 1: Foundation

**Timeline:** Q1 2024  
**Status:** ✅ Completed

### Milestone 1.1: Project Setup

**Purpose:** Establish the technical foundation for the entire application.

**Features:**
- Flutter project initialization
- Multi-platform configuration (Android, Windows, Web, Linux)
- Basic project structure created
- Git repository setup

**Dependencies:** None

**Status:** ✅ Completed

---

### Milestone 1.2: Architecture Implementation

**Purpose:** Implement clean architecture patterns that will scale with the application.

**Features:**
- Feature-first folder structure
- Domain/Data/Presentation layer separation
- Base classes for entities, repositories, and use cases
- Dependency injection foundation

**Dependencies:** Milestone 1.1

**Status:** ✅ Completed

---

### Milestone 1.3: Design System

**Purpose:** Create a consistent, premium visual language for the entire application.

**Features:**
- Dark mode only theme implementation
- Color palette (Nothing OS inspired)
- Typography system (Inter font)
- Spacing constants (8pt grid)
- Border radius constants
- Animation duration constants
- Reusable components:
  - AppCard
  - AppButton
  - AppTextField
  - AppScaffold
  - AppLoading

**Dependencies:** Milestone 1.1

**Status:** ✅ Completed

---

### Milestone 1.4: State Management

**Purpose:** Establish predictable, testable state management patterns.

**Features:**
- Riverpod integration
- Global providers configuration
- Provider organization patterns
- StateNotifier base classes
- Async state handling patterns

**Dependencies:** Milestone 1.2

**Status:** ✅ Completed

---

### Milestone 1.5: Navigation System

**Purpose:** Implement robust, type-safe navigation throughout the application.

**Features:**
- GoRouter integration
- Route path constants
- Shell route for main navigation
- Page transition animations
- Deep linking preparation
- Error/Not found page

**Dependencies:** Milestone 1.2, Milestone 1.4

**Status:** ✅ Completed

---

### Milestone 1.6: Documentation Foundation

**Purpose:** Ensure the project is well-documented for contributors and users.

**Features:**
- README.md with project overview
- ARCHITECTURE.md with detailed architecture documentation
- ROADMAP.md (this document)
- PRODUCT_SPEC.md with product specifications
- CONTRIBUTING.md with contribution guidelines
- Code documentation standards

**Dependencies:** Milestone 1.2

**Status:** ✅ Completed

---

## Phase 2: Backend Integration

**Timeline:** Q2 2024  
**Status:** ⏳ Upcoming

### Milestone 2.1: Supabase Setup

**Purpose:** Configure backend infrastructure for data storage and synchronization.

**Features:**
- Supabase project creation
- Environment variable configuration
- Dio HTTP client setup
- API service layer implementation
- Error handling and retry logic
- Network connectivity detection

**Dependencies:** Phase 1 Complete

**Status:** ⏳ Not Started

---

### Milestone 2.2: Authentication

**Purpose:** Enable secure user authentication and account management.

**Features:**
- Supabase Auth integration
- Email/password authentication
- OAuth providers (Google, Apple)
- Session management
- Token refresh logic
- Protected routes
- Login/Signup pages
- Password reset flow
- Remember me functionality

**Dependencies:** Milestone 2.1

**Status:** ⏳ Not Started

---

### Milestone 2.3: Database Schema

**Purpose:** Design and implement the database structure for all application data.

**Features:**
- PostgreSQL schema design
- Users table
- Meals table
- Foods table
- Daily logs table
- Goals table
- Body measurements table
- Database migrations
- Indexes for performance
- Row-level security policies

**Dependencies:** Milestone 2.1

**Status:** ⏳ Not Started

---

### Milestone 2.4: Local Data Persistence

**Purpose:** Enable offline functionality and fast local data access.

**Features:**
- SQLite or Hive integration
- Local database schema
- Sync mechanism with remote
- Conflict resolution strategy
- Cache invalidation
- Offline-first architecture
- Data migration handling

**Dependencies:** Milestone 2.3

**Status:** ⏳ Not Started

---

## Phase 3: Core Features

**Timeline:** Q3 2024  
**Status:** ⏳ Upcoming

### Milestone 3.1: Food Database

**Purpose:** Provide a comprehensive database of foods for quick logging.

**Features:**
- Food entity and model
- Food repository implementation
- Search functionality
- Food categories
- Nutritional data (calories, protein, carbs, fat, fiber, etc.)
- Serving sizes and units
- Food images
- Brand foods vs generic foods
- Quick add common foods

**Dependencies:** Phase 2 Complete

**Status:** ⏳ Not Started

---

### Milestone 3.2: Meal Logging

**Purpose:** Enable fast, frictionless meal tracking.

**Features:**
- Log meal interface
- Food search with smart ranking
- Recent foods quick access
- Favorites system
- Portion size selection
- Custom food creation
- Meal templates
- Copy previous meal
- Voice input (future)
- Barcode scanner integration (future)
- Meal photos (future)

**Dependencies:** Milestone 3.1

**Status:** ⏳ Not Started

---

### Milestone 3.3: Dashboard

**Purpose:** Provide an at-a-glance view of daily progress.

**Features:**
- Daily macro summary cards
- Calorie progress ring/bar
- Protein/Carbs/Fat breakdown
- Meal list for current day
- Quick add buttons
- Date selector
- Weekly average display
- Streak counter
- Goal progress indicators

**Dependencies:** Milestone 3.2

**Status:** ⏳ Not Started

---

### Milestone 3.4: Goal Tracking

**Purpose:** Allow users to set and track nutrition goals.

**Features:**
- Daily calorie goal
- Macro ratio targets
- Weight goals
- Goal presets (cut, bulk, maintain)
- TDEE calculator
- Automatic goal adjustment suggestions
- Goal history tracking
- Progress photos integration

**Dependencies:** Milestone 3.2

**Status:** ⏳ Not Started

---

## Phase 4: Analytics & Insights

**Timeline:** Q4 2024  
**Status:** ⏳ Upcoming

### Milestone 4.1: Charts Implementation

**Purpose:** Visualize nutrition data with beautiful, interactive charts.

**Features:**
- fl_chart integration
- Weekly macro trends
- Monthly weight progression
- Calorie intake distribution
- Macro ratio pie chart
- Day-over-day comparison
- Interactive tooltips
- Export chart images

**Dependencies:** Phase 3 Complete

**Status:** ⏳ Not Started

---

### Milestone 4.2: Advanced Analytics

**Purpose:** Provide deep insights into eating patterns and progress.

**Features:**
- Weekly/monthly summaries
- Best/worst days analysis
- Meal timing patterns
- Food variety metrics
- Consistency score
- Progress velocity
- Correlation analysis (weight vs calories)
- Insights generation
- Achievement badges

**Dependencies:** Milestone 4.1

**Status:** ⏳ Not Started

---

### Milestone 4.3: Reports

**Purpose:** Generate comprehensive reports for review and sharing.

**Features:**
- Weekly report generation
- Monthly summary PDF
- Email reports
- Share progress cards
- Export data as CSV
- Print-friendly views
- Custom date range reports

**Dependencies:** Milestone 4.1

**Status:** ⏳ Not Started

---

## Phase 5: AI & Smart Features

**Timeline:** Q1 2025  
**Status:** ⏳ Upcoming

### Milestone 5.1: AI Coach

**Purpose:** Provide intelligent, personalized nutrition guidance.

**Features:**
- AI-powered meal suggestions
- Pattern recognition
- Personalized recommendations
- Habit formation tips
- Motivational messaging
- Goal adjustment suggestions
- Plateau breaking strategies
- Conversation interface

**Dependencies:** Phase 4 Complete, AI API integration

**Status:** ⏳ Not Started

---

### Milestone 5.2: Photo Food Recognition

**Purpose:** Enable logging meals by taking photos.

**Features:**
- Camera integration
- Image upload
- AI food identification
- Portion estimation from image
- Confidence scoring
- Manual correction option
- Learning from corrections
- Multiple food detection

**Dependencies:** Milestone 5.1, Computer Vision API

**Status:** ⏳ Not Started

---

### Milestone 5.3: Body Fat Estimation

**Purpose:** Provide body composition estimates from photos.

**Features:**
- Body photo upload
- AI body fat percentage estimation
- Progress comparison overlays
- Measurement tracking
- DEXA scan calibration option
- Trend analysis
- Privacy-focused processing

**Dependencies:** Milestone 5.1, Specialized AI model

**Status:** ⏳ Not Started

---

## Phase 6: Advanced Features

**Timeline:** Q2 2025  
**Status:** ⏳ Upcoming

### Milestone 6.1: Meal Planning

**Purpose:** Enable users to plan meals in advance.

**Features:**
- Weekly meal planner
- Drag-and-drop interface
- Recipe integration
- Shopping list generation
- Nutrition preview
- Plan templates
- Bulk planning tools
- Calendar integration

**Dependencies:** Phase 3 Complete

**Status:** ⏳ Not Started

---

### Milestone 6.2: Recipes

**Purpose:** Allow users to save and manage custom recipes.

**Features:**
- Recipe creation interface
- Ingredient calculator
- Serving size adjustment
- Recipe scaling
- Nutritional calculation
- Recipe categories
- Import from URL
- Recipe sharing
- Cook time and instructions

**Dependencies:** Milestone 3.1

**Status:** ⏳ Not Started

---

### Milestone 6.3: Health Integrations

**Purpose:** Sync data with health platforms.

**Features:**
- Apple Health integration
- Google Fit integration
- Fitbit sync
- Garmin Connect
- Oura Ring integration
- Weight auto-import
- Activity data correlation
- Sleep data integration

**Dependencies:** Platform-specific APIs

**Status:** ⏳ Not Started

---

### Milestone 6.4: Wearables Support

**Purpose:** Extend app functionality to wearable devices.

**Features:**
- Wear OS app
- watchOS app
- Quick log from watch
- Glanceable progress
- Haptic feedback
- Voice commands
- Complications/widgets

**Dependencies:** Milestone 6.3

**Status:** ⏳ Not Started

---

## Phase 7: Social & Community

**Timeline:** Q3 2025  
**Status:** ⏳ Upcoming

### Milestone 7.1: Social Features

**Purpose:** Build community and accountability features.

**Features:**
- User profiles
- Follow/followers
- Progress sharing
- Feed of followed users
- Comments and reactions
- Privacy controls
- Block/mute functionality
- Achievement sharing

**Dependencies:** Phase 2 Complete

**Status:** ⏳ Not Started

---

### Milestone 7.2: Community Database

**Purpose:** Leverage community contributions for food data.

**Features:**
- User-submitted foods
- Voting system for accuracy
- Moderator approval workflow
- Contributor credits
- Food verification badges
- Restaurant menu submissions
- Regional foods database

**Dependencies:** Milestone 7.1

**Status:** ⏳ Not Started

---

### Milestone 7.3: Challenges

**Purpose:** Gamify the experience with community challenges.

**Features:**
- Weekly challenges
- Group challenges
- Leaderboards
- Challenge creation
- Participation badges
- Progress tracking
- Challenge chat
- Prize system (future)

**Dependencies:** Milestone 7.1

**Status:** ⏳ Not Started

---

## Phase 8: Polish & Optimization

**Timeline:** Q4 2025  
**Status:** ⏳ Upcoming

### Milestone 8.1: Performance Optimization

**Purpose:** Ensure the app feels instant and responsive.

**Features:**
- Bundle size optimization
- Image caching improvements
- Query optimization
- Lazy loading implementation
- Memory leak fixes
- Frame rate optimization
- Cold start time reduction
- Network request batching

**Dependencies:** All previous phases

**Status:** ⏳ Not Started

---

### Milestone 8.2: Accessibility

**Purpose:** Make the app usable by everyone.

**Features:**
- Screen reader support
- Dynamic text sizing
- High contrast mode option
- Keyboard navigation (desktop/web)
- Touch target sizing
- Color blindness considerations
- Reduced motion option
- Accessibility testing

**Dependencies:** Phase 1 Design System

**Status:** ⏳ Not Started

---

### Milestone 8.3: Internationalization

**Purpose:** Support users worldwide.

**Features:**
- i18n framework setup
- String externalization
- RTL language support
- Number format localization
- Date/time localization
- Unit conversion (metric/imperial)
- Translation infrastructure
- Initial languages: EN, ES, DE, FR

**Dependencies:** Phase 1 Complete

**Status:** ⏳ Not Started

---

### Milestone 8.4: Testing Suite

**Purpose:** Ensure reliability through comprehensive testing.

**Features:**
- Unit test coverage >80%
- Widget test coverage
- Integration tests
- E2E tests
- Performance tests
- Visual regression tests
- CI/CD pipeline
- Automated testing on PRs

**Dependencies:** All feature complete

**Status:** ⏳ Not Started

---

## Phase 9: Release & Growth

**Timeline:** Q1 2026  
**Status:** ⏳ Upcoming

### Milestone 9.1: Open Source Release

**Purpose:** Launch the project to the open source community.

**Features:**
- GitHub organization setup
- Contribution guidelines finalized
- Code of conduct
- Issue templates
- PR templates
- Release process documentation
- Version 1.0.0 release
- Announcement blog post
- Social media launch

**Dependencies:** Phase 8 Complete

**Status:** ⏳ Not Started

---

### Milestone 9.2: App Store Releases

**Purpose:** Make the app available on all platforms.

**Features:**
- Google Play Store submission
- Microsoft Store submission
- Web deployment
- App Store submission (iOS)
- Store listing optimization
- Screenshots and previews
- Privacy policy
- Terms of service

**Dependencies:** Milestone 8.4

**Status:** ⏳ Not Started

---

### Milestone 9.3: Feedback Loop

**Purpose:** Establish channels for user feedback and continuous improvement.

**Features:**
- In-app feedback form
- Bug reporting system
- Feature request voting
- User analytics (privacy-focused)
- Crash reporting
- Regular update cadence
- Changelog communication
- Community forum/Discord

**Dependencies:** Milestone 9.1

**Status:** ⏳ Not Started

---

## Intentionally Postponed (Version 1)

The following features are explicitly NOT part of Version 1:

| Feature | Reason for Postponement | Potential Future Phase |
|---------|------------------------|----------------------|
| Workout tracking | Focus on nutrition only | Phase 10+ |
| Water tracking | Separate concern, can be integrated via Health | Phase 10+ |
| Notifications | Can feel spammy, prioritize intrinsic motivation | Phase 8+ |
| Grocery management | Different product category | Never (out of scope) |
| Complex social features | Increases complexity, privacy concerns | Phase 7+ |
| Meal planning | Advanced feature, validate core first | Phase 6 |
| Recipe builder | Complex UI/UX, secondary use case | Phase 6 |
| Restaurant support | Requires extensive database | Phase 6+ |
| Voice logging | Nice-to-have, not essential | Phase 5+ |
| Supplement tracking | Niche use case | Phase 10+ |
| Intermittent fasting timer | Separate concern | Phase 10+ |
| Macro cycling | Advanced feature for specific users | Phase 6+ |

---

## Version History

| Version | Date | Status | Major Features |
|---------|------|--------|----------------|
| 0.1.0 | TBD | 🔄 In Development | Foundation, Architecture, Theme |
| 0.2.0 | TBD | ⏳ Planned | Backend, Authentication |
| 0.3.0 | TBD | ⏳ Planned | Core Features (Food, Logging, Dashboard) |
| 0.4.0 | TBD | ⏳ Planned | Analytics & Charts |
| 0.5.0 | TBD | ⏳ Planned | AI Features |
| 1.0.0 | TBD | ⏳ Planned | Production Release |

---

## Maintenance Notes

This document must be updated:
- After each milestone is completed
- When new milestones are added
- When priorities change
- Quarterly for review and adjustment

**Last Updated:** [Current Date]  
**Next Review:** [Quarterly Review Date]
