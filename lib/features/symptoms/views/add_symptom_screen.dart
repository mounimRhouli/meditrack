import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/text_styles.dart';
import '../../auth/viewmodels/auth_viewmodel.dart';
import '../models/symptom_entry.dart';
import '../models/blood_pressure.dart';
import '../models/pain_level.dart';
import '../models/mood.dart';
import '../viewmodels/symptoms_viewmodel.dart';

class AddSymptomScreen extends StatefulWidget {
  const AddSymptomScreen({Key? key}) : super(key: key);

  @override
  State<AddSymptomScreen> createState() => _AddSymptomScreenState();
}

class _AddSymptomScreenState extends State<AddSymptomScreen> {
  final _formKey = GlobalKey<FormState>();
  final _systolicController = TextEditingController();
  final _diastolicController = TextEditingController();
  final _pulseController = TextEditingController();
  double _painValue = 0;
  final _painLocationController = TextEditingController();
  MoodType? _selectedMood;
  final _noteController = TextEditingController();

  void _submitLog() async {
    if (!_formKey.currentState!.validate()) return;
    final user = context.read<AuthViewModel>().user;
    if (user == null) return;

    BloodPressure? bp;
    if (_systolicController.text.isNotEmpty &&
        _diastolicController.text.isNotEmpty) {
      bp = BloodPressure(
        systolic: int.parse(_systolicController.text),
        diastolic: int.parse(_diastolicController.text),
        pulse: int.tryParse(_pulseController.text),
      );
    }

    PainLevel? pain;
    if (_painValue > 0) {
      pain = PainLevel(
        value: _painValue.round(),
        location: _painLocationController.text.isNotEmpty
            ? _painLocationController.text
            : null,
      );
    }

    Mood? mood;
    if (_selectedMood != null) mood = Mood(value: _selectedMood!);

    if (bp == null &&
        pain == null &&
        mood == null &&
        _noteController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez entrer au moins un symptôme.")),
      );
      return;
    }

    final entry = SymptomEntry(
      id: const Uuid().v4(),
      userId: user.id,
      timestamp: DateTime.now(),
      bloodPressure: bp,
      pain: pain,
      mood: mood,
      note: _noteController.text.isNotEmpty ? _noteController.text : null,
      isSynced: false,
    );

    final success = await context.read<SymptomsViewModel>().addSymptom(entry);
    if (success && mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.addSymptomTitle)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.paddingMedium),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(
                Icons.favorite,
                AppStrings.bloodPressure,
                AppColors.error,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _systolicController,
                      decoration: const InputDecoration(labelText: 'SYS'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text("/"),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _diastolicController,
                      decoration: const InputDecoration(labelText: 'DIA'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppDimensions.paddingLarge),

              _buildHeader(Icons.healing, AppStrings.pain, AppColors.warning),
              Slider(
                value: _painValue,
                min: 0,
                max: 10,
                divisions: 10,
                label: _painValue.round().toString(),
                activeColor: AppColors.warning,
                onChanged: (val) => setState(() => _painValue = val),
              ),
              if (_painValue > 0)
                TextFormField(
                  controller: _painLocationController,
                  decoration: const InputDecoration(
                    labelText: AppStrings.painLocation,
                  ),
                ),

              const SizedBox(height: AppDimensions.paddingLarge),

              _buildHeader(Icons.mood, AppStrings.mood, AppColors.primary),
              Wrap(
                spacing: 8,
                children: MoodType.values.map((m) {
                  final selected = _selectedMood == m;
                  return ChoiceChip(
                    label: Text(m.name),
                    selected: selected,
                    onSelected: (val) =>
                        setState(() => _selectedMood = val ? m : null),
                  );
                }).toList(),
              ),

              const SizedBox(height: AppDimensions.paddingLarge),

              TextFormField(
                controller: _noteController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: AppStrings.notes),
              ),

              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _submitLog,
                child: const Text(AppStrings.saveEntry),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(IconData icon, String title, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 8),
          Text(title, style: AppTextStyles.h3),
        ],
      ),
    );
  }
}
