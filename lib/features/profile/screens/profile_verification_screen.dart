import 'package:flutter/material.dart';
import 'package:speakmobilemvp/core/theme/app_colors.dart';
import 'package:speakmobilemvp/core/theme/app_spacing.dart';

class ProfileVerificationScreen extends StatelessWidget {
  const ProfileVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Legacy Progress'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.background,
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.m),
          children: [
            _buildLegacyStatus(),
            const SizedBox(height: AppSpacing.l),
            _buildProgressionPath(),
          ],
        ),
      ),
    );
  }

  Widget _buildLegacyStatus() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.m),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFE6A87C), // Using the Cultural Heritage palette
            const Color(0xFFC17F59),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Voice Legacy Status',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: AppSpacing.s),
          Text(
            'Cultural Preservationist - Level 2',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: AppSpacing.m),
          LinearProgressIndicator(
            value: 0.4,
            backgroundColor: Colors.white.withOpacity(0.3),
            valueColor: AlwaysStoppedAnimation<Color>(
              const Color(0xFF234B6B),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '400/1000 Legacy Points',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressionPath() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.m),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Legacy Building Path',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.m),
          _buildMilestone(
            icon: Icons.record_voice_over,
            title: 'Voice NFT Collection',
            subtitle: 'Mint your first 5 voice NFTs',
            progress: '3/5 Completed',
            status: 'In Progress',
          ),
          _buildMilestone(
            icon: Icons.groups,
            title: 'DAO Participation',
            subtitle: 'Join and contribute to voice preservation DAOs',
            progress: '2 Active DAOs',
            status: 'Active',
          ),
          _buildMilestone(
            icon: Icons.description,
            title: 'Smart Contracts',
            subtitle: 'Execute voice licensing contracts',
            progress: '1/3 Completed',
            status: 'In Progress',
          ),
          _buildMilestone(
            icon: Icons.diversity_3,
            title: 'Community Engagement',
            subtitle: 'Participate in cultural preservation initiatives',
            progress: '150 Points',
            status: 'Active',
          ),
          _buildMilestone(
            icon: Icons.verified,
            title: 'Cultural Authentication',
            subtitle: 'Complete cultural voice verification',
            progress: 'Not Started',
            status: 'Locked',
          ),
        ],
      ),
    );
  }

  Widget _buildMilestone({
    required IconData icon,
    required String title,
    required String subtitle,
    required String progress,
    required String status,
  }) {
    final isLocked = status == 'Locked';
    final isActive = status == 'Active';

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.m),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.s),
            decoration: BoxDecoration(
              color: isLocked
                  ? Colors.grey.withOpacity(0.1)
                  : const Color(0xFF234B6B).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: isLocked ? Colors.grey : const Color(0xFF234B6B),
              size: 24,
            ),
          ),
          const SizedBox(width: AppSpacing.m),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isLocked ? Colors.grey : AppColors.textPrimary,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: isLocked
                        ? Colors.grey
                        : AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  progress,
                  style: TextStyle(
                    fontSize: 12,
                    color: isActive
                        ? const Color(0xFFE6A87C)
                        : AppColors.textSecondary,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: status == 'Completed'
                  ? AppColors.success.withOpacity(0.1)
                  : AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 12,
                color: status == 'Completed'
                    ? AppColors.success
                    : AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
