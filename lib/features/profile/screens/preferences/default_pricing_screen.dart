import 'package:flutter/material.dart';

import '../../../../core/config/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

class DefaultPricingScreen extends StatefulWidget {
  const DefaultPricingScreen({super.key});

  @override
  State<DefaultPricingScreen> createState() => _DefaultPricingScreenState();
}

class _DefaultPricingScreenState extends State<DefaultPricingScreen> {
  final Map<String, double> _hourlyRates = {
    'Entertainment': 150.0,
    'Education': 100.0,
    'Commercial': 200.0,
    'Personal': 75.0,
  };

  final Map<String, double> _wordRates = {
    'Entertainment': 0.15,
    'Education': 0.10,
    'Commercial': 0.20,
    'Personal': 0.08,
  };

  bool _customPricingEnabled = false;
  String _selectedCurrency = 'USD';
  bool _allowNegotiation = true;
  double _rushFeePercentage = 50.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Default Pricing'),
        backgroundColor: AppColors.primary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.m),
        children: [
          _buildPricingInfo(),
          const SizedBox(height: AppSpacing.l),
          _buildHourlyRates(),
          const SizedBox(height: AppSpacing.l),
          _buildWordRates(),
          const SizedBox(height: AppSpacing.l),
          _buildPricingPreferences(),
          const SizedBox(height: AppSpacing.l),
          _buildAdditionalFees(),
        ],
      ),
    );
  }

  Widget _buildPricingInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pricing Settings',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.s),
            const Text(
              'Set your default rates for different types of voice work. '
              'These rates will be used as starting points for new contracts.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHourlyRates() {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.m),
            child: Text(
              'Hourly Rates',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          ..._hourlyRates.entries.map((entry) => ListTile(
            title: Text(entry.key),
            subtitle: Text('Per hour rate for ${entry.key.toLowerCase()} projects'),
            trailing: SizedBox(
              width: 120,
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  prefixText: '\$',
                  suffixText: '/hr',
                ),
                controller: TextEditingController(
                  text: entry.value.toString(),
                ),
                onChanged: (value) => _updateHourlyRate(entry.key, value),
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildWordRates() {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.m),
            child: Text(
              'Per Word Rates',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          ..._wordRates.entries.map((entry) => ListTile(
            title: Text(entry.key),
            subtitle: Text('Per word rate for ${entry.key.toLowerCase()} projects'),
            trailing: SizedBox(
              width: 120,
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  prefixText: '\$',
                  suffixText: '/word',
                ),
                controller: TextEditingController(
                  text: entry.value.toString(),
                ),
                onChanged: (value) => _updateWordRate(entry.key, value),
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildPricingPreferences() {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.m),
            child: Text(
              'Pricing Preferences',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          ListTile(
            title: const Text('Currency'),
            subtitle: Text('All rates shown in $_selectedCurrency'),
            trailing: DropdownButton<String>(
              value: _selectedCurrency,
              items: ['USD', 'EUR', 'GBP', 'CAD', 'AUD']
                  .map((currency) => DropdownMenuItem(
                        value: currency,
                        child: Text(currency),
                      ))
                  .toList(),
              onChanged: (value) => setState(() => _selectedCurrency = value!),
            ),
          ),
          SwitchListTile(
            title: const Text('Custom Pricing'),
            subtitle: const Text('Allow custom rates for specific projects'),
            value: _customPricingEnabled,
            onChanged: (value) => setState(() => _customPricingEnabled = value),
          ),
          SwitchListTile(
            title: const Text('Rate Negotiation'),
            subtitle: const Text('Allow clients to negotiate rates'),
            value: _allowNegotiation,
            onChanged: (value) => setState(() => _allowNegotiation = value),
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalFees() {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.m),
            child: Text(
              'Additional Fees',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          ListTile(
            title: const Text('Rush Fee'),
            subtitle: Text('${_rushFeePercentage.toStringAsFixed(0)}% additional for rush jobs'),
            trailing: SizedBox(
              width: 120,
              child: Slider(
                value: _rushFeePercentage,
                min: 0,
                max: 100,
                divisions: 20,
                label: '${_rushFeePercentage.toStringAsFixed(0)}%',
                onChanged: (value) => setState(() => _rushFeePercentage = value),
              ),
            ),
          ),
          ListTile(
            title: const Text('Additional Fees'),
            subtitle: const Text('Set up other additional fees'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.pushNamed(context, AppRoutes.additionalFees),
          ),
        ],
      ),
    );
  }

  void _updateHourlyRate(String category, String value) {
    setState(() {
      _hourlyRates[category] = double.tryParse(value) ?? _hourlyRates[category]!;
    });
  }

  void _updateWordRate(String category, String value) {
    setState(() {
      _wordRates[category] = double.tryParse(value) ?? _wordRates[category]!;
    });
  }
} 