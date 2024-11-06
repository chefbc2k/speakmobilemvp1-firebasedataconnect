import 'package:flutter/material.dart';

class StakingAnalyticsScreen extends StatelessWidget {
  const StakingAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildStakingSummary(),
        const SizedBox(height: 16),
        _buildStakingRewards(),
        const SizedBox(height: 16),
        _buildStakingHistory(),
      ],
    );
  }

  Widget _buildStakingSummary() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Staking Summary',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text('Total Staked: 0'),
            Text('Current APY: 0%'),
            Text('Earned Rewards: \$0.00'),
          ],
        ),
      ),
    );
  }

  Widget _buildStakingRewards() {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Rewards Chart',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: Text('Rewards chart coming soon'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStakingHistory() {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Staking History',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: Text('No staking history'),
            ),
          ],
        ),
      ),
    );
  }
} 