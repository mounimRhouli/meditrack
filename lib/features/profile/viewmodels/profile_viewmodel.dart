import 'package:flutter/foundation.dart';
import '../models/user_profile.dart';
import '../models/allergy.dart';
import '../models/chronic_disease.dart';
import '../repositories/profile_repository.dart';

enum ProfileStatus { initial, loading, loaded, error }

class ProfileViewModel extends ChangeNotifier {
  final ProfileRepository _profileRepository;

  // ---------------------------------------------------------------------------
  // State
  // ---------------------------------------------------------------------------
  ProfileStatus _status = ProfileStatus.initial;
  UserProfile? _profile;
  String? _errorMessage;

  ProfileViewModel({required ProfileRepository profileRepository})
    : _profileRepository = profileRepository;

  // Getters
  ProfileStatus get status => _status;
  UserProfile? get profile => _profile;
  String? get errorMessage => _errorMessage;

  bool get isLoading => _status == ProfileStatus.loading;
  bool get isError => _status == ProfileStatus.error;

  // ---------------------------------------------------------------------------
  // Actions: Fetching
  // ---------------------------------------------------------------------------
  Future<void> loadProfile(String userId) async {
    _status = ProfileStatus.loading;
    _errorMessage = null;
    notifyListeners();

    final result = await _profileRepository.getUserProfile(userId);

    if (result.isSuccess) {
      _profile = result.data;
      _status = ProfileStatus.loaded;
    } else {
      _status = ProfileStatus.error;
      _errorMessage = result.error?.message ?? "Failed to load profile";
    }
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // Actions: Updating (Individual Fields)
  // ---------------------------------------------------------------------------

  // Updates local state immediately, then calls repo to save
  Future<void> updateBasicInfo({
    double? height,
    double? weight,
    String? bloodType,
  }) async {
    if (_profile == null) return;

    // 1. Update State Optimistically
    final oldProfile = _profile!;
    _profile = _profile!.copyWith(
      height: height,
      weight: weight,
      bloodType: bloodType,
      isSynced: false, // Mark dirty until repo confirms save
    );
    notifyListeners();

    // 2. Persist to Repo
    final result = await _profileRepository.updateProfile(_profile!);

    if (!result.isSuccess) {
      // Revert or show error if save failed critically
      // For now, we just show error but keep local changes (Optimistic UI)
      _errorMessage = "Sync failed: Changes saved locally only.";
      notifyListeners();
    }
  }

  Future<void> addAllergy(Allergy allergy) async {
    if (_profile == null) return;

    final updatedList = List<Allergy>.from(_profile!.allergies)..add(allergy);
    _profile = _profile!.copyWith(allergies: updatedList, isSynced: false);
    notifyListeners();

    await _profileRepository.updateProfile(_profile!);
  }

  Future<void> addChronicDisease(ChronicDisease disease) async {
    if (_profile == null) return;

    final updatedList = List<ChronicDisease>.from(_profile!.chronicDiseases)
      ..add(disease);
    _profile = _profile!.copyWith(
      chronicDiseases: updatedList,
      isSynced: false,
    );
    notifyListeners();

    await _profileRepository.updateProfile(_profile!);
  }
}
