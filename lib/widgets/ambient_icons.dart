import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:auraflow/models/timer_theme.dart';

class AmbientIcons extends StatefulWidget {
  final TimerThemeType theme;
  final bool isRunning;

  const AmbientIcons({
    super.key,
    required this.theme,
    required this.isRunning,
  });

  @override
  State<AmbientIcons> createState() => _AmbientIconsState();
}

class _AmbientIconsState extends State<AmbientIcons>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _controllers = List.generate(
      6,
      (index) => AnimationController(
        duration: Duration(milliseconds: 2000 + (index * 500)),
        vsync: this,
      ),
    );

    _animations = _controllers.map((controller) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOut),
      );
    }).toList();

    // Start animations with staggered delays
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 300), () {
        if (mounted) {
          _controllers[i].repeat(reverse: true);
        }
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  List<IconData> _getThemeIcons() {
    switch (widget.theme) {
      case TimerThemeType.forest:
        return [Icons.eco, Icons.local_florist, Icons.park, Icons.grass];
      case TimerThemeType.ocean:
        return [Icons.waves, Icons.sailing, Icons.water_drop, Icons.beach_access];
      case TimerThemeType.sunset:
        return [Icons.wb_sunny, Icons.cloud, Icons.brightness_5, Icons.flare];
      case TimerThemeType.galaxy:
        return [Icons.star, Icons.star_border, Icons.brightness_2, Icons.star_outline];
    }
  }

  @override
  Widget build(BuildContext context) {
    final icons = _getThemeIcons();
    final screenSize = MediaQuery.of(context).size;

    return SizedBox(
      width: screenSize.width,
      height: screenSize.height,
      child: Stack(
        children: List.generate(6, (index) {
          final iconIndex = index % icons.length;
          final angle = (index * 60) * math.pi / 180;
          final radius = 150.0 + (index * 20);
          
          return AnimatedBuilder(
            animation: _animations[index],
            builder: (context, child) {
              final opacity = widget.isRunning 
                  ? _animations[index].value * 0.4
                  : _animations[index].value * 0.2;
              
              return Positioned(
                left: screenSize.width / 2 + 
                      math.cos(angle) * radius - 12,
                top: screenSize.height / 2 + 
                     math.sin(angle) * radius - 12,
                child: Transform.rotate(
                  angle: _animations[index].value * 2 * math.pi,
                  child: Icon(
                    icons[iconIndex],
                    color: Colors.white.withValues(alpha: opacity),
                    size: 24 + (_animations[index].value * 8),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}