import 'package:flutter/material.dart';
import 'package:speakmobilemvp/core/theme/app_spacing.dart';
import 'package:speakmobilemvp/core/constants/asset_paths.dart';

class TrendingScreen extends StatelessWidget {
  const TrendingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trending'),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.m),
        children: [
          _buildTrendingList(),
        ],
      ),
    );
  }

  Widget _buildTrendingList() {
    return Column(
      children: [
        _TrendingItem(
          title: 'Cultural Heritage Voices',
          creator: 'Emma Davis',
          views: '15.2K',
          imageUrl: AssetPaths.voiceArtist1,
          description: 'Preserving indigenous dialects through voice artistry',
        ),
        const SizedBox(height: AppSpacing.m),
        _TrendingItem(
          title: 'Global Storytelling Collection',
          creator: 'Michael Chen',
          views: '12.8K',
          imageUrl: AssetPaths.voiceArtist2,
          description: 'Connecting cultures through authentic narratives',
        ),
        const SizedBox(height: AppSpacing.m),
        _TrendingItem(
          title: 'Voice Legacy Series',
          creator: 'Sarah Johnson',
          views: '10.5K',
          imageUrl: AssetPaths.voiceArtist3,
          description: 'Building digital legacies through voice preservation',
        ),
      ],
    );
  }
}

class _TrendingItem extends StatelessWidget {
  final String title;
  final String creator;
  final String views;
  final String imageUrl;
  final String description;

  const _TrendingItem({
    required this.title,
    required this.creator,
    required this.views,
    required this.imageUrl,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.asset(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[200],
                    child: Center(
                      child: Icon(
                        Icons.image,
                        size: 48,
                        color: Colors.grey[400],
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.m),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          creator,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.visibility,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            views,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
