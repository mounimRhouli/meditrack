// lib/providers/app_providers.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

/// This file will be populated by the team with all necessary ViewModels and Services.
/// It acts as a central registry for dependency injection.
class AppProviders {
  // --- UPDATED: Let Dart infer the type for robustness ---
  // This is a common pattern that avoids potential IDE resolution issues.
  static final providers = <SingleChildWidget>[
    // TODO: Add all providers here
    Provider.value(value: 0)
    // Example:
    // ChangeNotifierProvider(create: (_) => AuthViewModel()),
    // ChangeNotifierProvider(create: (_) => HomeViewModel()),
    // ... and so on for all features
  ];
}