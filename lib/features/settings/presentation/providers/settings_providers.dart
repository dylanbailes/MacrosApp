// Path: providers/settings_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Measurement system preference.
///
/// Real, editable setting — drives weight/height display once tracking is
/// built (weight chart, calorie-burn inputs). Currently the choice is stored
/// and shown on the Settings screen.
enum UnitSystem {
  metric('Metric', 'kg · cm'),
  imperial('Imperial', 'lb · in');

  const UnitSystem(this.label, this.subtitle);

  /// Display name for the setting row (e.g. "Metric").
  final String label;

  /// Short unit hint shown under the label.
  final String subtitle;
}

/// Editable app settings.
///
/// In-memory for now (mirrors the mock-dashboard base pattern) until a
/// persistence layer lands — units/goals/toggles reset on restart, so treat
/// this as session state, not durable storage. The notification toggles are
/// preference flags (no scheduling system exists yet); the goals are the
/// single source of truth consumed by Profile, Dashboard, Log, and Analytics.
class SettingsState {
  const SettingsState({
    this.unitSystem = UnitSystem.metric,
    this.mealReminders = true,
    this.dailySummary = true,
    this.calorieTarget = 2200,
    this.proteinTarget = 165,
    this.carbsTarget = 220,
    this.fatTarget = 73,
  });

  final UnitSystem unitSystem;

  /// Notifications
  final bool mealReminders;
  final bool dailySummary;

  /// Daily goal targets (shared with the Profile Goals Summary card).
  final int calorieTarget;
  final int proteinTarget;
  final int carbsTarget;
  final int fatTarget;

  SettingsState copyWith({
    UnitSystem? unitSystem,
    bool? mealReminders,
    bool? dailySummary,
    int? calorieTarget,
    int? proteinTarget,
    int? carbsTarget,
    int? fatTarget,
  }) {
    return SettingsState(
      unitSystem: unitSystem ?? this.unitSystem,
      mealReminders: mealReminders ?? this.mealReminders,
      dailySummary: dailySummary ?? this.dailySummary,
      calorieTarget: calorieTarget ?? this.calorieTarget,
      proteinTarget: proteinTarget ?? this.proteinTarget,
      carbsTarget: carbsTarget ?? this.carbsTarget,
      fatTarget: fatTarget ?? this.fatTarget,
    );
  }
}

/// App-wide settings state (units, notifications, goals).
final settingsProvider =
    NotifierProvider<SettingsNotifier, SettingsState>(SettingsNotifier.new);

class SettingsNotifier extends Notifier<SettingsState> {
  @override
  SettingsState build() => const SettingsState();

  void setUnitSystem(UnitSystem system) =>
      state = state.copyWith(unitSystem: system);

  void setMealReminders(bool value) =>
      state = state.copyWith(mealReminders: value);

  void setDailySummary(bool value) =>
      state = state.copyWith(dailySummary: value);

  void setGoals({
    required int calorieTarget,
    required int proteinTarget,
    required int carbsTarget,
    required int fatTarget,
  }) {
    state = state.copyWith(
      calorieTarget: calorieTarget,
      proteinTarget: proteinTarget,
      carbsTarget: carbsTarget,
      fatTarget: fatTarget,
    );
  }
}
