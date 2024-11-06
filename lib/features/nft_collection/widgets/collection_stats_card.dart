import 'package:flutter/material.dart';

class CollectionStatsCard extends StatelessWidget {
  final int totalNFTs;
  final int mintedCount;
  final int processingCount;
  final String totalValue;

  const CollectionStatsCard({
    super.key,
    required this.totalNFTs,
    required this.mintedCount,
    required this.processingCount,
    required this.totalValue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE6A87C),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('Total NFTs', totalNFTs.toString()),
          _buildStatItem('Minted', mintedCount.toString()),
          _buildStatItem('Processing', processingCount.toString()),
          _buildStatItem('Value', totalValue),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF234B6B),
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF345F88),
          ),
        ),
      ],
    );
  }
} 