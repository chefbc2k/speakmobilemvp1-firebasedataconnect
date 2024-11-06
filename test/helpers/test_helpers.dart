import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:speakmobilemvp/core/services/frontend/recording_service.dart';
import 'package:speakmobilemvp/core/services/backend/supabase_service.dart';
import 'package:speakmobilemvp/core/services/backend/cognitive_service.dart';
import 'package:speakmobilemvp/core/services/backend/audio_processor.dart';

// Mock class to handle named parameters for RecordingService
class RecordingServiceBase extends Mock implements RecordingService {
  @override
  Future<String?> stopRecording({
    required String category,
    required String language,
    String? description,
    Map<String, dynamic>? culturalMetadata,
  }) =>
      super.noSuchMethod(
        Invocation.method(#stopRecording, [], {
          #category: category,
          #language: language,
          #description: description,
          #culturalMetadata: culturalMetadata,
        }),
        returnValue: Future.value(null),
      );
}

// Mock class to handle named parameters for SupabaseService
class SupabaseServiceBase extends Mock implements SupabaseService {
  @override
  Future<String?> uploadVoiceClip(
    String filePath, {
    required String category,
    required String language,
    String? description,
    Map<String, dynamic>? culturalMetadata,
  }) =>
      super.noSuchMethod(
        Invocation.method(#uploadVoiceClip, [filePath], {
          #category: category,
          #language: language,
          #description: description,
          #culturalMetadata: culturalMetadata,
        }),
        returnValue: Future.value(null),
      );
}

// Mock class to handle AudioProcessor's return type
class AudioProcessorBase extends Mock implements AudioProcessor {
  @override
  Future<String> processAudio(String inputFilePath) =>
      super.noSuchMethod(
        Invocation.method(#processAudio, [inputFilePath]),
        returnValue: Future.value('processed_$inputFilePath'),
      );
}

@GenerateMocks([], customMocks: [
  MockSpec<RecordingServiceBase>(as: #MockRecordingService),
  MockSpec<SupabaseServiceBase>(as: #MockSupabaseService),
  MockSpec<CognitiveService>(as: #MockCognitiveService),
  MockSpec<AudioProcessorBase>(as: #MockAudioProcessor),
])
void main() {}
