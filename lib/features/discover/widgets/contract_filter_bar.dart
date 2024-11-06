import 'package:flutter/material.dart';

import '../screens/discover_screen.dart';

class ContractFilterBar extends StatelessWidget {
  final String? searchQuery;
  final ContractType? selectedType;
  final String? selectedCategory;
  final String? selectedLanguage;
  final Function(String) onSearchChanged;
  final Function(ContractType?) onTypeChanged;
  final Function(String?) onCategoryChanged;
  final Function(String?) onLanguageChanged;

  const ContractFilterBar({
    super.key,
    this.searchQuery,
    this.selectedType,
    this.selectedCategory,
    this.selectedLanguage,
    required this.onSearchChanged,
    required this.onTypeChanged,
    required this.onCategoryChanged,
    required this.onLanguageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            onChanged: onSearchChanged,
            decoration: InputDecoration(
              hintText: 'Search contracts...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              FilterChip(
                label: const Text('All Types'),
                selected: selectedType == null,
                onSelected: (selected) => onTypeChanged(null),
              ),
              const SizedBox(width: 8),
              ...ContractType.values.map((type) => Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: FilterChip(
                  label: Text(_formatContractType(type)),
                  selected: selectedType == type,
                  onSelected: (selected) => onTypeChanged(selected ? type : null),
                ),
              )),
            ],
          ),
        ),
      ],
    );
  }

  String _formatContractType(ContractType type) {
    final name = type.toString().split('.').last;
    final words = name.replaceAllMapped(
      RegExp(r'([A-Z])', caseSensitive: true),
      (match) => ' ${match.group(1)}',
    ).trim();
    return words[0].toUpperCase() + words.substring(1);
  }
} 