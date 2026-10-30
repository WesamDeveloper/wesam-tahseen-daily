import 'package:get/get.dart';
import '../../features/about/bindings/about_binding.dart';
import '../../features/about/views/about_view.dart';
import '../../features/adhkar/bindings/adhkar_binding.dart';
import '../../features/adhkar/bindings/tasbeeh_binding.dart';
import '../../features/adhkar/views/prayers_view.dart';
import '../../features/adhkar/views/tasbeeh_view.dart';
import '../../features/adhkar/views/zikr_detail_view.dart';
import '../../features/home/bindings/home_binding.dart';
import '../../features/home/views/home_view.dart';
import '../../features/quran/bindings/quran_binding.dart';
import '../../features/quran/bindings/surah_detail_binding.dart';
import '../../features/quran/views/quran_view.dart';
import '../../features/quran/views/surah_view.dart';
import '../../features/quran_audio/bindings/quran_audio_binding.dart';
import '../../features/quran_audio/views/quran_audio_view.dart';
import '../../features/settings/bindings/settings_binding.dart';
import '../../features/settings/views/settings_view.dart';
import '../../features/splash/bindings/splash_binding.dart';
import '../../features/splash/views/splash_view.dart';
import '../../features/study/views/study_view.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = AppRoutes.splash;

  static final List<GetPage> routes = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.prayers,
      page: () => const PrayersView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.zikrDetail,
      page: () => const ZikrDetailView(),
      binding: AdhkarBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.tasbeeh,
      page: () => const TasbeehView(),
      binding: TasbeehBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.quran,
      page: () => const QuranView(),
      binding: QuranBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.quranAudio,
      page: () => const QuranAudioView(),
      binding: QuranAudioBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.surah,
      page: () => const SurahView(),
      binding: SurahDetailBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.about,
      page: () => const AboutView(),
      binding: AboutBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.settings,
      page: () => const SettingsView(),
      binding: SettingsBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.study,
      page: () => const StudyView(),
      transition: Transition.rightToLeft,
    ),
  ];
}
