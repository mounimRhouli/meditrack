import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/text_styles.dart';

class DiseaseListItem extends StatelessWidget {
  final String diseaseName;
  final String? diagnosedDate;

  const DiseaseListItem({
    Key? key,
    required this.diseaseName,
    this.diagnosedDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: const Icon(
          Icons.medical_services_outlined,
          color: AppColors.primary,
        ),
        title: Text(
          diseaseName,
          style: AppTextStyles.bodyLg.copyWith(fontWeight: FontWeight.w600),
        ),
        subtitle: diagnosedDate != null
            ? Text("Depuis: $diagnosedDate", style: AppTextStyles.bodySm)
            : null,
      ),
    );
  }
}
