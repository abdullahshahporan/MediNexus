import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_colors.dart';

/// Glass TextField - Input field with glass effect
class GlassTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final String? errorText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final FormFieldValidator<String>? validator;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLines;
  final int? minLines;
  final bool enabled;
  final FocusNode? focusNode;
  final bool autofocus;
  final TextCapitalization textCapitalization;

  const GlassTextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.onEditingComplete,
    this.validator,
    this.inputFormatters,
    this.maxLines = 1,
    this.minLines,
    this.enabled = true,
    this.focusNode,
    this.autofocus = false,
    this.textCapitalization = TextCapitalization.none,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: TextStyle(
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
        ],
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          autofocus: autofocus,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          onChanged: onChanged,
          onEditingComplete: onEditingComplete,
          validator: validator,
          inputFormatters: inputFormatters,
          maxLines: maxLines,
          minLines: minLines,
          enabled: enabled,
          textCapitalization: textCapitalization,
          style: TextStyle(
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            fontSize: 16,
          ),
          decoration: InputDecoration(
            hintText: hint,
            errorText: errorText,
            prefixIcon: prefixIcon != null
                ? Icon(
                    prefixIcon,
                    color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
                    size: 22,
                  )
                : null,
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: isDark ? AppColors.darkGlassWhite : AppColors.lightBg3,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: isDark ? AppColors.darkGlassBorder : AppColors.lightGlassBorder,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: isDark ? AppColors.darkGlassBorder : AppColors.lightGlassBorder,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.error, width: 2),
            ),
            hintStyle: TextStyle(
              color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
            ),
          ),
        ),
      ],
    );
  }
}

/// Search TextField with glass effect
class GlassSearchField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hint;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final VoidCallback? onSubmitted;

  const GlassSearchField({
    super.key,
    this.controller,
    this.hint,
    this.onChanged,
    this.onClear,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkGlassWhite : AppColors.lightBg3,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkGlassBorder : AppColors.lightGlassBorder,
        ),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        onSubmitted: (_) => onSubmitted?.call(),
        style: TextStyle(
          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          hintText: hint ?? 'Search...',
          hintStyle: TextStyle(
            color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
          ),
          suffixIcon: controller?.text.isNotEmpty == true
              ? IconButton(
                  icon: Icon(
                    Icons.close_rounded,
                    color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
                  ),
                  onPressed: () {
                    controller?.clear();
                    onClear?.call();
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}
