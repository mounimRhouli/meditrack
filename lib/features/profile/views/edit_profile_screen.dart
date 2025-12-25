import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/profile_viewmodel.dart';
import '../models/user_profile.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
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
    // Initialize with current data
    final profile = context.read<ProfileViewModel>().profile;
    _heightController = TextEditingController(
      text: profile?.height?.toString() ?? '',
    );
    _weightController = TextEditingController(
      text: profile?.weight?.toString() ?? '',
    );
    _selectedBloodType = profile?.bloodType;
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      final double? height = double.tryParse(_heightController.text);
      final double? weight = double.tryParse(_weightController.text);

      context.read<ProfileViewModel>().updateBasicInfo(
        height: height,
        weight: weight,
        bloodType: _selectedBloodType,
      );

      Navigator.pop(context); // Return to Profile Screen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          IconButton(icon: const Icon(Icons.check), onPressed: _saveProfile),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Basic Information',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Height Field
              TextFormField(
                controller: _heightController,
                decoration: const InputDecoration(
                  labelText: 'Height (cm)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.height),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    if (double.tryParse(value) == null) return 'Invalid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Weight Field
              TextFormField(
                controller: _weightController,
                decoration: const InputDecoration(
                  labelText: 'Weight (kg)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.monitor_weight),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    if (double.tryParse(value) == null) return 'Invalid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Blood Type Dropdown
              DropdownButtonFormField<String>(
                value: _bloodTypes.contains(_selectedBloodType)
                    ? _selectedBloodType
                    : null,
                decoration: const InputDecoration(
                  labelText: 'Blood Type',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.bloodtype),
                ),
                items: _bloodTypes.map((type) {
                  return DropdownMenuItem(value: type, child: Text(type));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedBloodType = value;
                  });
                },
              ),

              const SizedBox(height: 32),

              // Note: Adding Allergies/Diseases is usually complex enough
              // to warrant its own separate screen (e.g. "AddAllergyScreen"),
              // so we keep this screen focused on Vitals for Phase 2.
              const Center(
                child: Text(
                  "To add allergies or chronic diseases,\nplease contact your doctor.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
