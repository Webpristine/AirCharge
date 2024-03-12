import 'package:get/get.dart';

import '../controllers/splash_scareen_controller.dart';

class SplashScareenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashScareenController>(
      () => SplashScareenController(),
    );
  }
}
