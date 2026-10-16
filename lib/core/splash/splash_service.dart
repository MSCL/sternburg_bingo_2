import 'package:flutter/widgets.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

abstract interface class SplashService {
  void preserve({required WidgetsBinding widgetsBinding});

  void remove();
}

final class FlutterNativeSplashService implements SplashService {
  const new();

  @override
  void preserve({required WidgetsBinding widgetsBinding}) =>
      FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  @override
  void remove() => FlutterNativeSplash.remove();
}
