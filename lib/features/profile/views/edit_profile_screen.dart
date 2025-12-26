import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/text_styles.dart';
import '../viewmodels/profile_viewmodel.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _heightController;
  late TextEditingController _weightController;
  String? _selectedBloodType;

  final List<String> _bloodTypes = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-',
  ];

  @override
  void initState() {
    super.initState();
    final profile = context.read<ProfileViewModel>().profile;
    _heightController = TextEditingController(
      text: profile?.height?.toString() ?? '',
    );
    _weightController = TextEditingController(
      text: profile?.weight?.toString() ?? '',
    );
    _selectedBloodType = profile?.bloodType;
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      context.read<ProfileViewModel>().updateBasicInfo(
        height: double.tryParse(_heightController.text),
        weight: double.tryParse(_weightController.text),
        bloodType: _selectedBloodType,
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.edit),
        actions: [
          IconButton(icon: const Icon(Icons.check), onPressed: _saveProfile),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.paddingMedium),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppStrings.basicInfo, style: AppTextStyles.h2),
              const SizedBox(height: AppDimensions.paddingMedium),

              TextFormField(
                controller: _heightController,
                decoration: const InputDecoration(
                  labelText: AppStrings.height,
                  prefixIcon: Icon(Icons.height),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: AppDimensions.paddingMedium),

              TextFormField(
                controller: _weightController,
                decoration: const InputDecoration(
                  labelText: AppStrings.weight,
                  prefixIcon: Icon(Icons.monitor_weight),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: AppDimensions.paddingMedium),

              DropdownButtonFormField<String>(
                value: _bloodTypes.contains(_selectedBloodType)
                    ? _selectedBloodType
                    : null,
                decoration: const InputDecoration(
                  labelText: AppStrings.bloodType,
                  prefixIcon: Icon(Icons.bloodtype),
                ),
                items: _bloodTypes
                    .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                    .toList(),
                onChanged: (val) => setState(() => _selectedBloodType = val),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
