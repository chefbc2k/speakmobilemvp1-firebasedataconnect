import 'package:flutter/material.dart';
import 'package:speakmobilemvp/core/theme/app_colors.dart';
import 'package:speakmobilemvp/core/theme/app_spacing.dart';
import 'package:speakmobilemvp/core/routes/app_routes.dart';

class ProfileMainScreen extends StatelessWidget {
  const ProfileMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.m),
          children: [
            _buildProfileHeader(context),
            const SizedBox(height: AppSpacing.l),
            _buildNavigationSection(context),
            const SizedBox(height: AppSpacing.l),
            _buildSettingsSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.m),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.primaryLight,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: AppColors.background.withOpacity(0.2),
            child: Icon(
              Icons.person,
              size: 40,
              color: AppColors.background,
            ),
          ),
          const SizedBox(width: AppSpacing.m),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'User Name',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.background,
                  ),
                ),
                Text(
                  'Tap to edit profile',
                  style: TextStyle(
                    color: AppColors.background.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'My Content',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.m),
        _buildNavigationTile(
          context,
          title: 'Voice NFT Collection',
          route: AppRoutes.collection,
          icon: Icons.music_note,
        ),
        _buildNavigationTile(
          context,
          title: 'Analytics',
          route: AppRoutes.profileAnalytics,
          icon: Icons.bar_chart,
        ),
        _buildNavigationTile(
          context,
          title: 'Verification Status',
          route: AppRoutes.verification,
          icon: Icons.verified_user,
        ),
      ],
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Settings',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.m),
        _buildNavigationTile(
          context,
          title: 'Profile Settings',
          route: AppRoutes.profileSettings,
          icon: Icons.settings,
        ),
        _buildNavigationTile(
          context,
          title: 'Notifications',
          route: AppRoutes.notifications,
          icon: Icons.notifications,
        ),
      ],
    );
  }

  Widget _buildNavigationTile(
    BuildContext context, {
    required String title,
    required String route,
    required IconData icon,
  }) {
    return InkWell(
      onTap: () => Navigator.of(context, rootNavigator: true).pushNamed(route),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.m,
          vertical: AppSpacing.s,
        ),
        margin: const EdgeInsets.only(bottom: AppSpacing.xs),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.cardBorder,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: AppColors.primary,
              size: 24,
            ),
            const SizedBox(width: AppSpacing.m),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: AppColors.textSecondary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
