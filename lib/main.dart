// lib/main.dart

import 'package:flutter/material.dart';
// 1. CHANGE: Import flutter_riverpod instead of provider
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Core Imports
import 'core/constants/app_colors.dart';
import 'core/constants/app_strings.dart';

// Feature & Routing Imports
import 'routes/app_router.dart';
// NOTE: We no longer need to import AppProviders here directly for the MultiProvider widget.
// Providers will be read directly by the widgets that need them.

void main() {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // 2. CHANGE: Wrap your app with ProviderScope
  // This is the essential Riverpod widget that stores the state of all your providers.
  runApp(const ProviderScope(child: MediTrackApp()));
}

class MediTrackApp extends StatelessWidget {
  const MediTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 3. Your MaterialApp.router remains the same
    // It is correctly configured and does not need to be changed.
    return MaterialApp.router(
      // --- Router Configuration ---
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false, // Set to false for production builds
      // --- App Configuration ---
      title: AppStrings.appName,

      // --- Theme Configuration ---
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textInverse,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
            color: AppColors.textInverse,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.textInverse,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.surface,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 12.0,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: AppColors.primary),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: AppColors.error),
          ),
          hintStyle: const TextStyle(color: AppColors.textSecondary),
          labelStyle: const TextStyle(color: AppColors.textPrimary),
        ),
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 22.0,
          ),
          bodyLarge: TextStyle(color: AppColors.textSecondary, fontSize: 16.0),
          bodyMedium: TextStyle(color: AppColors.textPrimary, fontSize: 14.0),
        ),
      ),
    );
  }
}
