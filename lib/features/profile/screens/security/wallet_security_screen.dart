import 'package:flutter/material.dart';

import '../../../../core/config/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

class WalletSecurityScreen extends StatefulWidget {
  const WalletSecurityScreen({super.key});

  @override
  State<WalletSecurityScreen> createState() => _WalletSecurityScreenState();
}

class _WalletSecurityScreenState extends State<WalletSecurityScreen> {
  final List<Map<String, dynamic>> _connectedWallets = [
    {
      'name': 'MetaMask',
      'address': '0x1234...5678',
      'isActive': true,
    },
    {
      'name': 'WalletConnect',
      'address': '0x8765...4321',
      'isActive': false,
    },
  ];

  bool _requireConfirmation = true;
  bool _autoLockEnabled = true;
  int _autoLockDuration = 15; // minutes

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallet Security'),
        backgroundColor: AppColors.primary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.m),
        children: [
          _buildConnectedWallets(),
          const SizedBox(height: AppSpacing.l),
          _buildSecuritySettings(),
          const SizedBox(height: AppSpacing.l),
          _buildTransactionSettings(),
          const SizedBox(height: AppSpacing.l),
          _buildBackupSection(),
        ],
      ),
    );
  }

  Widget _buildConnectedWallets() {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.m),
            child: Text(
              'Connected Wallets',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          ..._connectedWallets.map((wallet) => ListTile(
            title: Text(wallet['name']),
            subtitle: Text(wallet['address']),
            trailing: Switch(
              value: wallet['isActive'],
              onChanged: (value) => _toggleWallet(wallet, value),
            ),
            leading: Icon(
              Icons.account_balance_wallet_outlined,
              color: wallet['isActive'] ? AppColors.primary : AppColors.textSecondary,
            ),
          )),
          ListTile(
            title: const Text('Connect New Wallet'),
            leading: const Icon(Icons.add),
            onTap: _connectNewWallet,
          ),
        ],
      ),
    );
  }

  Widget _buildSecuritySettings() {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.m),
            child: Text(
              'Security Settings',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          SwitchListTile(
            title: const Text('Require Authentication'),
            subtitle: const Text('Confirm identity for all transactions'),
            value: _requireConfirmation,
            onChanged: (value) => setState(() => _requireConfirmation = value),
          ),
          SwitchListTile(
            title: const Text('Auto-Lock'),
            subtitle: const Text('Automatically lock wallet after inactivity'),
            value: _autoLockEnabled,
            onChanged: (value) => setState(() => _autoLockEnabled = value),
          ),
          if (_autoLockEnabled)
            ListTile(
              title: const Text('Auto-Lock Duration'),
              subtitle: Text('$_autoLockDuration minutes'),
              trailing: DropdownButton<int>(
                value: _autoLockDuration,
                items: [5, 15, 30, 60].map((duration) => DropdownMenuItem(
                  value: duration,
                  child: Text('$duration min'),
                )).toList(),
                onChanged: (value) => setState(() => _autoLockDuration = value!),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTransactionSettings() {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.m),
            child: Text(
              'Transaction Settings',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          ListTile(
            title: const Text('Transaction Limits'),
            subtitle: const Text('Set daily transaction limits'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.pushNamed(context, AppRoutes.transactionLimits),
          ),
          ListTile(
            title: const Text('Approved Contracts'),
            subtitle: const Text('Manage pre-approved smart contracts'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.pushNamed(context, AppRoutes.approvedContracts),
          ),
        ],
      ),
    );
  }

  Widget _buildBackupSection() {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.m),
            child: Text(
              'Backup & Recovery',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          ListTile(
            title: const Text('Export Private Keys'),
            subtitle: const Text('Securely backup your wallet'),
            leading: const Icon(Icons.key_outlined),
            onTap: _exportPrivateKeys,
          ),
          ListTile(
            title: const Text('Recovery Phrase'),
            subtitle: const Text('View your recovery phrase'),
            leading: const Icon(Icons.restore_outlined),
            onTap: _showRecoveryPhrase,
          ),
        ],
      ),
    );
  }

  void _toggleWallet(Map<String, dynamic> wallet, bool value) {
    setState(() {
      wallet['isActive'] = value;
    });
  }

  void _connectNewWallet() {
    // Implement wallet connection logic
  }

  void _exportPrivateKeys() {
    // Implement private key export logic
  }

  void _showRecoveryPhrase() {
    // Implement recovery phrase display logic
  }
} 