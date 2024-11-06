import 'package:flutter/material.dart';
import 'package:speakmobilemvp/core/theme/app_colors.dart';
import 'package:speakmobilemvp/core/theme/app_spacing.dart';

class VoiceFingerprintScreen extends StatefulWidget {
  const VoiceFingerprintScreen({super.key});

  @override
  State<VoiceFingerprintScreen> createState() => _VoiceFingerprintScreenState();
}

class _VoiceFingerprintScreenState extends State<VoiceFingerprintScreen> {
  bool _fingerprintEnabled = true;
  bool _enhancedProtection = false;
  bool _autoScan = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Voice Fingerprint'),
        backgroundColor: AppColors.primary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.m),
        children: [
          _buildInfoCard(),
          const SizedBox(height: AppSpacing.l),
          _buildSettings(),
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
              'Voice Fingerprint Protection',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: AppSpacing.s),
            Text(
              'Your voice fingerprint helps protect your voice assets from unauthorized use '
              'and ensures proper attribution across the platform.',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettings() {
    return Card(
      child: Column(
        children: [
          SwitchListTile(
            title: const Text('Voice Fingerprint Protection'),
            subtitle: const Text('Enable unique voice identification'),
            value: _fingerprintEnabled,
            onChanged: (value) => setState(() => _fingerprintEnabled = value),
          ),
          SwitchListTile(
            title: const Text('Enhanced Protection'),
            subtitle: const Text('Additional security for high-value assets'),
            value: _enhancedProtection,
            onChanged: _fingerprintEnabled 
              ? (value) => setState(() => _enhancedProtection = value)
              : null,
          ),
          SwitchListTile(
            title: const Text('Automatic Scanning'),
            subtitle: const Text('Continuously monitor for unauthorized usage'),
            value: _autoScan,
            onChanged: _fingerprintEnabled 
              ? (value) => setState(() => _autoScan = value)
              : null,
          ),
        ],
      ),
    );
  }
}
