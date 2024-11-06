import 'package:flutter/cupertino.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Wallet'),
      ),
      child: SafeArea(
        child: Center(
          child: Text('Wallet Screen Content'),
        ),
      ),
    );
  }
}
