import 'package:flutter/material.dart';
import 'package:speakmobilemvp/core/theme/app_colors.dart';
import 'package:speakmobilemvp/core/theme/app_spacing.dart';
import 'package:speakmobilemvp/features/profile/models/voice_contract.dart';

import '../../../core/services/frontend/contract_service.dart';
import '../models/contract_filter.dart';

class RoyaltyManagementScreen extends StatefulWidget {
  final ContractService contractService;

  const RoyaltyManagementScreen({
    super.key,
    required this.contractService,
  });

  @override
  State<RoyaltyManagementScreen> createState() => _RoyaltyManagementScreenState();
}

class _RoyaltyManagementScreenState extends State<RoyaltyManagementScreen> {
  late Future<List<VoiceContract>> _contractsFuture;

  @override
  void initState() {
    super.initState();
    _loadContracts();
  }

  Future<void> _loadContracts() async {
    setState(() {
      _contractsFuture = widget.contractService
          .getContracts(filter: ContractFilter(contractType: 'royalty'))
          .then((contracts) => contracts
              .map((contract) => VoiceContract.fromContractDetails(contract))
              .toList());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Royalty Management'),
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
              _buildRoyaltyOverview(),
              const SizedBox(height: AppSpacing.l),
              _buildRoyaltyContracts(contracts),
            ],
          );
        },
      ),
    );
  }

  Widget _buildRoyaltyOverview() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Royalty Overview',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.m),
            _buildRoyaltyStats(),
          ],
        ),
      ),
    );
  }

  Widget _buildRoyaltyStats() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatItem('Active Royalties', '12'),
        _buildStatItem('Total Earned', '\$15,234'),
        _buildStatItem('Pending', '\$1,234'),
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

  Widget _buildRoyaltyContracts(List<VoiceContract> contracts) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Active Royalty Contracts',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: AppSpacing.m),
        ...contracts.map((contract) => _buildRoyaltyContractCard(contract)),
      ],
    );
  }

  Widget _buildRoyaltyContractCard(VoiceContract contract) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.m),
      child: ListTile(
        title: Text(contract.title),
        subtitle: Text(
          'Rate: ${contract.rate}% - ${contract.usageScope}',
        ),
        trailing: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () => _editRoyaltyContract(contract),
        ),
        onTap: () => _viewRoyaltyDetails(contract),
      ),
    );
  }

  Future<void> _editRoyaltyContract(VoiceContract contract) async {
    // Implementation for editing royalty contract
  }

  Future<void> _viewRoyaltyDetails(VoiceContract contract) async {
    // Implementation for viewing royalty details
  }
} 