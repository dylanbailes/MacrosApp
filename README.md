# Macro Tracker

A fast, premium macro and nutrition tracker designed for gym enthusiasts and athletes. Built with Flutter using clean architecture principles.

## 🎯 Project Vision

The primary goal is **minimizing friction** when logging meals. Every design decision prioritizes making meal logging as fast as possible while providing advanced analytics.

### Design Philosophy

- **Nothing OS Inspired**: Minimal, dark mode only, smooth animations
- **High Information Density**: Maximum utility without clutter
- **Modern Typography**: Clean, readable, professional
- **Premium Feel**: Polished interactions and transitions

## 🏗️ Architecture

This project follows **Feature-First Clean Architecture** with clear separation of concerns:

```
lib/
├── core/                    # Shared infrastructure
│   ├── constants/           # App-wide constants (colors, spacing, etc.)
│   ├── theme/               # Theme configuration
│   ├── widgets/             # Reusable UI components
│   └── providers/           # Global Riverpod providers
│
├── shared/                  # Cross-feature utilities
│   ├── domain/              # Base entities and failures
│   └── extensions/          # Dart extensions
│
├── features/                # Feature modules
│   ├── feature_name/
│   │   ├── data/            # Data sources, repositories, models
│   │   ├── domain/          # Entities, use cases, repository interfaces
│   │   └── presentation/    # Pages, widgets, providers, state
│   │
│   └── ...
│
└── app/                     # Application root
    ├── router/              # GoRouter configuration
    └── macro_tracker_app.dart
```

### Layer Responsibilities

#### Domain Layer (`domain/`)
- Pure business logic
- Entities (domain models)
- Use Cases (interactors)
- Repository interfaces
- **No external dependencies**

#### Data Layer (`data/`)
- Repository implementations
- Data sources (API, local DB)
- DTOs (Data Transfer Objects)
- External service integrations

#### Presentation Layer (`presentation/`)
- UI components (pages, widgets)
- State management (Riverpod providers)
- User interaction handling

## 🛠️ Technology Stack

| Category | Technology |
|----------|------------|
| **Framework** | Flutter (latest stable) |
| **State Management** | Riverpod |
| **Navigation** | GoRouter |
| **Backend** | Supabase (planned) |
| **Database** | PostgreSQL via Supabase (planned) |
| **Networking** | Dio |
| **JSON Serialization** | json_serializable |
| **Environment Variables** | flutter_dotenv |
| **Charts** | fl_chart (planned) |
| **Linting** | flutter_lints |

## 📁 Supported Platforms

- ✅ Android
- ✅ Windows
- ✅ Web
- ✅ Linux
- ⏳ iOS (future, minimal changes required)

## 🚀 Getting Started

### Prerequisites

- Flutter SDK >= 3.2.0
- Dart >= 3.2.0
- Android Studio / VS Code
- A code editor of your choice

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd macro_tracker
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure environment variables**
   ```bash
   cp .env.example .env
   ```
   
   Edit `.env` with your configuration (for future Supabase integration).

4. **Run code generation** (if using freezed/json_serializable)
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

5. **Run the application**
   ```bash
   # For the current platform
   flutter run
   
   # For specific platforms
   flutter run -d windows
   flutter run -d chrome
   flutter run -d android
   ```

## 🎨 Design System

The app includes a comprehensive design system located in `lib/core/theme/`:

### Colors
- Dark mode only palette
- Nothing OS inspired surface colors
- Consistent semantic color naming

### Typography
- Inter font family (via Google Fonts)
- Comprehensive text styles for all use cases
- Tabular figures for numeric displays

### Spacing
- 8-point grid system
- Consistent padding and margins
- Predefined spacing constants

### Components
- `AppCard` - Reusable card with consistent styling
- `AppButton` - Multi-variant button component
- `AppTextField` - Styled text input
- `AppAnimatedSwitcher` - Smooth page transitions

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage
```

## 📝 Code Style

The project uses strict linting rules defined in `analysis_options.yaml`:

- Always declare return types
- Avoid print statements in production
- Prefer const constructors
- Use meaningful names
- Single responsibility per class
- No deprecated APIs

Run the analyzer:
```bash
flutter analyze
```

## 🔮 Future Features

The following features are planned but not yet implemented:

- [ ] Meal tracking with barcode scanning
- [ ] Food database integration
- [ ] Advanced analytics and charts
- [ ] AI-powered meal suggestions
- [ ] Supabase backend integration
- [ ] User authentication
- [ ] Cloud sync
- [ ] Custom macro goals
- [ ] Recipe builder
- [ ] Meal planning

## 🤝 Contributing

Contributions are welcome! Please follow these guidelines:

1. Fork the repository
2. Create a feature branch
3. Follow the existing code style
4. Write tests for new features
5. Submit a pull request

## 📄 License

[License information to be added]

## 🙏 Acknowledgments

- Design inspiration: Nothing OS
- Font: Inter by Rasmus Andersson
- Icons: Material Design Icons

---

**Built with ❤️ for fitness enthusiasts**