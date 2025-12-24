// lib/shared/widgets/custom_app_bar.dart

import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_strings.dart';
import '../extensions/context_extensions.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final bool centerTitle;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;
  final VoidCallback? onBackPressed;

  const CustomAppBar({
    super.key,
    this.title,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.centerTitle = true,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    // Use theme colors if none are provided
    final theme = context.colorScheme;
    final appBarBgColor = backgroundColor ?? theme.primary;
    final appBarFgColor = foregroundColor ?? theme.onPrimary;

    return AppBar(
      title: title != null
          ? Text(
              title!,
              style: TextStyle(
                color: appBarFgColor,
                fontWeight: FontWeight.w600,
              ),
            )
          : null,
      centerTitle: centerTitle,
      backgroundColor: appBarBgColor,
      foregroundColor: appBarFgColor,
      elevation: elevation ?? 0, // Default to no shadow for a flatter look
      leading: leading ??
          (automaticallyImplyLeading && Navigator.canPop(context)
              ? IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: appBarFgColor,
                  ),
                  onPressed: onBackPressed ?? () => context.pop(),
                )
              : null),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}