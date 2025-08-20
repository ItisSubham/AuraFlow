import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:auraflow/models/timer_theme.dart';
import 'package:auraflow/widgets/gradient_background.dart';
import 'package:auraflow/widgets/breathing_timer.dart';
import 'package:auraflow/widgets/theme_selector.dart';
import 'package:auraflow/widgets/control_buttons.dart';
import 'package:auraflow/widgets/ambient_icons.dart';
import 'package:auraflow/widgets/time_selector.dart';

class FocusTimerScreen extends StatefulWidget {
  const FocusTimerScreen({super.key});

  @override
  State<FocusTimerScreen> createState() => _FocusTimerScreenState();
}

class _FocusTimerScreenState extends State<FocusTimerScreen>
    with TickerProviderStateMixin {
  Timer? _timer;
  int _remainingSeconds = 1500; // 25 minutes default
  int _totalSeconds = 1500;
  bool _isRunning = false;
  TimerThemeType _currentTheme = TimerThemeType.forest;

  late AnimationController _breathingController;
  late AnimationController _progressController;

  @override
  void initState() {
    super.initState();
    _breathingController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);

    _progressController = AnimationController(
      duration: Duration(seconds: _totalSeconds),
      vsync: this,
    );

    _loadSettings();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _breathingController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _remainingSeconds = prefs.getInt('timer_duration') ?? 1500;
      _totalSeconds = _remainingSeconds;
      _currentTheme = TimerThemeType.values[prefs.getInt('theme') ?? 0];
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('timer_duration', _totalSeconds);
    await prefs.setInt('theme', _currentTheme.index);
  }

  void _startTimer() {
    if (_isRunning) return;

    setState(() {
      _isRunning = true;
    });

    _progressController.duration = Duration(seconds: _remainingSeconds);
    _progressController.forward();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _completeTimer();
      }
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    _progressController.stop();
    setState(() {
      _isRunning = false;
    });
  }

  void _resetTimer() {
    _timer?.cancel();
    _progressController.reset();
    setState(() {
      _isRunning = false;
      _remainingSeconds = _totalSeconds;
    });
  }

  void _completeTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
    });

    // Show completion dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.celebration,
                color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 8),
            const Text('Focus Complete!'),
          ],
        ),
        content: const Text('Great job! You completed your focus session.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _resetTimer();
            },
            child: const Text('New Session'),
          ),
        ],
      ),
    );
  }

  void _updateTheme(TimerThemeType theme) {
    setState(() {
      _currentTheme = theme;
    });
    _saveSettings();
  }

  void _updateDuration(int minutes) {
    if (!_isRunning) {
      setState(() {
        _totalSeconds = minutes * 60;
        _remainingSeconds = _totalSeconds;
      });
      _saveSettings();
    }
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final progress = 1 - (_remainingSeconds / _totalSeconds);
    final screenHeight = MediaQuery.of(context).size.height;
    final safeAreaHeight = screenHeight -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;

    return Scaffold(
      body: GradientBackground(
        theme: _currentTheme,
        child: SafeArea(
          child: SizedBox(
            height: safeAreaHeight,
            child: Column(
              children: [
                // Theme Selector at top - reduced padding
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: ThemeSelector(
                    currentTheme: _currentTheme,
                    onThemeChanged: _updateTheme,
                  ),
                ),

                // Pomodoro Title - reduced padding
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    children: [
                      Text(
                        'POMODORO TIMER',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 2.0,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _isRunning ? 'FOCUS SESSION ACTIVE' : 'READY TO FOCUS',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 11,
                          fontWeight: FontWeight.w300,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                ),

                // Expanded middle section for timer and ambient icons
                Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      AmbientIcons(
                        theme: _currentTheme,
                        isRunning: _isRunning,
                      ),

                      // Main Timer Display - centered in available space
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Timer Circle - responsive size
                          BreathingTimer(
                            progress: progress,
                            isRunning: _isRunning,
                            theme: _currentTheme,
                            breathingController: _breathingController,
                            time: _formatTime(_remainingSeconds),
                            size: (safeAreaHeight * 0.35)
                                .clamp(200.0, 280.0), // Responsive size
                          ),

                          const SizedBox(height: 16),

                          // Time Selector - reduced spacing
                          if (!_isRunning)
                            TimeSelector(
                              selectedMinutes: _totalSeconds ~/ 60,
                              onTimeSelected: _updateDuration,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Control Buttons - reduced padding
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 16.0),
                  child: ControlButtons(
                    isRunning: _isRunning,
                    onStart: _startTimer,
                    onPause: _pauseTimer,
                    onReset: _resetTimer,
                    theme: _currentTheme,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
