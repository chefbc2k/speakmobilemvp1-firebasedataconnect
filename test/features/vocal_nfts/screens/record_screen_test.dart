import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'dart:async';
import 'package:speakmobilemvp/features/vocal_nfts/screens/record_screen.dart';

import '../../../helpers/test_helpers.mocks.dart';

// Create a custom mock for RecorderController since it has a Stream
class MockRecorderController extends Mock implements RecorderController {
  final _durationController = StreamController<Duration>.broadcast();
  
  @override
  Stream<Duration> get onCurrentDuration => _durationController.stream;
  
  @override
  bool get isRecording => false;

  @override
  bool get shouldRefresh => false;

  @override
  bool get shouldClearLabels => false;

  @override
  Duration get updateFrequency => const Duration(milliseconds: 100);

  @override
  List<double> get waveData => List.filled(100, 0.5);

  @override
  Future<void> record({
    AndroidEncoder? androidEncoder,
    AndroidOutputFormat? androidOutputFormat, 
    int? bitRate,
    IosEncoder? iosEncoder,
    String? path,
    int? sampleRate
  }) async {
    return Future.value();
  }

  @override
  Future<String?> stop([bool? deleteFile]) async {
    return Future.value('test_path');
  }
  
  @override
  void dispose() {
    _durationController.close();
  }
}

void main() {
  late Widget testWidget;
  late MockRecordingService mockRecordingService;
  late MockAudioProcessor mockAudioProcessor;
  late MockRecorderController mockRecorderController;

  setUp(() {
    mockRecordingService = MockRecordingService();
    mockAudioProcessor = MockAudioProcessor();
    mockRecorderController = MockRecorderController();

    // Set up mock behaviors
    when(mockRecordingService.isRecording).thenReturn(false);
    when(mockRecordingService.startRecording())
        .thenAnswer((_) async => 'test_path');
    when(mockRecordingService.stopRecording(
      category: anyNamed('category'),
      language: anyNamed('language'),
      description: anyNamed('description'),
      culturalMetadata: anyNamed('culturalMetadata'),
    )).thenAnswer((_) async => 'test_url');
    when(mockRecordingService.requestAllPermissions())
        .thenAnswer((_) async => true);
    when(mockAudioProcessor.processAudio(any))
        .thenAnswer((_) async => 'processed_test_path');

    testWidget = MaterialApp(
      home: Material(
        child: MediaQuery(
          data: const MediaQueryData(),
          child: Scaffold(
            body: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 600),
              child: SingleChildScrollView(
                child: RecordScreen(
                  recordingService: mockRecordingService,
                  audioProcessor: mockAudioProcessor,
                  recorderController: mockRecorderController,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  });

  tearDown(() {
    mockRecorderController.dispose();
  });

  group('RecordScreen UI Tests', () {
    testWidgets('shows initial voice preservation UI', (WidgetTester tester) async {
      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();
      
      expect(find.text('Create Your Voice Legacy'), findsOneWidget);
      expect(find.text('Preserve your voice for future generations'), findsOneWidget);
      expect(find.byIcon(Icons.mic), findsOneWidget);
      expect(find.text('Start Recording'), findsOneWidget);
    });

    testWidgets('shows metadata dialog before recording', (WidgetTester tester) async {
      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();
      
      await tester.tap(find.byIcon(Icons.mic));
      await tester.pumpAndSettle();
      
      expect(find.text('Voice Legacy Details'), findsOneWidget);
      expect(find.text('Category'), findsOneWidget);
      expect(find.text('Language'), findsOneWidget);
      expect(find.text('Cultural Significance'), findsOneWidget);
      expect(find.text('Preservation Intent'), findsOneWidget);
      expect(find.text('Community Connection'), findsOneWidget);
    });

    testWidgets('completes full recording flow with metadata', (WidgetTester tester) async {
      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();
      
      // Open metadata dialog
      await tester.tap(find.byIcon(Icons.mic));
      await tester.pumpAndSettle();
      
      // Fill metadata
      await tester.enterText(
        find.widgetWithText(TextField, 'Name your voice preservation'),
        'Test Recording'
      );
      
      // Select category
      await tester.tap(find.byType(DropdownButtonFormField<String>).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cultural Heritage').last);
      await tester.pumpAndSettle();
      
      // Select language
      await tester.tap(find.byType(DropdownButtonFormField<String>).last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('English').last);
      await tester.pumpAndSettle();
      
      // Enter cultural significance
      await tester.enterText(
        find.widgetWithText(TextField, 'Describe the cultural importance...'),
        'Test cultural significance'
      );
      
      // Enter preservation intent
      await tester.enterText(
        find.widgetWithText(TextField, 'Why are you preserving this voice?'),
        'For cultural preservation'
      );
      
      // Enter community connection
      await tester.enterText(
        find.widgetWithText(TextField, 'How does this connect to your community?'),
        'Represents our heritage'
      );
      
      // Start recording
      await tester.tap(find.text('Start Recording'));
      await tester.pumpAndSettle();
      
      // Verify recording state
      when(mockRecordingService.isRecording).thenReturn(true);
      await tester.pump();
      
      expect(find.text('Recording in progress...'), findsOneWidget);
      expect(find.byIcon(Icons.stop), findsOneWidget);
      
      // Stop recording
      await tester.tap(find.byIcon(Icons.stop));
      await tester.pumpAndSettle();
      
      // Verify success message
      expect(find.text('Voice successfully preserved for future generations'), findsOneWidget);
      
      // Verify complete service chain
      verify(mockRecordingService.startRecording()).called(1);
      verify(mockRecordingService.stopRecording(
        category: argThat(equals('Cultural Heritage'), named: 'category'),
        language: argThat(equals('English'), named: 'language'),
        description: argThat(equals('Test cultural significance'), named: 'description'),
        culturalMetadata: argThat(
          predicate((Map<String, dynamic>? metadata) =>
            metadata?['title'] == 'Test Recording' &&
            metadata?['preservation_intent'] == 'For cultural preservation' &&
            metadata?['community_connection'] == 'Represents our heritage'
          ),
          named: 'culturalMetadata'
        ),
      )).called(1);
    });

    testWidgets('handles permission denial', (WidgetTester tester) async {
      when(mockRecordingService.requestAllPermissions())
          .thenAnswer((_) async => false);
      
      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();
      
      expect(find.text('Permissions Required'), findsOneWidget);
      expect(
        find.text('To preserve your voice and create your legacy, we need microphone access. '
                 'Please grant the necessary permissions to continue your cultural preservation journey.'),
        findsOneWidget
      );
    });
  });
}
