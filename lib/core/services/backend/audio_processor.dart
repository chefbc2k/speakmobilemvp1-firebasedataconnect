import 'package:flutter/foundation.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'dart:io';
import 'dart:async';
import 'cognitive_service.dart';

class AudioProcessingException implements Exception {
  final String message;
  AudioProcessingException(this.message);

  @override
  String toString() => 'AudioProcessingException: $message';
}

class AudioProcessor {
  final CognitiveService _cognitiveService = CognitiveService();

  // Audio processing settings
  final double _noiseReductionLevel = 0.2;
  final double _gainLevel = 1.0;

  // Waveform analysis settings
  static const int sampleRate = 44100;
  static const int frameSize = 2048;

  Future<String> processAudio(String inputFilePath) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final outputPath = path.join(tempDir.path, 'processed_${path.basename(inputFilePath)}');

      // Example FFmpeg command to convert audio format
      final List<String> commands = [
        '-i', inputFilePath,
        '-af', 'anlmdn=s=$_noiseReductionLevel,volume=$_gainLevel',
        '-ar', '$sampleRate',
        '-ac', '2',
        '-c:a', 'aac',
        '-b:a', '192k',
        outputPath
      ];

      final session = await FFmpegKit.executeWithArguments(commands);
      final returnCode = await session.getReturnCode();
      
      if (returnCode!.isValueSuccess()) {
        if (kDebugMode) {
          print('Audio processed successfully: $outputPath');
        }
        return outputPath;
      } else {
        throw Exception('FFmpeg process failed with rc: $returnCode');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error processing audio: $e');
      }
      rethrow;
    }
  }


  Future<void> adjustAudioSettings({
    required String filePath,
    required double noiseReduction,
    required double gain,
  }) async {
    // Implementation for adjusting audio settings
    // This could include applying filters, normalization, etc.
  }

  Future<Map<String, dynamic>> analyzeTone({
    required String audioPath,
    required String transcription,
  }) async {
    try {
      final response = await _cognitiveService.analyzeTone(
        audioPath: audioPath,
        transcription: transcription,
      );

      return response;
    } catch (e) {
      throw AudioProcessingException('Tone analysis failed: $e');
    }
  }

  Future<void> compressAudio({
    required String filePath,
    required int targetBitrate,
  }) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final outputPath = path.join(tempDir.path, 'compressed_${path.basename(filePath)}');

      final session = await FFmpegKit.execute(
        '-i $filePath -c:a aac -b:a ${targetBitrate}k $outputPath'
      );

      final returnCode = await session.getReturnCode();
      
      if (returnCode!.isValueSuccess()) {
        // Replace original file with compressed version
        await File(outputPath).copy(filePath);
        await File(outputPath).delete();
      } else {
        final logs = await session.getLogs();
        throw Exception('FFmpeg process failed: ${logs.join('\n')}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error compressing audio: $e');
      }
      rethrow;
    }
  }
}
