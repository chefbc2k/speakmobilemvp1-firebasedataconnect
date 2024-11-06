import 'package:flutter/material.dart';
import 'package:speakmobilemvp/features/profile/widgets/contract_list_item.dart';

import '../../../core/models/contract_details.dart';
import '../../../core/services/frontend/contract_service.dart';
import '../models/contract_filter.dart';

class ContractManagementScreen extends StatefulWidget {
  final ContractService contractService;
  final ContractFilter filter;

  const ContractManagementScreen({
    super.key,
    required this.contractService,
    required this.filter,
  });

  @override
  State<ContractManagementScreen> createState() => _ContractManagementScreenState();
}

class _ContractManagementScreenState extends State<ContractManagementScreen> {
  late Future<List<ContractDetails>> _contractsFuture;

  @override
  void initState() {
    super.initState();
    _contractsFuture = _loadContracts();
  }

  Future<List<ContractDetails>> _loadContracts() {
    return widget.contractService.getContracts(filter: widget.filter);
  }

  Future<void> refresh() async {
    setState(() {
      _contractsFuture = _loadContracts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contract Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterOptions,
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _createNewContract(context),
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
              child: Text('Error loading contracts: ${snapshot.error}'),
            );
          }

          final contracts = snapshot.data ?? [];
          
          return ListView.builder(
            itemCount: contracts.length,
            itemBuilder: (context, index) {
              final contract = contracts[index];
              return ContractListItem(
                contract: contract,
                onTap: () => _viewContractDetails(context, contract),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _showFilterOptions() async {
    // Implementation for filter dialog
  }

  Future<void> _createNewContract(BuildContext context) async {
    // Implementation for contract creation
  }

  Future<void> _viewContractDetails(BuildContext context, ContractDetails contract) async {
    // Implementation for viewing contract details
  }
} 