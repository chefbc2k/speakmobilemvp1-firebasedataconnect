import 'package:flutter/cupertino.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Analytics'),
      ),
      child: SafeArea(
        child: Center(
          child: Text('Analytics Screen Content'),
        ),
      ),
    );
  }
}
