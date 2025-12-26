import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/text_styles.dart';
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
    Future.microtask(() {
      final user = context.read<AuthViewModel>().user;
      if (user != null)
        context.read<SymptomChartsViewModel>().loadWeeklyStats(user.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.trendsTitle)),
      body: Consumer<SymptomChartsViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading)
            return const Center(child: CircularProgressIndicator());
          if (viewModel.totalReadings == 0)
            return const Center(child: Text(AppStrings.noDataWeek));

          return Padding(
            padding: const EdgeInsets.all(AppDimensions.paddingMedium),
            child: Column(
              children: [
                Card(
                  color: AppColors.surfaceAlt,
                  child: Padding(
                    padding: const EdgeInsets.all(AppDimensions.paddingLarge),
                    child: Column(
                      children: [
                        Text("Moyenne Tension", style: AppTextStyles.bodyMd),
                        Text(
                          "${viewModel.avgSystolic}/${viewModel.avgDiastolic}",
                          style: AppTextStyles.h1.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  height: 300,
                  child: BarChart(
                    BarChartData(
                      barGroups: [
                        BarChartGroupData(
                          x: 0,
                          barRods: [
                            BarChartRodData(
                              toY: viewModel.avgSystolic.toDouble(),
                              color: AppColors.error,
                              width: 30,
                            ),
                          ],
                        ),
                        BarChartGroupData(
                          x: 1,
                          barRods: [
                            BarChartRodData(
                              toY: viewModel.avgDiastolic.toDouble(),
                              color: AppColors.warning,
                              width: 30,
                            ),
                          ],
                        ),
                      ],
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (val, _) {
                              if (val == 0) return const Text("SYS");
                              if (val == 1) return const Text("DIA");
                              return const Text("");
                            },
                          ),
                        ),
                        leftTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
