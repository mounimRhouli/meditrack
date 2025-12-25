import 'package:flutter/material.dart';
import '../../models/allergy.dart';

class AllergyListItem extends StatelessWidget {
  final Allergy allergy;
  final VoidCallback? onTap;

  const AllergyListItem({Key? key, required this.allergy, this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 0,
      color: Colors.grey.shade50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: _getSeverityColor(allergy.severity).withOpacity(0.2),
          child: Icon(
            Icons.warning_amber_rounded,
            color: _getSeverityColor(allergy.severity),
          ),
        ),
        title: Text(
          allergy.name,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(allergy.reaction ?? 'No reaction details'),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _getSeverityColor(allergy.severity).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            allergy.severity.toUpperCase(),
            style: TextStyle(
              color: _getSeverityColor(allergy.severity),
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Color _getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'severe':
      case 'high':
        return Colors.red;
      case 'moderate':
      case 'medium':
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }
}
