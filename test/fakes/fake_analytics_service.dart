import 'package:sternburg_bingo_2/core/analytics/analytics_service.dart';

/// In-memory [AnalyticsService] implementation for unit and widget tests.
final class FakeAnalyticsService implements AnalyticsService {
  new();

  bool? collectionEnabled;
  final List<String> loggedEvents = <String>[];
  final List<String> screens = <String>[];
  final Map<String, String> userProperties = <String, String>{};
  String? userId;

  @override
  Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
  }) async {
    loggedEvents.add(name);
  }

  @override
  Future<void> setCurrentScreen(String screenName) async {
    screens.add(screenName);
  }

  @override
  Future<void> setUserProperty({
    required String name,
    required String? value,
  }) async {
    if (value == null) {
      userProperties.remove(name);
    } else {
      userProperties[name] = value;
    }
  }

  @override
  Future<void> setUserId(String? userId) async {
    this.userId = userId;
  }

  @override
  Future<void> setAnalyticsCollectionEnabled({required bool enabled}) async {
    collectionEnabled = enabled;
  }
}
