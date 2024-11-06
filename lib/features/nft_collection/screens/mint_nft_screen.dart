import 'package:flutter/cupertino.dart';

class MintNftScreen extends StatelessWidget {
  const MintNftScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Mint NFT'),
      ),
      child: SafeArea(
        child: Center(
          child: Text('Mint NFT Screen Content'),
        ),
      ),
    );
  }
}
