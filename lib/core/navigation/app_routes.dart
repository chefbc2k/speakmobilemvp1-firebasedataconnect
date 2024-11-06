import 'package:flutter/material.dart';

import '../../features/profile/screens/notifications_screen.dart';

class AppRoutes {
  static const String initial = '/';
  static const String notifications = '/profile/notification-settings';

  static Map<String, WidgetBuilder> get routes => {
    notifications: (context) => const NotificationsScreen(),
  };
} 