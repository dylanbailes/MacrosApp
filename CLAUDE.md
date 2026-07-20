# Project Context

## Overview

- **Type:** monorepo
- **Tech Stack:** Riverpod, GoRouter, Dio, Freezed
- **Entry Points:** lib\lib\main.dart

## Architecture

### Layers

- Page (8 files)
- Widget (5 files)
- Domain (3 files)
- Provider (2 files)

### Layer Dependencies

- Page → Core

## Directory Structure

```
lib/
  app/
    router/
      app_router.dart
    macro_tracker_app.dart
  core/
    constants/
      app_border_radius.dart
      app_colors.dart
      app_durations.dart
      app_spacing.dart
      app_typography.dart
      constants.dart
    providers/
      app_providers.dart
      providers.dart
    theme/
      app_text_styles.dart
      app_theme.dart
      theme.dart
    widgets/
      app_animated_switcher.dart
      app_button.dart
      app_card.dart
      app_text_field.dart
      widgets.dart
  features/
    analytics/
      presentation/
    coach/
      presentation/
    dashboard/
      presentation/
    home/
      presentation/
    log/
      presentation/
    profile/
      presentation/
    settings/
      presentation/
  shared/
    domain/
      domain.dart
      entity.dart
      failure.dart
    extensions/
      build_context_extensions.dart
      extensions.dart
  main.dart
```

## Conventions

- File naming: snake_case with suffixes (_page)
- Class naming: PascalCase with suffixes (Page)
- File purposes: other (18), widget (13), entry_point (1)

## Dependencies

- flutter: 22 files
- flutter_riverpod: 4 files
- go_router: 2 files
- google_fonts: 2 files
- equatable: 1 file

## Code Health

- 32 files, 2714 lines of Dart code
- 37 classes, 66 methods
- Average 85.8 LOC/file, 8.4% comment ratio
- 6 files without comments

### Technical Debt

- Largest files: app_theme.dart (439), dashboard_page.dart (265), app_button.dart (220), settings_page.dart (211), app_text_styles.dart (168)

