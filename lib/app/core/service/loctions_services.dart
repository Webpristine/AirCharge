import 'dart:io';

import 'package:aircharge/app/core/service/loctions_controller.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart' as handler;

class LocationService {
  LocationService.init();
  static LocationService instance = LocationService.init();

  final Location _location = Location();
  // final Geolocator _geolocation = Geolocator();

  Future<bool> checkForServiceAvailability() async {
    if (Platform.isAndroid) {
      bool isEnabled = await _location.serviceEnabled();
      if (isEnabled) {
        return Future.value(true);
      }

      isEnabled = await _location.requestService();

      if (isEnabled) {
        return Future.value(true);
      }

      return Future.value(false);
    } else {
      bool isEnabled = await Geolocator.isLocationServiceEnabled();
      if (isEnabled) {
        return Future.value(true);
      }

      isEnabled = await _location.requestService();

      if (isEnabled) {
        return Future.value(true);
      }

      return Future.value(false);
    }
  }

  Future<bool> checkForPermission() async {
    if (Platform.isAndroid) {
      PermissionStatus status = await _location.hasPermission();

      if (status == PermissionStatus.denied) {
        status = await _location.requestPermission();
        if (status == PermissionStatus.granted) {
          return true;
        }
        return false;
      }
      if (status == PermissionStatus.deniedForever) {
        Get.snackbar("Permission Needed",
            "We use permission to get your location in order to give your service",
            onTap: (snack) async {
          await handler.openAppSettings();
        }).show();
        return false;
      }

      return Future.value(true);
    } else {
      LocationPermission status = await Geolocator.checkPermission();

      if (status == LocationPermission.denied) {
        status = await Geolocator.requestPermission();
        if (status == LocationPermission.always) {
          return true;
        } else if (status == LocationPermission.whileInUse) {
          return true;
        }
        return false;
      }
      if (status == LocationPermission.deniedForever) {
        Get.snackbar("Permission Needed",
            "We use permission to get your location in order to give your service",
            onTap: (snack) async {
          await handler.openAppSettings();
        }).show();
        return false;
      }

      return Future.value(true);
    }
  }

  Future<void> getUserLocation({required LocationController controller}) async {
    print("Lat long is init1");

    controller.updateIsAccessingLocation(true);
    if (!(await checkForServiceAvailability())) {
      controller.errorDescription.value = "Service not enabled";
      controller.updateIsAccessingLocation(false);

      return;
    }
    if (!(await checkForPermission())) {
      print("Lat long is Service Permission issue");

      controller.errorDescription.value = "Permission not given";
      controller.updateIsAccessingLocation(false);
      return;
    }
    final position = await Geolocator.getCurrentPosition();

    print("Lat long is ${position.latitude}");

    if (Platform.isAndroid) {
      final LocationData data = await _location.getLocation();

      controller.updateUserLocation(lat: data.latitude!, long: data.longitude!);
    } else {
      final position = await Geolocator.getCurrentPosition();
      controller.updateUserLocation(
          lat: position.latitude, long: position.longitude);
    }
    controller.updateIsAccessingLocation(false);
  }
}

// import 'package:location/location.dart';
// import 'package:aircharge/app/core/service/loctions-controller.dart';

// class LocationService {
//   LocationService.init();
//   static LocationService instance = LocationService.init();

//   final Location _location = Location();

//   Future<void> getUserLocation({required LocationController controller}) async {
//     controller.updateIsAccessingLocation(true);
//     try {
//       // Subscribe to location changes
//       _location.onLocationChanged.listen((LocationData data) {
//         // Update user location in the controller
//         controller.updateUserLocation(data);
//       });

//       // Check if location service is enabled
//       bool isEnabled = await _location.serviceEnabled();
//       if (!isEnabled) {
//         isEnabled = await _location.requestService();
//         if (!isEnabled) {
//           throw Exception("Service not enabled");
//         }
//       }

//       // Check for location permission
//       PermissionStatus status = await _location.hasPermission();
//       if (status == PermissionStatus.denied) {
//         status = await _location.requestPermission();
//         if (status != PermissionStatus.granted) {
//           throw Exception("Permission not granted");
//         }
//       }

//       // Get initial location
//       final LocationData data = await _location.getLocation();
//       controller.updateUserLocation(data);
//     } catch (e) {
//       // Handle exceptions
//       print("Error getting user location: $e");
//     } finally {
//       controller.updateIsAccessingLocation(false);
//     }
//   }
// }

