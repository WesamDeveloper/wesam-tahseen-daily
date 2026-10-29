import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutController extends GetxController {
  Future<void> launchTargetUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void launchPhone(String phone) => launchTargetUrl('tel:$phone');
  void launchEmail(String email) => launchTargetUrl('mailto:$email');
  void launchWeb(String url) => launchTargetUrl(url);
}
