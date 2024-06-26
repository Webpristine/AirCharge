import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class LocationController extends GetxController {
  final RxBool isAccessingLocation = RxBool(false);
  final RxString errorDescription = RxString("");

  final Rx<double?> latitude = Rx<double?>(null);
  final Rx<double?> longitude = Rx<double?>(null);

  void updateIsAccessingLocation(bool b) {
    isAccessingLocation.value = b;
  }

  void updateUserLocation({
    required double lat,
    required double long,
  }) {
    // userLocation.value = data;
    latitude.value = lat;
    longitude.value = long;
  }
}
