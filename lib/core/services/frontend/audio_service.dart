import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/foundation.dart';

class AudioService {
  final _supabase = Supabase.instance.client;

  /// Uploads an audio file to Supabase storage and saves its metadata
  Future<void> saveAudioToSupabase({
    required String filePath,
    required String transcription,
    required Map<String, dynamic> metadata,
  }) async {
    try {
      final file = File(filePath);
      final fileName = path.basename(filePath);

      // Upload the audio file to Supabase storage
      await _supabase.storage.from('audio-files').upload(fileName, file);

      // Get the public URL of the uploaded file
      final fileUrl =
          _supabase.storage.from('audio-files').getPublicUrl(fileName);

      // Save metadata to the database
      await _supabase.from('audio_recordings').insert({
        'file_name': fileName,
        'file_url': fileUrl,
        'transcription': transcription,
        'metadata': metadata,
        'created_at': DateTime.now().toIso8601String(),
      });

      if (kDebugMode) {
        print('Audio file and metadata saved successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error saving audio to Supabase: $e');
      }
      rethrow;
    }
  }

  /// Retrieves audio recordings from Supabase
  Future<List<Map<String, dynamic>>> getAudioRecordings() async {
    try {
      final response = await _supabase
          .from('audio_recordings')
          .select()
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching audio recordings: $e');
      }
      rethrow;
    }
  }

  /// Deletes an audio recording and its associated file
  Future<void> deleteAudioRecording(String fileName) async {
    try {
      // Delete the file from storage
      await _supabase.storage.from('audio-files').remove([fileName]);

      // Delete the metadata from the database
      await _supabase
          .from('audio_recordings')
          .delete()
          .eq('file_name', fileName);

      if (kDebugMode) {
        print('Audio recording deleted successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting audio recording: $e');
      }
      rethrow;
    }
  }

  /// Updates the metadata of an audio recording
  Future<void> updateAudioMetadata(
      String fileName, Map<String, dynamic> newMetadata) async {
    try {
      await _supabase
          .from('audio_recordings')
          .update({'metadata': newMetadata}).eq('file_name', fileName);

      if (kDebugMode) {
        print('Audio metadata updated successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error updating audio metadata: $e');
      }
      rethrow;
    }
  }
}
