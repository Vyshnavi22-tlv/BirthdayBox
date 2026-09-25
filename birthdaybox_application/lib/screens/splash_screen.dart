import 'dart:async';
import 'package:flutter/material.dart';
import '../routes/app_routes.dart';
import '../utils/constants.dart';

/// Animated Splash Screen for BirthdayBox.
/// Demonstrates:
/// - Flutter Animation Framework (Lab Experiment 8a)
/// - Fade & Scale Animations with AnimationController (Lab Experiment 8b)
/// - Stateful Widgets & Lifecycle / Resource Disposal (Lab Experiment 5a)
/// - Responsive UI & Theme-aware styling (Lab Experiments 3a & 6b)
class SplashScreen extends StatefulWidget {
  final Duration animationDuration;
  final Duration navigationDelay;

  const SplashScreen({
    super.key,
    this.animationDuration = const Duration(milliseconds: 1500),
    this.navigationDelay = const Duration(milliseconds: 2500),
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();

    // 1. Initialize AnimationController
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    // 2. Setup Fade Animation (Opacity 0.0 -> 1.0)
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.8, curve: Curves.easeIn),
    );

    // 3. Setup Scale Animation (Scale 0.6 -> 1.0 with a soft overshoot)
    _scaleAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.85, curve: Curves.easeOutBack),
      ),
    );

    // 4. Start animation forward
    _controller.forward();

    // 5. Automatic navigation to Login after short delay
    _navigationTimer = Timer(widget.navigationDelay, _navigateToLogin);
  }

  void _navigateToLogin() {
    if (mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  @override
  void dispose() {
    // Correctly dispose of animation controller and timer to prevent leaks
    _navigationTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final size = MediaQuery.sizeOf(context);

    // Responsive scaling factor for logo based on screen size
    final isCompact = size.width < AppConstants.mobileBreakpoint;
    final logoSize = isCompact ? 100.0 : 130.0;
    final iconFontSize = isCompact ? 52.0 : 68.0;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // BirthdayBox Logo Container
                  Container(
                    width: logoSize,
                    height: logoSize,
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer.withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: colorScheme.primary.withValues(alpha: 0.3),
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.primary.withValues(alpha: 0.2),
                          blurRadius: 24,
                          spreadRadius: 4,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '🎂',
                      style: TextStyle(fontSize: iconFontSize),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Application Name
                  Text(
                    AppConstants.appName,
                    style: theme.textTheme.headlineLarge?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Tagline
                  Text(
                    'Never miss a special day.',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 36),

                  // Subtle celebratory loading indicator
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        colorScheme.secondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
