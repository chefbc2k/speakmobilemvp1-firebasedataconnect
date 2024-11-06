import 'package:flutter/material.dart';

class CategoryScreen extends StatelessWidget {
  final String category;

  const CategoryScreen({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category),
        elevation: 0,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.85,
        ),
        itemCount: _getCategoryItems().length,
        itemBuilder: (context, index) {
          final item = _getCategoryItems()[index];
          return _CategoryCard(
            title: item['title']!,
            description: item['description']!,
            icon: item['icon']!,
            count: item['count']!,
          );
        },
      ),
    );
  }

  List<Map<String, String>> _getCategoryItems() {
    switch (category) {
      case 'Cultural Voices':
        return [
          {
            'title': 'Indigenous Languages',
            'description': 'Preserving native voice traditions',
            'icon': 'language',
            'count': '24',
          },
          {
            'title': 'Oral Histories',
            'description': 'Capturing generational stories',
            'icon': 'history_edu',
            'count': '18',
          },
          {
            'title': 'Traditional Songs',
            'description': 'Cultural musical expressions',
            'icon': 'music_note',
            'count': '32',
          },
          {
            'title': 'Dialects',
            'description': 'Regional voice variations',
            'icon': 'record_voice_over',
            'count': '45',
          },
          {
            'title': 'Storytelling',
            'description': 'Cultural narrative preservation',
            'icon': 'auto_stories',
            'count': '29',
          },
          {
            'title': 'Ceremonies',
            'description': 'Sacred vocal traditions',
            'icon': 'celebration',
            'count': '15',
          },
        ];
      case 'Voice Legacy':
        return [
          {
            'title': 'Personal Archives',
            'description': 'Individual voice preservation',
            'icon': 'archive',
            'count': '56',
          },
          {
            'title': 'Family Heritage',
            'description': 'Generational voice collections',
            'icon': 'family_restroom',
            'count': '34',
          },
          {
            'title': 'Community Voices',
            'description': 'Local cultural expressions',
            'icon': 'groups',
            'count': '42',
          },
          {
            'title': 'Historical Records',
            'description': 'Preserved voice moments',
            'icon': 'history',
            'count': '27',
          },
        ];
      default:
        return [
          {
            'title': 'Voice Authentication',
            'description': 'Secure identity verification',
            'icon': 'security',
            'count': '38',
          },
          {
            'title': 'Voice Markets',
            'description': 'Monetize your voice assets',
            'icon': 'storefront',
            'count': '64',
          },
          {
            'title': 'Educational Voices',
            'description': 'Teaching through voice',
            'icon': 'school',
            'count': '51',
          },
          {
            'title': 'Voice Analytics',
            'description': 'Understanding voice patterns',
            'icon': 'analytics',
            'count': '23',
          },
        ];
    }
  }
}

class _CategoryCard extends StatelessWidget {
  final String title;
  final String description;
  final String icon;
  final String count;

  const _CategoryCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    // Using Material icons based on the icon string
                    IconData(
                      icon.codeUnits.first,
                      fontFamily: 'MaterialIcons',
                    ),
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      count,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              Align(
                alignment: Alignment.centerRight,
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey[400],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
