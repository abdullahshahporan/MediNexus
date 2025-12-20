import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  final Widget nextScreen;
  
  const SplashScreen({
    super.key,
    required this.nextScreen,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    // Setup animation controller
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );

    // Fade animation: 0.0 to 1.0
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );

    // Scale animation: 0.5 to 1.0 with bounce
    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
    );

    // Start the animation
    _controller.forward();

    // Navigate after 3 seconds
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                widget.nextScreen,
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    const Color(0xFF0A0A0A),
                    const Color(0xFF1A1A2E),
                    const Color(0xFF0A0A0A),
                  ]
                : [
                    const Color(0xFFF0F4F8),
                    const Color(0xFFFFFFFF),
                    const Color(0xFFE8EEF5),
                  ],
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo with shadow and glow effect
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: isDark
                                  ? const Color(0xFF10B981).withOpacity(0.3)
                                  : const Color(0xFF10B981).withOpacity(0.2),
                              blurRadius: 40,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: Image.asset(
                            'assets/images/logo.jpeg',
                            width: 180,
                            height: 180,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),

                      // App Name with animated opacity
                      Opacity(
                        opacity: _fadeAnimation.value,
                        child: Text(
                          'MEDI NEXUS',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : const Color(0xFF1A1A2E),
                            letterSpacing: 4,
                            shadows: [
                              Shadow(
                                color: isDark
                                    ? Colors.black45
                                    : Colors.black12,
                                offset: const Offset(0, 2),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Tagline
                      Opacity(
                        opacity: _fadeAnimation.value * 0.8,
                        child: Text(
                          'Healthcare at Your Fingertips',
                          style: TextStyle(
                            fontSize: 16,
                            color: isDark
                                ? Colors.white70
                                : const Color(0xFF64748B),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 60),

                      // Loading indicator with pulse effect
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: const Duration(seconds: 3),
                        builder: (context, value, child) {
                          return SizedBox(
                            width: 50,
                            height: 50,
                            child: CircularProgressIndicator(
                              value: value,
                              strokeWidth: 4,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                isDark
                                    ? const Color(0xFF10B981)
                                    : const Color(0xFF059669),
                              ),
                              backgroundColor: isDark
                                  ? Colors.white12
                                  : Colors.black12,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
