import 'package:flutter/material.dart';
import 'package:speakmobilemvp/core/theme/app_spacing.dart';
import 'package:speakmobilemvp/features/profile/models/voice_contract.dart';
import 'package:speakmobilemvp/features/profile/models/contract_filter.dart';

import '../../../core/services/frontend/contract_service.dart';

class RightsProtectionScreen extends StatefulWidget {
  final ContractService contractService;

  const RightsProtectionScreen({
    super.key,
    required this.contractService,
  });

  @override
  State<RightsProtectionScreen> createState() => _RightsProtectionScreenState();
}

class _RightsProtectionScreenState extends State<RightsProtectionScreen> {
  late Future<List<VoiceContract>> _contractsFuture;

  @override
  void initState() {
    super.initState();
    _loadContracts();
  }

  Future<void> _loadContracts() async {
    setState(() {
      _contractsFuture = widget.contractService
          .getContracts(filter: ContractFilter(contractType: 'protection'))
          .then((contracts) => contracts.map((c) => c as VoiceContract).toList());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rights Protection'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRightsOverview(),
            const SizedBox(height: AppSpacing.l),
            _buildProtectionSettings(),
            const SizedBox(height: AppSpacing.l),
            _buildContractProtections(),
          ],
        ),
      ),
    );
  }

  Widget _buildRightsOverview() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Rights Overview',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.m),
            _buildRightsSummary(),
          ],
        ),
      ),
    );
  }

  Widget _buildRightsSummary() {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.security),
          title: const Text('Voice Rights Protection'),
          subtitle: const Text('Active on all contracts'),
          trailing: Switch(
            value: true,
            onChanged: (bool value) {
              // Implementation
            },
          ),
        ),
        ListTile(
          leading: const Icon(Icons.gavel),
          title: const Text('Legal Protection'),
          subtitle: const Text('Automatic legal documentation'),
          trailing: Switch(
            value: true,
            onChanged: (bool value) {
              // Implementation
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProtectionSettings() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Protection Settings',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.m),
            _buildProtectionOptions(),
          ],
        ),
      ),
    );
  }

  Widget _buildProtectionOptions() {
    return Column(
      children: [
        SwitchListTile(
          title: const Text('Automatic Rights Registration'),
          subtitle: const Text('Register new contracts automatically'),
          value: true,
          onChanged: (bool value) {
            // Implementation
          },
        ),
        SwitchListTile(
          title: const Text('Usage Monitoring'),
          subtitle: const Text('Track voice usage across platforms'),
          value: true,
          onChanged: (bool value) {
            // Implementation
          },
        ),
        SwitchListTile(
          title: const Text('Rights Violation Alerts'),
          subtitle: const Text('Get notified of potential misuse'),
          value: true,
          onChanged: (bool value) {
            // Implementation
          },
        ),
      ],
    );
  }

  Widget _buildContractProtections() {
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
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.m),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Contract Protections',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: AppSpacing.m),
                ...contracts.map((contract) => _buildContractProtectionItem(contract)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildContractProtectionItem(VoiceContract contract) {
    return ListTile(
      title: Text(contract.title),
      subtitle: Text(contract.contractType),
      trailing: IconButton(
        icon: const Icon(Icons.security),
        onPressed: () => _viewContractProtections(contract),
      ),
    );
  }

  Future<void> _viewContractProtections(VoiceContract contract) async {
    // Implementation for viewing contract protections
  }
}
