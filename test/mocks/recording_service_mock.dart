import 'package:mockito/mockito.dart';
import 'package:speakmobilemvp/core/services/frontend/recording_service.dart';

class MockRecordingService extends Mock implements RecordingService {
  @override
  Future<String?> stopRecording({
    required String category,
    required String language,
    String? description,
    Map<String, dynamic>? culturalMetadata,
  }) async {
    return super.noSuchMethod(
      Invocation.method(#stopRecording, [], {
        #category: category,
        #language: language,
        #description: description,
        #culturalMetadata: culturalMetadata,
      }),
      returnValue: Future.value(null),
    );
  }

  @override
  Future<String?> startRecording() async {
    return super.noSuchMethod(
      Invocation.method(#startRecording, []),
      returnValue: Future.value(null),
    );
  }

  @override
  Future<bool> requestAllPermissions() async {
    return super.noSuchMethod(
      Invocation.method(#requestAllPermissions, []),
      returnValue: Future.value(true),
    );
  }

  @override
  Future<double> getAmplitude() async {
    return super.noSuchMethod(
      Invocation.method(#getAmplitude, []),
      returnValue: Future.value(0.0),
    );
  }

  @override
  bool get isRecording => super.noSuchMethod(
    Invocation.getter(#isRecording),
    returnValue: false,
  );
}
