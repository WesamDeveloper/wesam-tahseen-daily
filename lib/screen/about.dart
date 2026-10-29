import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../features/about/controllers/about_controller.dart';
import '../features/about/views/about_view.dart';

export '../features/about/widgets/contact_tile.dart';

class CoreTeam extends StatelessWidget {
  const CoreTeam({super.key});
  static const screenRoute = '/team';

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<AboutController>()) {
      Get.lazyPut<AboutController>(() => AboutController());
    }
    return const AboutView();
  }
}
