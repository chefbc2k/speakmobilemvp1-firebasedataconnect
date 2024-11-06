import 'package:flutter/cupertino.dart';

class NotificationSettingsScreen extends StatelessWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Notification Settings'),
      ),
      child: SafeArea(
        child: ListView(
          children: const [
            Center(child: Text('Notification Settings Coming Soon')),
          ],
        ),
      ),
    );
  }
}
