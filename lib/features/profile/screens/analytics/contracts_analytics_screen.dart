import 'package:flutter/material.dart';

class ContractsAnalyticsScreen extends StatelessWidget {
  const ContractsAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildContractsSummary(),
        const SizedBox(height: 16),
        _buildContractsChart(),
        const SizedBox(height: 16),
        _buildActiveContracts(),
      ],
    );
  }

  Widget _buildContractsSummary() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Contracts Overview',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text('Active Contracts: 0'),
            Text('Pending Verification: 0'),
            Text('Completed: 0'),
          ],
        ),
      ),
    );
  }

  Widget _buildContractsChart() {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: SizedBox(
          height: 200,
          child: Center(
            child: Text('Contracts Chart Coming Soon'),
          ),
        ),
      ),
    );
  }

  Widget _buildActiveContracts() {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Active Contracts',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: Text('No active contracts'),
            ),
          ],
        ),
      ),
    );
  }
} 