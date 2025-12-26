import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/app_providers.dart';

class HistoryTestScreen extends ConsumerStatefulWidget {
  const HistoryTestScreen({super.key});

  @override
  ConsumerState<HistoryTestScreen> createState() => _HistoryTestScreenState();
}

class _HistoryTestScreenState extends ConsumerState<HistoryTestScreen> {
  @override
  void initState() {
    super.initState();
    // Use ref.read to trigger the initial load
    Future.microtask(() {
      final now = DateTime.now();
      ref.read(historyViewModelProvider.notifier).loadHistoryAndStats(
            now.subtract(const Duration(days: 7)),
            now,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    // Watch the state for automatic UI updates
    final state = ref.watch(historyViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Suivi d'Adhérence"),
        elevation: 0,
      ),
      body: state.isLoading 
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Professional Header with Brand Gradient
                Container(
                  padding: const EdgeInsets.all(24),
                  margin: const EdgeInsets.all(16),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF66BB6A), Color(0xFF42A5F5)], // Brand Colors
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "Taux d'adhérence (7 derniers jours)",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "${state.adherenceRate.toStringAsFixed(1)}%",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                if (state.errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(state.errorMessage!, style: const TextStyle(color: Colors.red)),
                  ),
                const Expanded(
                  child: Center(
                    child: Text(
                      "Liste des prises (Intégration Développeur C)",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}