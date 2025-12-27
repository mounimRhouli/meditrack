// lib/routes/route_guards.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'route_names.dart';

// This acts as a placeholder for a real Database check later
bool isProfileComplete = true; 

String? authGuard(BuildContext context, GoRouterState state) {
  // Compiler no longer sees this as "dead code" because 
  // 'isProfileComplete' is a variable that can change.
  if (!isProfileComplete && state.matchedLocation != AppRouteNames.profile) {
    return AppRouteNames.profile;
  }

  return null; 
}