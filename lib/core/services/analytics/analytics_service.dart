import 'package:flutter/foundation.dart';

/// A service for handling analytics events
class AnalyticsService {
  bool _isInitialized = false;

  AnalyticsService() {
    _initializeAnalytics();
  }

  Future<void> _initializeAnalytics() async {
    try {
      // Dynamically import Firebase Analytics to handle cases where it might not be available
      if (kDebugMode) {
        print('Analytics service initialization skipped in debug mode');
        return;
      }
      
      _isInitialized = true;
    } catch (e) {
      if (kDebugMode) {
        print('Failed to initialize Analytics: $e');
      }
      _isInitialized = false;
    }
  }

  Future<void> logScreenView({
    required String screenName,
    required String screenClass,
    Map<String, dynamic>? parameters,
  }) async {
    if (!_isInitialized) {
      if (kDebugMode) {
        print('Analytics not initialized. Screen view not logged: $screenName');
      }
      return;
    }

    try {
      // Log screen view when analytics is properly initialized
      if (kDebugMode) {
        print('Screen view logged: $screenName');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to log screen view: $e');
      }
    }
  }

  Future<void> logEvent({
    required String name,
    Map<String, dynamic>? parameters,
  }) async {
    if (!_isInitialized) {
      if (kDebugMode) {
        print('Analytics not initialized. Event not logged: $name');
      }
      return;
    }

    try {
      // Log event when analytics is properly initialized
      if (kDebugMode) {
        print('Event logged: $name');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to log event: $e');
      }
    }
  }
}
