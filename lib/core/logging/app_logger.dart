import 'dart:developer';

abstract interface class AppLogger {
  void info(String message, {String? tag});

  void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    String? tag,
  });
}

class ConsoleAppLogger implements AppLogger {
  const new();

  @override
  void info(String message, {String? tag}) =>
      log(message, name: tag ?? 'INFO', stackTrace: StackTrace.current);

  @override
  void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    String? tag,
  }) => log(
    message,
    name: tag ?? 'ERROR',
    error: error,
    stackTrace: stackTrace ?? StackTrace.current,
    level: 1000,
  );
}
