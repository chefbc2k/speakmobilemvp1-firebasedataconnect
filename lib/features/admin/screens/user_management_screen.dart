import 'package:flutter/cupertino.dart';

class UserManagementScreen extends StatelessWidget {
  const UserManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('User Management'),
      ),
      child: SafeArea(
        child: Center(
          child: Text('User Management Screen Content'),
        ),
      ),
    );
  }
}
