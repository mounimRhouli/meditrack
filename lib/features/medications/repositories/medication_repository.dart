import '../models/medication.dart';
import '../data_sources/medication_local_data_source.dart';

class MedicationRepository {
  final MedicationLocalDataSource _localDataSource;

  MedicationRepository(this._localDataSource);

  // FIX: Name matches MedicationFormViewModel.saveMedication()
  Future<void> addMedication(Medication medication) {
    return _localDataSource.insertMedication(medication);
  }

  // FIX: Name matches MedicationsListViewModel.loadMedications()
  Future<List<Medication>> getAllMedications() {
    return _localDataSource.fetchAll();
  }

  // FIX: Name matches MedicationsListViewModel.deleteMedication()
  Future<void> deleteMedication(String id) {
    return _localDataSource.removeById(id);
  }

  Future<List<Medication>> search(String query) {
    return _localDataSource.searchMedications(query);
  }
}