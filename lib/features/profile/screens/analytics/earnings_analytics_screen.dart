import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:speakmobilemvp/core/enums/time_range.dart';
import 'package:speakmobilemvp/features/profile/widgets/analytics/time_series_chart.dart';

class EarningsAnalyticsScreen extends StatefulWidget {
  const EarningsAnalyticsScreen({super.key});

  @override
  State<EarningsAnalyticsScreen> createState() => _EarningsAnalyticsScreenState();
}

class _EarningsAnalyticsScreenState extends State<EarningsAnalyticsScreen> {
  TimeRange _selectedRange = TimeRange.month;
  
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        _buildTotalEarningsCard(),
        const SizedBox(height: 16),
        TimeSeriesChart(
          title: 'Earnings Over Time',
          data: [], // Fetch from analytics service
          selectedRange: _selectedRange,
          onRangeChanged: (range) {
            setState(() => _selectedRange = range);
          },
          yAxisLabel: 'Earnings (\$)',
        ),
        const SizedBox(height: 16),
        _buildEarningsByCategory(),
        const SizedBox(height: 16),
        _buildRevenueStreams(),
      ],
    );
  }

  Widget _buildTotalEarningsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Total Earnings',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            const Text(
              '\$0.00', // Replace with actual earnings data
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRevenueStreams() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Revenue Streams',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            // Add revenue stream list items here
            _buildRevenueItem('Direct Sales', 0.00),
            _buildRevenueItem('Royalties', 0.00),
            _buildRevenueItem('Commissions', 0.00),
          ],
        ),
      ),
    );
  }

  Widget _buildRevenueItem(String title, double amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildEarningsByCategory() {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Earnings by Category',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 300,
            child: PieChart(
              PieChartData(
                sections: [
                  PieChartSectionData(
                    value: 30,
                    title: '30%',
                    color: Colors.blue,
                    radius: 100,
                  ),
                  PieChartSectionData(
                    value: 70,
                    title: '70%',
                    color: Colors.green,
                    radius: 100,
                  ),
                ],
                sectionsSpace: 2,
                centerSpaceRadius: 40,
              ),
            ),
          ),
        ],
      ),
    );
  }
} 