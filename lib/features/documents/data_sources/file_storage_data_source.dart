import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class FileStorageDataSource {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadFile(File file, String remotePath) async {
    final ref = _storage.ref().child(remotePath);
    final uploadTask = await ref.putFile(file);
    return await uploadTask.ref.getDownloadURL();
  }

  Future<void> deleteRemoteFile(String remoteUrl) async {
    final ref = _storage.refFromURL(remoteUrl);
    await ref.delete();
  }
}