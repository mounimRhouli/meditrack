import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class FileManagerService {
  Future<String> saveFileLocally(File file, String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final String documentsPath = path.join(directory.path, 'medical_docs');
    
    final Directory docsDir = Directory(documentsPath);
    if (!await docsDir.exists()) {
      await docsDir.create(recursive: true);
    }

    final String filePath = path.join(documentsPath, fileName);
    final File localFile = await file.copy(filePath);
    return localFile.path;
  }

  Future<void> deleteFile(String filePath) async {
    final file = File(filePath);
    if (await file.exists()) {
      await file.delete();
    }
  }
}