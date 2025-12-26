import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/medical_document.dart';
import '../repositories/document_repository.dart';

class DocumentsState {
  final bool isLoading;
  final List<MedicalDocument> documents;
  final String? errorMessage;

  DocumentsState({
    this.isLoading = false,
    this.documents = const [],
    this.errorMessage,
  });

  DocumentsState copyWith({
    bool? isLoading,
    List<MedicalDocument>? documents,
    String? errorMessage,
  }) {
    return DocumentsState(
      isLoading: isLoading ?? this.isLoading,
      documents: documents ?? this.documents,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class DocumentsViewModel extends StateNotifier<DocumentsState> {
  final DocumentRepository _repository;

  DocumentsViewModel(this._repository) : super(DocumentsState());

  /// Fetches all documents for a specific user.
  Future<void> fetchDocuments(String userId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final docs = await _repository.getDocuments(userId);
      state = state.copyWith(isLoading: false, documents: docs);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  /// Coordinates adding a document: local save, DB entry, and cloud sync.
  Future<void> addDocument(MedicalDocument doc, File file) async {
    state = state.copyWith(isLoading: true);
    try {
      await _repository.addDocument(doc, file);
      await fetchDocuments(doc.userId); // Refresh the list
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }
}