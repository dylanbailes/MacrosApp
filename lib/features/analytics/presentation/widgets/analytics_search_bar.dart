/// Searchable filter bar for the Analytics page.
///
/// Allows filtering by date range and searching for specific metrics.
/// Reference: Blueprint §3.6 — Analytics screen.
library;

import 'package:flutter/material.dart';

import '../../../../core/constants/app_border_radius.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Callback when search/filter criteria change.
typedef OnSearchChanged = void Function(String query, DateTimeRange? range);

/// A search bar with date range picker and metric search field.
class AnalyticsSearchBar extends StatefulWidget {
  const AnalyticsSearchBar({
    super.key,
    this.onChanged,
  });

  final OnSearchChanged? onChanged;

  @override
  State<AnalyticsSearchBar> createState() => _AnalyticsSearchBarState();
}

class _AnalyticsSearchBarState extends State<AnalyticsSearchBar> {
  final _searchController = TextEditingController();
  DateTimeRange? _selectedRange;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _pickDateRange() async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now,
      initialDateRange: _selectedRange ??
          DateTimeRange(
            start: now.subtract(const Duration(days: 30)),
            end: now,
          ),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primary,
              surface: AppColors.surfaceElevated,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedRange = picked);
      widget.onChanged?.call(_searchController.text, picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        children: [
          // Search field
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  style: AppTextStyles.bodyLarge,
                  decoration: InputDecoration(
                    hintText: 'Search metrics...',
                    hintStyle: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.textTertiary,
                    ),
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: AppColors.textTertiary,
                      size: 20,
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? GestureDetector(
                            onTap: () {
                              _searchController.clear();
                              widget.onChanged?.call('', _selectedRange);
                              setState(() {});
                            },
                            child: const Icon(
                              Icons.close_rounded,
                              color: AppColors.textTertiary,
                              size: 18,
                            ),
                          )
                        : null,
                    filled: true,
                    fillColor: AppColors.surfaceElevated,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {});
                    widget.onChanged?.call(value, _selectedRange);
                  },
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              // Date range button
              GestureDetector(
                onTap: _pickDateRange,
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevated,
                    borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                  ),
                  child: const Icon(
                    Icons.date_range_rounded,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          // Active filter chips
          if (_selectedRange != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                _FilterChip(
                  label:
                      '${_selectedRange!.start.month}/${_selectedRange!.start.day} - ${_selectedRange!.end.month}/${_selectedRange!.end.day}',
                  onRemove: () {
                    setState(() => _selectedRange = null);
                    widget.onChanged?.call(_searchController.text, null);
                  },
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.onRemove,
  });

  final String label;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppBorderRadius.sm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: AppTextStyles.tiny.copyWith(color: AppColors.primary),
          ),
          const SizedBox(width: AppSpacing.xs),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(
              Icons.close_rounded,
              size: 14,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}