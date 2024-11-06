import 'package:flutter/material.dart';
import 'package:speakmobilemvp/core/theme/app_colors.dart';
import 'package:speakmobilemvp/core/theme/app_spacing.dart';
import 'package:speakmobilemvp/features/profile/models/voice_contract.dart';

class VoiceAssetsScreen extends StatefulWidget {
  const VoiceAssetsScreen({super.key});

  @override
  State<VoiceAssetsScreen> createState() => _VoiceAssetsScreenState();
}

class _VoiceAssetsScreenState extends State<VoiceAssetsScreen> {
  final Map<String, List<VoiceContract>> _contractsByCategory = {
    'Entertainment': [],
    'Education': [],
    'Commercial': [],
    'Personal': [],
  };

  void _addNewVoiceAsset() {
    // TODO: Implement new voice asset creation
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Voice Asset'),
        content: const Text('This feature is coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Voice Assets'),
        backgroundColor: AppColors.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addNewVoiceAsset,
          ),
        ],
      ),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(text: 'Portfolio'),
                Tab(text: 'Contracts'),
                Tab(text: 'Analytics'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildPortfolioTab(),
                  _buildContractsTab(),
                  _buildAnalyticsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPortfolioTab() {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.m),
      children: [
        _buildVoiceCategories(),
        const SizedBox(height: AppSpacing.l),
        _buildVoiceSamples(),
      ],
    );
  }

  Widget _buildVoiceCategories() {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.m),
            child: Text(
              'Voice Categories',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _contractsByCategory.length,
            itemBuilder: (context, index) {
              final category = _contractsByCategory.keys.elementAt(index);
              return ListTile(
                title: Text(category),
                subtitle: Text('${_contractsByCategory[category]!.length} contracts'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _viewCategoryDetails(category),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildVoiceSamples() {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.m),
            child: Text(
              'Recent Voice Samples',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(AppSpacing.m),
            child: Center(
              child: Text('No voice samples yet'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContractsTab() {
    return const Center(
      child: Text('Contracts tab coming soon'),
    );
  }

  Widget _buildAnalyticsTab() {
    return const Center(
      child: Text('Analytics tab coming soon'),
    );
  }

  void _viewCategoryDetails(String category) {
    // TODO: Implement category details view
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(category),
        content: const Text('Category details coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
