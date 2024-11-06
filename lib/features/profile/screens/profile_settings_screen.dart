import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speakmobilemvp/core/theme/app_colors.dart';
import 'package:speakmobilemvp/core/theme/app_spacing.dart';
import 'package:speakmobilemvp/core/routes/app_routes.dart';
import 'package:speakmobilemvp/features/profile/screens/contract_management_screen.dart';
import 'package:speakmobilemvp/features/profile/screens/royalty_management_screen.dart';
import 'package:speakmobilemvp/features/profile/screens/usage_rights_screen.dart';
import 'package:speakmobilemvp/features/profile/screens/contract_history_screen.dart';
import 'package:speakmobilemvp/features/profile/screens/contract_analytics_screen.dart';
import 'package:speakmobilemvp/features/profile/screens/rights_protection_screen.dart';

import '../../../core/services/frontend/contract_service.dart';
import '../models/contract_filter.dart';

class ProfileSettingsScreen extends StatelessWidget {
  const ProfileSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final contractService = context.read<ContractService>();
    
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.background,
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.m),
          children: [
            _buildAccountSection(context),
            const SizedBox(height: AppSpacing.l),
            _buildVoiceAssetsSection(context),
            const SizedBox(height: AppSpacing.l),
            _buildContractsSection(context, contractService),
            const SizedBox(height: AppSpacing.l),
            _buildPaymentSection(context),
            const SizedBox(height: AppSpacing.l),
            _buildPrivacySection(context),
            const SizedBox(height: AppSpacing.l),
            _buildSecuritySection(context),
            const SizedBox(height: AppSpacing.l),
            _buildPreferencesSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection(String title, List<SettingsItem> items) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.m),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          ...items.map((item) => _buildSettingsItem(item)),
        ],
      ),
    );
  }

  Widget _buildSettingsItem(SettingsItem item) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: AppColors.cardBorder),
        ),
      ),
      child: ListTile(
        leading: Icon(item.icon, color: AppColors.primary),
        title: Text(
          item.title,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
          ),
        ),
        subtitle: item.subtitle != null
          ? Text(
              item.subtitle!,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            )
          : null,
        trailing: Icon(
          Icons.chevron_right,
          color: AppColors.textSecondary,
        ),
        onTap: item.onTap,
      ),
    );
  }

  Widget _buildAccountSection(BuildContext context) {
    return _buildSettingsSection(
      'Account',
      [
        SettingsItem(
          icon: Icons.person_outline,
          title: 'Profile Information',
          subtitle: 'Manage your personal details',
          onTap: () => Navigator.pushNamed(context, AppRoutes.profileInfo),
        ),
        SettingsItem(
          icon: Icons.record_voice_over,
          title: 'Voice Assets',
          subtitle: 'Manage your voice portfolio and contracts',
          onTap: () => Navigator.pushNamed(context, AppRoutes.voiceAssets),
        ),
        SettingsItem(
          icon: Icons.history,
          title: 'Activity History',
          subtitle: 'View your platform interactions',
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildVoiceAssetsSection(BuildContext context) {
    return _buildSettingsSection(
      'Voice Assets',
      [
        SettingsItem(
          icon: Icons.music_note,
          title: 'Voice NFT Management',
          subtitle: 'Manage your voice NFTs and collections',
          onTap: () {},
        ),
        SettingsItem(
          icon: Icons.category,
          title: 'Categories & Tags',
          subtitle: 'Organize your voice assets',
          onTap: () {},
        ),
        SettingsItem(
          icon: Icons.analytics,
          title: 'Asset Analytics',
          subtitle: 'Track performance and usage',
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildContractsSection(BuildContext context, ContractService contractService) {
    return _buildSettingsSection(
      'Contracts & Licensing',
      [
        SettingsItem(
          icon: Icons.description,
          title: 'Active Contracts',
          subtitle: 'Manage your current voice licensing agreements',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ContractManagementScreen(
                contractService: contractService,
                filter: ContractFilter(status: 'active', contractType: ''),
              ),
            ),
          ),
        ),
        SettingsItem(
          icon: Icons.receipt_long,
          title: 'Royalty Management',
          subtitle: 'Configure revenue sharing and distributions',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RoyaltyManagementScreen(
                contractService: contractService,
              ),
            ),
          ),
        ),
        SettingsItem(
          icon: Icons.gavel,
          title: 'Usage Rights',
          subtitle: 'Set permissions and restrictions for voice usage',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UsageRightsScreen(
                contractService: contractService,
              ),
            ),
          ),
        ),
        SettingsItem(
          icon: Icons.history,
          title: 'Contract History',
          subtitle: 'View past and archived contracts',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ContractHistoryScreen(
                contractService: contractService,
              ),
            ),
          ),
        ),
        SettingsItem(
          icon: Icons.analytics,
          title: 'Contract Analytics',
          subtitle: 'Track performance and revenue metrics',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ContractAnalyticsScreen(
                contractService: contractService,
              ),
            ),
          ),
        ),
        SettingsItem(
          icon: Icons.security,
          title: 'Rights Protection',
          subtitle: 'Manage voice rights and protection settings',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RightsProtectionScreen(
                contractService: contractService,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentSection(BuildContext context) {
    return _buildSettingsSection(
      'Payment & Revenue',
      [
        SettingsItem(
          icon: Icons.account_balance_wallet,
          title: 'Payment Methods',
          subtitle: 'Manage crypto wallets and bank accounts',
          onTap: () {},
        ),
        SettingsItem(
          icon: Icons.payments,
          title: 'Revenue Distribution',
          subtitle: 'Configure earning allocations',
          onTap: () {},
        ),
        SettingsItem(
          icon: Icons.currency_exchange,
          title: 'Currency Preferences',
          subtitle: 'Set preferred payment currencies',
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildPrivacySection(BuildContext context) {
    return _buildSettingsSection(
      'Privacy',
      [
        SettingsItem(
          icon: Icons.visibility_outlined,
          title: 'Profile Visibility',
          subtitle: 'Control your public profile visibility',
          onTap: () => Navigator.pushNamed(
            context, 
            AppRoutes.profileVisibilitySettings
          ),
        ),
        SettingsItem(
          icon: Icons.record_voice_over_outlined,
          title: 'Voice Privacy',
          subtitle: 'Manage voice sample visibility and usage',
          onTap: () => Navigator.pushNamed(
            context, 
            AppRoutes.voicePrivacySettings
          ),
        ),
        SettingsItem(
          icon: Icons.fingerprint,
          title: 'Voice Identity Protection',
          subtitle: 'Configure voice fingerprint settings',
          onTap: () => Navigator.pushNamed(
            context, 
            AppRoutes.voiceIdentitySettings
          ),
        ),
        SettingsItem(
          icon: Icons.block_outlined,
          title: 'Blocked Users',
          subtitle: 'Manage blocked accounts and entities',
          onTap: () => Navigator.pushNamed(
            context, 
            AppRoutes.blockedUsers
          ),
        ),
        SettingsItem(
          icon: Icons.data_usage,
          title: 'Data Usage',
          subtitle: 'Control how your data is used and shared',
          onTap: () => Navigator.pushNamed(
            context, 
            AppRoutes.dataUsageSettings
          ),
        ),
      ],
    );
  }

  Widget _buildSecuritySection(BuildContext context) {
    return _buildSettingsSection(
      'Security',
      [
        SettingsItem(
          icon: Icons.lock_outline,
          title: 'Authentication',
          subtitle: 'Manage passwords and 2FA',
          onTap: () => Navigator.pushNamed(
            context, 
            AppRoutes.authenticationSettings
          ),
        ),
        SettingsItem(
          icon: Icons.account_balance_wallet_outlined,
          title: 'Wallet Security',
          subtitle: 'Manage connected wallets and permissions',
          onTap: () => Navigator.pushNamed(
            context, 
            AppRoutes.walletSecurity
          ),
        ),
        SettingsItem(
          icon: Icons.verified_user_outlined,
          title: 'Identity Verification',
          subtitle: 'Verify your identity for enhanced security',
          onTap: () => Navigator.pushNamed(
            context, 
            AppRoutes.identityVerification
          ),
        ),
        SettingsItem(
          icon: Icons.history_outlined,
          title: 'Login Activity',
          subtitle: 'Monitor account access and sessions',
          onTap: () => Navigator.pushNamed(
            context, 
            AppRoutes.loginActivity
          ),
        ),
        SettingsItem(
          icon: Icons.security_outlined,
          title: 'Recovery Options',
          subtitle: 'Set up account recovery methods',
          onTap: () => Navigator.pushNamed(
            context, 
            AppRoutes.recoveryOptions
          ),
        ),
      ],
    );
  }

  Widget _buildPreferencesSection(BuildContext context) {
    return _buildSettingsSection(
      'Preferences',
      [
        SettingsItem(
          icon: Icons.notifications_outlined,
          title: 'Notifications',
          subtitle: 'Configure alerts and reminders',
          onTap: () => Navigator.pushNamed(
            context, 
            AppRoutes.notificationPreferences
          ),
        ),
        SettingsItem(
          icon: Icons.language_outlined,
          title: 'Language & Region',
          subtitle: 'Set your preferred language and location',
          onTap: () => Navigator.pushNamed(
            context, 
            AppRoutes.languageSettings
          ),
        ),
        SettingsItem(
          icon: Icons.monetization_on_outlined,
          title: 'Default Pricing',
          subtitle: 'Set default rates for your voice assets',
          onTap: () => Navigator.pushNamed(
            context, 
            AppRoutes.defaultPricing
          ),
        ),
        SettingsItem(
          icon: Icons.category_outlined,
          title: 'Content Categories',
          subtitle: 'Manage preferred voice work categories',
          onTap: () => Navigator.pushNamed(
            context, 
            AppRoutes.contentCategories
          ),
        ),
        SettingsItem(
          icon: Icons.color_lens_outlined,
          title: 'Appearance',
          subtitle: 'Customize app theme and display',
          onTap: () => Navigator.pushNamed(
            context, 
            AppRoutes.appearanceSettings
          ),
        ),
        SettingsItem(
          icon: Icons.accessibility_new_outlined,
          title: 'Accessibility',
          subtitle: 'Configure accessibility options',
          onTap: () => Navigator.pushNamed(
            context, 
            AppRoutes.accessibilitySettings
          ),
        ),
      ],
    );
  }
}

class SettingsItem {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const SettingsItem({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
  });
}
