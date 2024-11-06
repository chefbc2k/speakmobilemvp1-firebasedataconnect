import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

class ContentCategoriesScreen extends StatefulWidget {
  const ContentCategoriesScreen({super.key});

  @override
  State<ContentCategoriesScreen> createState() => _ContentCategoriesScreenState();
}

class _ContentCategoriesScreenState extends State<ContentCategoriesScreen> {
  final Map<String, Map<String, bool>> _categories = {
    'Entertainment': {
      'Animation': true,
      'Video Games': true,
      'Film & TV': false,
      'Audiobooks': true,
    },
    'Education': {
      'E-Learning': true,
      'Educational Games': true,
      'Training Videos': false,
      'Tutorials': true,
    },
    'Commercial': {
      'Advertising': true,
      'Corporate': false,
      'IVR/Phone Systems': true,
      'Product Demos': true,
    },
    'Personal': {
      'Podcasts': true,
      'Personal Greetings': false,
      'Social Media': true,
      'Voice Messages': true,
    },
  };

  bool _showInactiveCategories = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Content Categories'),
        backgroundColor: AppColors.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addCustomCategory,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.m),
        children: [
          _buildInfo(),
          const SizedBox(height: AppSpacing.l),
          _buildDisplayPreferences(),
          const SizedBox(height: AppSpacing.l),
          ..._buildCategoryCards(),
        ],
      ),
    );
  }

  Widget _buildInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Voice Work Categories',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.s),
            const Text(
              'Select the types of voice work you\'re interested in. '
              'This helps match you with relevant opportunities.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDisplayPreferences() {
    return Card(
      child: Column(
        children: [
          SwitchListTile(
            title: const Text('Show Inactive Categories'),
            subtitle: const Text('Display categories you\'re not currently accepting'),
            value: _showInactiveCategories,
            onChanged: (value) => setState(() => _showInactiveCategories = value),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildCategoryCards() {
    return _categories.entries.map((category) {
      return Column(
        children: [
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: Text(category.key),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _editCategory(category.key),
                  ),
                ),
                const Divider(),
                ...category.value.entries
                    .where((subcategory) =>
                        _showInactiveCategories || subcategory.value)
                    .map((subcategory) => CheckboxListTile(
                          title: Text(subcategory.key),
                          value: subcategory.value,
                          onChanged: (value) =>
                              _toggleSubcategory(category.key, subcategory.key),
                        )),
                TextButton(
                  onPressed: () => _addSubcategory(category.key),
                  child: const Text('Add Subcategory'),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.m),
        ],
      );
    }).toList();
  }

  void _toggleSubcategory(String category, String subcategory) {
    setState(() {
      _categories[category]![subcategory] = !_categories[category]![subcategory]!;
    });
  }

  void _addCustomCategory() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Category'),
        content: TextField(
          decoration: const InputDecoration(
            labelText: 'Category Name',
          ),
          onSubmitted: (value) {
            if (value.isNotEmpty) {
              setState(() {
                _categories[value] = {};
              });
              Navigator.pop(context);
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Implement add logic
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _addSubcategory(String category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Subcategory to $category'),
        content: TextField(
          decoration: const InputDecoration(
            labelText: 'Subcategory Name',
          ),
          onSubmitted: (value) {
            if (value.isNotEmpty) {
              setState(() {
                _categories[category]![value] = true;
              });
              Navigator.pop(context);
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Implement add logic
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _editCategory(String category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit $category'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Category Name',
              ),
              controller: TextEditingController(text: category),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Implement edit logic
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
          TextButton(
            onPressed: () => _deleteCategory(category),
            child: Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _deleteCategory(String category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Category'),
        content: Text('Are you sure you want to delete $category?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _categories.remove(category);
              });
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
} 