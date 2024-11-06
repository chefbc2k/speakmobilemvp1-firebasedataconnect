import 'package:flutter/material.dart';

import '../../../../core/config/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

class AuthenticationSettingsScreen extends StatefulWidget {
  const AuthenticationSettingsScreen({super.key});

  @override
  State<AuthenticationSettingsScreen> createState() => _AuthenticationSettingsScreenState();
}

class _AuthenticationSettingsScreenState extends State<AuthenticationSettingsScreen> {
  bool _twoFactorEnabled = false;
  bool _biometricsEnabled = false;
  String _selectedTwoFactorMethod = 'authenticator';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Authentication Settings'),
        backgroundColor: AppColors.primary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.m),
        children: [
          _buildPasswordSection(),
          const SizedBox(height: AppSpacing.l),
          _buildTwoFactorSection(),
          const SizedBox(height: AppSpacing.l),
          _buildBiometricsSection(),
          const SizedBox(height: AppSpacing.l),
          _buildRecoverySection(),
        ],
      ),
    );
  }

  Widget _buildPasswordSection() {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.m),
            child: Text(
              'Password',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          ListTile(
            title: const Text('Change Password'),
            subtitle: const Text('Update your account password'),
            leading: const Icon(Icons.lock_outline),
            onTap: () => Navigator.pushNamed(context, AppRoutes.changePassword),
          ),
          ListTile(
            title: const Text('Password Requirements'),
            subtitle: const Text('View security requirements'),
            leading: const Icon(Icons.security_outlined),
            onTap: () => _showPasswordRequirements(),
          ),
        ],
      ),
    );
  }

  Widget _buildTwoFactorSection() {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.m),
            child: Text(
              'Two-Factor Authentication',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          SwitchListTile(
            title: const Text('Enable 2FA'),
            subtitle: const Text('Add an extra layer of security'),
            value: _twoFactorEnabled,
            onChanged: (value) => setState(() => _twoFactorEnabled = value),
          ),
          if (_twoFactorEnabled) ...[
            RadioListTile(
              title: const Text('Authenticator App'),
              value: 'authenticator',
              groupValue: _selectedTwoFactorMethod,
              onChanged: (value) => setState(() => _selectedTwoFactorMethod = value!),
            ),
            RadioListTile(
              title: const Text('SMS'),
              value: 'sms',
              groupValue: _selectedTwoFactorMethod,
              onChanged: (value) => setState(() => _selectedTwoFactorMethod = value!),
            ),
            RadioListTile(
              title: const Text('Email'),
              value: 'email',
              groupValue: _selectedTwoFactorMethod,
              onChanged: (value) => setState(() => _selectedTwoFactorMethod = value!),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBiometricsSection() {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.m),
            child: Text(
              'Biometric Authentication',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          SwitchListTile(
            title: const Text('Enable Biometrics'),
            subtitle: const Text('Use fingerprint or face recognition'),
            value: _biometricsEnabled,
            onChanged: (value) => setState(() => _biometricsEnabled = value),
          ),
        ],
      ),
    );
  }

  Widget _buildRecoverySection() {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.m),
            child: Text(
              'Account Recovery',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          ListTile(
            title: const Text('Recovery Email'),
            subtitle: const Text('Add or update recovery email'),
            leading: const Icon(Icons.email_outlined),
            onTap: () => _manageRecoveryEmail(),
          ),
          ListTile(
            title: const Text('Recovery Phone'),
            subtitle: const Text('Add or update recovery phone'),
            leading: const Icon(Icons.phone_outlined),
            onTap: () => _manageRecoveryPhone(),
          ),
          ListTile(
            title: const Text('Backup Codes'),
            subtitle: const Text('Generate backup codes'),
            leading: const Icon(Icons.code_outlined),
            onTap: () => _generateBackupCodes(),
          ),
        ],
      ),
    );
  }

  void _showPasswordRequirements() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Password Requirements'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('• Minimum 12 characters'),
            Text('• At least one uppercase letter'),
            Text('• At least one lowercase letter'),
            Text('• At least one number'),
            Text('• At least one special character'),
            Text('• No common words or patterns'),
          ],
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

  // Implement other methods
  void _manageRecoveryEmail() {}
  void _manageRecoveryPhone() {}
  void _generateBackupCodes() {}
} 