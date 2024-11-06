import 'package:flutter/material.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:speakmobilemvp/core/services/frontend/recording_service.dart';

class EditAudioScreen extends StatefulWidget {
  final String audioPath;
  final RecordingService recordingService;
  final Function(String) onSave;

  const EditAudioScreen({
    super.key,
    required this.audioPath,
    required this.recordingService,
    required this.onSave,
  });

  @override
  State<EditAudioScreen> createState() => _EditAudioScreenState();
}

class _EditAudioScreenState extends State<EditAudioScreen> {
  late final PlayerController _playerController;
  bool isPlaying = false;
  bool isTrimming = false;
  RangeValues _trimRange = const RangeValues(0.0, 1.0);
  Duration? _audioDuration;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    _playerController = PlayerController();
    try {
      await _playerController.preparePlayer(
        path: widget.audioPath,
        shouldExtractWaveform: true,
      );
      final duration = await _playerController.getDuration();
      if (mounted) {
        setState(() {
          _audioDuration = Duration(milliseconds: duration);
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load audio: $e')),
      );
    }
  }

  @override
  void dispose() {
    _playerController.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  Widget _buildTrimControls() {
    if (!isTrimming) return const SizedBox.shrink();
    
    return Column(
      children: [
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(_formatDuration(Duration(milliseconds: (_trimRange.start * (_audioDuration?.inMilliseconds ?? 0)).round()))),
            Text(_formatDuration(Duration(milliseconds: (_trimRange.end * (_audioDuration?.inMilliseconds ?? 0)).round()))),
          ],
        ),
        RangeSlider(
          values: _trimRange,
          onChanged: (RangeValues values) {
            setState(() {
              _trimRange = values;
            });
          },
          labels: RangeLabels(
            _formatDuration(Duration(milliseconds: (_trimRange.start * (_audioDuration?.inMilliseconds ?? 0)).round())),
            _formatDuration(Duration(milliseconds: (_trimRange.end * (_audioDuration?.inMilliseconds ?? 0)).round())),
          ),
        ),
        ElevatedButton(
          onPressed: _trimAudio,
          child: const Text('Apply Trim'),
        ),
      ],
    );
  }

  Future<void> _trimAudio() async {
    try {
      final startMs = (_trimRange.start * (_audioDuration?.inMilliseconds ?? 0)).round();
      final endMs = (_trimRange.end * (_audioDuration?.inMilliseconds ?? 0)).round();
      
      final trimmedPath = await widget.recordingService.trimAudio(
        widget.audioPath,
        startMs / 1000, // Convert to seconds
        endMs / 1000,
      );
      
      if (!mounted) return;
      
      // Reinitialize player with trimmed audio
      await _playerController.stopPlayer();
      await _playerController.preparePlayer(
        path: trimmedPath,
        shouldExtractWaveform: true,
      );
      
      setState(() {
        isTrimming = false;
        _trimRange = const RangeValues(0.0, 1.0);
      });
      
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Audio trimmed successfully')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to trim audio: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Audio'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              try {
                widget.onSave(widget.audioPath);
                Navigator.pop(context);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Failed to save audio: $e'),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Edit Your Voice Recording',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            AudioFileWaveforms(
              size: Size(MediaQuery.of(context).size.width - 32, 100),
              playerController: _playerController,
              enableSeekGesture: true,
              waveformType: WaveformType.fitWidth,
              playerWaveStyle: const PlayerWaveStyle(
                fixedWaveColor: Colors.blue,
                liveWaveColor: Colors.blueAccent,
                spacing: 6,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                  onPressed: () async {
                    try {
                      if (isPlaying) {
                        await _playerController.pausePlayer();
                      } else {
                        await _playerController.startPlayer(
                          finishMode: FinishMode.loop,
                        );
                      }
                      if (!mounted) return;
                      setState(() {
                        isPlaying = !isPlaying;
                      });
                    } catch (e) {
                      if (!mounted) return;
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Failed to ${isPlaying ? 'pause' : 'play'} audio: $e'),
                        ),
                      );
                    }
                  },
                ),
                IconButton(
                  icon: Icon(isTrimming ? Icons.close : Icons.content_cut),
                  onPressed: () {
                    setState(() {
                      isTrimming = !isTrimming;
                    });
                  },
                ),
              ],
            ),
            _buildTrimControls(),
          ],
        ),
      ),
    );
  }
}
