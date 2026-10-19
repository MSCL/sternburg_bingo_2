import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sternburg_bingo_2/core/audio/audio_provider.dart';
import 'package:sternburg_bingo_2/core/audio/audio_service.dart';
import 'package:sternburg_bingo_2/core/audio/audioplayers_audio_service.dart';

import '../../fakes/fake_audio_service.dart';

void main() {
  group('AudioService', () {
    test('audioServiceProvider provides registered AudioService', () async {
      final FakeAudioService fakeAudio = FakeAudioService();
      final ProviderContainer container = ProviderContainer(
        overrides: <Override>[
          audioServiceProvider.overrideWith((Ref ref) {
            ref.onDispose(fakeAudio.dispose);
            return fakeAudio;
          }),
        ],
      );

      final AudioService audio = container.read(audioServiceProvider);
      await audio.playWinSound();

      expect(fakeAudio.playWinSoundCount, equals(1));
      expect(fakeAudio.isDisposed, isFalse);

      container.dispose();
      expect(fakeAudio.isDisposed, isTrue);
    });

    test('AudioplayersAudioService initializes audio context without '
        'assertion errors', () async {
      TestWidgetsFlutterBinding.ensureInitialized();
      const MethodChannel channel = MethodChannel(
        'xyz.luan/audioplayers.global',
      );
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
            channel,
            (MethodCall methodCall) async => null,
          );

      final AudioplayersAudioService service = AudioplayersAudioService();
      await service.initialize();
    });
  });
}
