import 'package:flutter/material.dart';
import 'package:speakmobilemvp/core/theme/app_spacing.dart';

class AccessibilitySettingsScreen extends StatefulWidget {
  const AccessibilitySettingsScreen({super.key});

  @override
  State<AccessibilitySettingsScreen> createState() => _AccessibilitySettingsScreenState();
}

class _AccessibilitySettingsScreenState extends State<AccessibilitySettingsScreen> {
  bool _screenReader = false;
  bool _largeText = false;
  bool _highContrast = false;
  bool _reduceMotion = false;
  double _speechRate = 1.0;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accessibility'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(AppSpacing.medium),
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.medium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Accessibility Options',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(height: AppSpacing.small),
                    const Text(
                      'Customize your experience to make the app more accessible.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SwitchListTile(
            title: const Text('Screen Reader Support'),
            subtitle: const Text('Enable enhanced screen reader compatibility'),
            value: _screenReader,
            onChanged: (bool value) {
              setState(() => _screenReader = value);
            },
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Large Text'),
            subtitle: const Text('Increase text size throughout the app'),
            value: _largeText,
            onChanged: (bool value) {
              setState(() => _largeText = value);
            },
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('High Contrast'),
            subtitle: const Text('Enhance visibility with higher contrast'),
            value: _highContrast,
            onChanged: (bool value) {
              setState(() => _highContrast = value);
            },
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Reduce Motion'),
            subtitle: const Text('Minimize animations and transitions'),
            value: _reduceMotion,
            onChanged: (bool value) {
              setState(() => _reduceMotion = value);
            },
          ),
          const Divider(),
          Padding(
            padding: EdgeInsets.all(AppSpacing.medium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Speech Rate'),
                Slider(
                  value: _speechRate,
                  min: 0.5,
                  max: 2.0,
                  divisions: 6,
                  label: '${_speechRate}x',
                  onChanged: (double value) {
                    setState(() => _speechRate = value);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
