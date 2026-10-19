import 'package:audioplayers/audioplayers.dart';

import 'audio_service.dart';

/// [AudioService] implementation backed by [AudioPlayer] from `audioplayers`.
final class AudioplayersAudioService implements AudioService {
  new() : _player = AudioPlayer();

  final AudioPlayer _player;

  static const String _winSoundAsset = 'audio/bingo_win.wav';

  @override
  Future<void> initialize() => AudioPlayer.global.setAudioContext(
    AudioContext(
      android: const AudioContextAndroid(
        usageType: AndroidUsageType.game,
        contentType: AndroidContentType.sonification,
        audioFocus: AndroidAudioFocus.none,
      ),
      iOS: AudioContextIOS(category: AVAudioSessionCategory.ambient),
    ),
  );

  @override
  Future<void> playWinSound() => _player.play(AssetSource(_winSoundAsset));

  @override
  Future<void> dispose() => _player.dispose();
}
