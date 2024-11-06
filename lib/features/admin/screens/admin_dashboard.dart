import 'package:flutter/cupertino.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Admin Dashboard'),
      ),
      child: SafeArea(
        child: Center(
          child: Text('Admin Dashboard Content'),
        ),
      ),
    );
  }
}
