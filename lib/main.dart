// lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Core Imports
import 'core/constants/app_colors.dart';
import 'core/constants/app_strings.dart';

// Feature & Routing Imports
import 'routes/app_router.dart';
import 'providers/app_providers.dart'; // This will be created by the team

void main() {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(const MediTrackApp());
}

class MediTrackApp extends StatelessWidget {
  const MediTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MultiProvider is where you will wrap your app with all the necessary ViewModels/Services.
    // For now, it's empty, but it's ready for the team to add their providers.
    return MultiProvider(
      providers: AppProviders.providers, // This list will be populated by the team
      child: MaterialApp.router(
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
            bodyLarge: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16.0,
            ),
            bodyMedium: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14.0,
            ),
          ),
        ),
      ),
    );
  }}