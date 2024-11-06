import 'package:flutter/material.dart';
import '../../../core/services/analytics/analytics_service.dart';
import '../../../core/services/frontend/contract_service.dart';
import '../../../core/utils/error_handler.dart';
import '../models/voice_contract_type.dart';
import '../widgets/contract_type_selector.dart';

class CreateNftScreen extends StatefulWidget {
  final ContractService contractService;
  final AnalyticsService analytics;

  const CreateNftScreen({
    super.key,
    required this.contractService,
    required this.analytics,
  });

  @override
  State<CreateNftScreen> createState() => _CreateNftScreenState();
}

class _CreateNftScreenState extends State<CreateNftScreen> {
  VoiceContractCategory? _selectedCategory;
  String? _selectedSubcategory;
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _onCategoryChanged(VoiceContractCategory? category) {
    setState(() {
      _selectedCategory = category;
      _selectedSubcategory = null; // Reset subcategory when category changes
    });
  }

  void _onSubcategoryChanged(String? subcategory) {
    setState(() {
      _selectedSubcategory = subcategory;
    });
  }

  void _handleContractCreation() async {
    if (_formKey.currentState!.validate()) {
      try {
        final contractId = await widget.contractService.createVoiceContract(
          title: _titleController.text,
          description: _descriptionController.text,
          recordingUrl: '',
          language: 'en',
          culturalMetadata: {
            'category': VoiceContractType.categoryToString(_selectedCategory!),
            'subcategory': _selectedSubcategory,
          },
        );

        widget.analytics.logEvent(
          name: 'create_contract',
          parameters: {
            'contract_id': contractId,
            'category': _selectedCategory.toString(),
            'subcategory': _selectedSubcategory,
          },
        );

        if (mounted) {
          Navigator.pop(context, contractId);
        }
      } catch (e) {
        if (mounted) {
          ErrorHandler.showError(
            context: context,
            error: e,
            message: 'Failed to create contract',
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Voice NFT'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
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
            ContractTypeSelector(
              selectedCategory: _selectedCategory,
              selectedSubcategory: _selectedSubcategory,
              onCategoryChanged: _onCategoryChanged,
              onSubcategoryChanged: _onSubcategoryChanged,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _selectedCategory != null && _selectedSubcategory != null
                  ? _handleContractCreation
                  : null,
              child: const Text('Create Contract'),
            ),
          ],
        ),
      ),
    );
  }
}
