import 'package:flutter/material.dart';
import 'package:speakmobilemvp/core/services/frontend/recording_service.dart';
import 'package:speakmobilemvp/core/services/frontend/contract_service.dart';
import 'package:speakmobilemvp/features/vocal_nfts/screens/edit_audio_screen.dart';
import 'package:speakmobilemvp/core/utils/error_handler.dart';

class VoiceContractScreen extends StatefulWidget {
  final ContractService contractService;
  final RecordingService recordingService;

  const VoiceContractScreen({
    super.key,
    required this.contractService,
    required this.recordingService,
  });

  @override
  State<VoiceContractScreen> createState() => _VoiceContractScreenState();
}

class _VoiceContractScreenState extends State<VoiceContractScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _recordingPath;
  bool _isRecording = false;
  double _amplitude = 0.0;
  String? _selectedLanguage;
  VoiceLanguage? _languageDetails;
  final Map<String, dynamic> _culturalMetadata = {};

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _checkPermissions() async {
    final hasPermissions = await widget.recordingService.requestAllPermissions();
    if (!hasPermissions && mounted) {
      ErrorHandler.showError(
        context: context,
        error: PermissionException('Required permissions not granted'),
        message: 'Permissions are required to create voice contracts',
      );
    }
  }

  Future<void> _toggleRecording() async {
    if (!_isRecording) {
      final path = await widget.recordingService.startRecording();
      if (path != null) {
        setState(() {
          _recordingPath = path;
          _isRecording = true;
        });
        _updateAmplitude();
      }
    } else {
      final url = await widget.recordingService.stopRecording(
        category: 'voice_contract',
        language: _selectedLanguage ?? 'en',
        description: _descriptionController.text,
        culturalMetadata: {
          'language': _selectedLanguage,
          'language_details': _languageDetails?.toJson(),
          'cultural_significance': _culturalMetadata['cultural_significance'],
          'preservation_intent': _culturalMetadata['preservation_intent'],
          'community_connection': _culturalMetadata['community_connection'],
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
      if (url != null) {
        setState(() {
          _isRecording = false;
        });
      }
    }
  }

  Future<void> _updateAmplitude() async {
    if (_isRecording) {
      final amplitude = await widget.recordingService.getAmplitude();
      setState(() {
        _amplitude = amplitude;
      });
      Future.delayed(const Duration(milliseconds: 100), _updateAmplitude);
    }
  }

  Future<void> _editRecording() async {
    if (_recordingPath == null) return;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditAudioScreen(
          audioPath: _recordingPath!,
          recordingService: widget.recordingService,
          onSave: (String path) {
            setState(() {
              _recordingPath = path;
            });
          },
        ),
      ),
    );
  }

  Future<void> _createContract() async {
    try {
      if (!_formKey.currentState!.validate() || _recordingPath == null) return;

      // Step 1: Stop recording and upload through the recording service
      final recordingUrl = await widget.recordingService.stopRecording(
        category: 'voice_contract',
        language: _selectedLanguage ?? 'en',
        description: _descriptionController.text,
        culturalMetadata: {
          'title': _titleController.text,
          'contract_type': 'voice_preservation',
          ..._culturalMetadata,
        },
      );

      if (recordingUrl == null) {
        throw Exception('Failed to process and upload recording');
      }

      // Step 2: Create a new contract with the recording URL
      await widget.contractService.createVoiceContract(
        title: _titleController.text,
        description: _descriptionController.text,
        recordingUrl: recordingUrl,
        language: _selectedLanguage ?? 'en',
        culturalMetadata: _culturalMetadata,
      );

      // Step 3: Navigate back to the discover screen
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ErrorHandler.showError(
          context: context,
          error: e,
          message: 'Failed to create voice contract',
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Voice Contract'),
        actions: [
          if (_recordingPath != null)
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: _createContract,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Contract Title',
                  hintText: 'Enter a title for your voice contract',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Describe the purpose of this voice contract',
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              const Text(
                'Voice Recording',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 100,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: _isRecording
                            ? LinearProgressIndicator(value: _amplitude)
                            : const Icon(Icons.mic, size: 48),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(_isRecording ? Icons.stop : Icons.mic),
                          onPressed: _toggleRecording,
                        ),
                        if (_recordingPath != null) ...[
                          const SizedBox(width: 16),
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: _editRecording,
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
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

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      'script': script,
      'isIndigenous': isIndigenous,
      'region': region,
      'culturalContext': culturalContext,
    };
  }
}
