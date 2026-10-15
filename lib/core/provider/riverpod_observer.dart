import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../logging/app_logger.dart';

base class RiverpodObserver extends ProviderObserver {
  const new(this._logger, {this.enabled = false});

  final AppLogger _logger;
  final bool enabled;

  static const _tag = 'Riverpod';

  @override
  void didAddProvider(ProviderObserverContext context, Object? value) {
    if (!enabled) {
      return;
    }
    _logger.info('Initialized: ${context.name} ($value)', tag: _tag);
  }

  @override
  void didUpdateProvider(
    ProviderObserverContext context,
    Object? previousValue,
    Object? newValue,
  ) {
    if (!enabled) {
      return;
    }
    _logger.info(
      'Updated: ${context.name} | $previousValue -> $newValue',
      tag: _tag,
    );
  }

  @override
  void didDisposeProvider(ProviderObserverContext context) {
    if (!enabled) {
      return;
    }
    _logger.info('Disposed: ${context.name}', tag: _tag);
  }

  @override
  void providerDidFail(
    ProviderObserverContext context,
    Object error,
    StackTrace stackTrace,
  ) {
    _logger.error(
      'Failure in ${context.name}: $error',
      error: error,
      stackTrace: stackTrace,
      tag: _tag,
    );
  }
}

extension on ProviderObserverContext {
  String get name => provider.name ?? '${provider.runtimeType}';
}
