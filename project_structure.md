# Project Structure

- 📁 **app**
  - 📄 `app\macro_tracker_app.dart`
      <details>
        <summary>Imports</summary>

        - `../app/router/app_router.dart`
        - `../core/theme/app_theme.dart`
        - `package:flutter/material.dart`
        - `package:flutter_riverpod/flutter_riverpod.dart`
      </details>

  - 📁 **router**
    - 📄 `app\router\app_router.dart`
        <details>
          <summary>Imports</summary>

          - `../../features/analytics/presentation/pages/analytics_page.dart`
          - `../../features/coach/presentation/pages/coach_page.dart`
          - `../../features/dashboard/presentation/pages/dashboard_page.dart`
          - `../../features/home/presentation/pages/error_page.dart`
          - `../../features/home/presentation/pages/home_page.dart`
          - `../../features/log/presentation/pages/log_page.dart`
          - `../../features/profile/presentation/pages/profile_page.dart`
          - `../../features/settings/presentation/pages/settings_page.dart`
          - `package:flutter/material.dart`
          - `package:go_router/go_router.dart`
        </details>

- 📁 **core**
  - 📁 **constants**
    - 📄 `core\constants\app_border_radius.dart`
    - 📄 `core\constants\app_colors.dart`
        <details>
          <summary>Imports</summary>

          - `package:flutter/material.dart`
        </details>

    - 📄 `core\constants\app_durations.dart`
        <details>
          <summary>Imports</summary>

          - `package:flutter/material.dart`
        </details>

    - 📄 `core\constants\app_spacing.dart`
    - 📄 `core\constants\app_typography.dart`
        <details>
          <summary>Imports</summary>

          - `app_colors.dart`
          - `package:flutter/material.dart`
          - `package:google_fonts/google_fonts.dart`
        </details>

    - 📄 `core\constants\constants.dart`
  - 📁 **providers**
    - 📄 `core\providers\app_providers.dart`
        <details>
          <summary>Imports</summary>

          - `package:flutter_riverpod/flutter_riverpod.dart`
        </details>

    - 📄 `core\providers\providers.dart`
        <details>
          <summary>Imports</summary>

          - `package:flutter_riverpod/flutter_riverpod.dart`
        </details>

  - 📁 **theme**
    - 📄 `core\theme\app_text_styles.dart`
        <details>
          <summary>Imports</summary>

          - `../constants/app_colors.dart`
          - `package:flutter/material.dart`
          - `package:google_fonts/google_fonts.dart`
        </details>

    - 📄 `core\theme\app_theme.dart`
        <details>
          <summary>Imports</summary>

          - `../constants/app_border_radius.dart`
          - `../constants/app_colors.dart`
          - `../constants/app_spacing.dart`
          - `app_text_styles.dart`
          - `package:flutter/cupertino.dart`
          - `package:flutter/material.dart`
        </details>

    - 📄 `core\theme\theme.dart`
  - 📁 **widgets**
    - 📄 `core\widgets\animated_list_item.dart`
        <details>
          <summary>Imports</summary>

          - `../constants/app_durations.dart`
          - `package:flutter/material.dart`
        </details>

    - 📄 `core\widgets\animated_metric_ring.dart`
        <details>
          <summary>Imports</summary>

          - `../constants/app_colors.dart`
          - `../constants/app_durations.dart`
          - `dart:math`
          - `package:flutter/material.dart`
        </details>

    - 📄 `core\widgets\app_animated_switcher.dart`
        <details>
          <summary>Imports</summary>

          - `package:flutter/material.dart`
        </details>

    - 📄 `core\widgets\app_button.dart`
        <details>
          <summary>Imports</summary>

          - `../constants/app_border_radius.dart`
          - `../constants/app_colors.dart`
          - `../constants/app_durations.dart`
          - `../constants/app_spacing.dart`
          - `package:flutter/material.dart`
        </details>

    - 📄 `core\widgets\app_card.dart`
        <details>
          <summary>Imports</summary>

          - `../constants/app_colors.dart`
          - `../constants/app_durations.dart`
          - `../constants/app_spacing.dart`
          - `package:flutter/material.dart`
        </details>

    - 📄 `core\widgets\app_glass_container.dart`
        <details>
          <summary>Imports</summary>

          - `../constants/app_border_radius.dart`
          - `../constants/app_colors.dart`
          - `dart:ui`
          - `package:flutter/material.dart`
        </details>

    - 📄 `core\widgets\app_text_field.dart`
        <details>
          <summary>Imports</summary>

          - `../constants/app_border_radius.dart`
          - `../constants/app_colors.dart`
          - `../constants/app_spacing.dart`
          - `../theme/app_text_styles.dart`
          - `package:flutter/material.dart`
        </details>

    - 📄 `core\widgets\widgets.dart`
- 📁 **features**
  - 📁 **analytics**
    - 📁 **presentation**
      - 📁 **pages**
        - 📄 `features\analytics\presentation\pages\analytics_page.dart`
            <details>
              <summary>Imports</summary>

              - `../../../../core/constants/app_spacing.dart`
              - `package:flutter/material.dart`
            </details>

  - 📁 **coach**
    - 📁 **presentation**
      - 📁 **pages**
        - 📄 `features\coach\presentation\pages\coach_page.dart`
            <details>
              <summary>Imports</summary>

              - `../../../../core/constants/app_spacing.dart`
              - `package:flutter/material.dart`
            </details>

  - 📁 **dashboard**
    - 📁 **presentation**
      - 📁 **pages**
        - 📄 `features\dashboard\presentation\pages\dashboard_page.dart`
            <details>
              <summary>Imports</summary>

              - `../../../../core/constants/app_colors.dart`
              - `../../../../core/constants/app_spacing.dart`
              - `package:flutter/material.dart`
            </details>

  - 📁 **home**
    - 📁 **presentation**
      - 📁 **pages**
        - 📄 `features\home\presentation\pages\error_page.dart`
            <details>
              <summary>Imports</summary>

              - `package:flutter/material.dart`
            </details>

        - 📄 `features\home\presentation\pages\home_page.dart`
            <details>
              <summary>Imports</summary>

              - `../../../../core/constants/app_colors.dart`
              - `../../../../core/constants/app_durations.dart`
              - `../../../../core/constants/app_spacing.dart`
              - `../../../../core/theme/app_text_styles.dart`
              - `../../../../core/widgets/app_glass_container.dart`
              - `package:flutter/cupertino.dart`
              - `package:flutter/material.dart`
              - `package:go_router/go_router.dart`
            </details>

  - 📁 **log**
    - 📁 **presentation**
      - 📁 **pages**
        - 📄 `features\log\presentation\pages\log_page.dart`
            <details>
              <summary>Imports</summary>

              - `../../../../core/constants/app_spacing.dart`
              - `package:flutter/material.dart`
            </details>

  - 📁 **profile**
    - 📁 **presentation**
      - 📁 **pages**
        - 📄 `features\profile\presentation\pages\profile_page.dart`
            <details>
              <summary>Imports</summary>

              - `../../../../core/constants/app_spacing.dart`
              - `package:flutter/material.dart`
            </details>

  - 📁 **settings**
    - 📁 **presentation**
      - 📁 **pages**
        - 📄 `features\settings\presentation\pages\settings_page.dart`
            <details>
              <summary>Imports</summary>

              - `../../../../core/constants/app_spacing.dart`
              - `package:flutter/material.dart`
            </details>

- 📄 `main.dart`
    <details>
      <summary>Imports</summary>

      - `app/macro_tracker_app.dart`
      - `core/providers/providers.dart`
      - `package:flutter/material.dart`
      - `package:flutter_riverpod/flutter_riverpod.dart`
    </details>

- 📁 **shared**
  - 📁 **domain**
    - 📄 `shared\domain\domain.dart`
    - 📄 `shared\domain\entity.dart`
        <details>
          <summary>Imports</summary>

          - `package:equatable/equatable.dart`
        </details>

    - 📄 `shared\domain\failure.dart`
  - 📁 **extensions**
    - 📄 `shared\extensions\build_context_extensions.dart`
        <details>
          <summary>Imports</summary>

          - `package:flutter/material.dart`
        </details>

    - 📄 `shared\extensions\extensions.dart`

## Project Type

- **Project Type:** monorepo
- **Indicators:**
  - Found 5 pubspec.yaml files (monorepo indicator)
  - Found `flutter` key in pubspec.yaml


## Detected Frameworks

| Framework | In pubspec | Files using it |
|-----------|-----------|----------------|
| Riverpod | Yes | 4 |
| GoRouter | Yes | 2 |
| Dio | Yes | 0 |
| Freezed | Yes | 0 |


## Architecture

### Detected Layers

- **Widget** (8 files)
- **Page** (8 files)
- **Domain** (3 files)
- **Provider** (2 files)

### Entry Points

- `lib\lib\main.dart`

### Layer Dependencies

- Page → Core



## Project Statistics

- Total Files: 35
- Dart Files: 35
- Total Lines of Dart Code: 3075
- Largest File: `lib\theme\app_theme.dart` with 329 lines
- Smallest File: `lib\extensions\extensions.dart` with 2 lines


## TODO and FIXME Comments

No TODO or FIXME comments found.

## Dependency Analysis

Package: flutter
Used in:
  - lib\app\macro_tracker_app.dart
  - lib\router\app_router.dart
  - lib\constants\app_colors.dart
  - lib\constants\app_durations.dart
  - lib\constants\app_typography.dart
  - lib\theme\app_text_styles.dart
  - lib\theme\app_theme.dart
  - lib\widgets\animated_list_item.dart
  - lib\widgets\animated_metric_ring.dart
  - lib\widgets\app_animated_switcher.dart
  - lib\widgets\app_button.dart
  - lib\widgets\app_card.dart
  - lib\widgets\app_glass_container.dart
  - lib\widgets\app_text_field.dart
  - lib\pages\analytics_page.dart
  - lib\pages\coach_page.dart
  - lib\pages\dashboard_page.dart
  - lib\pages\error_page.dart
  - lib\pages\home_page.dart
  - lib\pages\log_page.dart
  - lib\pages\profile_page.dart
  - lib\pages\settings_page.dart
  - lib\lib\main.dart
  - lib\extensions\build_context_extensions.dart

Package: flutter_riverpod
Used in:
  - lib\app\macro_tracker_app.dart
  - lib\providers\app_providers.dart
  - lib\providers\providers.dart
  - lib\lib\main.dart

Package: go_router
Used in:
  - lib\router\app_router.dart
  - lib\pages\home_page.dart

Package: google_fonts
Used in:
  - lib\constants\app_typography.dart
  - lib\theme\app_text_styles.dart

Package: equatable
Used in:
  - lib\domain\entity.dart



## Code Metrics

File: lib\app\macro_tracker_app.dart
  Lines of Code: 45
  Classes: 1
  Methods: 1
  Comment Lines: 6
  Comment Ratio: 13.33%

File: lib\router\app_router.dart
  Lines of Code: 117
  Classes: 2
  Methods: 0
  Comment Lines: 5
  Comment Ratio: 4.27%

File: lib\constants\app_border_radius.dart
  Lines of Code: 53
  Classes: 1
  Methods: 0
  Comment Lines: 18
  Comment Ratio: 33.96%

File: lib\constants\app_colors.dart
  Lines of Code: 104
  Classes: 1
  Methods: 0
  Comment Lines: 28
  Comment Ratio: 26.92%

File: lib\constants\app_durations.dart
  Lines of Code: 62
  Classes: 2
  Methods: 1
  Comment Lines: 16
  Comment Ratio: 25.81%

File: lib\constants\app_spacing.dart
  Lines of Code: 63
  Classes: 1
  Methods: 0
  Comment Lines: 19
  Comment Ratio: 30.16%

File: lib\constants\app_typography.dart
  Lines of Code: 135
  Classes: 1
  Methods: 1
  Comment Lines: 9
  Comment Ratio: 6.67%

File: lib\constants\constants.dart
  Lines of Code: 7
  Classes: 0
  Methods: 0
  Comment Lines: 0
  Comment Ratio: 0.00%

File: lib\providers\app_providers.dart
  Lines of Code: 21
  Classes: 0
  Methods: 0
  Comment Lines: 6
  Comment Ratio: 28.57%

File: lib\providers\providers.dart
  Lines of Code: 25
  Classes: 1
  Methods: 2
  Comment Lines: 1
  Comment Ratio: 4.00%

File: lib\theme\app_text_styles.dart
  Lines of Code: 172
  Classes: 1
  Methods: 19
  Comment Lines: 8
  Comment Ratio: 4.65%

File: lib\theme\app_theme.dart
  Lines of Code: 330
  Classes: 1
  Methods: 2
  Comment Lines: 6
  Comment Ratio: 1.82%

File: lib\theme\theme.dart
  Lines of Code: 4
  Classes: 0
  Methods: 0
  Comment Lines: 0
  Comment Ratio: 0.00%

File: lib\widgets\animated_list_item.dart
  Lines of Code: 91
  Classes: 2
  Methods: 5
  Comment Lines: 6
  Comment Ratio: 6.59%

File: lib\widgets\animated_metric_ring.dart
  Lines of Code: 198
  Classes: 3
  Methods: 7
  Comment Lines: 10
  Comment Ratio: 5.05%

File: lib\widgets\app_animated_switcher.dart
  Lines of Code: 38
  Classes: 1
  Methods: 1
  Comment Lines: 1
  Comment Ratio: 2.63%

File: lib\widgets\app_button.dart
  Lines of Code: 239
  Classes: 2
  Methods: 11
  Comment Lines: 3
  Comment Ratio: 1.26%

File: lib\widgets\app_card.dart
  Lines of Code: 142
  Classes: 2
  Methods: 7
  Comment Lines: 3
  Comment Ratio: 2.11%

File: lib\widgets\app_glass_container.dart
  Lines of Code: 61
  Classes: 1
  Methods: 1
  Comment Lines: 4
  Comment Ratio: 6.56%

File: lib\widgets\app_text_field.dart
  Lines of Code: 83
  Classes: 1
  Methods: 1
  Comment Lines: 1
  Comment Ratio: 1.20%

File: lib\widgets\widgets.dart
  Lines of Code: 9
  Classes: 0
  Methods: 0
  Comment Lines: 0
  Comment Ratio: 0.00%

File: lib\pages\analytics_page.dart
  Lines of Code: 67
  Classes: 1
  Methods: 1
  Comment Lines: 9
  Comment Ratio: 13.43%

File: lib\pages\coach_page.dart
  Lines of Code: 66
  Classes: 1
  Methods: 1
  Comment Lines: 8
  Comment Ratio: 12.12%

File: lib\pages\dashboard_page.dart
  Lines of Code: 265
  Classes: 3
  Methods: 7
  Comment Lines: 7
  Comment Ratio: 2.64%

File: lib\pages\error_page.dart
  Lines of Code: 32
  Classes: 1
  Methods: 1
  Comment Lines: 1
  Comment Ratio: 3.13%

File: lib\pages\home_page.dart
  Lines of Code: 164
  Classes: 3
  Methods: 4
  Comment Lines: 6
  Comment Ratio: 3.66%

File: lib\pages\log_page.dart
  Lines of Code: 67
  Classes: 1
  Methods: 1
  Comment Lines: 9
  Comment Ratio: 13.43%

File: lib\pages\profile_page.dart
  Lines of Code: 67
  Classes: 1
  Methods: 1
  Comment Lines: 9
  Comment Ratio: 13.43%

File: lib\pages\settings_page.dart
  Lines of Code: 211
  Classes: 3
  Methods: 3
  Comment Lines: 9
  Comment Ratio: 4.27%

File: lib\lib\main.dart
  Lines of Code: 22
  Classes: 0
  Methods: 0
  Comment Lines: 0
  Comment Ratio: 0.00%

File: lib\domain\domain.dart
  Lines of Code: 4
  Classes: 0
  Methods: 0
  Comment Lines: 0
  Comment Ratio: 0.00%

File: lib\domain\entity.dart
  Lines of Code: 19
  Classes: 1
  Methods: 3
  Comment Lines: 5
  Comment Ratio: 26.32%

File: lib\domain\failure.dart
  Lines of Code: 74
  Classes: 8
  Methods: 1
  Comment Lines: 10
  Comment Ratio: 13.51%

File: lib\extensions\build_context_extensions.dart
  Lines of Code: 50
  Classes: 0
  Methods: 12
  Comment Lines: 13
  Comment Ratio: 26.00%

File: lib\extensions\extensions.dart
  Lines of Code: 3
  Classes: 0
  Methods: 0
  Comment Lines: 0
  Comment Ratio: 0.00%



## Naming Conventions

- Files following suffix convention: 8/35 (22.9%)

### File Naming Conventions

| Suffix | Count |
|--------|-------|
| `_page` | 8 |

### Class Naming Conventions

| Suffix | Count |
|--------|-------|
| `Page` | 8 |
| `State` | 4 |



## File Purposes

### Purpose Summary

| Purpose | Count |
|---------|-------|
| other | 18 |
| widget | 16 |
| entry_point | 1 |

### File Details

- `lib\app\macro_tracker_app.dart` → other
- `lib\constants\app_border_radius.dart` → other
- `lib\constants\app_colors.dart` → other
- `lib\constants\app_durations.dart` → other
- `lib\constants\app_spacing.dart` → other
- `lib\constants\app_typography.dart` → other
- `lib\constants\constants.dart` → other
- `lib\domain\domain.dart` → other
- `lib\domain\entity.dart` → other
- `lib\domain\failure.dart` → other
- `lib\extensions\build_context_extensions.dart` → other
- `lib\extensions\extensions.dart` → other
- `lib\lib\main.dart` → entry_point
- `lib\pages\analytics_page.dart` → widget
- `lib\pages\coach_page.dart` → widget
- `lib\pages\dashboard_page.dart` → widget
- `lib\pages\error_page.dart` → widget
- `lib\pages\home_page.dart` → widget
- `lib\pages\log_page.dart` → widget
- `lib\pages\profile_page.dart` → widget
- `lib\pages\settings_page.dart` → widget
- `lib\providers\app_providers.dart` → other
- `lib\providers\providers.dart` → other
- `lib\router\app_router.dart` → other
- `lib\theme\app_text_styles.dart` → other
- `lib\theme\app_theme.dart` → other
- `lib\theme\theme.dart` → other
- `lib\widgets\animated_list_item.dart` → widget
- `lib\widgets\animated_metric_ring.dart` → widget
- `lib\widgets\app_animated_switcher.dart` → widget
- `lib\widgets\app_button.dart` → widget
- `lib\widgets\app_card.dart` → widget
- `lib\widgets\app_glass_container.dart` → widget
- `lib\widgets\app_text_field.dart` → widget
- `lib\widgets\widgets.dart` → widget



## Aggregated Metrics

- Total Classes: 47
- Total Methods: 94
- Average LOC per file: 88.9
- Average Comment Ratio: 7.6%
- Files without comments: 6

### Largest Files (Top 5)

1. `lib\theme\app_theme.dart` - 330 lines
2. `lib\pages\dashboard_page.dart` - 265 lines
3. `lib\widgets\app_button.dart` - 239 lines
4. `lib\pages\settings_page.dart` - 211 lines
5. `lib\widgets\animated_metric_ring.dart` - 198 lines


