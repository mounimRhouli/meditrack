import 'dart:io';
import '../../../core/database/database_helper.dart';
import '../models/medical_document.dart';
import '../data_sources/file_storage_data_source.dart';
import '../services/file_manager_service.dart';

class DocumentRepository {
  final DatabaseHelper _dbHelper;
  final FileStorageDataSource _remoteStorage;
  final FileManagerService _fileManager;

  DocumentRepository(this._dbHelper, this._remoteStorage, this._fileManager);

  Future<void> addDocument(MedicalDocument doc, File originalFile) async {
    // 1. Save File Locally
    final String localPath = await _fileManager.saveFileLocally(originalFile, "${doc.id}.jpg");
    
    // 2. Save Metadata to Local SQLite
    final db = await _dbHelper.database;
    await db.insert('documents', doc.toJson());

    // 3. (Optional Background Task) Sync to Firebase Storage & Firestore
    // For Phase 3, we attempt immediate sync:
    try {
      final String remoteUrl = await _remoteStorage.uploadFile(
        originalFile, 
        "users/${doc.userId}/docs/${doc.id}.jpg"
      );
      // Update local record with remote URL and status
      await db.update(
        'documents', 
        {'remote_url': remoteUrl, 'sync_status': 'synced'},
        where: 'id = ?', 
        whereArgs: [doc.id]
      );
    } catch (e) {
      // Sync remains 'pending', Phase 3 Sync Engine will retry
    }
  }

  Future<List<MedicalDocument>> getDocuments(String userId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'documents', 
      where: 'user_id = ?', 
      whereArgs: [userId]
    );
    return maps.map((m) => MedicalDocument.fromJson(m)).toList();
  }
}