import '../../../shared/models/sync_status.dart';
import 'document_type.dart';

class MedicalDocument {
  final String id;
  final String userId;
  final String name;
  final DocumentType type;
  final String localPath;
  final String? remoteUrl;
  final String? ocrText;
  final DateTime uploadDate;
  final SyncStatus syncStatus;

  MedicalDocument({
    required this.id,
    required this.userId,
    required this.name,
    required this.type,
    required this.localPath,
    this.remoteUrl,
    this.ocrText,
    required this.uploadDate,
    this.syncStatus = SyncStatus.pending,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'type': type.name,
      'local_path': localPath,
      'remote_url': remoteUrl,
      'ocr_text': ocrText,
      'upload_date': uploadDate.millisecondsSinceEpoch,
      'sync_status': syncStatus.name,
    };
  }

  factory MedicalDocument.fromJson(Map<String, dynamic> json) {
    return MedicalDocument(
      id: json['id'],
      userId: json['user_id'],
      name: json['name'],
      type: DocumentType.values.byName(json['type']),
      localPath: json['local_path'],
      remoteUrl: json['remote_url'],
      ocrText: json['ocr_text'],
      uploadDate: DateTime.fromMillisecondsSinceEpoch(json['upload_date']),
      syncStatus: SyncStatus.values.byName(json['sync_status'] ?? 'pending'),
    );
  }
}
