import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:dene/features/quran_audio/models/audio_surah_model.dart';
import 'package:dene/features/quran_audio/controllers/quran_audio_controller.dart';
import 'package:dene/features/quran_audio/services/quran_audio_service.dart';

class FakeQuranAudioService extends Fake implements QuranAudioService {
  final StreamController<PlayerState> _playerStateController =
      StreamController<PlayerState>.broadcast();
  final StreamController<Duration> _positionController =
      StreamController<Duration>.broadcast();
  final StreamController<Duration?> _durationController =
      StreamController<Duration?>.broadcast();
  final StreamController<Duration> _bufferedController =
      StreamController<Duration>.broadcast();

  PlayerState _state = PlayerState(false, ProcessingState.idle);
  Duration _pos = Duration.zero;
  final Duration _dur = const Duration(minutes: 2);
  bool shouldThrowOnLoad = false;
  String? lastLoadedAsset;

  @override
  Stream<PlayerState> get playerStateStream => _playerStateController.stream;

  @override
  Stream<Duration> get positionStream => _positionController.stream;

  @override
  Stream<Duration?> get durationStream => _durationController.stream;

  @override
  Stream<Duration> get bufferedPositionStream => _bufferedController.stream;

  @override
  Duration get position => _pos;

  @override
  Duration? get duration => _dur;

  @override
  bool get isPlaying => _state.playing;

  @override
  ProcessingState get processingState => _state.processingState;

  @override
  Future<void> init() async {}

  @override
  Future<Duration?> loadAndPlay(String assetPath) async {
    if (shouldThrowOnLoad) {
      throw Exception('Failed to load asset: $assetPath');
    }
    lastLoadedAsset = assetPath;
    _state = PlayerState(true, ProcessingState.ready);
    _playerStateController.add(_state);
    _positionController.add(Duration.zero);
    _durationController.add(_dur);
    return _dur;
  }

  @override
  Future<void> play() async {
    _state = PlayerState(true, ProcessingState.ready);
    _playerStateController.add(_state);
  }

  @override
  Future<void> pause() async {
    _state = PlayerState(false, ProcessingState.ready);
    _playerStateController.add(_state);
  }

  @override
  Future<void> stop() async {
    _state = PlayerState(false, ProcessingState.idle);
    _playerStateController.add(_state);
  }

  @override
  Future<void> seek(Duration position) async {
    _pos = position;
    _positionController.add(position);
  }

  @override
  Future<void> dispose() async {
    await _playerStateController.close();
    await _positionController.close();
    await _durationController.close();
    await _bufferedController.close();
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AudioSurahModel Tests', () {
    test(
      'Loads exactly 114 Surahs with matching 001-114 filenames and paths',
      () {
        final surahs = AudioSurahModel.getAllSurahs();
        expect(surahs.length, 114);

        // Surah 1: Al-Fatihah
        expect(surahs[0].index, 1);
        expect(surahs[0].name, 'الفاتحة');
        expect(surahs[0].fileName, '001.mp3');
        expect(surahs[0].assetPath, 'assets/audio/001.mp3');
        expect(surahs[0].formattedIndex, '001');

        // Surah 18: Al-Kahf
        expect(surahs[17].index, 18);
        expect(surahs[17].name, 'الكهف');
        expect(surahs[17].fileName, '018.mp3');
        expect(surahs[17].assetPath, 'assets/audio/018.mp3');
        expect(surahs[17].formattedIndex, '018');

        // Surah 114: An-Nas
        expect(surahs[113].index, 114);
        expect(surahs[113].name, 'الناس');
        expect(surahs[113].fileName, '114.mp3');
        expect(surahs[113].assetPath, 'assets/audio/114.mp3');
        expect(surahs[113].formattedIndex, '114');
      },
    );
  });

  group('QuranAudioController Tests', () {
    late FakeQuranAudioService fakeService;
    late QuranAudioController controller;

    setUp(() {
      Get.reset();
      fakeService = FakeQuranAudioService();
      controller = QuranAudioController(audioService: fakeService);
      Get.put<QuranAudioController>(controller);
    });

    tearDown(() {
      Get.reset();
    });

    test('Initial state is correctly populated', () {
      expect(controller.surahs.length, 114);
      expect(controller.filteredSurahs.length, 114);
      expect(controller.currentSurah.value?.index, 1);
      expect(controller.isPlaying.value, false);
      expect(controller.isLoading.value, false);
      expect(controller.hasError.value, false);
    });

    test('Play surah loads asset and transitions state', () async {
      final surah2 = controller.surahs[1]; // Al-Baqarah
      await controller.playSurah(surah2);

      expect(controller.currentSurah.value?.index, 2);
      expect(fakeService.lastLoadedAsset, 'assets/audio/002.mp3');
      expect(controller.isPlaying.value, true);
      expect(controller.hasError.value, false);
    });

    test('Tapping active playing surah pauses it immediately without glitch', () async {
      final surah1 = controller.surahs[0];
      await controller.playSurah(surah1);
      expect(controller.isPlaying.value, true);

      // Tapping same surah again pauses immediately
      await controller.playSurah(surah1);
      expect(controller.isPlaying.value, false);
      expect(fakeService.isPlaying, false);

      // Tapping again resumes immediately
      controller.position.value = const Duration(seconds: 10);
      await controller.playSurah(surah1);
      expect(controller.isPlaying.value, true);
      expect(fakeService.isPlaying, true);
    });

    test('Switching smoothly between different surahs without blocking', () async {
      await controller.playSurah(controller.surahs[0]); // Surah 1
      expect(controller.currentSurah.value?.index, 1);
      expect(controller.isPlaying.value, true);

      // Switch to Surah 18
      await controller.playSurah(controller.surahs[17]);
      expect(controller.currentSurah.value?.index, 18);
      expect(fakeService.lastLoadedAsset, 'assets/audio/018.mp3');
      expect(controller.isPlaying.value, true);

      // Switch to Surah 114
      await controller.playSurah(controller.surahs[113]);
      expect(controller.currentSurah.value?.index, 114);
      expect(fakeService.lastLoadedAsset, 'assets/audio/114.mp3');
      expect(controller.isPlaying.value, true);
    });

    test('Next and previous navigation works across surahs', () async {
      expect(controller.currentSurah.value?.index, 1);

      await controller.playNext();
      expect(controller.currentSurah.value?.index, 2);
      expect(fakeService.lastLoadedAsset, 'assets/audio/002.mp3');

      await controller.playNext();
      expect(controller.currentSurah.value?.index, 3);

      // Play previous when position is 0 should go back to surah 2
      controller.position.value = Duration.zero;
      await controller.playPrevious();
      expect(controller.currentSurah.value?.index, 2);
    });

    test('Previous when position > 3s seeks to beginning', () async {
      await controller.playSurah(controller.surahs[1]); // surah 2
      controller.position.value = const Duration(seconds: 15);

      await controller.playPrevious();
      // Should remain on surah 2, and seek to 0
      expect(controller.currentSurah.value?.index, 2);
      expect(fakeService.position, Duration.zero);
    });

    test(
      'Arabic search filtering supports with and without Al-, and diacritics',
      () {
        // Search with "الكهف"
        controller.filterSurahs('الكهف');
        expect(controller.filteredSurahs.length, 1);
        expect(controller.filteredSurahs.first.name, 'الكهف');

        // Search without "ال" -> "كهف"
        controller.filterSurahs('كهف');
        expect(controller.filteredSurahs.length, 1);
        expect(controller.filteredSurahs.first.name, 'الكهف');

        // Search with alef variation "ابراهيم" for "إبراهيم"
        controller.filterSurahs('ابراهيم');
        expect(controller.filteredSurahs.length, 1);
        expect(controller.filteredSurahs.first.name, 'إبراهيم');

        // Search by number "1"
        controller.filterSurahs('1');
        expect(controller.filteredSurahs.any((s) => s.index == 1), true);

        // Clear search
        controller.clearSearch();
        expect(controller.filteredSurahs.length, 114);
        expect(controller.searchQuery.value, '');
      },
    );

    test('Error during loading sets hasError state gracefully', () async {
      fakeService.shouldThrowOnLoad = true;
      await controller.playSurah(controller.surahs[5]);

      expect(controller.hasError.value, true);
      expect(controller.isPlaying.value, false);
      expect(controller.isLoading.value, false);
      expect(controller.errorMessage.value.isNotEmpty, true);
    });

    test('Seeking updates position smoothly', () async {
      controller.onSeeking(const Duration(seconds: 45));
      expect(controller.isSeeking.value, true);
      expect(controller.position.value, const Duration(seconds: 45));

      await controller.seekTo(const Duration(seconds: 50));
      expect(controller.isSeeking.value, false);
      expect(fakeService.position, const Duration(seconds: 50));
    });
  });
}
