import 'package:flutter/material.dart';
import '../models/birthday.dart';
import '../theme/app_theme.dart';

/// Special Birthday Celebration Card.
/// Displayed when today is someone's birthday with celebratory animations.
/// Demonstrates:
/// - Flutter Animation framework with AnimationController, FadeTransition,
///   ScaleTransition, and SlideTransition
/// - AnimatedContainer for dynamic theme and glow styling
/// - Visual consistency in both Light and Dark themes
class CelebrationCard extends StatefulWidget {
  final Birthday birthday;
  final VoidCallback? onTap;

  const CelebrationCard({
    super.key,
    required this.birthday,
    this.onTap,
  });

  @override
  State<CelebrationCard> createState() => _CelebrationCardState();
}

class _CelebrationCardState extends State<CelebrationCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _cardScaleAnimation;
  late final Animation<double> _iconPulseAnimation;
  late final Animation<Offset> _balloonFloatAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    // Fade-in entry
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
    );

    // Slide-in entrance
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.12),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOutCubic),
      ),
    );

    // Card gentle bounce and settling
    _cardScaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.92, end: 1.03).chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.03, end: 1.0).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
    ]).animate(_controller);

    // Celebratory pulse on avatar badge
    _iconPulseAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.8, end: 1.25).chain(CurveTween(curve: Curves.easeOutBack)),
        weight: 45,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.25, end: 0.95).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.95, end: 1.0).chain(CurveTween(curve: Curves.easeOut)),
        weight: 30,
      ),
    ]).animate(_controller);

    // Floating balloon celebration motion
    _balloonFloatAnimation = TweenSequence<Offset>([
      TweenSequenceItem(
        tween: Tween(begin: const Offset(0.0, 0.2), end: const Offset(0.0, -0.16)).chain(CurveTween(curve: Curves.easeOut)),
        weight: 55,
      ),
      TweenSequenceItem(
        tween: Tween(begin: const Offset(0.0, -0.16), end: Offset.zero).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 45,
      ),
    ]).animate(_controller);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final birthday = widget.birthday;

    // Theme-adaptive gradient & border colors
    final gradientColors = isDark
        ? [
            colorScheme.surfaceContainerHigh,
            const Color(0xFF2A2012),
            colorScheme.primaryContainer.withValues(alpha: 0.22),
          ]
        : [
            const Color(0xFFFFF9E8),
            const Color(0xFFFFF3D6),
            colorScheme.primaryContainer.withValues(alpha: 0.35),
          ];

    final goldAccent = isDark
        ? AppTheme.celebrationGold
        : const Color(0xFFB57000);

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: ScaleTransition(
          scale: _cardScaleAnimation,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppTheme.celebrationGold.withValues(alpha: isDark ? 0.55 : 0.75),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.celebrationGold.withValues(alpha: isDark ? 0.18 : 0.25),
                  blurRadius: 14,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.onTap,
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 14.0),
                  child: Row(
                    children: [
                      // 1. Pulsing Avatar Badge with ScaleTransition
                      ScaleTransition(
                        scale: _iconPulseAnimation,
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppTheme.celebrationGold.withValues(alpha: 0.2),
                            border: Border.all(
                              color: AppTheme.celebrationGold,
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.celebrationGold.withValues(alpha: 0.35),
                                blurRadius: 8,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            birthday.avatarEmoji.isNotEmpty ? birthday.avatarEmoji : '🎂',
                            style: const TextStyle(fontSize: 24),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      // 2. Birthday Celebration Text Announcement
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Required title: "🎉 Happy Birthday!"
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    '🎉 Happy Birthday!',
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: goldAccent,
                                      letterSpacing: 0.2,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),

                            // Required subtitle: "[Name] is celebrating today!"
                            Text(
                              '${birthday.name} is celebrating today!',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: colorScheme.onSurface,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),

                            // Age & Relationship badge (fitted to prevent overflow on narrow screens)
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppTheme.celebrationGold.withValues(alpha: 0.18),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      'Turning ${birthday.age} today',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: goldAccent,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    '• ${birthday.relationship}',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: colorScheme.onSurfaceVariant,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 8),

                      // 3. Floating Celebration Balloon Animation
                      SlideTransition(
                        position: _balloonFloatAnimation,
                        child: ScaleTransition(
                          scale: _iconPulseAnimation,
                          child: Container(
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              color: colorScheme.primary.withValues(alpha: 0.12),
                              shape: BoxShape.circle,
                            ),
                            child: const Text('🎈', style: TextStyle(fontSize: 18)),
                          ),
                        ),
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
  }
}

/// Backward compatibility alias
typedef BirthdayCelebrationCard = CelebrationCard;
