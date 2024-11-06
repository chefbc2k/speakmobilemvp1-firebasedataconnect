import 'package:flutter/cupertino.dart';

class TransactionDetailScreen extends StatelessWidget {
  const TransactionDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Transaction Detail'),
      ),
      child: SafeArea(
        child: Center(
          child: Text('Transaction Detail Content'),
        ),
      ),
    );
  }
}
