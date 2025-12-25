import 'package:flutter/material.dart';

class ProfileInfoCard extends StatelessWidget {
  final String? bloodType;
  final double? height;
  final double? weight;

  const ProfileInfoCard({Key? key, this.bloodType, this.height, this.weight})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem(context, Icons.bloodtype, 'Blood', bloodType ?? '-'),
            _buildDivider(),
            _buildStatItem(
              context,
              Icons.height,
              'Height',
              height != null ? '${height}cm' : '-',
            ),
            _buildDivider(),
            _buildStatItem(
              context,
              Icons.monitor_weight,
              'Weight',
              weight != null ? '${weight}kg' : '-',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Column(
      children: [
        Icon(icon, color: Theme.of(context).primaryColor, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(height: 40, width: 1, color: Colors.grey.shade300);
  }
}
