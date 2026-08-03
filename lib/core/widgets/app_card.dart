// Path: widgets/app_card.dart
import 'dart:ui';
import 'package:flutter/material.dart';

import '../constants/app_border_radius.dart';
import '../constants/app_colors.dart';
import '../constants/app_durations.dart';
import '../constants/app_spacing.dart';

/// The single reusable card shell in the application.
///
/// Consolidates the previous quartet — AppCard, AppSurface, AppGlassContainer,
/// and AppInteractiveCard — into one versatile primitive.
///
/// Reference: Blueprint §2.2 — Card, Visual Design Specification §4 — Elevation
///
/// - [variant] controls the default border radius (hero / standard / row)
/// - [level] maps to the §4 elevation ladder (0 transparent … 4 scrim)
/// - [accentColor] adds a subtle ambient glow + accent border on hover
/// - [glass] switches to glassmorphic BackdropFilter rendering (nav chrome)
/// - [onTap] enables the Nothing OS hover lift / border glow / press squash
///
/// Hover behavior:
/// - Interactive cards lift -2px, scale to 1.015, and glow toward the accent
///   (or primary) border color — ripple-free, intentionally engineered feel.
/// - Non-interactive (or [AppCardVariant.static]) cards stay clean.
class AppCard extends StatefulWidget {
  const AppCard({
    super.key,
    this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.variant = AppCardVariant.standard,
    this.showBorder = true,
    this.backgroundColor,
    this.borderRadius,
    this.level = 1,
    this.accentColor,
    this.clip = true,
    this.glass = false,
    this.blur = 24.0,
    this.glassOpacity = 0.5,
    this.onHover,
  });

  final Widget? child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final AppCardVariant variant;

  /// Overrides the variant-derived border radius (in px).
  final double? borderRadius;

  /// Elevation level (0 = transparent, 1 = surface, 2 = surfaceElevated,
  /// 3 = surfaceGlass, 4 = scrim). See Visual Design Specification §4.
  final int level;

  /// Optional accent color for ambient glow + accent-tinted hover border.
  final Color? accentColor;

  /// Whether content is clipped to the border radius.
  final bool clip;

  /// Glassmorphic mode (BackdropFilter blur) — floating chrome like the
  /// bottom navigation bar.
  final bool glass;

  /// Backdrop blur sigma when [glass] is true.
  final double blur;

  /// Translucency of the glass surface when [glass] is true.
  final double glassOpacity;

  /// Hover state callback (useful for cross-fading sibling content).
  final ValueChanged<bool>? onHover;

  final bool showBorder;
  final Color? backgroundColor;

  @override
  State<AppCard> createState() => _AppCardState();
}

class _AppCardState extends State<AppCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _liftAnimation;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppDurations.fast,
    );
    _liftAnimation = Tween<double>(begin: 0.0, end: -2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.015).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _isInteractive =>
      widget.onTap != null && widget.variant != AppCardVariant.static;

  double get _radius =>
      widget.borderRadius ??
      switch (widget.variant) {
        AppCardVariant.hero => AppBorderRadius.lg,
        AppCardVariant.row => AppBorderRadius.sm,
        _ => AppBorderRadius.md,
      };

  Color _baseBorderColor() {
    if (widget.glass) return AppColors.glassBorder;
    return switch (widget.level) {
      2 => AppColors.dividerStrong,
      >= 3 => AppColors.glassBorder,
      _ => AppColors.divider,
    };
  }

  Color _hoverBorderColor() {
    final accent = widget.accentColor ?? AppColors.primary;
    return accent.withValues(alpha: 0.4);
  }

  Color _baseColor() {
    if (widget.backgroundColor != null) return widget.backgroundColor!;
    if (widget.glass) {
      return AppColors.surfaceGlass.withValues(alpha: widget.glassOpacity);
    }
    return switch (widget.level) {
      0 => Colors.transparent,
      2 => AppColors.surfaceElevated,
      3 => AppColors.surfaceGlass,
      4 => AppColors.scrim,
      _ => AppColors.surface,
    };
  }

  List<BoxShadow>? _shadows() {
    if (widget.level >= 3) {
      return [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.6),
          blurRadius: 32,
          offset: const Offset(0, 12),
        ),
      ];
    }
    if (_isHovered && _isInteractive) {
      return [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.4),
          blurRadius: 16,
          offset: const Offset(0, 6),
        ),
      ];
    }
    return null;
  }

  void _onEnter(_) {
    if (!_isInteractive) return;
    setState(() => _isHovered = true);
    widget.onHover?.call(true);
    _controller.forward();
  }

  void _onExit(_) {
    if (!_isInteractive) return;
    setState(() => _isHovered = false);
    widget.onHover?.call(false);
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(_radius);

    Widget surface = AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // Fade the border toward the accent as the controller advances.
        final borderColor = _isInteractive
            ? Color.lerp(
                _baseBorderColor(),
                _hoverBorderColor(),
                _controller.value,
              )
            : _baseBorderColor();

        Widget card = Container(
          padding: widget.padding ?? const EdgeInsets.all(AppSpacing.lg),
          margin: widget.margin,
          decoration: BoxDecoration(
            color: _baseColor(),
            borderRadius: radius,
            border: widget.showBorder
                ? Border.all(color: borderColor!, width: 1)
                : null,
            boxShadow: _shadows(),
          ),
          clipBehavior: widget.clip ? Clip.antiAlias : Clip.none,
          child: child,
        );

        // Ambient accent glow behind data/chart areas (skipped for glass).
        if (widget.accentColor != null && !widget.glass) {
          card = _AccentGlow(
            accentColor: widget.accentColor!,
            borderRadius: _radius,
            child: card,
          );
        }

        // Glassmorphic rendering for floating chrome.
        if (widget.glass) {
          card = ClipRRect(
            borderRadius: radius,
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: widget.blur,
                sigmaY: widget.blur,
              ),
              child: card,
            ),
          );
        }

        // Hover lift + scale.
        return Transform.translate(
          offset: Offset(0, _liftAnimation.value),
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: card,
          ),
        );
      },
      child: widget.child,
    );

    if (!_isInteractive) return surface;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: _onEnter,
      onExit: _onExit,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedScale(
          scale: _isPressed ? 0.985 : 1.0,
          duration: AppDurations.xFast,
          curve: Curves.easeOutCubic,
          child: surface,
        ),
      ),
    );
  }
}

/// Card variants per Blueprint §2.2 (radius presets).
enum AppCardVariant {
  /// Vertical content stack — radius.md (default)
  standard,

  /// Horizontal content, e.g., food-log list item — radius.sm
  row,

  /// Uses radius.lg (28px) — the single most important card per screen
  hero,

  /// Informational only, no press/hover feedback
  static,
}

/// Very subtle radial gradient glow behind an accent-colored surface element.
/// Opacity is intentionally low (5-8%) to never look like gaming RGB.
class _AccentGlow extends StatelessWidget {
  const _AccentGlow({
    required this.accentColor,
    required this.borderRadius,
    required this.child,
  });

  final Color accentColor;
  final double borderRadius;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Ambient glow
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              gradient: RadialGradient(
                center: Alignment.centerRight,
                radius: 1.2,
                colors: [
                  accentColor.withValues(alpha: 0.07),
                  accentColor.withValues(alpha: 0.0),
                ],
              ),
            ),
          ),
        ),
        // Inner highlight (1px top edge)
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(borderRadius),
              ),
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.white.withValues(alpha: 0.04),
                  Colors.white.withValues(alpha: 0.08),
                  Colors.white.withValues(alpha: 0.04),
                ],
              ),
            ),
          ),
        ),
        child,
      ],
    );
  }
}
