import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart'; // Requires 'fl_chart' in pubspec.yaml

import '../../auth/viewmodels/auth_viewmodel.dart';
import '../viewmodels/symptom_charts_viewmodel.dart';

class SymptomChartsScreen extends StatefulWidget {
  const SymptomChartsScreen({Key? key}) : super(key: key);

  @override
  State<SymptomChartsScreen> createState() => _SymptomChartsScreenState();
}

class _SymptomChartsScreenState extends State<SymptomChartsScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch chart data on load
    Future.microtask(() {
      final user = context.read<AuthViewModel>().user;
      if (user != null) {
        context.read<SymptomChartsViewModel>().loadWeeklyStats(user.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Weekly Trends')),
      body: Consumer<SymptomChartsViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.status == ChartStatus.error) {
            return Center(
              child: Text(viewModel.errorMessage ?? 'Error loading charts'),
            );
          }

          if (viewModel.totalReadings == 0) {
            return const Center(
              child: Text("No blood pressure data recorded this week."),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Summary Card
                _buildSummaryCard(viewModel),
                const SizedBox(height: 24),

                // 2. The Chart
                Text(
                  "Average BP vs. Normal",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                const Text(
                  "Comparing your weekly average to standard levels (120/80).",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 24),

                SizedBox(height: 300, child: _buildBarChart(viewModel)),
              ],
            ),
          );
        },
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // WIDGET: Text Summary
  // ---------------------------------------------------------------------------
  Widget _buildSummaryCard(SymptomChartsViewModel vm) {
    return Card(
      color: Colors.blue.shade50,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Text(
              "This Week's Average",
              style: TextStyle(color: Colors.blueGrey),
            ),
            const SizedBox(height: 8),
            Text(
              "${vm.avgSystolic} / ${vm.avgDiastolic}",
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            Text(
              "Based on ${vm.totalReadings} readings",
              style: const TextStyle(fontSize: 12, color: Colors.blueGrey),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // WIDGET: FL Chart Implementation
  // ---------------------------------------------------------------------------
  Widget _buildBarChart(SymptomChartsViewModel vm) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 200, // Cap chart at 200 mmHg
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            // tooltipBgColor: Colors.blueGrey, // Uncomment for older fl_chart versions
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                '${rod.toY.round()}',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, TitleMeta meta) {
                switch (value.toInt()) {
                  case 0:
                    return const Text('Systolic');
                  case 1:
                    return const Text('Diastolic');
                  default:
                    return const Text('');
                }
              },
            ),
          ),
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ), // Hide left numbers
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 40, // Lines every 40 units
        ),
        borderData: FlBorderData(show: false),
        barGroups: [
          // Bar 1: Systolic
          BarChartGroupData(
            x: 0,
            barRods: [
              BarChartRodData(
                toY: vm.avgSystolic.toDouble(),
                color: vm.avgSystolic > 120 ? Colors.redAccent : Colors.green,
                width: 40,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          ),
          // Bar 2: Diastolic
          BarChartGroupData(
            x: 1,
            barRods: [
              BarChartRodData(
                toY: vm.avgDiastolic.toDouble(),
                color: vm.avgDiastolic > 80
                    ? Colors.orangeAccent
                    : Colors.green,
                width: 40,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
