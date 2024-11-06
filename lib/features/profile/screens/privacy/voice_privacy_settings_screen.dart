import 'package:flutter/material.dart';
import 'package:speakmobilemvp/core/theme/app_colors.dart';
import 'package:speakmobilemvp/core/theme/app_spacing.dart';

import '../../../../core/config/app_routes.dart';

class VoicePrivacySettingsScreen extends StatefulWidget {
  const VoicePrivacySettingsScreen({super.key});

  @override
  State<VoicePrivacySettingsScreen> createState() => _VoicePrivacySettingsScreenState();
}

class _VoicePrivacySettingsScreenState extends State<VoicePrivacySettingsScreen> {
  bool _voiceSamplesPublic = false;
  bool _allowAITraining = false;
  bool _showVoiceMetrics = true;
  bool _allowVoiceSearching = true;
  final Map<String, bool> _categoryVisibility = {
    'Entertainment': true,
    'Education': true,
    'Commercial': false,
    'Personal': false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Voice Privacy'),
        backgroundColor: AppColors.primary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.m),
        children: [
          _buildInfoCard(),
          const SizedBox(height: AppSpacing.l),
          _buildGeneralSettings(),
          const SizedBox(height: AppSpacing.l),
          _buildCategoryVisibility(),
          const SizedBox(height: AppSpacing.l),
          _buildAdvancedSettings(),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Voice Privacy Controls',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: AppSpacing.s),
            Text(
              'Control how your voice samples are shared and used across the platform. '
              'These settings affect your visibility to potential clients and your '
              'participation in various voice-related activities.',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGeneralSettings() {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.m),
            child: Text(
              'General Settings',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          SwitchListTile(
            title: const Text('Public Voice Samples'),
            subtitle: const Text('Allow others to preview your voice samples'),
            value: _voiceSamplesPublic,
            onChanged: (value) => setState(() => _voiceSamplesPublic = value),
          ),
          SwitchListTile(
            title: const Text('Voice Search'),
            subtitle: const Text('Allow your voice to appear in search results'),
            value: _allowVoiceSearching,
            onChanged: (value) => setState(() => _allowVoiceSearching = value),
          ),
          SwitchListTile(
            title: const Text('Voice Metrics'),
            subtitle: const Text('Show voice performance metrics on your profile'),
            value: _showVoiceMetrics,
            onChanged: (value) => setState(() => _showVoiceMetrics = value),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryVisibility() {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.m),
            child: Text(
              'Category Visibility',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          ..._categoryVisibility.entries.map((entry) => SwitchListTile(
            title: Text(entry.key),
            subtitle: Text('Show availability for ${entry.key.toLowerCase()} projects'),
            value: entry.value,
            onChanged: (value) => setState(() => _categoryVisibility[entry.key] = value),
          )),
        ],
      ),
    );
  }

  Widget _buildAdvancedSettings() {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.m),
            child: Text(
              'Advanced Settings',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          SwitchListTile(
            title: const Text('AI Training'),
            subtitle: const Text('Allow your voice to be used for AI model training'),
            value: _allowAITraining,
            onChanged: (value) => setState(() => _allowAITraining = value),
          ),
          ListTile(
            title: const Text('Voice Fingerprint'),
            subtitle: const Text('Manage your unique voice identification settings'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.pushNamed(context, AppRoutes.voiceFingerprint),
          ),
          ListTile(
            title: const Text('Usage Restrictions'),
            subtitle: const Text('Set specific restrictions for voice usage'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.pushNamed(context, AppRoutes.usageRestrictions),
          ),
        ],
      ),
    );
  }
} 