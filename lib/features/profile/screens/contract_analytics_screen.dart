import 'package:flutter/material.dart';
import 'package:speakmobilemvp/core/theme/app_spacing.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../core/models/contract_details.dart';
import '../../../core/services/frontend/contract_service.dart';
import '../models/contract_filter.dart';

class ContractAnalyticsScreen extends StatefulWidget {
  final ContractService contractService;

  const ContractAnalyticsScreen({
    super.key,
    required this.contractService,
  });

  @override
  State<ContractAnalyticsScreen> createState() => _ContractAnalyticsScreenState();
}

class _ContractAnalyticsScreenState extends State<ContractAnalyticsScreen> {
  late Future<List<ContractDetails>> _contractsFuture;
  String _selectedTimeframe = 'month';

  @override
  void initState() {
    super.initState();
    _loadContracts();
  }

  Future<void> _loadContracts() async {
    setState(() {
      _contractsFuture = widget.contractService.getContracts(
        filter: ContractFilter(contractType: 'analytics'),
      ).then((contracts) => contracts);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contract Analytics'),
        actions: [
          DropdownButton<String>(
            value: _selectedTimeframe,
            items: ['week', 'month', 'year'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value.toUpperCase()),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  _selectedTimeframe = newValue;
                  _loadContracts();
                });
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<List<ContractDetails>>(
        future: _contractsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          final contracts = snapshot.data ?? [];
          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.m),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildEarningsChart(contracts),
                const SizedBox(height: AppSpacing.l),
                _buildContractTypeDistribution(contracts),
                const SizedBox(height: AppSpacing.l),
                _buildUsageScopeAnalysis(contracts),
                const SizedBox(height: AppSpacing.l),
                _buildRevenueByPlatform(contracts),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildEarningsChart(List<ContractDetails> contracts) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Earnings Overview',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.m),
            SizedBox(
              height: 200,
              child: LineChart(
                // Implementation of earnings chart
                LineChartData(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContractTypeDistribution(List<ContractDetails> contracts) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Contract Type Distribution',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.m),
            SizedBox(
              height: 200,
              child: PieChart(
                // Implementation of contract type distribution
                PieChartData(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUsageScopeAnalysis(List<ContractDetails> contracts) {
    // Implementation
    return Container();
  }

  Widget _buildRevenueByPlatform(List<ContractDetails> contracts) {
    // Implementation
    return Container();
  }
}
