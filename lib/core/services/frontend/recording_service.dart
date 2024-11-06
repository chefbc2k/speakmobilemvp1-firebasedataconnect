import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../backend/supabase_service.dart';
import '../backend/audio_processor.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'dart:io';

/// Custom exception for permission-related errors
class PermissionException implements Exception {
  final String message;
  PermissionException(this.message);

  @override
  String toString() => 'PermissionException: $message';
}

class RecordingService {
  final _audioRecorder = AudioRecorder();
  final _audioProcessor = AudioProcessor();
  final _supabaseService = SupabaseService();
  
  bool _isRecording = false;
  String? _currentRecordingPath;

  /// Request microphone permission
  Future<bool> requestMicrophonePermission() async {
    try {
      final status = await Permission.microphone.request();
      return status.isGranted;
    } catch (e) {
      if (kDebugMode) {
        print('Error requesting microphone permission: $e');
      }
      return false;
    }
  }

  /// Check if microphone permission is granted
  Future<bool> hasMicrophonePermission() async {
    try {
      final status = await Permission.microphone.status;
      return status.isGranted;
    } catch (e) {
      if (kDebugMode) {
        print('Error checking microphone permission: $e');
      }
      return false;
    }
  }

  /// Start recording
  Future<String?> startRecording() async {
    if (!await hasMicrophonePermission()) {
      final granted = await requestMicrophonePermission();
      if (!granted) {
        throw PermissionException('Microphone permission not granted');
      }
    }

    try {
      final hasRecordingPermission = await _audioRecorder.hasPermission();
      if (!hasRecordingPermission) {
        throw PermissionException('Recording permission not granted');
      }

      final directory = await getTemporaryDirectory();
      final filePath = path.join(
        directory.path,
        'preservation_${DateTime.now().millisecondsSinceEpoch}.m4a',
      );

      // Configure recording parameters for optimal quality
      await _audioRecorder.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,
          sampleRate: 44100,
          numChannels: 2, // Stereo recording for better preservation
        ),
        path: filePath,
      );

      _isRecording = true;
      _currentRecordingPath = filePath;
      return filePath;
    } catch (e) {
      if (kDebugMode) {
        print('Error starting recording: $e');
      }
      return null;
    }
  }

  /// Stop recording and preserve with cultural metadata
  Future<String?> stopRecording({
    required String category,
    required String language,
    String? description,
    Map<String, dynamic>? culturalMetadata,
  }) async {
    try {
      if (!_isRecording || _currentRecordingPath == null) return null;

      final filePath = await _audioRecorder.stop();
      _isRecording = false;
      
      if (filePath != null) {
        // Process the audio for optimal preservation
        final processedPath = await _audioProcessor.processAudio(filePath);

        // Upload the processed recording with cultural metadata
        final publicUrl = await _supabaseService.uploadVoiceClip(
          processedPath,
          category: category,
          language: language,
          description: description,
          culturalMetadata: culturalMetadata,
        );

        return publicUrl;
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Error stopping recording: $e');
      }
      return null;
    }
  }

  /// Pause recording
  Future<void> pauseRecording() async {
    try {
      await _audioRecorder.pause();
    } catch (e) {
      if (kDebugMode) {
        print('Error pausing recording: $e');
      }
    }
  }

  /// Resume recording
  Future<void> resumeRecording() async {
    try {
      await _audioRecorder.resume();
    } catch (e) {
      if (kDebugMode) {
        print('Error resuming recording: $e');
      }
    }
  }

  /// Check if currently recording
  bool get isRecording => _isRecording;

  /// Get the current amplitude for waveform visualization
  Future<double> getAmplitude() async {
    try {
      final amplitude = await _audioRecorder.getAmplitude();
      return amplitude.current;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting amplitude: $e');
      }
      return 0.0;
    }
  }

  /// Request all required permissions
  Future<bool> requestAllPermissions() async {
    try {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.microphone,
        Permission.storage,
        Permission.speech,
      ].request();
      
      return !statuses.values.any((status) => status.isDenied || status.isPermanentlyDenied);
    } catch (e) {
      if (kDebugMode) {
        print('Error requesting permissions: $e');
      }
      return false;
    }
  }

  /// Dispose resources
  Future<void> dispose() async {
    await _audioRecorder.dispose();
  }

  Future<String> trimAudio(String inputPath, double startTime, double endTime) async {
    final Directory tempDir = await getTemporaryDirectory();
    final String outputPath = '${tempDir.path}/trimmed_${DateTime.now().millisecondsSinceEpoch}.m4a';

    try {
      final session = await FFmpegKit.execute(
        '-i "$inputPath" -ss $startTime -to $endTime -c copy "$outputPath"'
      );
      
      final returnCode = await session.getReturnCode();

      if (ReturnCode.isSuccess(returnCode)) {
        return outputPath;
      } else {
        final logs = await session.getLogs();
        throw Exception('Failed to trim audio: ${logs.join('\n')}');
      }
    } catch (e) {
      throw Exception('Error trimming audio: $e');
    }
  }
}
