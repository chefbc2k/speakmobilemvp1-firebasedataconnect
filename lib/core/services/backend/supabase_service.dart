import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart' as path;
import 'dart:io';
import 'cognitive_service.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;

  late final SupabaseClient _supabase;
  final CognitiveService _cognitiveService = CognitiveService();

  SupabaseService._internal() {
    _supabase = Supabase.instance.client;
  }

  /// Upload a voice clip with cultural metadata to Supabase
  Future<String?> uploadVoiceClip(
    String filePath, {
    required String category,
    required String language,
    String? description,
    Map<String, dynamic>? culturalMetadata,
  }) async {
    try {
      final fileName = path.basename(filePath);
      final userId = _supabase.auth.currentUser?.id;
      
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      // Analyze voice characteristics
      final transcription = await _cognitiveService.performTranscription(filePath);
      final voiceAnalysis = await _cognitiveService.analyzeTone(
        audioPath: filePath,
        transcription: transcription,
      );

      // Upload to the 'voice-preservations' bucket with organized structure
      final String storagePath = 'recordings/$userId/$category/$fileName';
      
      // Upload the file
      final file = File(filePath);
      await _supabase.storage
          .from('voice-preservations')
          .upload(storagePath, file);

      // Get the public URL
      final String publicUrl = _supabase.storage
          .from('voice-preservations')
          .getPublicUrl(storagePath);

      // Store metadata in the database
      await _storeVoiceMetadata(
        userId: userId,
        publicUrl: publicUrl,
        category: category,
        language: language,
        description: description,
        culturalMetadata: {
          ...?culturalMetadata,
          'voice_analysis': voiceAnalysis,
          'transcription': transcription,
        },
        fileName: fileName,
      );

      return publicUrl;
    } catch (e) {
      if (kDebugMode) {
        print('Error uploading voice preservation: $e');
      }
      return null;
    }
  }

  /// Store voice preservation metadata in Supabase database
  Future<void> _storeVoiceMetadata({
    required String userId,
    required String publicUrl,
    required String category,
    required String language,
    required String fileName,
    String? description,
    Map<String, dynamic>? culturalMetadata,
  }) async {
    try {
      await _supabase.from('voice_preservations').insert({
        'user_id': userId,
        'file_url': publicUrl,
        'category': category,
        'language': language,
        'description': description,
        'cultural_metadata': culturalMetadata,
        'file_name': fileName,
        'created_at': DateTime.now().toIso8601String(),
        'preservation_status': 'active',
        'analysis_version': '1.0',
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error storing voice metadata: $e');
      }
      rethrow;
    }
  }

  /// Fetch user's voice preservations with analysis
  Future<List<Map<String, dynamic>>> getUserVoicePreservations() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      final response = await _supabase
          .from('voice_preservations')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching voice preservations: $e');
      }
      return [];
    }
  }

  /// Update voice preservation metadata
  Future<void> updateVoicePreservation({
    required String preservationId,
    String? category,
    String? language,
    String? description,
    Map<String, dynamic>? culturalMetadata,
  }) async {
    try {
      final updates = <String, dynamic>{};
      if (category != null) updates['category'] = category;
      if (language != null) updates['language'] = language;
      if (description != null) updates['description'] = description;
      if (culturalMetadata != null) updates['cultural_metadata'] = culturalMetadata;

      await _supabase
          .from('voice_preservations')
          .update(updates)
          .eq('id', preservationId);
    } catch (e) {
      if (kDebugMode) {
        print('Error updating voice preservation: $e');
      }
      rethrow;
    }
  }
}
