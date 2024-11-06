import 'package:flutter/material.dart';
import 'package:speakmobilemvp/core/theme/app_colors.dart';
import 'package:speakmobilemvp/core/theme/app_spacing.dart';
import 'package:speakmobilemvp/features/profile/models/voice_contract.dart';
import 'package:speakmobilemvp/features/profile/widgets/contract_list_item.dart';

import '../../../core/models/contract_details.dart';
import '../../../core/services/frontend/contract_service.dart';
import '../models/contract_filter.dart';

class ContractHistoryScreen extends StatefulWidget {
  final ContractService contractService;

  const ContractHistoryScreen({
    super.key,
    required this.contractService,
  });

  @override
  State<ContractHistoryScreen> createState() => _ContractHistoryScreenState();
}

class _ContractHistoryScreenState extends State<ContractHistoryScreen> {
  late Future<List<VoiceContract>> _contractsFuture;

  @override
  void initState() {
    super.initState();
    _contractsFuture = _loadContracts();
  }

  Future<List<VoiceContract>> _loadContracts() {
    return widget.contractService
        .getContracts(filter: ContractFilter(contractType: 'history'))
        .then((contracts) => contracts.map((c) => c as VoiceContract).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contract History'),
      ),
      body: FutureBuilder<List<VoiceContract>>(
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

          return ListView(
            padding: const EdgeInsets.all(AppSpacing.m),
            children: [
              _buildHistoryOverview(),
              const SizedBox(height: AppSpacing.l),
              _buildContractList(contracts),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHistoryOverview() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Contract History Overview',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.m),
            _buildHistoryStats(),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryStats() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatItem('Total Contracts', '45'),
        _buildStatItem('Completed', '32'),
        _buildStatItem('Terminated', '13'),
      ],
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildContractList(List<VoiceContract> contracts) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Past Contracts',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: AppSpacing.m),
        ...contracts.map((contract) => ContractListItem(
              contract: _convertToContractDetails(contract),
              onTap: () => _viewContractDetails(contract),
            )),
      ],
    );
  }

  ContractDetails _convertToContractDetails(VoiceContract contract) {
    return ContractDetails(
      id: contract.id,
      title: contract.title,
      description: contract.clientName, // or any other field you want to use as description
      status: contract.status,
      contractType: contract.contractType,
      language: contract.usageScope, // or appropriate language field from VoiceContract
      culturalMetadata: contract.culturalMetadata, type: null,
    );
  }

  Future<void> _viewContractDetails(VoiceContract contract) async {
    // Implementation for viewing contract details
  }
} 