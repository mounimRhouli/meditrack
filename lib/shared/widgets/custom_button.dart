// lib/shared/widgets/custom_button.dart

import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final bool isLoading;
  final double? width;
  final double? height;
  final bool isSecondary; // To use secondary color

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.isLoading = false,
    this.width,
    this.height,
    this.isSecondary = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final buttonColor = backgroundColor ?? (isSecondary ? AppColors.secondary : AppColors.primary);
    final buttonTextColor = textColor ?? AppColors.textInverse;

    return SizedBox(
      width: width,
      height: height ?? 48.0,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          foregroundColor: buttonTextColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          ),
          elevation: 2,
        ),
        child: isLoading
            ? SizedBox(
                width: AppDimensions.iconMedium,
                height: AppDimensions.iconMedium,
                child: CircularProgressIndicator(
                  color: buttonTextColor,
                  strokeWidth: 2.0,
                ),
              )
            : Text(
                text,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  color: buttonTextColor,
                ),
              ),
      ),
    );
  }
}