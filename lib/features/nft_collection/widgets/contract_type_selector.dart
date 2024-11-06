import 'package:flutter/material.dart';
import '../models/voice_contract_type.dart';

class ContractTypeSelector extends StatelessWidget {
  final VoiceContractCategory? selectedCategory;
  final String? selectedSubcategory;
  final ValueChanged<VoiceContractCategory?> onCategoryChanged;
  final ValueChanged<String?> onSubcategoryChanged;

  const ContractTypeSelector({
    super.key,
    this.selectedCategory,
    this.selectedSubcategory,
    required this.onCategoryChanged,
    required this.onSubcategoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Contract Category',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: VoiceContractCategory.values.map((category) {
            return FilterChip(
              label: Text(VoiceContractType.categoryToString(category)),
              selected: selectedCategory == category,
              onSelected: (selected) => onCategoryChanged(selected ? category : null),
            );
          }).toList(),
        ),
        if (selectedCategory != null) ...[
          const SizedBox(height: 16),
          Text(
            'Subcategory',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: VoiceContractType.getSubcategories(selectedCategory!)
                .map((subcategory) {
              return FilterChip(
                label: Text(subcategory),
                selected: selectedSubcategory == subcategory,
                onSelected: (selected) {
                  onSubcategoryChanged(selected ? subcategory : null);
                },
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
} 