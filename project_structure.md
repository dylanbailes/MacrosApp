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

    - 📄 `core\widgets\app_animated_counter.dart`
        <details>
          <summary>Imports</summary>

          - `package:flutter/material.dart`
        </details>

    - 📄 `core\widgets\app_animated_switcher.dart`
        <details>
          <summary>Imports</summary>

          - `package:flutter/material.dart`
        </details>

    - 📄 `core\widgets\app_bottom_nav_bar.dart`
        <details>
          <summary>Imports</summary>

          - `../constants/app_colors.dart`
          - `../constants/app_durations.dart`
          - `../constants/app_spacing.dart`
          - `dart:ui`
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

          - `../constants/app_border_radius.dart`
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

    - 📄 `core\widgets\app_interactive_card.dart`
        <details>
          <summary>Imports</summary>

          - `../constants/app_border_radius.dart`
          - `../constants/app_colors.dart`
          - `../constants/app_durations.dart`
          - `app_surface.dart`
          - `package:flutter/material.dart`
        </details>

    - 📄 `core\widgets\app_metric_tile.dart`
        <details>
          <summary>Imports</summary>

          - `../constants/app_border_radius.dart`
          - `../constants/app_colors.dart`
          - `../constants/app_spacing.dart`
          - `../theme/app_text_styles.dart`
          - `package:flutter/material.dart`
        </details>

    - 📄 `core\widgets\app_progress_ring.dart`
        <details>
          <summary>Imports</summary>

          - `../constants/app_colors.dart`
          - `dart:math`
          - `package:flutter/material.dart`
        </details>

    - 📄 `core\widgets\app_section_header.dart`
        <details>
          <summary>Imports</summary>

          - `../theme/app_text_styles.dart`
          - `package:flutter/material.dart`
        </details>

    - 📄 `core\widgets\app_skeleton.dart`
        <details>
          <summary>Imports</summary>

          - `../constants/app_border_radius.dart`
          - `../constants/app_colors.dart`
          - `package:flutter/material.dart`
        </details>

    - 📄 `core\widgets\app_stat_display.dart`
        <details>
          <summary>Imports</summary>

          - `../constants/app_colors.dart`
          - `../constants/app_spacing.dart`
          - `../theme/app_text_styles.dart`
          - `package:flutter/material.dart`
        </details>

    - 📄 `core\widgets\app_surface.dart`
        <details>
          <summary>Imports</summary>

          - `../constants/app_border_radius.dart`
          - `../constants/app_colors.dart`
          - `package:flutter/material.dart`
        </details>

    - 📄 `core\widgets\app_text_field.dart`
        <details>
          <summary>Imports</summary>

          - `../constants/app_colors.dart`
          - `../constants/app_spacing.dart`
          - `../theme/app_text_styles.dart`
          - `package:flutter/material.dart`
        </details>

    - 📄 `core\widgets\app_toast.dart`
        <details>
          <summary>Imports</summary>

          - `../constants/app_border_radius.dart`
          - `../constants/app_colors.dart`
          - `../constants/app_spacing.dart`
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

              - `../../../../core/constants/app_border_radius.dart`
              - `../../../../core/constants/app_colors.dart`
              - `../../../../core/constants/app_spacing.dart`
              - `../../../../core/widgets/app_skeleton.dart`
              - `../providers/dashboard_provider.dart`
              - `../providers/dashboard_state.dart`
              - `../widgets/ai_coach_entry_card.dart`
              - `../widgets/analytics_hero_section.dart`
              - `../widgets/dashboard_header.dart`
              - `../widgets/dashboard_stats_section.dart`
              - `../widgets/macro_overview_row.dart`
              - `../widgets/quick_actions_row.dart`
              - `../widgets/recent_meals_list.dart`
              - `package:flutter/material.dart`
              - `package:flutter_riverpod/flutter_riverpod.dart`
              - `package:go_router/go_router.dart`
            </details>

      - 📁 **providers**
        - 📄 `features\dashboard\presentation\providers\dashboard_provider.dart`
            <details>
              <summary>Imports</summary>

              - `dart:async`
              - `dashboard_state.dart`
              - `package:flutter/material.dart`
              - `package:flutter_riverpod/flutter_riverpod.dart`
            </details>

        - 📄 `features\dashboard\presentation\providers\dashboard_state.dart`
            <details>
              <summary>Imports</summary>

              - `package:flutter/material.dart`
            </details>

      - 📁 **widgets**
        - 📄 `features\dashboard\presentation\widgets\ai_coach_entry_card.dart`
            <details>
              <summary>Imports</summary>

              - `../../../../core/constants/app_border_radius.dart`
              - `../../../../core/constants/app_colors.dart`
              - `../../../../core/constants/app_spacing.dart`
              - `../../../../core/theme/app_text_styles.dart`
              - `../../../../core/widgets/app_card.dart`
              - `package:flutter/material.dart`
              - `package:go_router/go_router.dart`
            </details>

        - 📄 `features\dashboard\presentation\widgets\analytics_hero_section.dart`
            <details>
              <summary>Imports</summary>

              - `../../../../core/constants/app_colors.dart`
              - `../../../../core/constants/app_spacing.dart`
              - `../../../../core/theme/app_text_styles.dart`
              - `../../../../core/widgets/app_animated_counter.dart`
              - `../../../../core/widgets/app_card.dart`
              - `../../../../core/widgets/app_progress_ring.dart`
              - `../providers/dashboard_state.dart`
              - `package:flutter/material.dart`
              - `weekly_overview_chart.dart`
            </details>

        - 📄 `features\dashboard\presentation\widgets\avg_calories_card.dart`
            <details>
              <summary>Imports</summary>

              - `../../../../core/constants/app_border_radius.dart`
              - `../../../../core/constants/app_colors.dart`
              - `../../../../core/constants/app_spacing.dart`
              - `../../../../core/theme/app_text_styles.dart`
              - `../../../../core/widgets/app_interactive_card.dart`
              - `package:fl_chart/fl_chart.dart`
              - `package:flutter/material.dart`
            </details>

        - 📄 `features\dashboard\presentation\widgets\calorie_hero_card.dart`
            <details>
              <summary>Imports</summary>

              - `../../../../core/constants/app_colors.dart`
              - `../../../../core/constants/app_spacing.dart`
              - `../../../../core/theme/app_text_styles.dart`
              - `../../../../core/widgets/app_animated_counter.dart`
              - `../../../../core/widgets/app_card.dart`
              - `../../../../core/widgets/app_progress_ring.dart`
              - `package:flutter/material.dart`
            </details>

        - 📄 `features\dashboard\presentation\widgets\dashboard_header.dart`
            <details>
              <summary>Imports</summary>

              - `../../../../core/constants/app_colors.dart`
              - `../../../../core/constants/app_spacing.dart`
              - `../../../../core/theme/app_text_styles.dart`
              - `package:flutter/material.dart`
              - `package:go_router/go_router.dart`
            </details>

        - 📄 `features\dashboard\presentation\widgets\dashboard_stats_section.dart`
            <details>
              <summary>Imports</summary>

              - `../../../../core/constants/app_spacing.dart`
              - `../../../../core/widgets/app_section_header.dart`
              - `../providers/dashboard_state.dart`
              - `avg_calories_card.dart`
              - `goal_completion_card.dart`
              - `package:flutter/material.dart`
              - `protein_avg_card.dart`
              - `streak_card.dart`
              - `water_card.dart`
              - `weekly_calories_chart.dart`
              - `weekly_macros_chart.dart`
              - `weight_trend_card.dart`
            </details>

        - 📄 `features\dashboard\presentation\widgets\goal_completion_card.dart`
            <details>
              <summary>Imports</summary>

              - `../../../../core/constants/app_border_radius.dart`
              - `../../../../core/constants/app_colors.dart`
              - `../../../../core/constants/app_spacing.dart`
              - `../../../../core/theme/app_text_styles.dart`
              - `../../../../core/widgets/app_interactive_card.dart`
              - `dart:math`
              - `package:flutter/material.dart`
            </details>

        - 📄 `features\dashboard\presentation\widgets\macro_overview_row.dart`
            <details>
              <summary>Imports</summary>

              - `../../../../core/constants/app_colors.dart`
              - `../../../../core/constants/app_spacing.dart`
              - `../../../../core/theme/app_text_styles.dart`
              - `../../../../core/widgets/app_metric_tile.dart`
              - `../providers/dashboard_state.dart`
              - `package:flutter/material.dart`
            </details>

        - 📄 `features\dashboard\presentation\widgets\protein_avg_card.dart`
            <details>
              <summary>Imports</summary>

              - `../../../../core/constants/app_border_radius.dart`
              - `../../../../core/constants/app_colors.dart`
              - `../../../../core/constants/app_spacing.dart`
              - `../../../../core/theme/app_text_styles.dart`
              - `../../../../core/widgets/app_interactive_card.dart`
              - `../providers/dashboard_state.dart`
              - `package:fl_chart/fl_chart.dart`
              - `package:flutter/material.dart`
            </details>

        - 📄 `features\dashboard\presentation\widgets\quick_actions_row.dart`
            <details>
              <summary>Imports</summary>

              - `../../../../core/constants/app_spacing.dart`
              - `../../../../core/widgets/app_button.dart`
              - `package:flutter/material.dart`
            </details>

        - 📄 `features\dashboard\presentation\widgets\recent_meals_list.dart`
            <details>
              <summary>Imports</summary>

              - `../../../../core/constants/app_border_radius.dart`
              - `../../../../core/constants/app_colors.dart`
              - `../../../../core/constants/app_spacing.dart`
              - `../../../../core/theme/app_text_styles.dart`
              - `../../../../core/widgets/app_card.dart`
              - `../providers/dashboard_state.dart`
              - `package:flutter/material.dart`
            </details>

        - 📄 `features\dashboard\presentation\widgets\streak_card.dart`
            <details>
              <summary>Imports</summary>

              - `../../../../core/constants/app_border_radius.dart`
              - `../../../../core/constants/app_colors.dart`
              - `../../../../core/constants/app_spacing.dart`
              - `../../../../core/theme/app_text_styles.dart`
              - `../../../../core/widgets/app_interactive_card.dart`
              - `../../../../core/widgets/app_progress_ring.dart`
              - `package:flutter/material.dart`
            </details>

        - 📄 `features\dashboard\presentation\widgets\water_card.dart`
            <details>
              <summary>Imports</summary>

              - `../../../../core/constants/app_border_radius.dart`
              - `../../../../core/constants/app_colors.dart`
              - `../../../../core/constants/app_spacing.dart`
              - `../../../../core/theme/app_text_styles.dart`
              - `../../../../core/widgets/app_interactive_card.dart`
              - `package:flutter/material.dart`
            </details>

        - 📄 `features\dashboard\presentation\widgets\weekly_calories_chart.dart`
            <details>
              <summary>Imports</summary>

              - `../../../../core/constants/app_border_radius.dart`
              - `../../../../core/constants/app_colors.dart`
              - `../../../../core/constants/app_spacing.dart`
              - `../../../../core/theme/app_text_styles.dart`
              - `../../../../core/widgets/app_interactive_card.dart`
              - `../providers/dashboard_state.dart`
              - `package:fl_chart/fl_chart.dart`
              - `package:flutter/material.dart`
              - `package:flutter_riverpod/flutter_riverpod.dart`
            </details>

        - 📄 `features\dashboard\presentation\widgets\weekly_macros_chart.dart`
            <details>
              <summary>Imports</summary>

              - `../../../../core/constants/app_border_radius.dart`
              - `../../../../core/constants/app_colors.dart`
              - `../../../../core/constants/app_spacing.dart`
              - `../../../../core/theme/app_text_styles.dart`
              - `../../../../core/widgets/app_interactive_card.dart`
              - `../providers/dashboard_state.dart`
              - `package:fl_chart/fl_chart.dart`
              - `package:flutter/material.dart`
            </details>

        - 📄 `features\dashboard\presentation\widgets\weekly_overview_chart.dart`
            <details>
              <summary>Imports</summary>

              - `../../../../core/constants/app_colors.dart`
              - `../providers/dashboard_state.dart`
              - `package:flutter/material.dart`
            </details>

        - 📄 `features\dashboard\presentation\widgets\weight_trend_card.dart`
            <details>
              <summary>Imports</summary>

              - `../../../../core/constants/app_border_radius.dart`
              - `../../../../core/constants/app_colors.dart`
              - `../../../../core/constants/app_spacing.dart`
              - `../../../../core/theme/app_text_styles.dart`
              - `../../../../core/widgets/app_interactive_card.dart`
              - `package:fl_chart/fl_chart.dart`
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

              - `../../../../core/constants/app_border_radius.dart`
              - `../../../../core/constants/app_colors.dart`
              - `../../../../core/constants/app_spacing.dart`
              - `../../../../core/theme/app_text_styles.dart`
              - `../widgets/log_day_summary.dart`
              - `../widgets/log_meal_section.dart`
              - `../widgets/log_quick_input_bar.dart`
              - `package:flutter/cupertino.dart`
              - `package:flutter/material.dart`
            </details>

      - 📁 **widgets**
        - 📄 `features\log\presentation\widgets\log_day_summary.dart`
            <details>
              <summary>Imports</summary>

              - `../../../../core/constants/app_border_radius.dart`
              - `../../../../core/constants/app_colors.dart`
              - `../../../../core/constants/app_spacing.dart`
              - `../../../../core/theme/app_text_styles.dart`
              - `package:flutter/material.dart`
            </details>

        - 📄 `features\log\presentation\widgets\log_food_row.dart`
            <details>
              <summary>Imports</summary>

              - `../../../../core/constants/app_border_radius.dart`
              - `../../../../core/constants/app_colors.dart`
              - `../../../../core/constants/app_spacing.dart`
              - `../../../../core/theme/app_text_styles.dart`
              - `package:flutter/material.dart`
            </details>

        - 📄 `features\log\presentation\widgets\log_meal_section.dart`
            <details>
              <summary>Imports</summary>

              - `../../../../core/constants/app_colors.dart`
              - `../../../../core/constants/app_spacing.dart`
              - `../../../../core/theme/app_text_styles.dart`
              - `log_food_row.dart`
              - `package:flutter/material.dart`
            </details>

        - 📄 `features\log\presentation\widgets\log_quick_input_bar.dart`
            <details>
              <summary>Imports</summary>

              - `../../../../core/constants/app_border_radius.dart`
              - `../../../../core/constants/app_colors.dart`
              - `../../../../core/constants/app_spacing.dart`
              - `../../../../core/theme/app_text_styles.dart`
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
| Riverpod | Yes | 7 |
| GoRouter | Yes | 5 |
| Dio | Yes | 0 |
| Freezed | Yes | 0 |


## Architecture

### Detected Layers

- **Widget** (39 files)
- **Page** (8 files)
- **Provider** (4 files)
- **Domain** (3 files)

### Entry Points

- `lib\lib\main.dart`

### Layer Dependencies

- Page → Core, Provider, Widget
- Widget → Core, Provider



## Project Statistics

- Total Files: 68
- Dart Files: 68
- Total Lines of Dart Code: 8534
- Largest File: `lib\pages\log_page.dart` with 398 lines
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
  - lib\widgets\app_animated_counter.dart
  - lib\widgets\app_animated_switcher.dart
  - lib\widgets\app_bottom_nav_bar.dart
  - lib\widgets\app_button.dart
  - lib\widgets\app_card.dart
  - lib\widgets\app_glass_container.dart
  - lib\widgets\app_interactive_card.dart
  - lib\widgets\app_metric_tile.dart
  - lib\widgets\app_progress_ring.dart
  - lib\widgets\app_section_header.dart
  - lib\widgets\app_skeleton.dart
  - lib\widgets\app_stat_display.dart
  - lib\widgets\app_surface.dart
  - lib\widgets\app_text_field.dart
  - lib\widgets\app_toast.dart
  - lib\pages\analytics_page.dart
  - lib\pages\coach_page.dart
  - lib\pages\dashboard_page.dart
  - lib\providers\dashboard_provider.dart
  - lib\providers\dashboard_state.dart
  - lib\widgets\ai_coach_entry_card.dart
  - lib\widgets\analytics_hero_section.dart
  - lib\widgets\avg_calories_card.dart
  - lib\widgets\calorie_hero_card.dart
  - lib\widgets\dashboard_header.dart
  - lib\widgets\dashboard_stats_section.dart
  - lib\widgets\goal_completion_card.dart
  - lib\widgets\macro_overview_row.dart
  - lib\widgets\protein_avg_card.dart
  - lib\widgets\quick_actions_row.dart
  - lib\widgets\recent_meals_list.dart
  - lib\widgets\streak_card.dart
  - lib\widgets\water_card.dart
  - lib\widgets\weekly_calories_chart.dart
  - lib\widgets\weekly_macros_chart.dart
  - lib\widgets\weekly_overview_chart.dart
  - lib\widgets\weight_trend_card.dart
  - lib\pages\error_page.dart
  - lib\pages\home_page.dart
  - lib\pages\log_page.dart
  - lib\widgets\log_day_summary.dart
  - lib\widgets\log_food_row.dart
  - lib\widgets\log_meal_section.dart
  - lib\widgets\log_quick_input_bar.dart
  - lib\pages\profile_page.dart
  - lib\pages\settings_page.dart
  - lib\lib\main.dart
  - lib\extensions\build_context_extensions.dart

Package: flutter_riverpod
Used in:
  - lib\app\macro_tracker_app.dart
  - lib\providers\app_providers.dart
  - lib\providers\providers.dart
  - lib\pages\dashboard_page.dart
  - lib\providers\dashboard_provider.dart
  - lib\widgets\weekly_calories_chart.dart
  - lib\lib\main.dart

Package: go_router
Used in:
  - lib\router\app_router.dart
  - lib\pages\dashboard_page.dart
  - lib\widgets\ai_coach_entry_card.dart
  - lib\widgets\dashboard_header.dart
  - lib\pages\home_page.dart

Package: google_fonts
Used in:
  - lib\constants\app_typography.dart

Package: fl_chart
Used in:
  - lib\widgets\avg_calories_card.dart
  - lib\widgets\protein_avg_card.dart
  - lib\widgets\weekly_calories_chart.dart
  - lib\widgets\weekly_macros_chart.dart
  - lib\widgets\weight_trend_card.dart

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
  Lines of Code: 47
  Classes: 1
  Methods: 0
  Comment Lines: 17
  Comment Ratio: 36.17%

File: lib\constants\app_colors.dart
  Lines of Code: 110
  Classes: 1
  Methods: 0
  Comment Lines: 35
  Comment Ratio: 31.82%

File: lib\constants\app_durations.dart
  Lines of Code: 62
  Classes: 2
  Methods: 1
  Comment Lines: 16
  Comment Ratio: 25.81%

File: lib\constants\app_spacing.dart
  Lines of Code: 66
  Classes: 1
  Methods: 0
  Comment Lines: 20
  Comment Ratio: 30.30%

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
  Lines of Code: 293
  Classes: 1
  Methods: 25
  Comment Lines: 34
  Comment Ratio: 11.60%

File: lib\theme\app_theme.dart
  Lines of Code: 352
  Classes: 1
  Methods: 2
  Comment Lines: 10
  Comment Ratio: 2.84%

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

File: lib\widgets\app_animated_counter.dart
  Lines of Code: 89
  Classes: 2
  Methods: 5
  Comment Lines: 6
  Comment Ratio: 6.74%

File: lib\widgets\app_animated_switcher.dart
  Lines of Code: 38
  Classes: 1
  Methods: 1
  Comment Lines: 1
  Comment Ratio: 2.63%

File: lib\widgets\app_bottom_nav_bar.dart
  Lines of Code: 307
  Classes: 5
  Methods: 9
  Comment Lines: 12
  Comment Ratio: 3.91%

File: lib\widgets\app_button.dart
  Lines of Code: 278
  Classes: 2
  Methods: 11
  Comment Lines: 21
  Comment Ratio: 7.55%

File: lib\widgets\app_card.dart
  Lines of Code: 183
  Classes: 2
  Methods: 8
  Comment Lines: 20
  Comment Ratio: 10.93%

File: lib\widgets\app_glass_container.dart
  Lines of Code: 61
  Classes: 1
  Methods: 1
  Comment Lines: 4
  Comment Ratio: 6.56%

File: lib\widgets\app_interactive_card.dart
  Lines of Code: 148
  Classes: 2
  Methods: 7
  Comment Lines: 5
  Comment Ratio: 3.38%

File: lib\widgets\app_metric_tile.dart
  Lines of Code: 109
  Classes: 1
  Methods: 1
  Comment Lines: 13
  Comment Ratio: 11.93%

File: lib\widgets\app_progress_ring.dart
  Lines of Code: 116
  Classes: 2
  Methods: 3
  Comment Lines: 13
  Comment Ratio: 11.21%

File: lib\widgets\app_section_header.dart
  Lines of Code: 30
  Classes: 1
  Methods: 1
  Comment Lines: 4
  Comment Ratio: 13.33%

File: lib\widgets\app_skeleton.dart
  Lines of Code: 145
  Classes: 3
  Methods: 9
  Comment Lines: 12
  Comment Ratio: 8.28%

File: lib\widgets\app_stat_display.dart
  Lines of Code: 96
  Classes: 1
  Methods: 1
  Comment Lines: 11
  Comment Ratio: 11.46%

File: lib\widgets\app_surface.dart
  Lines of Code: 211
  Classes: 3
  Methods: 7
  Comment Lines: 20
  Comment Ratio: 9.48%

File: lib\widgets\app_text_field.dart
  Lines of Code: 82
  Classes: 1
  Methods: 1
  Comment Lines: 1
  Comment Ratio: 1.22%

File: lib\widgets\app_toast.dart
  Lines of Code: 109
  Classes: 1
  Methods: 3
  Comment Lines: 8
  Comment Ratio: 7.34%

File: lib\widgets\widgets.dart
  Lines of Code: 22
  Classes: 0
  Methods: 0
  Comment Lines: 3
  Comment Ratio: 13.64%

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
  Lines of Code: 246
  Classes: 4
  Methods: 4
  Comment Lines: 11
  Comment Ratio: 4.47%

File: lib\providers\dashboard_provider.dart
  Lines of Code: 180
  Classes: 1
  Methods: 4
  Comment Lines: 5
  Comment Ratio: 2.78%

File: lib\providers\dashboard_state.dart
  Lines of Code: 183
  Classes: 7
  Methods: 10
  Comment Lines: 8
  Comment Ratio: 4.37%

File: lib\widgets\ai_coach_entry_card.dart
  Lines of Code: 66
  Classes: 1
  Methods: 1
  Comment Lines: 5
  Comment Ratio: 7.58%

File: lib\widgets\analytics_hero_section.dart
  Lines of Code: 269
  Classes: 5
  Methods: 5
  Comment Lines: 4
  Comment Ratio: 1.49%

File: lib\widgets\avg_calories_card.dart
  Lines of Code: 113
  Classes: 1
  Methods: 4
  Comment Lines: 4
  Comment Ratio: 3.54%

File: lib\widgets\calorie_hero_card.dart
  Lines of Code: 101
  Classes: 1
  Methods: 1
  Comment Lines: 4
  Comment Ratio: 3.96%

File: lib\widgets\dashboard_header.dart
  Lines of Code: 66
  Classes: 1
  Methods: 1
  Comment Lines: 3
  Comment Ratio: 4.55%

File: lib\widgets\dashboard_stats_section.dart
  Lines of Code: 226
  Classes: 1
  Methods: 6
  Comment Lines: 13
  Comment Ratio: 5.75%

File: lib\widgets\goal_completion_card.dart
  Lines of Code: 221
  Classes: 4
  Methods: 8
  Comment Lines: 4
  Comment Ratio: 1.81%

File: lib\widgets\macro_overview_row.dart
  Lines of Code: 96
  Classes: 2
  Methods: 2
  Comment Lines: 10
  Comment Ratio: 10.42%

File: lib\widgets\protein_avg_card.dart
  Lines of Code: 125
  Classes: 1
  Methods: 1
  Comment Lines: 3
  Comment Ratio: 2.40%

File: lib\widgets\quick_actions_row.dart
  Lines of Code: 53
  Classes: 2
  Methods: 1
  Comment Lines: 4
  Comment Ratio: 7.55%

File: lib\widgets\recent_meals_list.dart
  Lines of Code: 143
  Classes: 3
  Methods: 3
  Comment Lines: 5
  Comment Ratio: 3.50%

File: lib\widgets\streak_card.dart
  Lines of Code: 132
  Classes: 2
  Methods: 4
  Comment Lines: 4
  Comment Ratio: 3.03%

File: lib\widgets\water_card.dart
  Lines of Code: 148
  Classes: 2
  Methods: 5
  Comment Lines: 4
  Comment Ratio: 2.70%

File: lib\widgets\weekly_calories_chart.dart
  Lines of Code: 269
  Classes: 2
  Methods: 4
  Comment Lines: 5
  Comment Ratio: 1.86%

File: lib\widgets\weekly_macros_chart.dart
  Lines of Code: 233
  Classes: 3
  Methods: 5
  Comment Lines: 4
  Comment Ratio: 1.72%

File: lib\widgets\weekly_overview_chart.dart
  Lines of Code: 147
  Classes: 2
  Methods: 3
  Comment Lines: 5
  Comment Ratio: 3.40%

File: lib\widgets\weight_trend_card.dart
  Lines of Code: 157
  Classes: 1
  Methods: 3
  Comment Lines: 4
  Comment Ratio: 2.55%

File: lib\pages\error_page.dart
  Lines of Code: 32
  Classes: 1
  Methods: 1
  Comment Lines: 1
  Comment Ratio: 3.13%

File: lib\pages\home_page.dart
  Lines of Code: 163
  Classes: 3
  Methods: 4
  Comment Lines: 6
  Comment Ratio: 3.68%

File: lib\pages\log_page.dart
  Lines of Code: 398
  Classes: 4
  Methods: 12
  Comment Lines: 9
  Comment Ratio: 2.26%

File: lib\widgets\log_day_summary.dart
  Lines of Code: 188
  Classes: 2
  Methods: 3
  Comment Lines: 5
  Comment Ratio: 2.66%

File: lib\widgets\log_food_row.dart
  Lines of Code: 150
  Classes: 2
  Methods: 2
  Comment Lines: 6
  Comment Ratio: 4.00%

File: lib\widgets\log_meal_section.dart
  Lines of Code: 97
  Classes: 2
  Methods: 1
  Comment Lines: 5
  Comment Ratio: 5.15%

File: lib\widgets\log_quick_input_bar.dart
  Lines of Code: 178
  Classes: 3
  Methods: 5
  Comment Lines: 5
  Comment Ratio: 2.81%

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

- Files following suffix convention: 10/68 (14.7%)

### File Naming Conventions

| Suffix | Count |
|--------|-------|
| `_page` | 8 |
| `_provider` | 1 |
| `_state` | 1 |

### Class Naming Conventions

| Suffix | Count |
|--------|-------|
| `State` | 18 |
| `Page` | 8 |



## File Purposes

### Purpose Summary

| Purpose | Count |
|---------|-------|
| widget | 47 |
| other | 18 |
| provider | 1 |
| state | 1 |
| entry_point | 1 |

*68 files analyzed — detailed list omitted for brevity.*



## Aggregated Metrics

- Total Classes: 123
- Total Methods: 237
- Average LOC per file: 125.9
- Average Comment Ratio: 6.3%
- Files without comments: 5

### Largest Files (Top 5)

1. `lib\pages\log_page.dart` - 398 lines
2. `lib\theme\app_theme.dart` - 352 lines
3. `lib\widgets\app_bottom_nav_bar.dart` - 307 lines
4. `lib\theme\app_text_styles.dart` - 293 lines
5. `lib\widgets\app_button.dart` - 278 lines


