// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:speakmobilemvp/core/services/frontend/contract_service.dart';
import 'package:speakmobilemvp/core/models/contract_details.dart';
import 'package:speakmobilemvp/features/discover/widgets/contract_filter_bar.dart';
import 'package:speakmobilemvp/features/discover/widgets/contract_list_item.dart';
import 'package:speakmobilemvp/core/utils/error_handler.dart';
import 'package:speakmobilemvp/core/services/analytics/analytics_service.dart';
import 'package:speakmobilemvp/features/profile/models/contract_filter.dart';

import 'discover_screen.dart';

class VoiceContractListScreen extends StatefulWidget {
  final ContractService contractService;
  final AnalyticsService analytics;

  const VoiceContractListScreen({
    super.key,
    required this.contractService,
    required this.analytics,
  });

  @override
  State<VoiceContractListScreen> createState() => _VoiceContractListScreenState();
}

class _VoiceContractListScreenState extends State<VoiceContractListScreen> {
  String? _searchQuery;
  ContractType? _selectedType;
  String? _selectedCategory;
  String? _selectedLanguage;
  bool _isLoading = false;
  List<ContractDetails> _contracts = [];
  int _currentPage = 1;
  static const int _pageSize = 20;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadContracts();
    _scrollController.addListener(_onScroll);
    _logScreenView();
  }

  Future<void> _logScreenView() async {
    await widget.analytics.logScreenView(
      screenName: 'voice_contract_list',
      screenClass: 'VoiceContractListScreen',
    );
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      _loadMoreContracts();
    }
  }

  Future<void> _loadContracts() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final contracts = await widget.contractService.getContracts(
        searchQuery: _searchQuery,
        type: _selectedType,
        category: _selectedCategory,
        language: _selectedLanguage,
        page: _currentPage,
        pageSize: _pageSize,
        filter: ContractFilter(contractType: 'voice'),
      );

      setState(() {
        _contracts = contracts;
        _isLoading = false;
      });

      await widget.analytics.logEvent(
        name: 'load_contracts',
        parameters: {
          'count': contracts.length,
          'type': _selectedType?.toString(),
          'category': _selectedCategory,
          'language': _selectedLanguage,
        },
      );
    } catch (e) {
      setState(() => _isLoading = false);
      ErrorHandler.showError(
        context: context,
        error: 'Failed to load contracts: $e',
      );
    }
  }

  Future<void> _loadMoreContracts() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);
    _currentPage++;

    try {
      final moreContracts = await widget.contractService.getContracts(
        searchQuery: _searchQuery,
        type: _selectedType,
        category: _selectedCategory,
        language: _selectedLanguage,
        page: _currentPage,
        pageSize: _pageSize,
        filter: ContractFilter(contractType: 'voice'),
      );

      setState(() {
        _contracts.addAll(moreContracts);
        _isLoading = false;
      });

      await widget.analytics.logEvent(
        name: 'load_more_contracts',
        parameters: {
          'page': _currentPage,
          'count': moreContracts.length,
        },
      );
    } catch (e) {
      setState(() => _isLoading = false);
      ErrorHandler.showError(
        context: context,
        error: 'Failed to load more contracts: $e',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Voice Contracts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Show advanced filters dialog
              widget.analytics.logEvent(name: 'open_filters');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          ContractFilterBar(
            searchQuery: _searchQuery,
            selectedType: _selectedType,
            selectedCategory: _selectedCategory,
            selectedLanguage: _selectedLanguage,
            onSearchChanged: (query) {
              setState(() => _searchQuery = query);
              _loadContracts();
              widget.analytics.logEvent(
                name: 'search_contracts',
                parameters: {'query': query},
              );
            },
            onTypeChanged: (type) {
              setState(() => _selectedType = type);
              _loadContracts();
              widget.analytics.logEvent(
                name: 'filter_by_type',
                parameters: {'type': type?.toString()},
              );
            },
            onCategoryChanged: (category) {
              setState(() => _selectedCategory = category);
              _loadContracts();
              widget.analytics.logEvent(
                name: 'filter_by_category',
                parameters: {'category': category},
              );
            },
            onLanguageChanged: (language) {
              setState(() => _selectedLanguage = language);
              _loadContracts();
              widget.analytics.logEvent(
                name: 'filter_by_language',
                parameters: {'language': language},
              );
            },
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                _currentPage = 1;
                await _loadContracts();
                widget.analytics.logEvent(name: 'refresh_contracts');
              },
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _contracts.length + (_isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _contracts.length) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  final contract = _contracts[index];
                  return ContractListItem(
                    contract: contract,
                    onTap: () {
                      widget.analytics.logEvent(
                        name: 'view_contract_details',
                        parameters: {'contract_id': contract.id},
                      );
                      // Navigate to contract details
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
