import 'dart:developer';

abstract interface class Logger {
  void info(String message, {String? tag});

  void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    String? tag,
  });
}

final class ConsoleLogger implements Logger {
  const new();

  @override
  void info(String message, {String? tag}) => log(message, name: tag ?? 'INFO');

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
