import 'package:flutter/cupertino.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('About'),
      ),
      child: SafeArea(
        child: Center(
          child: Text('About Screen Content'),
        ),
      ),
    );
  }
}
