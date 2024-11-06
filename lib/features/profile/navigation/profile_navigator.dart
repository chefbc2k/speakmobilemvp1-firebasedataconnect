import 'package:flutter/cupertino.dart';
import 'package:speakmobilemvp/features/profile/screens/edit_profile_screen.dart';
import 'package:speakmobilemvp/features/profile/screens/profile_main_screen.dart';
import 'package:speakmobilemvp/core/routes/app_routes.dart';

class ProfileNavigator extends StatelessWidget {
  const ProfileNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoTabView(
      builder: (context) => const ProfileMainScreen(),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case AppRoutes.editProfile:
            return CupertinoPageRoute(
              builder: (_) => const EditProfileScreen(),
              settings: settings,
            );
          default:
            return CupertinoPageRoute(
              builder: (_) => const ProfileMainScreen(),
              settings: settings,
            );
        }
      },
    );
  }
}

