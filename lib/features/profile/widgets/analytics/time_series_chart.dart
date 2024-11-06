import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:speakmobilemvp/core/enums/time_range.dart';

class TimeSeriesChart extends StatelessWidget {
  final String title;
  final List<TimeSeriesData> data;
  final TimeRange selectedRange;
  final Function(TimeRange) onRangeChanged;
  final String yAxisLabel;

  const TimeSeriesChart({
    super.key,
    required this.title,
    required this.data,
    required this.selectedRange,
    required this.onRangeChanged,
    required this.yAxisLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                DropdownButton<TimeRange>(
                  value: selectedRange,
                  items: TimeRange.values.map((range) {
                    return DropdownMenuItem(
                      value: range,
                      child: Text(range.label),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) onRangeChanged(value);
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  // Add your chart configuration here
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(show: true),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: data.map((point) => FlSpot(
                        point.timestamp.millisecondsSinceEpoch.toDouble(),
                        point.value,
                      )).toList(),
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 2,
                      dotData: FlDotData(show: false),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TimeSeriesData {
  final DateTime timestamp;
  final double value;
  final String? category;

  const TimeSeriesData({
    required this.timestamp,
    required this.value,
    this.category,
  });
}
