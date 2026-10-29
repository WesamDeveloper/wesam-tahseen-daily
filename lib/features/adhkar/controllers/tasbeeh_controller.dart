import 'package:get/get.dart';

class TasbeehController extends GetxController {
  final RxInt counter = 0.obs;

  void increment() {
    counter.value++;
  }

  void reset() {
    counter.value = 0;
  }
}
