import 'package:flutter/material.dart';
import 'package:speakmobilemvp/core/theme/app_colors.dart';
import 'package:speakmobilemvp/features/profile/screens/analytics/earnings_analytics_screen.dart';
import 'package:speakmobilemvp/features/profile/screens/analytics/contracts_analytics_screen.dart';
import 'package:speakmobilemvp/features/profile/screens/analytics/nft_analytics_screen.dart';
import 'package:speakmobilemvp/features/profile/screens/analytics/membership_analytics_screen.dart';
import 'package:speakmobilemvp/features/profile/screens/analytics/staking_analytics_screen.dart';

class AnalyticsMainScreen extends StatefulWidget {
  const AnalyticsMainScreen({super.key});

  @override
  State<AnalyticsMainScreen> createState() => _AnalyticsMainScreenState();
}

class _AnalyticsMainScreenState extends State<AnalyticsMainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const EarningsAnalyticsScreen(),
    const ContractsAnalyticsScreen(),
    const NFTAnalyticsScreen(),
    const MembershipAnalyticsScreen(),
    const StakingAnalyticsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Analytics Dashboard'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.background,
        elevation: 0,
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.attach_money),
            label: 'Earnings',
          ),
          NavigationDestination(
            icon: Icon(Icons.description),
            label: 'Contracts',
          ),
          NavigationDestination(
            icon: Icon(Icons.token),
            label: 'NFTs',
          ),
          NavigationDestination(
            icon: Icon(Icons.card_membership),
            label: 'Membership',
          ),
          NavigationDestination(
            icon: Icon(Icons.trending_up),
            label: 'Staking',
          ),
        ],
      ),
    );
  }
}
