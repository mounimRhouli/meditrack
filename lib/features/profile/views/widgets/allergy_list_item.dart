import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/text_styles.dart';

class AllergyListItem extends StatelessWidget {
  final String allergy;

  const AllergyListItem({Key? key, required this.allergy}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      surfaceTintColor: Colors.white,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: const Icon(
          Icons.warning_amber_rounded,
          color: AppColors.error,
        ),
        title: Text(
          allergy,
          style: AppTextStyles.bodyLg.copyWith(
            color: AppColors.error,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
