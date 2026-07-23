# Project Context

## Overview

- **Type:** monorepo
- **Tech Stack:** Riverpod, GoRouter, Dio, Freezed
- **Entry Points:** lib\lib\main.dart

## Architecture

### Layers

- Widget (39 files)
- Page (8 files)
- Provider (4 files)
- Domain (3 files)

### Layer Dependencies

- Page → Core, Provider, Widget
- Widget → Core, Provider

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
      animated_list_item.dart
      animated_metric_ring.dart
      app_animated_counter.dart
      app_animated_switcher.dart
      app_bottom_nav_bar.dart
      app_button.dart
      app_card.dart
      app_glass_container.dart
      app_interactive_card.dart
      app_metric_tile.dart
      app_progress_ring.dart
      app_section_header.dart
      app_skeleton.dart
      app_stat_display.dart
      app_surface.dart
      app_text_field.dart
      app_toast.dart
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

- File naming: snake_case with suffixes (_page, _provider, _state)
- Class naming: PascalCase with suffixes (State, Page)
- File purposes: widget (47), other (18), provider (1), state (1), entry_point (1)

## Dependencies

- flutter: 57 files
- flutter_riverpod: 7 files
- go_router: 5 files
- fl_chart: 5 files
- google_fonts: 1 file
- equatable: 1 file

## Code Health

- 68 files, 8534 lines of Dart code
- 123 classes, 237 methods
- Average 125.9 LOC/file, 6.3% comment ratio
- 5 files without comments

### Technical Debt

- Largest files: log_page.dart (398), app_theme.dart (352), app_bottom_nav_bar.dart (307), app_text_styles.dart (293), app_button.dart (278)

