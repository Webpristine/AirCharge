import 'package:aircharge/app/modules/find_charges_screen/controllers/find_charges_screen_controller.dart';
import 'package:get/get.dart';

import '../controllers/setting_screen_controller.dart';

class SettingScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingScreenController>(
      () => SettingScreenController(),
    );
    Get.put(
      FindChargesScreenController(),
    );
  }
}
