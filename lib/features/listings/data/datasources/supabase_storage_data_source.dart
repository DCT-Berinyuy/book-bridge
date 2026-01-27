import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:book_bridge/core/error/exceptions.dart';

/// Data source for storage operations using Supabase Storage.
///
/// This class handles all file upload/download operations to/from Supabase Storage.
class SupabaseStorageDataSource {
  final SupabaseClient supabaseClient;

  SupabaseStorageDataSource({required this.supabaseClient});

  /// Uploads an image file to Supabase Storage.
  ///
  /// The image is uploaded to the 'books' bucket with a unique filename.
  /// Returns the public URL of the uploaded image.
  ///
  /// Throws [ServerException] if the upload fails.
  Future<String> uploadBookImage(File imageFile) async {
    try {
      // Generate a unique filename using timestamp and random string
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final randomString = _generateRandomString(8);
      final fileName = 'book_${timestamp}_$randomString.jpg';

      // Read file bytes
      final bytes = await imageFile.readAsBytes();

      // Upload the file to the 'books' bucket using binary upload
      await Supabase.instance.client.storage
          .from('books')
          .uploadBinary(
            fileName,
            bytes,
            fileOptions: const FileOptions(
              upsert: true,
              contentType: 'image/jpeg',
            ),
          );

      // Return the public URL of the uploaded image
      final publicUrl = supabaseClient.storage
          .from('books')
          .getPublicUrl(fileName);
      return publicUrl;
    } on StorageException catch (e) {
      throw ServerException(message: 'Upload failed: ${e.message}');
    } catch (e) {
      throw ServerException(message: 'Upload failed: ${e.toString()}');
    }
  }

  /// Generates a random string of specified length.
  String _generateRandomString(int length) {
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = StringBuffer();

    for (int i = 0; i < length; i++) {
      random.write(chars[DateTime.now().microsecondsSinceEpoch % chars.length]);
    }

    return random.toString();
  }

  /// Deletes an image from Supabase Storage.
  ///
  /// Throws [ServerException] if the deletion fails.
  Future<void> deleteBookImage(String imagePath) async {
    try {
      // Extract filename from the URL
      final uri = Uri.parse(imagePath);
      final pathSegments = uri.pathSegments;
      final fileName = pathSegments.last;

      // Delete the file from the 'books' bucket
      await supabaseClient.storage.from('books').remove([fileName]);
    } on StorageException catch (e) {
      throw ServerException(message: 'Deletion failed: ${e.message}');
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
