import 'package:flutter/material.dart';
import 'package:auraflow/models/timer_theme.dart';

class GradientBackground extends StatefulWidget {
  final TimerThemeType theme;
  final Widget child;

  const GradientBackground({
    super.key,
    required this.theme,
    required this.child,
  });

  @override
  State<GradientBackground> createState() => _GradientBackgroundState();
}

class _GradientBackgroundState extends State<GradientBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = TimerTheme.getTheme(widget.theme);

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: theme.gradientColors,
              stops: [
                0.0,
                0.3 + (_animation.value * 0.2),
                0.7 + (_animation.value * 0.2),
                1.0,
              ],
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(
                  -0.5 + (_animation.value * 1.0),
                  -0.5 + (_animation.value * 1.0),
                ),
                radius: 1.5 + (_animation.value * 0.5),
                colors: [
                  Colors.white.withValues(alpha: 0.1),
                  Colors.transparent,
                ],
              ),
            ),
            child: widget.child,
          ),
        );
      },
    );
  }
}