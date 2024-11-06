import 'package:flutter/material.dart';
import 'package:speakmobilemvp/core/theme/app_colors.dart';
import 'package:speakmobilemvp/core/theme/app_spacing.dart';

class UsageRestrictionsScreen extends StatefulWidget {
  const UsageRestrictionsScreen({super.key});

  @override
  State<UsageRestrictionsScreen> createState() => _UsageRestrictionsScreenState();
}

class _UsageRestrictionsScreenState extends State<UsageRestrictionsScreen> {
  bool _commercialUse = true;
  bool _aiTraining = false;
  bool _derivativeWorks = true;
  final Map<String, bool> _categoryRestrictions = {
    'Entertainment': true,
    'Education': true,
    'Marketing': false,
    'Personal': true,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usage Restrictions'),
        backgroundColor: AppColors.primary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.m),
        children: [
          _buildInfoCard(),
          const SizedBox(height: AppSpacing.l),
          _buildGeneralRestrictions(),
          const SizedBox(height: AppSpacing.l),
          _buildCategoryRestrictions(),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Usage Restrictions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: AppSpacing.s),
            Text(
              'Control how your voice can be used across different contexts '
              'and applications. These settings affect all new contracts.',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGeneralRestrictions() {
    return Card(
      child: Column(
        children: [
          SwitchListTile(
            title: const Text('Commercial Use'),
            subtitle: const Text('Allow use in commercial projects'),
            value: _commercialUse,
            onChanged: (value) => setState(() => _commercialUse = value),
          ),
          SwitchListTile(
            title: const Text('AI Training'),
            subtitle: const Text('Allow use in AI model training'),
            value: _aiTraining,
            onChanged: (value) => setState(() => _aiTraining = value),
          ),
          SwitchListTile(
            title: const Text('Derivative Works'),
            subtitle: const Text('Allow creation of derivative works'),
            value: _derivativeWorks,
            onChanged: (value) => setState(() => _derivativeWorks = value),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryRestrictions() {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.m),
            child: Text(
              'Category Restrictions',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          ..._categoryRestrictions.entries.map((entry) => SwitchListTile(
            title: Text(entry.key),
            subtitle: Text('Allow use in ${entry.key.toLowerCase()} projects'),
            value: entry.value,
            onChanged: (value) => setState(() => 
              _categoryRestrictions[entry.key] = value
            ),
          )),
        ],
      ),
    );
  }
} 