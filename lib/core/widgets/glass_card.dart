import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Glassmorphism Card Widget
/// A beautiful frosted glass effect container
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final double blur;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderWidth;
  final VoidCallback? onTap;
  final Gradient? gradient;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius = 20,
    this.blur = 10,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 1,
    this.onTap,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final bgColor = backgroundColor ?? 
        (isDark ? AppColors.darkGlassWhite : AppColors.lightGlassWhite);
    final bColor = borderColor ?? 
        (isDark ? AppColors.darkGlassBorder : AppColors.lightGlassBorder);

    Widget card = ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: padding ?? const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: gradient,
            color: gradient == null ? bgColor : null,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: bColor, width: borderWidth),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.3 : 0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );

    if (margin != null) {
      card = Padding(padding: margin!, child: card);
    }

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: card,
      );
    }

    return card;
  }
}

/// Glass Container with optional animation
class GlassContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;

  const GlassContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.borderRadius = 16,
    this.backgroundColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      width: width,
      height: height,
      padding: padding ?? const EdgeInsets.all(16),
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor ?? 
            (isDark ? AppColors.darkGlassWhite : AppColors.lightGlassHighlight),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: borderColor ?? 
              (isDark ? AppColors.darkGlassBorder : AppColors.lightGlassBorder),
          width: 1,
        ),
      ),
      child: child,
    );
  }
}

/// Glass Icon Container
class GlassIconContainer extends StatelessWidget {
  final IconData icon;
  final double size;
  final Color? iconColor;
  final Color? backgroundColor;
  final double padding;
  final double borderRadius;

  const GlassIconContainer({
    super.key,
    required this.icon,
    this.size = 24,
    this.iconColor,
    this.backgroundColor,
    this.padding = 12,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: backgroundColor ?? 
            (isDark ? AppColors.darkGlassWhite : AppColors.lightGlassHighlight),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Icon(
        icon,
        size: size,
        color: iconColor ?? 
            (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
      ),
    );
  }
}
