# Architecture Documentation

## Project Philosophy

Macro Tracker is built on foundational principles that guide every architectural decision:

### Core Values

1. **Fast Logging Above Everything Else**
   - The primary metric of success is how quickly a user can log a meal
   - Every tap, every screen transition, and every interaction is optimized for speed
   - Features that add friction are deprioritized or redesigned

2. **Premium User Experience**
   - The application must feel polished and professional
   - Animations should be smooth (60fps minimum)
   - Visual design follows Nothing OS principles: minimal, dark, elegant

3. **Open Source**
   - Code must be readable and well-documented
   - Architecture should be understandable by contributors
   - No proprietary dependencies that limit community contribution

4. **Modular Design**
   - Features are independent modules that can be developed in isolation
   - New features can be added without modifying existing code
   - Features can be removed or replaced without breaking the application

5. **Maintainability**
   - Code is written for the next developer, not just the current one
   - Clear separation of concerns makes debugging and refactoring easier
   - Documentation stays synchronized with implementation

6. **Feature-First Architecture**
   - Code is organized by feature, not by technical layer
   - All code related to a feature lives together
   - Easier to understand, test, and maintain complete features

7. **Clean Architecture Principles**
   - Business logic is isolated from frameworks and UI
   - Dependencies point inward toward the domain
   - The domain layer has no external dependencies

---

## Folder Structure

```
lib/
├── main.dart                      # Application entry point
│
├── app/                           # Application-level configuration
│   ├── macro_tracker_app.dart     # Root widget with providers
│   └── router/                    # Navigation configuration
│       ├── app_router.dart        # GoRouter setup
│       ├── app_routes.dart        # Route path constants
│       └── router_config.dart     # Router configuration options
│
├── core/                          # Shared infrastructure across all features
│   ├── constants/                 # App-wide immutable constants
│   │   ├── app_constants.dart     # General app configuration
│   │   ├── spacing_constants.dart # Spacing values (8pt grid)
│   │   ├── animation_constants.dart # Animation durations
│   │   └── border_radius_constants.dart # Consistent corner radii
│   │
│   ├── theme/                     # Design system implementation
│   │   ├── app_theme.dart         # ThemeData configuration
│   │   ├── app_colors.dart        # Color palette definitions
│   │   ├── app_typography.dart    # Text style definitions
│   │   └── app_dimensions.dart    # Layout dimension constants
│   │
│   ├── widgets/                   # Reusable UI components
│   │   ├── app_card.dart          # Standard card component
│   │   ├── app_button.dart        # Button variants
│   │   ├── app_text_field.dart    # Input field component
│   │   ├── app_scaffold.dart      # Custom scaffold wrapper
│   │   └── app_loading.dart       # Loading indicators
│   │
│   └── providers/                 # Global Riverpod providers
│       └── global_providers.dart  # Non-feature-specific providers
│
├── shared/                        # Cross-feature utilities and base classes
│   ├── domain/                    # Domain-layer shared code
│   │   ├── entity.dart            # Base entity class
│   │   └── failure.dart           # Base failure class for error handling
│   │
│   ├── extensions/                # Dart extension methods
│   │   ├── context_extensions.dart # BuildContext extensions
│   │   ├── datetime_extensions.dart # DateTime formatting
│   │   └── num_extensions.dart    # Number formatting
│   │
│   └── mixins/                    # Reusable mixins
│       └── equatable_mixin.dart   # Value equality helpers
│
└── features/                      # Feature modules (the heart of the app)
    ├── feature_name/              # Example feature structure
    │   ├── data/                  # Data layer implementation
    │   │   ├── datasources/       # External data sources
    │   │   │   ├── local_datasource.dart   # Local storage access
    │   │   │   └── remote_datasource.dart  # API access
    │   │   ├── models/            # DTOs (Data Transfer Objects)
    │   │   │   └── feature_model.dart      # Serializable model
    │   │   ├── repositories/      # Repository implementations
    │   │   │   └── feature_repository_impl.dart
    │   │   └── dtos/              # Request/Response objects
    │   │
    │   ├── domain/                # Business logic layer
    │   │   ├── entities/          # Pure business objects
    │   │   │   └── feature_entity.dart
    │   │   ├── repositories/      # Abstract repository interfaces
    │   │   │   └── feature_repository.dart
    │   │   ├── usecases/          # Business logic use cases
    │   │   │   ├── get_feature.dart
    │   │   │   └── update_feature.dart
    │   │   └── failures/          # Feature-specific failures
    │   │       └── feature_failure.dart
    │   │
    │   └── presentation/          # UI layer
    │       ├── pages/             # Full-screen pages
    │       │   └── feature_page.dart
    │       ├── widgets/           # Feature-specific widgets
    │       │   ├── feature_list_widget.dart
    │       │   └── feature_item_widget.dart
    │       ├── providers/         # Riverpod providers for this feature
    │       │   ├── feature_state.dart      # State class
    │       │   ├── feature_provider.dart   # StateNotifier provider
    │       │   └── feature_notifier.dart   # StateNotifier implementation
    │       └── controllers/       # Optional: Complex UI controllers
    │
    ├── dashboard/                 # Dashboard feature
    ├── meal_tracking/             # Meal logging feature
    ├── analytics/                 # Analytics and charts feature
    ├── settings/                  # App settings feature
    └── home/                      # Home/navigation shell feature
```

### Why This Structure Exists

#### `/app` Directory
Contains application-level configuration that bootstraps the entire app. This includes the root widget, dependency injection setup, and navigation configuration. It's separated because it orchestrates features rather than implementing them.

#### `/core` Directory
Houses infrastructure shared across ALL features. If code is used by multiple features, it belongs here. This prevents duplication and ensures consistency. Core components are generic and not tied to specific business logic.

#### `/shared` Directory
Contains cross-cutting concerns that support both core and features. Extensions, base classes, and utilities live here. These are low-level helpers that don't contain business logic.

#### `/features` Directory
The most important directory. Each feature is completely self-contained:
- A developer can work on one feature without touching others
- Features can be tested in isolation
- Features can be removed without breaking other features
- New team members can understand one feature at a time

### Adding New Features

When adding a new feature:

1. Create a new folder under `/features` with a snake_case name
2. Create the three subdirectories: `data/`, `domain/`, `presentation/`
3. Start with the domain layer (entities, repository interface, use cases)
4. Implement the data layer (models, repository implementation, datasources)
5. Build the presentation layer (providers, widgets, pages)
6. Add routes to the router configuration
7. Update ROADMAP.md to mark the feature as complete

---

## Technology Choices

### Flutter
**Why:** Single codebase for Android, Windows, Web, Linux, and iOS. Excellent performance with Skia rendering engine. Hot reload for rapid development. Growing ecosystem with strong community support.

**Alternatives Considered:**
- React Native: JavaScript bridge adds complexity, less consistent performance
- Kotlin Multiplatform: More complex setup, smaller ecosystem
- Native development: Duplicates effort across platforms

### Riverpod
**Why:** Compile-time safety, excellent devtools integration, no context required for reading providers, testable by design, supports dependency injection naturally. Works seamlessly with code generation.

**Alternatives Considered:**
- Provider: Requires BuildContext, runtime errors possible
- Bloc: More boilerplate, steeper learning curve
- GetX: Too much magic, harder to test

### GoRouter
**Why:** Officially recommended by Flutter team, declarative routing, deep linking support, type-safe route parameters, integrates well with Riverpod. Handles complex navigation scenarios elegantly.

**Alternatives Considered:**
- Navigator 2.0: Too verbose, easy to make mistakes
- AutoRoute: Code generation adds complexity
- Get: Too much magic, not recommended for large apps

### Supabase
**Why:** Open-source Firebase alternative, PostgreSQL database, built-in authentication, real-time subscriptions, generous free tier, self-hostable option. Perfect for open-source projects.

**Alternatives Considered:**
- Firebase: Proprietary, vendor lock-in, expensive at scale
- AWS Amplify: Complex setup, steep learning curve
- Self-hosted backend: More maintenance overhead

### PostgreSQL (via Supabase)
**Why:** Industry-standard relational database, excellent for structured nutrition data, powerful querying capabilities, ACID compliance, mature ecosystem. JSONB support for flexible data when needed.

**Alternatives Considered:**
- MongoDB: Schema-less nature could lead to data inconsistency
- SQLite: Limited to local storage, no cloud sync
- Firestore: NoSQL limits complex queries needed for analytics

### Dio
**Why:** Powerful HTTP client with interceptors, request/response transformation, file upload/download support, cancellation tokens, retry logic. Better error handling than http package.

**Alternatives Considered:**
- http package: Basic functionality, lacks advanced features
- Retrofit: Adds code generation complexity
- Chopper: Similar to Retrofit, smaller community

### json_serializable
**Why:** Compile-time code generation, type safety, null safety support, integrates with build_runner, reduces boilerplate for JSON parsing. Catches serialization errors at compile time.

**Alternatives Considered:**
- manual JSON parsing: Error-prone, verbose
- dart_json_mapper: Less mature, smaller community
- built_value: More complex, steeper learning curve

### flutter_dotenv
**Why:** Simple environment variable management, loads from .env file, accessible throughout the app, keeps secrets out of source code. Essential for API keys and configuration.

**Alternatives Considered:**
- flutter_config: Similar functionality, less maintained
- envied: Code generation approach, more complex
- Package-info: Less flexible

### fl_chart
**Why:** Beautiful, customizable charts designed for Flutter. Supports line, bar, pie, scatter, and area charts. Good performance, active maintenance. Perfect for macro analytics visualization.

**Alternatives Considered:**
- charts_flutter: Google's package, less maintained
- syncfusion_flutter_charts: Commercial license required
- graphview: Limited chart types

### freezed
**Why:** Code generation for immutable classes, union types, pattern matching support, equals/hashCode generation, copyWith methods. Essential for state management and domain models.

**Alternatives Considered:**
- built_value: More complex, different philosophy
- Manual immutable classes: Verbose, error-prone

---

## Design Principles

### Single Responsibility Principle (SRP)
Every class should have one reason to change.

**Implementation:**
- Use cases do ONE thing only
- Widgets are either layout or logic, rarely both
- Providers manage one piece of state
- Repositories handle one entity type

**Example:**
```dart
// ❌ Bad: Multiple responsibilities
class MealTracker {
  void logMeal(Meal meal) { ... }
  void calculateDailyMacros() { ... }
  void saveToDatabase(Meal meal) { ... }
  void showSnackbar(String message) { ... }
}

// ✅ Good: Single responsibility each
class LogMealUseCase { ... }
class CalculateDailyMacrosUseCase { ... }
class MealRepository { ... }
// UI handles snackbars
```

### Dependency Inversion Principle (DIP)
High-level modules should not depend on low-level modules. Both should depend on abstractions.

**Implementation:**
- Domain layer defines repository interfaces
- Data layer implements those interfaces
- Presentation layer depends on domain interfaces
- Dependencies injected via Riverpod

**Example:**
```dart
// Domain layer - defines the contract
abstract class MealRepository {
  Future<Either<Failure, Meal>> getMealById(String id);
  Future<Either<Failure, Unit>> saveMeal(Meal meal);
}

// Data layer - implements the contract
class MealRepositoryImpl implements MealRepository {
  final RemoteDataSource remoteDataSource;
  final LocalDataSource localDataSource;
  
  @override
  Future<Either<Failure, Meal>> getMealById(String id) { ... }
}

// Presentation layer - uses the abstraction
final mealRepositoryProvider = Provider<MealRepository>((ref) {
  return MealRepositoryImpl(
    remoteDataSource: ref.read(remoteDataSourceProvider),
    localDataSource: ref.read(localDataSourceProvider),
  );
});
```

### Repository Pattern
The repository pattern mediates between the domain and data layers, providing a clean API for data access.

**Benefits:**
- Domain layer doesn't know about data sources
- Easy to swap data sources (local ↔ remote)
- Centralized error handling
- Testable with mock repositories

**Structure:**
```
Domain Layer          Data Layer
┌─────────────────┐   ┌─────────────────────┐
│   Repository    │◄──│  RepositoryImpl     │
│   (Interface)   │   │  (Implementation)   │
└─────────────────┘   └─────────────────────┘
                              │
              ┌───────────────┼───────────────┐
              ▼               ▼               ▼
       ┌────────────┐ ┌────────────┐ ┌────────────┐
       │   Remote   │ │   Local    │ │   Cache    │
       │ DataSource │ │ DataSource │ │ DataSource │
       └────────────┘ └────────────┘ └────────────┘
```

### Immutable Models
All data models are immutable. Once created, they cannot be changed.

**Why:**
- Predictable state management
- Thread-safe by design
- Easy to reason about
- Works perfectly with Riverpod and freezed

**Implementation with freezed:**
```dart
@freezed
class Meal with _$Meal {
  const factory Meal({
    required String id,
    required String name,
    required int calories,
    required double protein,
    required double carbs,
    required double fat,
    required DateTime timestamp,
  }) = _Meal;
  
  factory Meal.fromJson(Map<String, dynamic> json) => _$MealFromJson(json);
}

// Usage - creates a new instance with modifications
final updatedMeal = meal.copyWith(calories: meal.calories + 100);
```

### Feature Modules
Each feature is a self-contained module with its own:
- Data layer (models, repositories, datasources)
- Domain layer (entities, use cases, repository interfaces)
- Presentation layer (widgets, pages, providers)

**Benefits:**
- Features can be developed independently
- Easy to locate code
- Clear ownership boundaries
- Simplifies testing

### Separation of UI and Business Logic
UI components should never contain business logic.

**Rules:**
- Widgets only handle display and user input
- Business logic lives in use cases
- State management handled by providers/notifiers
- No API calls directly from widgets
- No database queries in presentation layer

**Example:**
```dart
// ❌ Bad: Business logic in widget
class MealLogWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () async {
        // Business logic in UI - BAD!
        final calories = protein * 4 + carbs * 4 + fat * 9;
        final meal = Meal(id: uuid(), calories: calories, ...);
        await supabase.from('meals').insert(meal.toJson());
        ScaffoldMessenger.of(context).showSnackBar(...);
      },
    );
  }
}

// ✅ Good: Business logic separated
class MealLogWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () => ref.read(logMealProvider.notifier).logMeal(meal),
      child: Text('Log Meal'),
    );
  }
}

// Use case handles business logic
class LogMealUseCase {
  final MealRepository repository;
  final MacroCalculator calculator;
  
  Future<Either<Failure, Unit>> execute(Meal meal) async {
    final calculatedMacros = calculator.calculate(meal);
    return await repository.saveMeal(meal.copyWith(macros: calculatedMacros));
  }
}
```

---

## State Management

### Riverpod Organization

Riverpod providers are organized hierarchically:

```
lib/core/providers/          # Global providers (theme, locale, etc.)
lib/features/*/providers/    # Feature-specific providers
```

### Provider Types

#### StateNotifierProvider
For complex state with multiple actions:

```dart
// State class
@freezed
class MealTrackingState with _$MealTrackingState {
  const factory MealTrackingState({
    required AsyncValue<List<Meal>> meals,
    required bool isSearching,
    required String searchQuery,
  }) = _MealTrackingState;
}

// Notifier
class MealTrackingNotifier extends StateNotifier<MealTrackingState> {
  final GetMealsUseCase getMeals;
  final SearchMealsUseCase searchMeals;
  
  MealTrackingNotifier(this.getMeals, this.searchMeals)
    : super(const MealTrackingState(
        meals: AsyncValue.loading(),
        isSearching: false,
        searchQuery: '',
      ));
  
  Future<void> loadMeals() async { ... }
  Future<void> search(String query) async { ... }
  void clearSearch() async { ... }
}

// Provider
final mealTrackingProvider = StateNotifierProvider<MealTrackingNotifier, MealTrackingState>(
  (ref) => MealTrackingNotifier(
    ref.watch(getMealsUseCaseProvider),
    ref.watch(searchMealsUseCaseProvider),
  ),
);
```

#### FutureProvider
For single async operations:

```dart
final dailyMacrosProvider = FutureProvider<DailyMacros>((ref) async {
  final date = ref.watch(selectedDateProvider);
  final meals = await ref.watch(mealRepositoryProvider).getMealsForDate(date);
  return _calculateDailyMacros(meals);
});
```

#### Provider
For simple dependencies:

```dart
final macroCalculatorProvider = Provider<MacroCalculator>((ref) {
  return MacroCalculator();
});
```

#### StateProvider
For simple mutable state:

```dart
final selectedDateProvider = StateProvider<DateTime>((ref) => DateTime.now());
final searchQueryProvider = StateProvider<String>((ref) => '');
```

### Provider Naming Conventions

- `*Provider` - Generic provider
- `*StateProvider` - StateProvider
- `*FutureProvider` - FutureProvider
- `*StreamProvider` - StreamProvider
- `*NotifierProvider` - StateNotifierProvider
- `*AsyncNotifierProvider` - AsyncNotifierProvider

### State Flow

```
User Action
    │
    ▼
Widget calls Notifier method
    │
    ▼
Notifier calls Use Case
    │
    ▼
Use Case calls Repository
    │
    ▼
Repository calls DataSource
    │
    ▼
DataSource returns Result
    │
    ▼
Result flows back up
    │
    ▼
Notifier updates State
    │
    ▼
Widget rebuilds with new State
```

---

## Navigation

### GoRouter Organization

Navigation is configured in `/app/router/`:

```
app/router/
├── app_router.dart        # Main router configuration
├── app_routes.dart        # Route path constants
└── router_config.dart     # Shell routes, redirects, observers
```

### Route Definition

```dart
// app_routes.dart
class AppRoutes {
  static const String home = '/';
  static const String dashboard = '/dashboard';
  static const String mealTracking = '/meal-tracking';
  static const String mealDetail = '/meal-tracking/:mealId';
  static const String analytics = '/analytics';
  static const String settings = '/settings';
}
```

### Router Configuration

```dart
// app_router.dart
final appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  debugLogDiagnostics: true,
  routes: [
    // Shell route for main navigation
    ShellRoute(
      builder: (context, state, child) => HomeScreen(child: child),
      routes: [
        GoRoute(
          path: AppRoutes.dashboard,
          name: 'dashboard',
          pageBuilder: (context, state) => const MaterialPage(
            child: DashboardPage(),
          ),
        ),
        GoRoute(
          path: AppRoutes.mealTracking,
          name: 'mealTracking',
          pageBuilder: (context, state) => const MaterialPage(
            child: MealTrackingPage(),
          ),
          routes: [
            GoRoute(
              path: ':mealId',
              name: 'mealDetail',
              pageBuilder: (context, state) {
                final mealId = state.pathParameters['mealId']!;
                return MaterialPage(
                  child: MealDetailPage(mealId: mealId),
                );
              },
            ),
          ],
        ),
        // ... more routes
      ],
    ),
  ],
  errorPageBuilder: (context, state) => MaterialPage(
    child: NotFoundPage(uri: state.uri),
  ),
);
```

### Navigation Patterns

#### Programmatic Navigation
```dart
context.go(AppRoutes.dashboard);
context.push(AppRoutes.mealDetail, pathParameters: {'mealId': meal.id});
context.pop();
```

#### Navigation with Results
```dart
final result = await context.pushNamed<bool>('mealDetail', ...);
if (result == true) {
  // Handle successful operation
}
```

#### Deep Linking
GoRouter automatically handles deep links:
```dart
// Opens: myapp://meal-tracking/abc123
goRouter.goLink(Uri.parse('myapp://meal-tracking/abc123'));
```

---

## Theme

The design system is implemented in `/core/theme/` and provides a consistent, premium experience.

### Design Tokens

All design values are defined as constants, never hardcoded:

```dart
// lib/core/constants/spacing_constants.dart
class Spacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
}

// lib/core/constants/border_radius_constants.dart
class BorderRadii {
  static const double sm = 4.0;
  static const double md = 8.0;
  static const double lg = 12.0;
  static const double xl = 16.0;
  static const double full = 9999.0;
}

// lib/core/constants/animation_constants.dart
class AnimationDurations {
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 250);
  static const Duration slow = Duration(milliseconds: 350);
}
```

### Color Palette

Dark mode only, inspired by Nothing OS:

```dart
// lib/core/theme/app_colors.dart
class AppColors {
  // Background surfaces
  static const Color background = Color(0xFF0A0A0A);
  static const Color surface1 = Color(0xFF141414);
  static const Color surface2 = Color(0xFF1E1E1E);
  static const Color surface3 = Color(0xFF282828);
  
  // Primary
  static const Color primary = Color(0xFFD0D0D0);
  static const Color primaryVariant = Color(0xFFE8E8E8);
  
  // Semantic colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFEF5350);
  static const Color info = Color(0xFF2196F3);
  
  // Text
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0B0B0);
  static const Color textTertiary = Color(0xFF6E6E6E);
  
  // Borders
  static const Color border = Color(0xFF2A2A2A);
  static const Color borderLight = Color(0xFF3A3A3A);
}
```

### Typography

Using Inter font for clean, modern readability:

```dart
// lib/core/theme/app_typography.dart
class AppTextStyles {
  static const String fontFamily = 'Inter';
  
  static const TextStyle displayLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: -0.5,
  );
  
  static const TextStyle headline = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );
  
  static const TextStyle title = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );
  
  static const TextStyle body = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );
  
  static const TextStyle caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );
  
  static const TextStyle overline = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.6,
    letterSpacing: 0.5,
  );
  
  // Numeric display with tabular figures
  static const TextStyle numeric = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w500,
    height: 1.2,
    fontFeatures: [FontFeature.tabularFigures()],
  );
}
```

### Reusable Components

All UI components are built once and reused everywhere:

#### AppCard
```dart
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final Color? color;
  
  const AppCard({
    required this.child,
    this.padding,
    this.onTap,
    this.color,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color ?? AppColors.surface2,
        borderRadius: BorderRadius.circular(BorderRadii.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(BorderRadii.lg),
          child: Padding(
            padding: padding ?? EdgeInsets.all(Spacing.md),
            child: child,
          ),
        ),
      ),
    );
  }
}
```

#### AppButton
```dart
enum AppButtonType { primary, secondary, text, destructive }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonType type;
  final bool isLoading;
  final IconData? icon;
  
  const AppButton({
    required this.label,
    this.onPressed,
    this.type = AppButtonType.primary,
    this.isLoading = false,
    this.icon,
  });
  
  @override
  Widget build(BuildContext context) {
    // Implementation with consistent styling
  }
}
```

#### AppTextField
```dart
class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final IconData? prefixIcon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String? errorText;
  
  const AppTextField({
    this.controller,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.keyboardType,
    this.obscureText = false,
    this.errorText,
  });
  
  @override
  Widget build(BuildContext context) {
    // Implementation with consistent styling
  }
}
```

### Motion Design

Animations follow consistent patterns:

- **Page transitions**: 250ms, ease-in-out
- **Card taps**: 150ms, scale effect
- **Loading states**: Smooth shimmer, not spinners
- **List animations**: Staggered entrance

```dart
// Page transition
class FadeSlideTransition extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: animation,
        curve: Curves.easeInOut,
      ),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.02),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOut,
        )),
        child: child,
      ),
    );
  }
}
```

---

## Data Flow

### Complete Data Flow Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                        PRESENTATION LAYER                        │
│                                                                  │
│  ┌─────────────┐                                                │
│  │   Widget    │ ◄─── User interacts with UI                    │
│  └──────┬──────┘                                                │
│         │ Calls method on                                        │
│         ▼                                                        │
│  ┌─────────────┐                                                │
│  │  Notifier   │ ◄─── Manages UI state                          │
│  │ (Stateless) │                                                │
│  └──────┬──────┘                                                │
│         │ Dispatches                                             │
│         ▼                                                        │
│  ┌─────────────┐                                                │
│  │  Use Case   │ ◄─── Contains business logic                   │
│  └──────┬──────┘                                                │
│         │ Requests                                               │
└─────────┼────────────────────────────────────────────────────────┘
          │                                                       
          ▼                                                       
┌─────────────────────────────────────────────────────────────────┐
│                         DOMAIN LAYER                             │
│                                                                  │
│  ┌─────────────┐                                                │
│  │ Repository │ ◄─── Abstract interface                         │
│  │ (Interface)│                                                 │
│  └──────┬──────┘                                                │
│         │ Delegates to                                          │
│         ▼                                                        │
│  ┌─────────────┐                                                │
│  │   Entity   │ ◄─── Pure business object                       │
│  └────────────┘                                                 │
└─────────┬────────────────────────────────────────────────────────┘
          │                                                       
          ▼                                                       
┌─────────────────────────────────────────────────────────────────┐
│                          DATA LAYER                              │
│                                                                  │
│  ┌─────────────────┐                                           │
│  │ RepositoryImpl  │ ◄─── Concrete implementation               │
│  └───────┬─────────┘                                           │
│          │ Uses                                                  │
│          ▼                                                       │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐ │
│  │    Remote DS    │  │     Local DS    │  │    Cache DS     │ │
│  │    (Supabase)   │  │   (SharedPreferences)│  │   (Memory)     │ │
│  └────────┬────────┘  └─────────────────┘  └─────────────────┘ │
│           │                                                      │
│           ▼                                                      │
│  ┌─────────────────┐                                           │
│  │  Model (DTO)    │ ◄─── Serializable data transfer object     │
│  └────────┬────────┘                                           │
│           │                                                      │
│           ▼                                                      │
│  ┌─────────────────┐                                           │
│  │  API / Database │ ◄─── External data source                  │
│  └─────────────────┘                                           │
└─────────────────────────────────────────────────────────────────┘
```

### Step-by-Step Flow Example: Loading Meals

1. **UI Trigger**: User opens meal tracking page
2. **Widget**: `MealTrackingPage` builds and watches `mealTrackingProvider`
3. **Notifier**: `MealTrackingNotifier` initializes with loading state
4. **Use Case**: Notifier calls `GetMealsUseCase.execute()`
5. **Repository Interface**: Use case calls `mealRepository.getMeals()`
6. **Repository Implementation**: `MealRepositoryImpl` handles the request
7. **Data Source**: Repository calls `remoteDataSource.fetchMeals()`
8. **API Call**: Dio makes HTTP request to Supabase
9. **Response**: JSON response received
10. **Mapping**: JSON → `MealModel` (DTO) → `Meal` (Entity)
11. **Return Path**: Entity flows back through repository → use case → notifier
12. **State Update**: Notifier calls `state = state.copyWith(meals: AsyncValue.data(meals))`
13. **UI Rebuild**: Widget rebuilds with loaded data

### Error Handling Flow

```
Error occurs at any layer
         │
         ▼
   Wrapped in Failure
         │
         ▼
   Returned as Either<Failure, T>
         │
         ▼
   Use Case handles or propagates
         │
         ▼
   Notifier receives Failure
         │
         ▼
   State updated with error
         │
         ▼
   Widget displays error state
```

---

## Naming Conventions

Consistent naming makes code predictable and easier to navigate.

### Files

| Type | Convention | Example |
|------|------------|---------|
| Widgets | `snake_case.dart` | `meal_card.dart` |
| Pages | `snake_case_page.dart` | `meal_tracking_page.dart` |
| Providers | `snake_case_provider.dart` | `meal_provider.dart` |
| Notifiers | `snake_case_notifier.dart` | `meal_notifier.dart` |
| Use Cases | `verb_noun.dart` | `get_meals.dart` |
| Repositories | `noun_repository.dart` | `meal_repository.dart` |
| Models | `noun_model.dart` | `meal_model.dart` |
| Entities | `noun.dart` | `meal.dart` |
| Constants | `noun_constants.dart` | `spacing_constants.dart` |
| Extensions | `noun_extensions.dart` | `datetime_extensions.dart` |

### Folders

- Always `snake_case`
- Singular for entities, plural for collections
- Feature names are descriptive nouns

```
✅ features/meal_tracking/
❌ features/mealTracking/
❌ features/meal-track/
```

### Classes

| Type | Convention | Example |
|------|------------|---------|
| Widgets | PascalCase + Widget suffix | `MealCardWidget` |
| Pages | PascalCase + Page suffix | `MealTrackingPage` |
| Providers | PascalCase + Provider suffix | `MealProvider` |
| Notifiers | PascalCase + Notifier suffix | `MealNotifier` |
| Use Cases | PascalCase + UseCase suffix | `GetMealsUseCase` |
| Repositories | PascalCase + Repository suffix | `MealRepository` |
| Models | PascalCase + Model suffix | `MealModel` |
| Entities | PascalCase only | `Meal` |
| Exceptions | PascalCase + Exception suffix | `MealNotFoundException` |
| Failures | PascalCase + Failure suffix | `MealLoadFailure` |

### Variables and Functions

| Type | Convention | Example |
|------|------------|---------|
| Variables | camelCase | `selectedMeal` |
| Constants | camelCase with static const | `maxCalories` |
| Functions | camelCase with verb prefix | `loadMeals()` |
| Private | Leading underscore | `_isLoading` |
| Parameters | camelCase | `mealId` |

### Providers

```dart
// Repository provider
final mealRepositoryProvider = Provider<MealRepository>(...);

// Use case provider
final getMealsUseCaseProvider = Provider<GetMealsUseCase>(...);

// State notifier provider
final mealTrackingProvider = StateNotifierProvider<MealTrackingNotifier, MealTrackingState>(...);

// Simple state provider
final selectedDateProvider = StateProvider<DateTime>(...);

// Future provider
final dailyMacrosProvider = FutureProvider<DailyMacros>(...);
```

### Enums

```dart
enum MealType { breakfast, lunch, dinner, snack }
enum AppButtonType { primary, secondary, text, destructive }
enum LoadState { initial, loading, success, error }
```

### Extensions

```dart
extension DateTimeExtensions on DateTime {
  String get formattedDate => ...
  bool get isToday => ...
}

extension ContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);
  void showSnackbar(String message) => ...
}
```

---

## Code Standards

### General Rules

1. **Always declare return types**
   ```dart
   // ✅ Good
   Future<void> loadMeals() async { ... }
   
   // ❌ Bad
   loadMeals() async { ... }
   ```

2. **Prefer const constructors**
   ```dart
   // ✅ Good
   const MealCard(meal: meal)
   
   // ❌ Bad
   MealCard(meal: meal)
   ```

3. **Avoid print statements**
   ```dart
   // ✅ Good - Use proper logging
   logger.d('Loading meals');
   
   // ❌ Bad
   print('Loading meals');
   ```

4. **Use meaningful names**
   ```dart
   // ✅ Good
   final totalDailyCalories = _calculateTotalCalories(meals);
   
   // ❌ Bad
   final total = _calc(meals);
   ```

5. **Single responsibility per class**
   - If a class does more than one thing, split it
   - Maximum 200 lines per file (guideline, not hard rule)

6. **No deprecated APIs**
   - Run `flutter analyze` regularly
   - Update deprecated code immediately

7. **No TODO comments**
   - Either implement it properly or create a GitHub issue
   - TODOs become technical debt

### Documentation Standards

1. **Public APIs must be documented**
   ```dart
   /// Calculates the total macronutrients for a given list of meals.
   ///
   /// Returns a [DailyMacros] object containing the sum of protein,
   /// carbohydrates, and fat across all provided meals.
   ///
   /// If [meals] is empty, returns [DailyMacros.zero].
   DailyMacros calculateDailyMacros(List<Meal> meals) { ... }
   ```

2. **Complex logic should have inline comments**
   ```dart
   // Macro calculation uses Atwater factors
   // Protein: 4 cal/g, Carbs: 4 cal/g, Fat: 9 cal/g
   final totalCalories = protein * 4 + carbs * 4 + fat * 9;
   ```

3. **Architecture decisions documented in ARCHITECTURE.md**
   - Major changes require documentation updates
   - Link to relevant sections in code comments

### Testing Standards

1. **Unit tests for all use cases**
   ```dart
   group('GetMealsUseCase', () {
     test('returns meals when repository succeeds', () async { ... });
     test('returns failure when repository fails', () async { ... });
   });
   ```

2. **Widget tests for reusable components**
   ```dart
   testWidgets('AppCard displays child content', (tester) async { ... });
   ```

3. **Integration tests for critical user flows**
   ```dart
   testWidgets('User can log a meal', (tester) async { ... });
   ```

4. **Test file naming**
   - Mirror source file structure
   - Add `_test.dart` suffix
   ```
   lib/features/meal_tracking/domain/usecases/get_meals.dart
   test/features/meal_tracking/domain/usecases/get_meals_test.dart
   ```

### Performance Standards

1. **Use `const` wherever possible**
2. **Avoid rebuilding entire lists** - Use `ListView.builder`
3. **Cache expensive computations** - Use Riverpod's caching
4. **Lazy load images** - Use `cached_network_image`
5. **Minimize setState scope** - Rebuild only what's necessary

### Security Standards

1. **Never commit secrets** - Use `.env` files
2. **Validate all user input** - Server-side and client-side
3. **Use HTTPS only** - Enforced by Supabase
4. **Sanitize displayed data** - Prevent XSS on web

---

## Documentation Maintenance

This document must stay synchronized with the codebase:

- When adding new features, update relevant sections
- When changing architecture, update diagrams and explanations
- When deprecating patterns, mark them clearly
- Review and update quarterly at minimum

**Outdated documentation is worse than no documentation.**

If you find inconsistencies between this document and the code:
1. Update the documentation immediately
2. Note the change in the changelog
3. Notify the team of significant changes
