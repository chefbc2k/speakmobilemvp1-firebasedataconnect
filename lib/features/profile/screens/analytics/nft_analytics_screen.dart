import 'package:flutter/material.dart';

class NFTAnalyticsScreen extends StatelessWidget {
  const NFTAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildNFTSummary(),
        const SizedBox(height: 16),
        _buildNFTPerformance(),
        const SizedBox(height: 16),
        _buildPopularNFTs(),
      ],
    );
  }

  Widget _buildNFTSummary() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'NFT Portfolio',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text('Total NFTs: 0'),
            Text('Total Value: \$0.00'),
            Text('Unique Collectors: 0'),
          ],
        ),
      ),
    );
  }

  Widget _buildNFTPerformance() {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: SizedBox(
          height: 200,
          child: Center(
            child: Text('NFT Performance Chart Coming Soon'),
          ),
        ),
      ),
    );
  }

  Widget _buildPopularNFTs() {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Popular NFTs',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: Text('No NFTs to display'),
            ),
          ],
        ),
      ),
    );
  }
} 