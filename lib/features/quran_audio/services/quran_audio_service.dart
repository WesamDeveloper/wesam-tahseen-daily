import 'dart:async';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

class QuranAudioService {
  AudioPlayer? _player;
  bool _isInitialized = false;

  AudioPlayer get player {
    _player ??= AudioPlayer();
    return _player!;
  }

  Future<void> init() async {
    if (_isInitialized) return;
    try {
      final session = await AudioSession.instance;
      await session.configure(const AudioSessionConfiguration.music());
    } catch (e) {
      debugPrint('Error configuring AudioSession: $e');
    }
    _isInitialized = true;
  }

  Stream<PlayerState> get playerStateStream => player.playerStateStream;
  Stream<Duration> get positionStream => player.positionStream;
  Stream<Duration?> get durationStream => player.durationStream;
  Stream<Duration> get bufferedPositionStream => player.bufferedPositionStream;

  Duration get position => player.position;
  Duration? get duration => player.duration;
  bool get isPlaying => player.playing;
  ProcessingState get processingState => player.processingState;

  Future<Duration?> loadAndPlay(String assetPath) async {
    await init();
    try {
      if (player.playing) {
        await player.stop();
      }
    } catch (_) {}

    try {
      final loadedDuration = await player.setAsset(assetPath);
      // Trigger play asynchronously without awaiting full playback completion
      unawaited(
        player.play().catchError((Object e) {
          debugPrint('Player play error: $e');
        }),
      );
      return loadedDuration;
    } catch (e) {
      debugPrint('Error loading/playing asset ($assetPath): $e');
      rethrow;
    }
  }

  Future<void> play() async {
    try {
      unawaited(
        player.play().catchError((Object e) {
          debugPrint('Player play error: $e');
        }),
      );
    } catch (e) {
      debugPrint('Error triggering play: $e');
    }
  }

  Future<void> pause() async {
    try {
      await player.pause();
    } catch (e) {
      debugPrint('Error pausing player: $e');
    }
  }

  Future<void> stop() async {
    try {
      await player.stop();
    } catch (e) {
      debugPrint('Error stopping player: $e');
    }
  }

  Future<void> seek(Duration position) async {
    try {
      await player.seek(position);
    } catch (e) {
      debugPrint('Error seeking player: $e');
    }
  }

  Future<void> dispose() async {
    try {
      await _player?.stop();
      await _player?.dispose();
    } catch (e) {
      debugPrint('Error disposing audio player: $e');
    } finally {
      _player = null;
      _isInitialized = false;
    }
  }
}
