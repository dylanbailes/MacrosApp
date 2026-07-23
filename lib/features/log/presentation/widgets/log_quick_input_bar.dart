// Path: widgets/log_quick_input_bar.dart
import 'package:flutter/material.dart';

import '../../../../core/constants/app_border_radius.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

/// A row of three action cards for quick food input: Scan, Photo, Search.
///
/// These are the primary entry points for logging. Each card shows an icon,
/// a label, and a subtle description. Pressed state follows the app's
/// interactive card pattern (scale + lift).
class LogQuickInputBar extends StatelessWidget {
  const LogQuickInputBar({
    super.key,
    this.onScanBarcode,
    this.onTakePhoto,
    this.onSearch,
  });

  final VoidCallback? onScanBarcode;
  final VoidCallback? onTakePhoto;
  final VoidCallback? onSearch;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          Expanded(
            child: _InputActionCard(
              icon: Icons.qr_code_scanner_outlined,
              label: 'Scan',
              description: 'Barcode',
              onTap: onScanBarcode,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: _InputActionCard(
              icon: Icons.camera_alt_outlined,
              label: 'Photo',
              description: 'AI Analyze',
              onTap: onTakePhoto,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: _InputActionCard(
              icon: Icons.search_outlined,
              label: 'Search',
              description: 'Find food',
              onTap: onSearch,
            ),
          ),
        ],
      ),
    );
  }
}

class _InputActionCard extends StatefulWidget {
  const _InputActionCard({
    required this.icon,
    required this.label,
    required this.description,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String description;
  final VoidCallback? onTap;

  @override
  State<_InputActionCard> createState() => _InputActionCardState();
}

class _InputActionCardState extends State<_InputActionCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isInteractive = widget.onTap != null;

    Widget card = Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
        border: Border.all(color: AppColors.divider, width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(AppBorderRadius.sm),
            ),
            child: Icon(
              widget.icon,
              size: 24,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            widget.label,
            style: AppTextStyles.headlineSmall.copyWith(
              color: AppColors.onPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            widget.description,
            style: AppTextStyles.tiny.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );

    if (!isInteractive) return card;

    card = AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) => Transform.scale(
        scale: _scaleAnimation.value,
        child: child,
      ),
      child: card,
    );

    return GestureDetector(
      onTapDown: isInteractive ? (_) => _controller.forward() : null,
      onTapUp: isInteractive
          ? (_) {
              _controller.reverse();
              widget.onTap?.call();
            }
          : null,
      onTapCancel: isInteractive ? () => _controller.reverse() : null,
      behavior: HitTestBehavior.opaque,
      child: card,
    );
  }
}