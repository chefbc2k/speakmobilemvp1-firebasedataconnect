import 'package:flutter/material.dart';
import 'package:speakmobilemvp/core/theme/app_colors.dart';
import 'package:speakmobilemvp/core/theme/app_spacing.dart';

class LanguageSettingsScreen extends StatefulWidget {
  const LanguageSettingsScreen({super.key});

  @override
  State<LanguageSettingsScreen> createState() => _LanguageSettingsScreenState();
}

class _LanguageSettingsScreenState extends State<LanguageSettingsScreen> {
  String _selectedLanguage = 'English';
  String _selectedRegion = 'United States';

  final List<String> _languages = [
    'English',
    'Spanish',
    'Mandarin',
    'Hindi',
    'Arabic',
    'French',
    'Portuguese',
    'Japanese',
    'Korean',
    'German',
  ];

  final List<String> _regions = [
    'United States',
    'United Kingdom',
    'Canada',
    'Australia',
    'India',
    'China',
    'Japan',
    'Brazil',
    'Mexico',
    'Germany',
    'France',
    'Spain',
  ];

  void _showLanguageSelector() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _buildLanguageList(),
    );
  }

  void _showRegionSelector() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _buildRegionList(),
    );
  }

  Widget _buildLanguageList() {
    return ListView.builder(
      itemCount: _languages.length,
      itemBuilder: (context, index) {
        final language = _languages[index];
        return ListTile(
          title: Text(language),
          trailing: language == _selectedLanguage
              ? const Icon(Icons.check, color: AppColors.primary)
              : null,
          onTap: () {
            setState(() => _selectedLanguage = language);
            Navigator.pop(context);
          },
        );
      },
    );
  }

  Widget _buildRegionList() {
    return ListView.builder(
      itemCount: _regions.length,
      itemBuilder: (context, index) {
        final region = _regions[index];
        return ListTile(
          title: Text(region),
          trailing: region == _selectedRegion
              ? const Icon(Icons.check, color: AppColors.primary)
              : null,
          onTap: () {
            setState(() => _selectedRegion = region);
            Navigator.pop(context);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Language Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.medium),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.medium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Language Preferences',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.small),
                  const Text(
                    'Choose your preferred language and region for voice contracts, content creation, and platform navigation.',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.medium),
          ListTile(
            title: const Text('App Language'),
            subtitle: Text(_selectedLanguage),
            trailing: const Icon(Icons.chevron_right),
            onTap: _showLanguageSelector,
          ),
          const Divider(),
          ListTile(
            title: const Text('Region'),
            subtitle: Text(_selectedRegion),
            trailing: const Icon(Icons.chevron_right),
            onTap: _showRegionSelector,
          ),
        ],
      ),
    );
  }
}
