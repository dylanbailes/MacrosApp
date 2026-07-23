// Path: widgets\weekly_overview_chart.dart
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../providers/dashboard_state.dart';

/// Weekly calorie overview chart.
///
/// Reference: Blueprint §3.1 — Weekly Overview. A 7-day line/bar chart
/// with subtle dot-grid background, target line, and today highlight.
/// Uses Nothing OS red accent for highlights, monochrome white for data.
class WeeklyOverviewChart extends StatelessWidget {
  const WeeklyOverviewChart({
    super.key,
    required this.days,
    required this.target,
  });

  final List<WeeklyDay> days;
  final int target;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(double.infinity, double.infinity),
      painter: _WeeklyChartPainter(days: days, target: target),
    );
  }
}

class _WeeklyChartPainter extends CustomPainter {
  _WeeklyChartPainter({required this.days, required this.target});

  final List<WeeklyDay> days;
  final int target;

  @override
  void paint(Canvas canvas, Size size) {
    final dotPaint = Paint()
      ..color = AppColors.divider.withValues(alpha: 0.4)
      ..style = PaintingStyle.fill;

    final targetPaint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final dataPaint = Paint()
      ..color = AppColors.onPrimary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final todayPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.fill;

    // Find max calories for scaling
    final maxCalories = days.map((d) => d.calories).reduce((a, b) => a > b ? a : b);
    final chartMax = (maxCalories * 1.1).toDouble(); // 10% headroom
    final chartMin = 0.0;

    // Padding
    const left = 24.0;
    const right = 8.0;
    const top = 4.0;
    const bottom = 28.0;
    final chartWidth = size.width - left - right;
    final chartHeight = size.height - top - bottom;

    // Draw dot-grid background
    const gridLines = 4;
    for (var i = 0; i <= gridLines; i++) {
      final y = top + (chartHeight / gridLines) * i;
      final dashWidth = 4.0;
      var dashX = left;
      while (dashX < size.width - right) {
        canvas.drawCircle(Offset(dashX, y), 1.5, dotPaint);
        dashX += dashWidth * 2;
      }
    }

    // Draw target line
    final targetY = top + chartHeight - ((target - chartMin) / (chartMax - chartMin)) * chartHeight;
    canvas.drawLine(
      Offset(left, targetY),
      Offset(size.width - right, targetY),
      targetPaint,
    );

    // Draw data points and lines
    final points = <Offset>[];
    for (var i = 0; i < days.length; i++) {
      final day = days[i];
      final x = left + (i + 0.5) * (chartWidth / days.length);
      final y = top + chartHeight - ((day.calories - chartMin) / (chartMax - chartMin)) * chartHeight;
      points.add(Offset(x, y));

      // Draw point
      if (day.isToday) {
        canvas.drawCircle(Offset(x, y), 4, todayPaint);
        // Outer ring
        canvas.drawCircle(
          Offset(x, y),
          8,
          Paint()
            ..color = AppColors.primary.withValues(alpha: 0.3)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1,
        );
      } else {
        canvas.drawCircle(Offset(x, y), 3, dataPaint);
      }
    }

    // Draw line segments
    for (var i = 0; i < points.length - 1; i++) {
      canvas.drawLine(points[i], points[i + 1], dataPaint);
    }

    // Draw day labels
    for (var i = 0; i < days.length; i++) {
      final day = days[i];
      final x = left + (i + 0.5) * (chartWidth / days.length);
      final builder = TextSpan(
        text: day.label,
        style: TextStyle(
          fontFamily: 'Nothing',
          fontSize: 12,
          color: day.isToday ? AppColors.onPrimary : AppColors.textTertiary,
        ),
      );
      final painter = TextPainter(
        text: builder,
        textDirection: TextDirection.ltr,
      );
      painter.layout();
      painter.paint(
        canvas,
        Offset(x - painter.width / 2, size.height - bottom + 4),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _WeeklyChartPainter old) =>
      old.days != days || old.target != target;
}