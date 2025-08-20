import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:auraflow/models/timer_theme.dart';

class BreathingTimer extends StatelessWidget {
  final double progress;
  final bool isRunning;
  final TimerThemeType theme;
  final AnimationController breathingController;
  final String time;
  final double? size;

  const BreathingTimer({
    super.key,
    required this.progress,
    required this.isRunning,
    required this.theme,
    required this.breathingController,
    required this.time,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    final timerTheme = TimerTheme.getTheme(theme);
    final timerSize = size ?? 280.0;
    final innerSize = timerSize * 0.71; // Maintain proportion

    return AnimatedBuilder(
      animation: breathingController,
      builder: (context, child) {
        final breathScale =
            isRunning ? 1.0 + (breathingController.value * 0.05) : 1.0;

        return Transform.scale(
          scale: breathScale,
          child: Container(
            width: timerSize,
            height: timerSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: timerTheme.primaryColor.withValues(alpha: 0.3),
                  blurRadius: timerSize * 0.14,
                  spreadRadius: timerSize * 0.036,
                ),
                if (isRunning)
                  BoxShadow(
                    color: timerTheme.accentColor.withValues(alpha: 0.6),
                    blurRadius: timerSize * 0.07,
                    spreadRadius: timerSize * 0.018,
                  ),
              ],
            ),
            child: CustomPaint(
              painter: TimerRingPainter(
                progress: progress,
                primaryColor: timerTheme.primaryColor,
                accentColor: timerTheme.accentColor,
                isRunning: isRunning,
              ),
              child: Center(
                child: Container(
                  width: innerSize,
                  height: innerSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.15),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      time,
                      style:
                          Theme.of(context).textTheme.displayMedium?.copyWith(
                        color: Colors.white,
                        fontSize: timerSize * 0.15, // Responsive font size
                        fontWeight: FontWeight.w300,
                        letterSpacing: 2.0,
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            offset: const Offset(0, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class TimerRingPainter extends CustomPainter {
  final double progress;
  final Color primaryColor;
  final Color accentColor;
  final bool isRunning;

  TimerRingPainter({
    required this.progress,
    required this.primaryColor,
    required this.accentColor,
    required this.isRunning,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 20;

    // Background ring
    final backgroundPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.2)
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Progress ring
    if (progress > 0) {
      final progressPaint = Paint()
        ..strokeWidth = 8
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      // Create gradient for progress ring
      progressPaint.shader = LinearGradient(
        colors: [
          primaryColor,
          accentColor,
          Colors.white,
        ],
      ).createShader(
        Rect.fromCircle(center: center, radius: radius),
      );

      final sweepAngle = 2 * math.pi * progress;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,
        sweepAngle,
        false,
        progressPaint,
      );

      // Glowing effect when running
      if (isRunning) {
        final glowPaint = Paint()
          ..color = accentColor.withValues(alpha: 0.5)
          ..strokeWidth = 12
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          -math.pi / 2,
          sweepAngle,
          false,
          glowPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
