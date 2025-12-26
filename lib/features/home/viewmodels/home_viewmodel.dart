// lib/features/home/viewmodels/home_viewmodel.dart

import 'package:flutter/material.dart';
import 'package:meditrack/features/home/models/dashboard_data.dart';
import 'package:meditrack/features/home/repositories/home_repository.dart';

class HomeViewModel extends ChangeNotifier {
  final HomeRepository repository;

  HomeViewModel({required this.repository});

  DashboardData? _dashboardData;
  bool _isLoading = false;
  String? _error;

  DashboardData? get dashboardData => _dashboardData;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadDashboardData() async {
    _setLoading(true);
    try {
      _dashboardData = await repository.getDashboardData();
      _error = null;
    } catch (e) {
      _error = 'Impossible de charger les données du tableau de bord.';
      debugPrint('Erreur Home ViewModel: $e');
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}