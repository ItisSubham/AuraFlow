import 'package:flutter/material.dart';
import 'package:auraflow/models/timer_theme.dart';

class ControlButtons extends StatelessWidget {
  final bool isRunning;
  final VoidCallback onStart;
  final VoidCallback onPause;
  final VoidCallback onReset;
  final TimerThemeType theme;

  const ControlButtons({
    super.key,
    required this.isRunning,
    required this.onStart,
    required this.onPause,
    required this.onReset,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final timerTheme = TimerTheme.getTheme(theme);

    return Column(
      children: [
        GestureDetector(
          onTap: isRunning ? onPause : onStart,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            constraints: const BoxConstraints(
              minWidth: 120,
              minHeight: 50,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: isRunning
                  ? Colors.white.withValues(alpha: 0.2)
                  : timerTheme.primaryColor.withValues(alpha: 0.9),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
                BoxShadow(
                  color: timerTheme.primaryColor.withValues(alpha: 0.3),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isRunning ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  isRunning ? 'PAUSE' : 'START',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.0,
                  ),
                  overflow: TextOverflow.visible,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Reset Button
            _buildSecondaryButton(
              icon: Icons.refresh,
              label: 'RESET',
              onTap: onReset,
            ),

            // Info Button
            _buildSecondaryButton(
              icon: Icons.info_outline,
              label: 'INFO',
              onTap: () => _showInfoDialog(context),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSecondaryButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: Colors.white.withValues(alpha: 0.1),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: Colors.white.withValues(alpha: 0.8),
              size: 18,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 9,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.info_outline,
                color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 8),
            const Text('About AuraFlow'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('AuraFlow helps you focus with:'),
            SizedBox(height: 8),
            Text('• Beautiful gradient backgrounds'),
            Text('• Breathing animations for relaxation'),
            Text('• Multiple calming themes'),
            Text('• Immersive ambient experience'),
            SizedBox(height: 16),
            Text('Tap themes at the top to change ambiance.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}
