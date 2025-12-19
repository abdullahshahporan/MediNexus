import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Glass Button - Primary action button with glass effect
class GlassButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool isOutlined;
  final double? width;
  final double height;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? textColor;
  final Gradient? gradient;

  const GlassButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isOutlined = false,
    this.width,
    this.height = 56,
    this.borderRadius = 16,
    this.backgroundColor,
    this.textColor,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    if (isOutlined) {
      return _buildOutlinedButton(context, isDark);
    }
    return _buildFilledButton(context, isDark);
  }

  Widget _buildFilledButton(BuildContext context, bool isDark) {
    return Container(
      width: width ?? double.infinity,
      height: height,
      decoration: BoxDecoration(
        gradient: gradient ?? AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Center(
            child: isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (icon != null) ...[
                        Icon(icon, color: Colors.white, size: 20),
                        const SizedBox(width: 10),
                      ],
                      Text(
                        text,
                        style: TextStyle(
                          color: textColor ?? Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildOutlinedButton(BuildContext context, bool isDark) {
    return Container(
      width: width ?? double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkGlassWhite : AppColors.lightGlassHighlight,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: backgroundColor ?? AppColors.primary,
          width: 1.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Center(
            child: isLoading
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        backgroundColor ?? AppColors.primary,
                      ),
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (icon != null) ...[
                        Icon(
                          icon,
                          color: backgroundColor ?? AppColors.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                      ],
                      Text(
                        text,
                        style: TextStyle(
                          color: textColor ?? backgroundColor ?? AppColors.primary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
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

/// Small icon button with glass effect
class GlassIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final double size;
  final Color? iconColor;
  final Color? backgroundColor;
  final double borderRadius;
  final bool hasBorder;

  const GlassIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.size = 48,
    this.iconColor,
    this.backgroundColor,
    this.borderRadius = 12,
    this.hasBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: backgroundColor ?? 
              (isDark ? AppColors.darkGlassWhite : AppColors.lightGlassHighlight),
          borderRadius: BorderRadius.circular(borderRadius),
          border: hasBorder ? Border.all(
            color: isDark ? AppColors.darkGlassBorder : AppColors.lightGlassBorder,
            width: 1,
          ) : null,
        ),
        child: Icon(
          icon,
          color: iconColor ?? 
              (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
          size: size * 0.5,
        ),
      ),
    );
  }
}

/// Toggle Button (for online/offline status)
class GlassToggleButton extends StatelessWidget {
  final bool isOn;
  final ValueChanged<bool>? onChanged;
  final String? labelOn;
  final String? labelOff;
  final IconData? iconOn;
  final IconData? iconOff;

  const GlassToggleButton({
    super.key,
    required this.isOn,
    this.onChanged,
    this.labelOn,
    this.labelOff,
    this.iconOn,
    this.iconOff,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return GestureDetector(
      onTap: () => onChanged?.call(!isOn),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isOn 
              ? AppColors.success.withOpacity(0.2) 
              : (isDark ? AppColors.darkGlassWhite : AppColors.lightGlassHighlight),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isOn 
                ? AppColors.success 
                : (isDark ? AppColors.darkGlassBorder : AppColors.lightGlassBorder),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isOn ? AppColors.success : AppColors.offline,
              ),
            ),
            const SizedBox(width: 8),
            if (iconOn != null || iconOff != null) ...[
              Icon(
                isOn ? iconOn : iconOff,
                size: 16,
                color: isOn 
                    ? AppColors.success 
                    : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
              ),
              const SizedBox(width: 6),
            ],
            Text(
              isOn ? (labelOn ?? 'On') : (labelOff ?? 'Off'),
              style: TextStyle(
                color: isOn 
                    ? AppColors.success 
                    : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
