import 'package:flutter/material.dart';
import 'package:speakmobilemvp/core/services/frontend/contract_service.dart';

class CategoryMetricsCard extends StatelessWidget {
  final CategoryStatistics statistics;

  const CategoryMetricsCard({
    super.key,
    required this.statistics,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Category Statistics',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _buildMetricRow(
              context,
              'Total Contracts',
              statistics.totalContracts.toString(),
              Icons.description,
            ),
            _buildMetricRow(
              context,
              'Active Contracts',
              statistics.activeContracts.toString(),
              Icons.check_circle_outline,
            ),
            _buildMetricRow(
              context,
              'Pending Verification',
              statistics.pendingVerification.toString(),
              Icons.pending_actions,
            ),
            const Divider(height: 32),
            Text(
              'Contract Types',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            _buildDistributionChart(
              context,
              statistics.contractsByType,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Text(label),
          const Spacer(),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildDistributionChart(
    BuildContext context,
    Map<String, int> distribution,
  ) {
    final total = distribution.values.fold(0, (sum, count) => sum + count);
    
    return Column(
      children: distribution.entries.map((entry) {
        final percentage = (entry.value / total * 100).toStringAsFixed(1);
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(entry.key),
              const SizedBox(height: 4),
              LinearProgressIndicator(
                value: entry.value / total,
                backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.primary,
                ),
              ),
              Text(
                '$percentage%',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
} 