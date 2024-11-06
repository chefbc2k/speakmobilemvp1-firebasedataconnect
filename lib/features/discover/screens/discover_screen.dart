import 'package:speakmobilemvp/features/discover/screens/contract_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:speakmobilemvp/features/nft_collection/screens/collection_screen.dart';
import 'package:speakmobilemvp/features/vocal_nfts/widgets/featured_item_card.dart';
import 'package:speakmobilemvp/features/discover/screens/top_voices_screen.dart';
import 'package:speakmobilemvp/features/discover/screens/trending_screen.dart';
import 'package:speakmobilemvp/features/discover/screens/category_screen.dart';
import 'package:speakmobilemvp/core/constants/asset_paths.dart';
import 'package:speakmobilemvp/features/discover/widgets/smart_contract_card.dart';
import 'package:speakmobilemvp/features/discover/widgets/nft_minting_item.dart';
import 'package:speakmobilemvp/core/services/frontend/contract_service.dart';
import 'package:speakmobilemvp/core/utils/error_handler.dart';
import 'package:speakmobilemvp/core/services/frontend/recording_service.dart';
import 'package:speakmobilemvp/features/vocal_nfts/screens/voice_contract_screen.dart';
import 'package:speakmobilemvp/core/routes/app_routes.dart';

class DiscoverScreen extends StatelessWidget {
  final ContractService contractService;

  const DiscoverScreen({
    super.key,
    required this.contractService,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Discover'),
        elevation: 0,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category buttons with horizontal scroll
                  SizedBox(
                    height: 48,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildCategoryChip(context, 'Top Voices'),
                        _buildCategoryChip(context, 'Trending'),
                        _buildCategoryChip(context, 'Categories'),
                        _buildCategoryChip(context, 'Collections'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Featured section with responsive width
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: constraints.maxWidth,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Featured Voices',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 250,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              FeaturedItemCard(
                                imagePath: AssetPaths.voiceArtist1,
                                title: 'Cultural Voices',
                                onTap: () => _navigateToCollection(context),
                              ),
                              const SizedBox(width: 16),
                              FeaturedItemCard(
                                imagePath: AssetPaths.voiceArtist2,
                                title: 'Voice Legacy',
                                onTap: () => _navigateToCollection(context),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Smart Contracts Section
                  const Text(
                    'Active Contracts',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SmartContractCard(
                    title: 'Voice Authentication',
                    status: 'Verification Pending',
                    onTap: () async {
                      try {
                        final contractDetails = await contractService.getContractDetails(
                          contractType: ContractType.voiceAuthentication,
                        );
                        
                        if (!context.mounted) return;
                        
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ContractDetailsScreen(
                              details: contractDetails,
                              onVerify: () async {
                                // Implement voice verification flow
                                await contractService.verifyVoiceContract(
                                  contractId: contractDetails.id,
                                );
                              },
                            ),
                          ),
                        );
                      } catch (e) {
                        if (!context.mounted) return;
                        
                        ErrorHandler.showError(
                          context: context,
                          error: e,
                          message: 'Failed to load contract details',
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  SmartContractCard(
                    title: 'Cultural Heritage',
                    status: 'Active',
                    onTap: () async {
                      try {
                        final contractDetails = await contractService.getContractDetails(
                          contractType: ContractType.culturalHeritage,
                        );
                        
                        if (!context.mounted) return;
                        
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ContractDetailsScreen(
                              details: contractDetails,
                              onVerify: () async {
                                // Cultural heritage contracts don't need verification
                                // since they're already active
                                throw UnimplementedError('Verification not needed for active contracts');
                              },
                            ),
                          ),
                        );
                      } catch (e) {
                        if (!context.mounted) return;
                        
                        ErrorHandler.showError(
                          context: context,
                          error: e,
                          message: 'Failed to load contract details',
                        );
                      }
                    },
                  ),

                  const SizedBox(height: 24),

                  // NFT Minting Section
                  const Text(
                    'Ready to Mint',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  NFTMintingItem(
                    title: 'Indigenous Language Collection',
                    status: 'Ready for minting',
                    onTap: () => Navigator.pushNamed(context, AppRoutes.mintNft),
                  ),
                  const SizedBox(height: 8),
                  NFTMintingItem(
                    title: 'Personal Voice Library',
                    status: 'Processing complete',
                    onTap: () => Navigator.pushNamed(context, AppRoutes.mintNft),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showBottomSheet(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildCategoryChip(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ActionChip(
        label: Text(title),
        onPressed: () => _navigateToCategory(context, title),
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Create New',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.record_voice_over),
                title: const Text('New Voice Contract'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VoiceContractScreen(
                        contractService: contractService,
                        recordingService: RecordingService(),
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.library_music),
                title: const Text('New Voice Collection'),
                onTap: () {
                  Navigator.pop(context);
                  
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _navigateToCollection(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const CollectionScreen(),
      ),
    );
  }

  void _navigateToCategory(BuildContext context, String category) {
    Widget screen;
    switch (category) {
      case 'Top Voices':
        screen = const TopVoicesScreen();
        break;
      case 'Trending':
        screen = const TrendingScreen();
        break;
      case 'Collections':
        screen = const CollectionScreen();
        break;
      default:
        screen = CategoryScreen(category: category);
    }
    
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => screen,
      ),
    );
  }
}

class ContractType {
  // ignore: prefer_typing_uninitialized_variables
  static var culturalHeritage;
  

  // ignore: prefer_typing_uninitialized_variables
  static var values;
  // ignore: prefer_typing_uninitialized_variables
  static var voiceAuthentication;

  get index => null;
}
