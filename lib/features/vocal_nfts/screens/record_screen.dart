import 'package:flutter/material.dart';
import 'dart:async';
import 'package:audio_waveforms/audio_waveforms.dart';

import '../../../core/services/backend/audio_processor.dart';
import '../../../core/services/frontend/recording_service.dart';
import '../../../core/utils/error_handler.dart';

class RecordScreen extends StatefulWidget {
  final RecordingService? recordingService;
  final AudioProcessor? audioProcessor;
  final RecorderController recorderController;
  
  const RecordScreen({
    super.key, 
    this.recordingService,
    this.audioProcessor,
    required this.recorderController,
  });

  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  late final RecordingService _recordingService;
  late final RecorderController _recorderController;
  bool _isRecording = false;
  String? _selectedCategory;
  String? _selectedLanguage;
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final Map<String, dynamic> _culturalMetadata = {};
  
  final List<String> _categories = [
    'Cultural Heritage',
    'Personal Legacy',
    'Traditional Story',
    'Indigenous Language',
    'Oral History',
    'Community Voice',
  ];

  final List<String> _languages = [
    'English',
    'Spanish',
    'Mandarin',
    'Cherokee',
    'Arabic',
    'Hindi',
    'Japanese',
    'Korean',
    'French',
    'German',
    'Portuguese',
    'Russian',
    'Swahili',
    'Vietnamese',
    'Thai',
    'Indigenous Languages',
    'Other',
  ];
  
  @override
  void initState() {
    super.initState();
    _recordingService = widget.recordingService ?? RecordingService();
    _recorderController = widget.recorderController;
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    final hasPermissions = await _recordingService.requestAllPermissions();
    if (!hasPermissions && mounted) {
      _showPermissionDeniedDialog();
    }
  }

  @override
  void dispose() {
    _recorderController.dispose();
    _descriptionController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _startRecording() async {
    if (_selectedCategory == null || _selectedLanguage == null) {
      _showMetadataDialog();
      return;
    }

    try {
      await _recordingService.startRecording();
      await _recorderController.record();
      setState(() => _isRecording = true);
    } catch (e) {
      _showErrorDialog(e.toString());
    }
  }

  Future<void> _stopRecording() async {
    try {
      final path = await _recordingService.stopRecording(
        category: _selectedCategory!,
        language: _selectedLanguage!,
        description: _descriptionController.text,
        culturalMetadata: {
          'title': _titleController.text,
          'preservation_intent': _culturalMetadata['preservation_intent'],
          'cultural_significance': _culturalMetadata['cultural_significance'],
          'community_connection': _culturalMetadata['community_connection'],
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
      await _recorderController.stop();
      setState(() => _isRecording = false);
      if (path != null) {
        _showSuccessMessage();
      }
    } catch (e) {
      _showErrorDialog(e.toString());
    }
  }

  void _showSuccessMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Voice successfully preserved for future generations'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showErrorDialog(String message) {
    ErrorHandler.showErrorDialog(
      context: context,
      title: 'Error',
      message: message,
    );
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permissions Required'),
        content: const Text(
          'To preserve your voice and create your legacy, we need microphone access. '
          'Please grant the necessary permissions to continue your cultural preservation journey.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showMetadataDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Voice Legacy Details'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  hintText: 'Name your voice preservation',
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(labelText: 'Category'),
                items: _categories.map((category) => DropdownMenuItem(
                  value: category,
                  child: Text(category),
                )).toList(),
                onChanged: (value) => setState(() => _selectedCategory = value),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedLanguage,
                decoration: const InputDecoration(labelText: 'Language'),
                items: _languages.map((language) => DropdownMenuItem(
                  value: language,
                  child: Text(language),
                )).toList(),
                onChanged: (value) => setState(() => _selectedLanguage = value),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Cultural Significance',
                  hintText: 'Describe the cultural importance...',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              TextField(
                onChanged: (value) => _culturalMetadata['preservation_intent'] = value,
                decoration: const InputDecoration(
                  labelText: 'Preservation Intent',
                  hintText: 'Why are you preserving this voice?',
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              TextField(
                onChanged: (value) => _culturalMetadata['community_connection'] = value,
                decoration: const InputDecoration(
                  labelText: 'Community Connection',
                  hintText: 'How does this connect to your community?',
                ),
                maxLines: 2,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _startRecording();
            },
            child: const Text('Start Recording'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preserve Your Voice'),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Create Your Voice Legacy',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Preserve your voice for future generations. Share your stories, '
                    'languages, and cultural heritage.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 32),
                  if (_selectedCategory != null) ...[
                    Chip(
                      label: Text(_selectedCategory!),
                      avatar: const Icon(Icons.category),
                    ),
                    const SizedBox(height: 8),
                  ],
                  if (_selectedLanguage != null) ...[
                    Chip(
                      label: Text(_selectedLanguage!),
                      avatar: const Icon(Icons.language),
                    ),
                    const SizedBox(height: 16),
                  ],
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          AudioWaveforms(
                            enableGesture: true,
                            size: Size(MediaQuery.of(context).size.width - 64, 50),
                            recorderController: _recorderController,
                            waveStyle: const WaveStyle(
                              showMiddleLine: false,
                              extendWaveform: true,
                              waveColor: Colors.blue,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _isRecording ? 'Recording in progress...' : 'Ready to preserve your voice',
                            style: TextStyle(
                              color: _isRecording ? Colors.red : Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  if (_isRecording)
                    Center(
                      child: FloatingActionButton(
                        onPressed: _stopRecording,
                        backgroundColor: Colors.red,
                        child: const Icon(Icons.stop),
                      ),
                    )
                  else
                    Center(
                      child: FloatingActionButton.extended(
                        onPressed: () => _selectedCategory == null ? _showMetadataDialog() : _startRecording(),
                        icon: const Icon(Icons.mic),
                        label: const Text('Start Recording'),
                      ),
                    ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class VoiceLanguage {
  final String code;
  final String name;
  final String? script;
  final bool isIndigenous;
  final String? region;
  final String? culturalContext;

  const VoiceLanguage({
    required this.code,
    required this.name,
    this.script,
    this.isIndigenous = false,
    this.region,
    this.culturalContext,
  });
}
