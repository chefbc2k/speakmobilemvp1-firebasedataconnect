import 'package:flutter/material.dart';
import 'package:speakmobilemvp/core/theme/app_colors.dart';
import 'package:speakmobilemvp/core/theme/app_spacing.dart';

class AppearanceSettingsScreen extends StatefulWidget {
  const AppearanceSettingsScreen({super.key});

  @override
  State<AppearanceSettingsScreen> createState() => _AppearanceSettingsScreenState();
}

class _AppearanceSettingsScreenState extends State<AppearanceSettingsScreen> {
  String _selectedTheme = 'System Default';
  String _selectedTextSize = 'Medium';
  bool _reduceAnimations = false;
  bool _highContrast = false;

  final List<String> _themes = [
    'System Default',
    'Light',
    'Dark',
    'Voice NFT Theme',
  ];

  final List<String> _textSizes = [
    'Small',
    'Medium',
    'Large',
    'Extra Large',
  ];

  void _showThemeSelector() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: _themes.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(_themes[index]),
              trailing: _selectedTheme == _themes[index]
                  ? const Icon(Icons.check, color: AppColors.primary)
                  : null,
              onTap: () {
                setState(() => _selectedTheme = _themes[index]);
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }

  void _showTextSizeSelector() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: _textSizes.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(_textSizes[index]),
              trailing: _selectedTextSize == _textSizes[index]
                  ? const Icon(Icons.check, color: AppColors.primary)
                  : null,
              onTap: () {
                setState(() => _selectedTextSize = _textSizes[index]);
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appearance'),
        elevation: 0,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.medium),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.medium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Customize Your Experience',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(height: AppSpacing.small),
                    const Text(
                      'Adjust the app appearance to match your preferences and improve visibility.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ),
          ListTile(
            title: const Text('Theme'),
            subtitle: Text(_selectedTheme),
            trailing: const Icon(Icons.chevron_right),
            onTap: _showThemeSelector,
          ),
          const Divider(),
          ListTile(
            title: const Text('Text Size'),
            subtitle: Text(_selectedTextSize),
            trailing: const Icon(Icons.chevron_right),
            onTap: _showTextSizeSelector,
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Reduce Animations'),
            subtitle: const Text('Minimize motion for better performance'),
            value: _reduceAnimations,
            onChanged: (bool value) {
              setState(() => _reduceAnimations = value);
            },
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('High Contrast'),
            subtitle: const Text('Increase visibility of text and controls'),
            value: _highContrast,
            onChanged: (bool value) {
              setState(() => _highContrast = value);
            },
          ),
        ],
      ),
    );
  }
}
