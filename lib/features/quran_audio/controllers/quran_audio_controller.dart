import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import '../../../core/constants/app_strings.dart';
import '../models/audio_surah_model.dart';
import '../services/quran_audio_service.dart';

class QuranAudioController extends GetxController {
  final QuranAudioService audioService;

  QuranAudioController({QuranAudioService? audioService})
    : audioService = audioService ?? QuranAudioService();

  // Surahs data
  final RxList<AudioSurahModel> surahs = <AudioSurahModel>[].obs;
  final RxList<AudioSurahModel> filteredSurahs = <AudioSurahModel>[].obs;
  final Rxn<AudioSurahModel> currentSurah = Rxn<AudioSurahModel>();

  // Player state
  final RxBool isPlaying = false.obs;
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;

  // Time & progress
  final Rx<Duration> position = Duration.zero.obs;
  final Rx<Duration> duration = Duration.zero.obs;
  final Rx<Duration> bufferedPosition = Duration.zero.obs;
  final RxBool isSeeking = false.obs;

  // Settings & search
  final RxString searchQuery = ''.obs;
  final RxBool autoPlayNext = true.obs;

  final TextEditingController searchController = TextEditingController();

  // Stream subscriptions
  StreamSubscription<PlayerState>? _playerStateSub;
  StreamSubscription<Duration>? _positionSub;
  StreamSubscription<Duration?>? _durationSub;
  StreamSubscription<Duration>? _bufferedSub;

  // Concurrency request tracker to prevent glitches
  int _activeRequestId = 0;

  @override
  void onInit() {
    super.onInit();
    _loadSurahs();
    _bindAudioStreams();
  }

  void _loadSurahs() {
    final list = AudioSurahModel.getAllSurahs();
    surahs.assignAll(list);
    filteredSurahs.assignAll(list);
    if (list.isNotEmpty && currentSurah.value == null) {
      currentSurah.value = list.first;
    }
  }

  void _bindAudioStreams() {
    _playerStateSub = audioService.playerStateStream.listen(
      (state) {
        final playing = state.playing;
        final processingState = state.processingState;

        isLoading.value =
            processingState == ProcessingState.loading ||
            processingState == ProcessingState.buffering;

        isPlaying.value =
            playing && processingState != ProcessingState.completed;

        if (processingState == ProcessingState.completed) {
          isPlaying.value = false;
          position.value = duration.value;
          if (autoPlayNext.value && !isLoading.value) {
            playNext();
          }
        }
      },
      onError: (Object e) {
        _handleError(e);
      },
    );

    _positionSub = audioService.positionStream.listen((pos) {
      if (!isSeeking.value) {
        position.value = pos;
      }
    });

    _durationSub = audioService.durationStream.listen((dur) {
      if (dur != null) {
        duration.value = dur;
      }
    });

    _bufferedSub = audioService.bufferedPositionStream.listen((buf) {
      bufferedPosition.value = buf;
    });
  }

  Future<void> playSurah(AudioSurahModel surah) async {
    // If user tapped the currently playing surah, pause it immediately
    if (currentSurah.value?.index == surah.index && isPlaying.value) {
      await pause();
      return;
    }

    // If user tapped the currently paused surah, resume it immediately
    if (currentSurah.value?.index == surah.index &&
        !isPlaying.value &&
        position.value > Duration.zero &&
        position.value < duration.value) {
      await resume();
      return;
    }

    // New surah playback request
    final requestId = ++_activeRequestId;
    hasError.value = false;
    errorMessage.value = '';
    currentSurah.value = surah;
    isLoading.value = true;
    position.value = Duration.zero;

    try {
      final loadedDur = await audioService.loadAndPlay(surah.assetPath);
      // Check if another request occurred while loading
      if (requestId != _activeRequestId) return;

      if (loadedDur != null) {
        duration.value = loadedDur;
      }
      isPlaying.value = true;
    } catch (e) {
      if (requestId != _activeRequestId) return;
      final errorStr = e.toString().toLowerCase();
      // Ignore normal interruptions and user cancellations
      if (!errorStr.contains('abort') && !errorStr.contains('interrupted')) {
        _handleError(e);
      }
    } finally {
      if (requestId == _activeRequestId) {
        isLoading.value = false;
      }
    }
  }

  Future<void> pause() async {
    isPlaying.value = false;
    try {
      await audioService.pause();
    } catch (e) {
      debugPrint('Error pausing: $e');
    }
  }

  Future<void> resume() async {
    isPlaying.value = true;
    try {
      await audioService.play();
    } catch (e) {
      debugPrint('Error resuming: $e');
    }
  }

  Future<void> togglePlayPause() async {
    final surah =
        currentSurah.value ?? (surahs.isNotEmpty ? surahs.first : null);
    if (surah == null) return;

    if (isPlaying.value) {
      await pause();
    } else {
      if (position.value > Duration.zero &&
          position.value < duration.value &&
          currentSurah.value?.index == surah.index) {
        await resume();
      } else {
        await playSurah(surah);
      }
    }
  }

  Future<void> playNext() async {
    if (surahs.isEmpty) return;
    final currentIndex =
        currentSurah.value != null ? surahs.indexOf(currentSurah.value!) : -1;
    final nextIndex = (currentIndex + 1) % surahs.length;
    await playSurah(surahs[nextIndex]);
  }

  Future<void> playPrevious() async {
    if (surahs.isEmpty) return;
    if (position.value.inSeconds > 3) {
      await seekTo(Duration.zero);
      return;
    }
    final currentIndex =
        currentSurah.value != null ? surahs.indexOf(currentSurah.value!) : 0;
    final prevIndex = (currentIndex - 1 + surahs.length) % surahs.length;
    await playSurah(surahs[prevIndex]);
  }

  void onSeeking(Duration interimPosition) {
    isSeeking.value = true;
    position.value = interimPosition;
  }

  Future<void> seekTo(Duration newPosition) async {
    isSeeking.value = false;
    position.value = newPosition;
    try {
      await audioService.seek(newPosition);
    } catch (e) {
      _handleError(e);
    }
  }

  void filterSurahs(String query) {
    searchQuery.value = query;
    if (query.trim().isEmpty) {
      filteredSurahs.assignAll(surahs);
      return;
    }

    final normalizedQuery = _normalizeArabic(query.trim());
    final results =
        surahs.where((s) {
          final normalizedName = _normalizeArabic(s.name);
          final indexStr = s.index.toString();
          final formattedIndex = s.formattedIndex;

          return normalizedName.contains(normalizedQuery) ||
              _stripAlPrefix(normalizedName).contains(normalizedQuery) ||
              indexStr == query.trim() ||
              formattedIndex == query.trim();
        }).toList();

    filteredSurahs.assignAll(results);
  }

  void clearSearch() {
    searchController.clear();
    filterSurahs('');
  }

  String _normalizeArabic(String text) {
    return text
        .replaceAll(RegExp(r'[\u064B-\u065F\u0670]'), '') // Remove diacritics
        .replaceAll(RegExp(r'[أإآ]'), 'ا')
        .replaceAll('ة', 'ه')
        .replaceAll('ى', 'ي')
        .replaceAll('ؤ', 'و')
        .replaceAll('ئ', 'ي')
        .toLowerCase();
  }

  String _stripAlPrefix(String text) {
    if (text.startsWith('ال')) {
      return text.substring(2);
    }
    return text;
  }

  void _handleError(Object error) {
    hasError.value = true;
    errorMessage.value = AppStrings.audioError;
    isLoading.value = false;
    isPlaying.value = false;
  }

  @override
  void onClose() {
    _playerStateSub?.cancel();
    _positionSub?.cancel();
    _durationSub?.cancel();
    _bufferedSub?.cancel();
    searchController.dispose();
    audioService.dispose();
    super.onClose();
  }
}
