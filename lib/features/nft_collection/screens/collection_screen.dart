import 'package:flutter/material.dart';
import 'package:speakmobilemvp/features/nft_collection/widgets/nft_card.dart';
import 'package:speakmobilemvp/core/models/voice_collection.dart';
import 'package:speakmobilemvp/features/nft_collection/widgets/collection_stats_card.dart';
import 'package:speakmobilemvp/features/nft_collection/widgets/collection_filter_bar.dart';
import 'package:speakmobilemvp/core/theme/app_colors.dart';
import 'package:speakmobilemvp/core/services/analytics/analytics_service.dart';

import '../../../core/routes/app_routes.dart';

class CollectionScreen extends StatefulWidget {
  const CollectionScreen({super.key});

  @override
  State<CollectionScreen> createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> {
  final List<VoiceCollection> collections = [
    VoiceCollection(
      id: '1',
      title: 'Entertainment Voice Pack',
      description: 'Professional voice pack for animation and gaming',
      category: 'Entertainment',
      status: 'Ready for minting',
      createdAt: '2024-01-01',
      usageRights: 'Commercial',
      culturalContext: 'Global',
      voiceCharacteristics: ['Energetic', 'Youthful'],
      potentialApplications: ['Gaming', 'Animation', 'Advertising'],
      estimatedValue: '0.5 ETH',
    ),
    VoiceCollection(
      id: '2', 
      title: 'Voice NFT #2',
      description: 'Educational content voice-over',
      category: 'E-Learning',
      status: 'Processing',
      createdAt: '2024-01-01',
    ),
    VoiceCollection(
      id: '3',
      title: 'Voice NFT #3', 
      description: 'Corporate training narration',
      category: 'Corporate',
      status: 'Minted',
      createdAt: '2024-01-01',
    ),
  ];

  String _selectedFilter = 'All';
  String _searchQuery = '';
  final AnalyticsService _analytics = AnalyticsService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            // Enhanced Stats Card
            CollectionStatsCard(
              totalNFTs: collections.length,
              mintedCount: collections.where((c) => c.status == 'Minted').length,
              processingCount: collections.where((c) => c.status == 'Processing').length,
              totalValue: _calculateTotalValue(),
            ),
            
            // Search and Filter Bar
            CollectionFilterBar(
              selectedFilter: _selectedFilter,
              onFilterChanged: _handleFilterChange,
              onSearchChanged: _handleSearch,
            ),

            // Collection List with Enhanced Information
            Expanded(
              child: _buildCollectionList(),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildCreateButton(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      title: const Text('Voice NFT Collection'),
      elevation: 0,
      actions: [
        IconButton(
          icon: const Icon(Icons.analytics_outlined),
          onPressed: () => _navigateToAnalytics(context),
        ),
        IconButton(
          icon: const Icon(Icons.help_outline),
          onPressed: () => _showHelp(context),
        ),
      ],
    );
  }

  Widget _buildCollectionList() {
    final filteredCollections = _filterCollections();
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredCollections.length,
      itemBuilder: (context, index) {
        final collection = filteredCollections[index];
        return NFTCard(
          title: collection.title,
          description: collection.description,
          status: collection.status,
          category: collection.category,
          createdAt: collection.createdAt,
          usageRights: collection.usageRights,
          culturalContext: collection.culturalContext,
          estimatedValue: collection.estimatedValue,
          voiceCharacteristics: collection.voiceCharacteristics,
          onTap: () => _navigateToDetail(context, collection),
          onMint: collection.status.toLowerCase() == 'ready for minting' 
              ? () => _navigateToMint(context, collection)
              : null,
        );
      },
    );
  }

  Widget _buildCreateButton() {
    return FloatingActionButton.extended(
      onPressed: () => _showCreateOptions(context),
      label: const Text('Create NFT'),
      icon: const Icon(Icons.add),
      backgroundColor: AppColors.accent,
    );
  }

  void _showCreateOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.library_add),
            title: const Text('New Voice Collection'),
            subtitle: const Text('Create a curated collection of voice assets'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.createNft);
            },
          ),
          ListTile(
            leading: const Icon(Icons.mic),
            title: const Text('Record New Voice'),
            subtitle: const Text('Record and mint a new voice NFT'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.record);
            },
          ),
          ListTile(
            leading: const Icon(Icons.upload_file),
            title: const Text('Import Existing Recording'),
            subtitle: const Text('Import and process existing voice recordings'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.import);
            },
          ),
        ],
      ),
    );
  }

  // Helper methods for filtering and analytics
  List<VoiceCollection> _filterCollections() {
    return collections.where((collection) {
      final matchesFilter = _selectedFilter == 'All' || 
                          collection.category == _selectedFilter;
      final matchesSearch = collection.title.toLowerCase()
                                   .contains(_searchQuery.toLowerCase()) ||
                          collection.description.toLowerCase()
                                   .contains(_searchQuery.toLowerCase());
      return matchesFilter && matchesSearch;
    }).toList();
  }

  String _calculateTotalValue() {
    // Implementation for calculating total collection value
    return '2.5 ETH';
  }

  void _handleFilterChange(String filter) {
    setState(() => _selectedFilter = filter);
    _analytics.logEvent(
      name: 'collection_filter_changed',
      parameters: {'filter': filter},
    );
  }

  void _handleSearch(String query) {
    setState(() => _searchQuery = query);
    _analytics.logEvent(
      name: 'collection_search',
      parameters: {'query': query},
    );
  }

  // Navigation methods
  void _navigateToDetail(BuildContext context, VoiceCollection collection) {
    Navigator.pushNamed(
      context,
      AppRoutes.nftDetail,
      arguments: collection,
    );
  }

  void _navigateToMint(BuildContext context, VoiceCollection collection) {
    Navigator.pushNamed(
      context,
      AppRoutes.mintNft,
      arguments: collection,
    );
  }

  void _navigateToAnalytics(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.collectionAnalytics);
  }

  void _showHelp(BuildContext context) {
    // Implementation for showing help/documentation
  }
}
