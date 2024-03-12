import 'package:aircharge/app/modules/home/controllers/home_controller.dart';
import 'package:aircharge/app/modules/setting_screen/controllers/setting_screen_controller.dart';
import 'package:get/get.dart';

import '../controllers/find_charges_screen_controller.dart';

class FindChargesScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(
      FindChargesScreenController(),
    );
    Get.put(HomeController());
    Get.put(SettingScreenController());
  }
}
