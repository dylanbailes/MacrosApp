import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database/app_database.dart';
import '../../data/repositories/food_repository_impl.dart';
import '../../domain/domain.dart';

/// The app-wide local database. Opened lazily on first read and closed when
/// the provider is disposed. Tests override this with an in-memory executor.
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

/// Food & logging repository backed by the local Drift database.
final foodRepositoryProvider = Provider<FoodRepository>((ref) {
  return FoodRepositoryImpl(ref.watch(appDatabaseProvider));
});

/// Search-as-you-type results for a query. Auto-disposed; an empty query
/// returns the most popular foods (browse mode).
final foodSearchProvider =
    FutureProvider.autoDispose.family<List<Food>, String>((ref, query) {
  return ref.watch(foodRepositoryProvider).searchFoods(query, limit: 30);
});

/// Strips the time component, so `DateTime.now()` and any other timestamp
/// from the same calendar day resolve to the same family key.
DateTime dayOf(DateTime date) => DateTime(date.year, date.month, date.day);

/// The full day log for a given calendar date.
///
/// **Callers must pass a day-normalized date** (use [dayOf]) so the family
/// key is stable for a calendar day — watching with a fresh `DateTime.now()`
/// on every rebuild would create a new provider instance that never settles.
/// The provider itself normalizes defensively for the repository query.
final dailyLogProvider =
    FutureProvider.autoDispose.family<DayLog, DateTime>((ref, date) async {
  final day = dayOf(date);
  final entries = await ref.watch(foodRepositoryProvider).getLogForDate(day);
  return DayLog(date: day, entries: entries);
});

/// The calendar day the user is currently viewing across the Log page and
/// the Dashboard. Always day-normalized via [dayOf] — both screens share the
/// selection, so navigating on one is reflected on the other.
final selectedDateProvider =
    NotifierProvider<SelectedDateNotifier, DateTime>(SelectedDateNotifier.new);

class SelectedDateNotifier extends Notifier<DateTime> {
  @override
  DateTime build() => dayOf(DateTime.now());

  /// Moves the viewed day by [days] (negative moves backwards).
  ///
  /// Uses calendar-day arithmetic (not `Duration(days:)`) so DST transitions
  /// can't leave midnight + 24h on the same calendar day.
  void shift(int days) {
    state = DateTime(state.year, state.month, state.day + days);
  }

  /// Jumps back to the current calendar day.
  void jumpToToday() => state = dayOf(DateTime.now());
}
