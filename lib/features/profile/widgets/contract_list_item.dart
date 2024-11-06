import 'package:flutter/material.dart';
import '../../../core/models/contract_details.dart';
import '../../../core/theme/app_colors.dart';

class ContractListItem extends StatelessWidget {
  final ContractDetails contract;
  final VoidCallback onTap;

  const ContractListItem({
    super.key,
    required this.contract,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: ListTile(
        title: Text(contract.title),
        subtitle: Text(
          '${contract.contractType} - ${contract.status}',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: AppColors.textSecondary,
        ),
        onTap: onTap,
      ),
    );
  }
} 