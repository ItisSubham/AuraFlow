import 'package:flutter/material.dart';
import 'package:auraflow/models/timer_theme.dart';

class ThemeSelector extends StatelessWidget {
  final TimerThemeType currentTheme;
  final Function(TimerThemeType) onThemeChanged;

  const ThemeSelector({
    super.key,
    required this.currentTheme,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.white.withValues(alpha: 0.1),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: TimerThemeType.values.map((themeType) {
          final theme = TimerTheme.getTheme(themeType);
          final isSelected = currentTheme == themeType;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: GestureDetector(
              onTap: () => onThemeChanged(themeType),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected
                      ? Colors.white.withValues(alpha: 0.25)
                      : Colors.transparent,
                  border: isSelected
                      ? Border.all(
                          color: Colors.white.withValues(alpha: 0.5),
                          width: 2,
                        )
                      : null,
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: theme.primaryColor.withValues(alpha: 0.3),
                            blurRadius: 6,
                            spreadRadius: 1,
                          ),
                        ]
                      : null,
                ),
                child: Icon(
                  theme.icon,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
