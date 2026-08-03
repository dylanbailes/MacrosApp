import '../entities/food.dart';
import '../entities/logged_food_entry.dart';

/// Contract for all food & logging data access.
///
/// Implementations are storage-agnostic (Drift today, sync-aware wrapper in a
/// later phase), which keeps the presentation layer decoupled from persistence.
abstract interface class FoodRepository {
  /// Searches foods by name/brand. Empty query returns the most popular foods
  /// (used for the initial "popular / browse" state of the search screen).
  Future<List<Food>> searchFoods(String query, {int limit = 30});

  /// Fetches a single food by id, or `null` if not found.
  Future<Food?> getFoodById(String id);

  /// Fetches a food by barcode (GTIN/EAN/UPC), or `null` if not found.
  ///
  /// The lookup trims surrounding whitespace. Write paths must store barcodes
  /// in a trimmed, normalized form for lookups to be symmetric.
  Future<Food?> getFoodByBarcode(String barcode);

  /// All logged entries for a calendar day (local time), oldest first.
  Future<List<LoggedFoodEntry>> getLogForDate(DateTime date);

  /// Persists a logged food entry.
  Future<void> logFood(LoggedFoodEntry entry);

  /// Replaces an existing entry (used for serving adjustments, meal moves).
  Future<void> updateLogEntry(LoggedFoodEntry entry);

  /// Deletes a logged entry by id.
  Future<void> removeLogEntry(String entryId);
}
