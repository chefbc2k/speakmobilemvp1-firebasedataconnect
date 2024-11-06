import 'package:flutter/material.dart';

class NFTMintingItem extends StatelessWidget {
  final String title;
  final String status;
  final VoidCallback? onTap;

  const NFTMintingItem({
    super.key,
    required this.title,
    required this.status,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: CircleAvatar(
        backgroundColor: Colors.blue[100],
        child: Icon(
          Icons.token,
          color: Colors.blue[900],
        ),
      ),
      title: Text(title),
      subtitle: Text('Status: $status'),
      trailing: IconButton(
        icon: const Icon(Icons.arrow_forward_ios),
        onPressed: onTap,
      ),
    );
  }
}
