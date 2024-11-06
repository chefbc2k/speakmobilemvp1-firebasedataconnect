import 'package:flutter/material.dart';
import 'package:speakmobilemvp/core/theme/app_spacing.dart';

class TopVoicesScreen extends StatelessWidget {
  const TopVoicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Voices'),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.m),
        children: [
          _buildVoiceList(),
        ],
      ),
    );
  }

  Widget _buildVoiceList() {
    return Column(
      children: const [
        _VoiceItem(
          name: 'Sarah Johnson',
          category: 'Cultural Storyteller',
          rating: '4.9',
          imageUrl: 'assets/images/justagirl.png',
          description: 'Preserving indigenous narratives through voice artistry',
          languages: ['English', 'Cherokee'],
        ),
        SizedBox(height: AppSpacing.m),
        _VoiceItem(
          name: 'Michael Chen',
          category: 'Heritage Voice Artist',
          rating: '4.8',
          imageUrl: 'assets/images/justaguy.png',
          description: 'Bridging generations through traditional vocal expressions',
          languages: ['Mandarin', 'Cantonese'],
        ),
        SizedBox(height: AppSpacing.m),
        _VoiceItem(
          name: 'Emma Davis',
          category: 'Voice Preservationist',
          rating: '4.7',
          imageUrl: 'assets/images/justagirlshoulders:head.jpeg',
          description: 'Creating lasting legacies through voice authentication',
          languages: ['English', 'Spanish'],
        ),
      ],
    );
  }
}

class _VoiceItem extends StatelessWidget {
  final String name;
  final String category;
  final String rating;
  final String imageUrl;
  final String description;
  final List<String> languages;

  const _VoiceItem({
    required this.name,
    required this.category,
    required this.rating,
    required this.imageUrl,
    required this.description,
    required this.languages,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.m),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      imageUrl,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 60,
                          height: 60,
                          color: Colors.grey[200],
                          child: Icon(
                            Icons.person,
                            color: Colors.grey[400],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: AppSpacing.m),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          category,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.s,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.amber[100],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.star,
                          size: 14,
                          color: Colors.amber[800],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          rating,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.amber[900],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.s),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSpacing.s),
              Wrap(
                spacing: 8,
                children: languages.map((lang) => Chip(
                  label: Text(
                    lang,
                    style: const TextStyle(fontSize: 12),
                  ),
                  backgroundColor: Colors.blue[50],
                  visualDensity: VisualDensity.compact,
                )).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
