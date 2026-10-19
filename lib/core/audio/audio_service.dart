abstract interface class AudioService {
  Future<void> initialize();

  Future<void> playWinSound();

  Future<void> dispose();
}
