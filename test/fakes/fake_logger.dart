import 'package:sternburg_bingo_2/core/logging/logger.dart';

/// In-memory [Logger] implementation that records log statements
/// for test assertions.
final class FakeLogger implements Logger {
  new([List<String>? logs]) : logs = logs ?? <String>[];

  final List<String> logs;

  @override
  void info(String message, {String? tag}) =>
      logs.add('INFO: [${tag ?? 'INFO'}] $message');

  @override
  void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    String? tag,
  }) => logs.add('ERROR: [${tag ?? 'ERROR'}] $message');
}
