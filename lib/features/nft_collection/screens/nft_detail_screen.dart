import 'package:flutter/cupertino.dart';

class NftDetailScreen extends StatelessWidget {
  const NftDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('NFT Detail'),
      ),
      child: SafeArea(
        child: Center(
          child: Text('NFT Detail Screen Content'),
        ),
      ),
    );
  }
}
