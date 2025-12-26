import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart'; // Ensure you have the 'uuid' package in pubspec.yaml

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

  // --- BP Controllers ---
  final _systolicController = TextEditingController();
  final _diastolicController = TextEditingController();
  final _pulseController = TextEditingController();

  // --- Pain State ---
  double _painValue = 0; // 0 means no entry
  final _painLocationController = TextEditingController();

  // --- Mood State ---
  MoodType? _selectedMood;
  final _noteController = TextEditingController();

  @override
  void dispose() {
    _systolicController.dispose();
    _diastolicController.dispose();
    _pulseController.dispose();
    _painLocationController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _submitLog() async {
    if (!_formKey.currentState!.validate()) return;

    final user = context.read<AuthViewModel>().user;
    if (user == null) return;

    // 1. Construct Sub-models (only if data is provided)
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
    if (_selectedMood != null) {
      mood = Mood(value: _selectedMood!);
    }

    // 2. Validation: Ensure at least one thing is logged
    if (bp == null &&
        pain == null &&
        mood == null &&
        _noteController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter at least one symptom to save."),
        ),
      );
      return;
    }

    // 3. Create Entry
    final entry = SymptomEntry(
      id: const Uuid().v4(), // Generate unique ID
      userId: user.id,
      timestamp: DateTime.now(),
      bloodPressure: bp,
      pain: pain,
      mood: mood,
      note: _noteController.text.isNotEmpty ? _noteController.text : null,
      isSynced: false, // Starts dirty until repo confirms sync
    );

    // 4. Send to ViewModel
    final success = await context.read<SymptomsViewModel>().addSymptom(entry);

    if (success && mounted) {
      Navigator.pop(context); // Go back to list
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Check-in')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSectionHeader(Icons.favorite, "Blood Pressure", Colors.red),
              _buildBPCard(),
              const SizedBox(height: 16),

              _buildSectionHeader(Icons.healing, "Pain Level", Colors.orange),
              _buildPainCard(),
              const SizedBox(height: 16),

              _buildSectionHeader(Icons.mood, "Mood", Colors.blue),
              _buildMoodCard(),
              const SizedBox(height: 16),

              _buildSectionHeader(Icons.note, "Notes", Colors.grey),
              TextFormField(
                controller: _noteController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: "Anything else to add? (e.g. Took medication)",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 32),

              ElevatedButton(
                onPressed: _submitLog,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text("SAVE ENTRY", style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(IconData icon, String title, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildBPCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _systolicController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Systolic (Top)'),
              ),
            ),
            const SizedBox(width: 16),
            const Text("/", style: TextStyle(fontSize: 24, color: Colors.grey)),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: _diastolicController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Diastolic (Bot)'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPainCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Intensity (1-10)"),
                Text(
                  _painValue == 0 ? "None" : "${_painValue.round()}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Slider(
              value: _painValue,
              min: 0,
              max: 10,
              divisions: 10,
              label: _painValue.round().toString(),
              activeColor: Colors.orange,
              onChanged: (val) => setState(() => _painValue = val),
            ),
            if (_painValue > 0)
              TextFormField(
                controller: _painLocationController,
                decoration: const InputDecoration(
                  labelText: 'Where does it hurt?',
                  prefixIcon: Icon(Icons.location_on_outlined),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodCard() {
    // A simple Wrap of ChoiceChips for Mood
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Wrap(
          spacing: 8.0,
          children: MoodType.values.map((mood) {
            final isSelected = _selectedMood == mood;
            return ChoiceChip(
              label: Text(mood.name.toUpperCase()),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedMood = selected ? mood : null;
                });
              },
              selectedColor: Colors.blue.shade100,
            );
          }).toList(),
        ),
      ),
    );
  }
}
