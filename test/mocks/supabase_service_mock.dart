import 'package:mockito/mockito.dart';
import 'package:speakmobilemvp/core/services/backend/supabase_service.dart';

class MockSupabaseService extends Mock implements SupabaseService {
  @override
  Future<String?> uploadVoiceClip(
    String filePath, {
    required String category,
    required String language,
    String? description,
    Map<String, dynamic>? culturalMetadata,
  }) async {
    return super.noSuchMethod(
      Invocation.method(#uploadVoiceClip, [filePath], {
        #category: category,
        #language: language,
        #description: description,
        #culturalMetadata: culturalMetadata,
      }),
      returnValue: Future.value(null),
    );
  }

  @override
  Future<List<Map<String, dynamic>>> getUserVoicePreservations() async {
    return super.noSuchMethod(
      Invocation.method(#getUserVoicePreservations, []),
      returnValue: Future.value(<Map<String, dynamic>>[]),
    );
  }

  @override
  Future<void> updateVoicePreservation({
    required String preservationId,
    String? category,
    String? language,
    String? description,
    Map<String, dynamic>? culturalMetadata,
  }) async {
    return super.noSuchMethod(
      Invocation.method(#updateVoicePreservation, [], {
        #preservationId: preservationId,
        #category: category,
        #language: language,
        #description: description,
        #culturalMetadata: culturalMetadata,
      }),
    );
  }
}
