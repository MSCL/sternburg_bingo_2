import 'package:sternburg_bingo_2/core/audio/audio_service.dart';

/// In-memory [AudioService] implementation for unit and widget tests.
final class FakeAudioService implements AudioService {
  new();

  int playWinSoundCount = 0;
  bool isDisposed = false;

  @override
  Future<void> initialize() async {}

  @override
  Future<void> playWinSound() async => playWinSoundCount++;

  @override
  Future<void> dispose() async => isDisposed = true;
}
