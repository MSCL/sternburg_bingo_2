// Envied requires static fields on the annotated class.
// ignore_for_file: avoid_classes_with_only_static_members
// Read at compile-time via --dart-define
// ignore_for_file: do_not_use_environment

import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(requireEnvFile: true)
abstract final class Env {
  // usefully for obfuscation functionality
  @EnviedField(varName: 'API_KEY', obfuscate: true)
  static final String apiKey = _Env.apiKey;

  @EnviedField(varName: 'API_URL')
  static const String apiUrl = _Env.apiUrl;

  // useful in case a variable needs to be accessed from native side
  static const String _serviceId = 'SERVICE_ID';
  static final String serviceId = const bool.hasEnvironment(_serviceId)
      ? const String.fromEnvironment(_serviceId)
      : throw const FormatException(
          '$_serviceId environment variable is not set via --dart-define.',
        );
}
