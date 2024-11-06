import 'package:flutter/material.dart';
import 'package:speakmobilemvp/core/theme/app_colors.dart';
import 'package:speakmobilemvp/core/theme/app_spacing.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  Map<String, bool> notificationSettings = {
    'Voice NFT Sales': true,
    'Royalty Payments': true,
    'Contract Updates': true,
    'Usage Analytics': true,
    'Market Opportunities': true,
    'Platform Updates': false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E6), // Using Timeless Legacy background
      appBar: AppBar(
        backgroundColor: const Color(0xFF234B6B), // Using Timeless Legacy primary
        foregroundColor: Colors.white,
        title: const Text('Notification Settings'),
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildNotificationCategories(),
            const SizedBox(height: 24),
            _buildRecentNotifications(),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCategories() {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFE6A87C), // Using Timeless Legacy accent
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: const Text(
              'Notification Preferences',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF234B6B), // Using Timeless Legacy primary
              ),
            ),
          ),
          ...notificationSettings.entries.map((entry) {
            return _buildNotificationToggle(
              title: entry.key,
              value: entry.value,
              onChanged: (value) {
                setState(() {
                  notificationSettings[entry.key] = value;
                });
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _buildNotificationToggle({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: AppColors.cardBorder),
        ),
      ),
      child: SwitchListTile(
        title: Text(
          title,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
          ),
        ),
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.primary,
      ),
    );
  }

  Widget _buildRecentNotifications() {
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
              'Recent Notifications',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          _buildNotificationItem(
            title: 'New Earnings',
            message: 'You earned \$50 from Voice NFT #123',
            time: '2h ago',
            icon: Icons.attach_money,
          ),
          _buildNotificationItem(
            title: 'Contract Update',
            message: 'Your contract for Project X has been updated',
            time: '1d ago',
            icon: Icons.description,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem({
    required String title,
    required String message,
    required String time,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: AppColors.cardBorder),
        ),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(
          title,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          message,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
          ),
        ),
        trailing: Text(
          time,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
} 