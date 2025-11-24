import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Upload file
  Future<String> uploadFile({
    required File file,
    required String path,
    String? fileName,
  }) async {
    try {
      final name = fileName ?? DateTime.now().millisecondsSinceEpoch.toString();
      final ref = _storage.ref().child('$path/$name');

      final uploadTask = await ref.putFile(file);
      final downloadUrl = await uploadTask.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      throw Exception('Failed to upload file: $e');
    }
  }

  // Upload product image
  Future<String> uploadProductImage(File file, String productId) async {
    return await uploadFile(
      file: file,
      path: 'products/$productId',
    );
  }

  // Upload avatar
  Future<String> uploadAvatar(File file, String userId) async {
    return await uploadFile(
      file: file,
      path: 'avatars',
      fileName: userId,
    );
  }

  // Delete file
  Future<void> deleteFile(String url) async {
    try {
      final ref = _storage.refFromURL(url);
      await ref.delete();
    } catch (e) {
      throw Exception('Failed to delete file: $e');
    }
  }

  // Get download URL
  Future<String> getDownloadUrl(String path) async {
    try {
      final ref = _storage.ref().child(path);
      return await ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to get download URL: $e');
    }
  }
}
