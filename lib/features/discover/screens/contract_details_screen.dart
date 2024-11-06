import 'package:flutter/material.dart';
import 'package:speakmobilemvp/core/models/contract_details.dart';

class ContractDetailsScreen extends StatelessWidget {
  final ContractDetails details;
  final Future<void> Function() onVerify;

  const ContractDetailsScreen({
    super.key,
    required this.details,
    required this.onVerify,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contract Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              details.title,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Text(
              'Status: ${details.status}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 24),
            Text(
              'Description',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(details.description),
            const SizedBox(height: 24),
            if (details.status == 'Verification Pending')
              ElevatedButton(
                onPressed: () async {
                  try {
                    await onVerify();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Contract verified successfully'),
                        ),
                      );
                      Navigator.pop(context);
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Failed to verify contract: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
                child: const Text('Verify Contract'),
              ),
          ],
        ),
      ),
    );
  }
}
