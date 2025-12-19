import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Animated Loading Widget with custom Lottie-like effects
class MediNexusLoader extends StatefulWidget {
  final double size;
  final Color? color;
  final LoaderType type;

  const MediNexusLoader({
    super.key,
    this.size = 50,
    this.color,
    this.type = LoaderType.pulse,
  });

  @override
  State<MediNexusLoader> createState() => _MediNexusLoaderState();
}

class _MediNexusLoaderState extends State<MediNexusLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? AppColors.doctorAccent;
    
    switch (widget.type) {
      case LoaderType.pulse:
        return _PulseLoader(controller: _controller, size: widget.size, color: color);
      case LoaderType.heartbeat:
        return _HeartbeatLoader(controller: _controller, size: widget.size, color: color);
      case LoaderType.dots:
        return _DotsLoader(controller: _controller, size: widget.size, color: color);
      case LoaderType.medical:
        return _MedicalLoader(controller: _controller, size: widget.size, color: color);
    }
  }
}

class _PulseLoader extends StatelessWidget {
  final AnimationController controller;
  final double size;
  final Color color;

  const _PulseLoader({
    required this.controller,
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Outer pulse
            Transform.scale(
              scale: 1 + (controller.value * 0.4),
              child: Opacity(
                opacity: 1 - controller.value,
                child: Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color.withOpacity(0.3),
                  ),
                ),
              ),
            ),
            // Inner circle
            Container(
              width: size * 0.6,
              height: size * 0.6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color,
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.4),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Icon(
                Icons.favorite,
                color: Colors.white,
                size: size * 0.3,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _HeartbeatLoader extends StatelessWidget {
  final AnimationController controller;
  final double size;
  final Color color;

  const _HeartbeatLoader({
    required this.controller,
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final scale = 1.0 + (0.2 * _heartbeatCurve(controller.value));
        
        return Transform.scale(
          scale: scale,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.15),
              border: Border.all(color: color, width: 2),
            ),
            child: Icon(
              Icons.favorite,
              color: color,
              size: size * 0.5,
            ),
          ),
        );
      },
    );
  }

  double _heartbeatCurve(double t) {
    // Simulates heartbeat: quick pulse, pause, quick pulse
    if (t < 0.15) {
      return (t / 0.15);
    } else if (t < 0.3) {
      return 1 - ((t - 0.15) / 0.15);
    } else if (t < 0.45) {
      return ((t - 0.3) / 0.15);
    } else if (t < 0.6) {
      return 1 - ((t - 0.45) / 0.15);
    } else {
      return 0;
    }
  }
}

class _DotsLoader extends StatelessWidget {
  final AnimationController controller;
  final double size;
  final Color color;

  const _DotsLoader({
    required this.controller,
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size * 1.5,
      height: size * 0.5,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(3, (index) {
          return AnimatedBuilder(
            animation: controller,
            builder: (context, child) {
              final delay = index * 0.2;
              final progress = (controller.value + delay) % 1.0;
              final bounce = _bounceCurve(progress);
              
              return Transform.translate(
                offset: Offset(0, -bounce * size * 0.3),
                child: Container(
                  width: size * 0.25,
                  height: size * 0.25,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color.withOpacity(0.5 + (bounce * 0.5)),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }

  double _bounceCurve(double t) {
    if (t < 0.5) {
      return 4 * t * t * t;
    } else {
      return 1 - 4 * (1 - t) * (1 - t) * (1 - t);
    }
  }
}

class _MedicalLoader extends StatelessWidget {
  final AnimationController controller;
  final double size;
  final Color color;

  const _MedicalLoader({
    required this.controller,
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: controller.value * 2 * 3.14159,
          child: SizedBox(
            width: size,
            height: size,
            child: CustomPaint(
              painter: _MedicalCrossPainter(color: color, progress: controller.value),
            ),
          ),
        );
      },
    );
  }
}

class _MedicalCrossPainter extends CustomPainter {
  final Color color;
  final double progress;

  _MedicalCrossPainter({required this.color, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final armWidth = size.width * 0.25;
    final armLength = size.width * 0.35;

    // Vertical arm
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(centerX, centerY),
          width: armWidth,
          height: armLength * 2,
        ),
        Radius.circular(armWidth * 0.2),
      ),
      paint,
    );

    // Horizontal arm
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(centerX, centerY),
          width: armLength * 2,
          height: armWidth,
        ),
        Radius.circular(armWidth * 0.2),
      ),
      paint,
    );

    // Glow effect
    final glowPaint = Paint()
      ..color = color.withOpacity(0.3 * (1 - progress))
      ..style = PaintingStyle.fill
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, size.width * 0.1);

    canvas.drawCircle(
      Offset(centerX, centerY),
      size.width * 0.4 * (1 + progress * 0.3),
      glowPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _MedicalCrossPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

enum LoaderType {
  pulse,
  heartbeat,
  dots,
  medical,
}

/// Shimmer Loading Placeholder
class ShimmerLoading extends StatefulWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const ShimmerLoading({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
  });

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark
        ? AppColors.darkCardBg
        : AppColors.lightCardBg;
    final highlightColor = isDark
        ? AppColors.darkBorder
        : AppColors.lightBorder;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
            gradient: LinearGradient(
              colors: [baseColor, highlightColor, baseColor],
              stops: [
                (_controller.value - 0.3).clamp(0.0, 1.0),
                _controller.value,
                (_controller.value + 0.3).clamp(0.0, 1.0),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        );
      },
    );
  }
}

/// Skeleton Card for loading states
class SkeletonCard extends StatelessWidget {
  final double? height;
  final bool showAvatar;
  final int lines;

  const SkeletonCard({
    super.key,
    this.height,
    this.showAvatar = true,
    this.lines = 3,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      height: height,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBg : AppColors.lightCardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showAvatar) ...[
            const ShimmerLoading(
              width: 50,
              height: 50,
              borderRadius: BorderRadius.all(Radius.circular(25)),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                lines,
                (index) => Padding(
                  padding: EdgeInsets.only(top: index == 0 ? 0 : 8),
                  child: ShimmerLoading(
                    width: index == 0
                        ? double.infinity
                        : (index == lines - 1 ? 100 : double.infinity * 0.7),
                    height: index == 0 ? 16 : 12,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
