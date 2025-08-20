import 'package:flutter/material.dart';

enum TimerThemeType {
  forest,
  ocean,
  sunset,
  galaxy,
}

class TimerTheme {
  final String name;
  final List<Color> gradientColors;
  final Color primaryColor;
  final Color accentColor;
  final IconData icon;

  const TimerTheme({
    required this.name,
    required this.gradientColors,
    required this.primaryColor,
    required this.accentColor,
    required this.icon,
  });

  static const Map<TimerThemeType, TimerTheme> themes = {
    TimerThemeType.forest: TimerTheme(
      name: 'Forest',
      gradientColors: [
        Color(0xFF2D5016),
        Color(0xFF2E7D32),
        Color(0xFF4CAF50),
        Color(0xFF81C784),
      ],
      primaryColor: Color(0xFF4CAF50),
      accentColor: Color(0xFF8BC34A),
      icon: Icons.forest,
    ),
    TimerThemeType.ocean: TimerTheme(
      name: 'Ocean',
      gradientColors: [
        Color(0xFF0D47A1),
        Color(0xFF1976D2),
        Color(0xFF2196F3),
        Color(0xFF64B5F6),
      ],
      primaryColor: Color(0xFF2196F3),
      accentColor: Color(0xFF03DAC6),
      icon: Icons.waves,
    ),
    TimerThemeType.sunset: TimerTheme(
      name: 'Sunset',
      gradientColors: [
        Color(0xFF8E24AA),
        Color(0xFFE91E63),
        Color(0xFFFF5722),
        Color(0xFFFF9800),
      ],
      primaryColor: Color(0xFFFF5722),
      accentColor: Color(0xFFFFAB91),
      icon: Icons.wb_sunny,
    ),
    TimerThemeType.galaxy: TimerTheme(
      name: 'Galaxy',
      gradientColors: [
        Color(0xFF1A0033),
        Color(0xFF4A148C),
        Color(0xFF7B1FA2),
        Color(0xFF9C27B0),
      ],
      primaryColor: Color(0xFF9C27B0),
      accentColor: Color(0xFFE1BEE7),
      icon: Icons.star,
    ),
  };

  static TimerTheme getTheme(TimerThemeType type) {
    return themes[type]!;
  }
}