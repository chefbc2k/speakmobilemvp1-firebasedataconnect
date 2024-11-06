import 'package:flutter/material.dart';

class MembershipAnalyticsScreen extends StatelessWidget {
  const MembershipAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildMembershipStatus(),
        const SizedBox(height: 16),
        _buildBenefitsUsage(),
        const SizedBox(height: 16),
        _buildUpcomingPerks(),
      ],
    );
  }

  Widget _buildMembershipStatus() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Membership Status',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text('Current Tier: Basic'),
            Text('Member Since: N/A'),
            Text('Next Tier: Premium'),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefitsUsage() {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Benefits Usage',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: Text('Benefits usage chart coming soon'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingPerks() {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Upcoming Perks',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: Text('No upcoming perks'),
            ),
          ],
        ),
      ),
    );
  }
} 