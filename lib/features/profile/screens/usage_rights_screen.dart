import 'package:flutter/material.dart';
import 'package:speakmobilemvp/core/theme/app_spacing.dart';
import 'package:speakmobilemvp/features/profile/models/voice_contract.dart';
import 'package:speakmobilemvp/features/profile/models/contract_filter.dart';

import '../../../core/services/frontend/contract_service.dart';

class UsageRightsScreen extends StatefulWidget {
  final ContractService contractService;

  const UsageRightsScreen({
    super.key,
    required this.contractService,
  });

  @override
  State<UsageRightsScreen> createState() => _UsageRightsScreenState();
}

class _UsageRightsScreenState extends State<UsageRightsScreen> {
  late Future<List<VoiceContract>> _contractsFuture;

  @override
  void initState() {
    super.initState();
    _loadContracts();
  }

  Future<void> _loadContracts() async {
    setState(() {
      _contractsFuture = widget.contractService
          .getContracts(filter: ContractFilter(contractType: 'rights'))
          .then((contracts) => contracts.map((c) => c as VoiceContract).toList());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usage Rights'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.m),
        children: [
          _buildUsageRightsOverview(),
          const SizedBox(height: AppSpacing.l),
          _buildUsageRestrictions(),
          const SizedBox(height: AppSpacing.l),
          _buildActiveContracts(),
        ],
      ),
    );
  }

  Widget _buildUsageRightsOverview() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Usage Rights Overview',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.m),
            ListTile(
              leading: const Icon(Icons.public),
              title: const Text('Global Usage Rights'),
              subtitle: const Text('Manage default usage permissions'),
              trailing: Switch(
                value: true,
                onChanged: (value) {
                  // Implementation
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUsageRestrictions() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Usage Restrictions',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.m),
            _buildRestrictionItem(
              'Commercial Use',
              'Allow usage in commercial projects',
              true,
            ),
            _buildRestrictionItem(
              'Educational Use',
              'Allow usage in educational content',
              true,
            ),
            _buildRestrictionItem(
              'Geographic Restrictions',
              'Limit usage to specific regions',
              false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRestrictionItem(String title, String subtitle, bool value) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Switch(
        value: value,
        onChanged: (newValue) {
          // Implementation
        },
      ),
    );
  }

  Widget _buildActiveContracts() {
    return FutureBuilder<List<VoiceContract>>(
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

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Active Contracts',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.m),
            ...contracts.map((contract) => _buildContractCard(contract)),
          ],
        );
      },
    );
  }

  Widget _buildContractCard(VoiceContract contract) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.m),
      child: ListTile(
        title: Text(contract.title),
        subtitle: Text(contract.usageScope),
        trailing: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () => _editUsageRights(contract),
        ),
        onTap: () => _viewUsageDetails(contract),
      ),
    );
  }

  Future<void> _editUsageRights(VoiceContract contract) async {
    // Implementation for editing usage rights
  }

  Future<void> _viewUsageDetails(VoiceContract contract) async {
    // Implementation for viewing usage details
  }
}
