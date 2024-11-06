import 'package:flutter/material.dart';

class NFTCard extends StatelessWidget {
  final String title;
  final String description;
  final String status;
  final String category;
  final String createdAt;
  final String? usageRights;
  final String? culturalContext;
  final String? estimatedValue;
  final List<String>? voiceCharacteristics;
  final VoidCallback onTap;
  final VoidCallback? onMint;

  const NFTCard({
    super.key,
    required this.title,
    required this.description,
    required this.status,
    required this.category,
    required this.createdAt,
    this.usageRights,
    this.culturalContext,
    this.estimatedValue,
    this.voiceCharacteristics,
    required this.onTap,
    this.onMint,
  });

  Color _getStatusColor() {
    switch (status.toLowerCase()) {
      case 'minted':
        return const Color(0xFF234B6B); // Timeless Legacy primary
      case 'processing':
        return const Color(0xFFE6A87C); // Timeless Legacy accent
      case 'ready for minting':
        return const Color(0xFF345F88); // Timeless Legacy secondary
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE6A87C).withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF234B6B).withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with category and date
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F0E6),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                border: Border(
                  bottom: BorderSide(
                    color: const Color(0xFFE6A87C).withOpacity(0.3),
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    category,
                    style: TextStyle(
                      color: const Color(0xFF234B6B),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    createdAt,
                    style: TextStyle(
                      color: const Color(0xFF345F88),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF234B6B),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: TextStyle(
                      color: const Color(0xFF345F88).withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Status and action row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor().withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: _getStatusColor(),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              status,
                              style: TextStyle(
                                color: _getStatusColor(),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (onMint != null)
                        TextButton(
                          onPressed: onMint,
                          style: TextButton.styleFrom(
                            foregroundColor: const Color(0xFF234B6B),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: const BorderSide(
                                color: Color(0xFF234B6B),
                              ),
                            ),
                          ),
                          child: const Text('Mint NFT'),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
