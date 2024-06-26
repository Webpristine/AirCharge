import 'dart:async';

import 'package:aircharge/app/core/service/loctions_controller.dart';
import 'package:aircharge/app/core/utils/device_info_util.dart';
import 'package:aircharge/app/data/models/error_model.dart';
import 'package:aircharge/app/data/network/api_controller.dart';
import 'package:aircharge/app/data/repostorys/api_repostory.dart';
import 'package:aircharge/app/data/request_dto/setting-request.dart';
import 'package:aircharge/app/data/response_dto/settings_response.dart';
import 'package:aircharge/app/modules/find_charges_screen/controllers/find_charges_screen_controller.dart';
import 'package:aircharge/main.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class SettingScreenController extends GetxController {
  late ApiRepostory _apiRepostory;

  var customeAlertRadiusSliderKm = 5.0.obs;
  var customeAlertRadiusSliderMiles = 3.0.obs;
  // var batteryPercentageAlertThresholdSliderValue = 0.0.obs;

  var sliderValue = 1.0.obs;

  // void updateCustomAlertSliderValue(double value) {
  //   customeAlertRadiusSlider.value = value;
  // }

  final _settingPage = SettingsResponceDto().obs;
  SettingsResponceDto get settingPage => _settingPage.value;
  set settingPage(SettingsResponceDto value) => _settingPage.value = value;

  final LocationController locationController = Get.find<LocationController>();

  final FindChargesScreenController findChargesScreenController =
      Get.find<FindChargesScreenController>();
  // RxInt markerModeValue = 0.obs;

  final _selectedDistanceUnit = 'Kilometers'.obs;
  String get selectedDistanceUnit => _selectedDistanceUnit.value;
  set selectedDistanceUnit(String value) => _selectedDistanceUnit.value = value;

  @override
  Future<void> onInit() async {
    _apiRepostory = ApiRepostory(apiControllerV1: Get.find<ApiControllerV1>());

    getSetting(DeviceInfoUtil.deviceInfo!);
    // postSetting();

    super.onInit();
  }

  @override
  void onClose() {
    // longPressTimer?.cancel();
    super.onClose();
  }

  Future<void> updateBatteryPercentageAlertThreshold(
      double batteryPercentageAlertThresholdSliderValue) async {
    final int calculatedBatteryPercentageAlertThreshold =
        batteryPercentageAlertThresholdSliderValue.round();
    getSettingValues.setting?.batteryPercentageAlertThreshold =
        calculatedBatteryPercentageAlertThreshold;
  }

  void updateBatteryLevelFromSlider(double sliderValue) {
    // final int calculatedBatteryLevel = sliderValue.round();
    // batteryLevel.value = calculatedBatteryLevel;
  }

  Future<void> updateCustomAlertRadius(double sliderValue) async {
    // final int calculatedBatteryLevel = sliderValue.round();
    //  batteryLevel.value = calculatedBatteryLevel;
  }

  /// Method to update settings
  //Low Power Notifications
  void updateLowPowerNotifications(Setting updateLowPowerNotificationsValue) {
    _getSettingValues.update((val) {
      val?.setting = updateLowPowerNotificationsValue;
    });
  }

  // Disable Notifications On Wifi
  void updatDisableNotificationsOnWifi(
      Setting updatDisableNotificationsOnWifiValue) {
    _getSettingValues.update((val) {
      val?.setting = updatDisableNotificationsOnWifiValue;
    });
  }

//Allow Power Monitoring
  void updateAllowPowerMonitoring(Setting updateAllowPowerMonitoringValue) {
    _getSettingValues.update((val) {
      val?.setting = updateAllowPowerMonitoringValue;
    });
  }

//Allow Loction Tracking
  void updateAllowLoctionTracking(Setting updateAllowLoctionTrackingValue) {
    _getSettingValues.update((val) {
      val?.setting = updateAllowLoctionTrackingValue;
    });
  }

  //Show Marker Mode
  void updateDistanceMiles(Setting updateDistanceMilesValue) {
    _getSettingValues.update((val) {
      val?.setting = updateDistanceMilesValue;
    });
  }

//Show Marker Mode
  void updateShowMarkerMode(Setting updateShowMarkerModeValue) {
    _getSettingValues.update((val) {
      val?.setting = updateShowMarkerModeValue;
    });
  }

//=====================================API==========================================

  ///setting
  Future<void> postSetting({int? id}) async {
    try {
      // isLoadingReport.value = true;

      settingPage = await _apiRepostory.setting(
        requestDTO: SettingRequestDto(
          deviceId: DeviceInfoUtil.deviceId,
          fcmId: findChargesScreenController.token,
          lowPowerNotifications:
              getSettingValues.setting?.lowPowerNotifications.toString() ?? "",
          notificationOnWifi:
              getSettingValues.setting?.notificationOnWifi.toString() ?? "",
          // customAlertRadius:
          //     getSettingValues.setting?.customAlertRadius.toString() ?? "",
          // batteryPercentageAlertThreshold: getSettingValues
          //         .setting?.batteryPercentageAlertThreshold
          //         .toString() ??
          //     "",
          customAlertRadius: getSettingValues.setting?.distanceUnit == "Miles"
              ? customeAlertRadiusSliderMiles.value.toString()
              : customeAlertRadiusSliderKm.value.toString(),
          // customAlertRadius:
          // getSettingValues.setting?.customAlertRadius.toString() ?? "",
          // customAlertRadiusKm:
          //     getSettingValues.setting?.customAlertRadiusKm.toString() ?? "",
          // customAlertRadiusMiles:
          //     getSettingValues.setting?.customAlertRadiusMiles.toString() ?? "",
          customAlertRadiusKm: customeAlertRadiusSliderKm.value.toString(),
          customAlertRadiusMiles:
              customeAlertRadiusSliderMiles.value.toString(),
          batteryPercentageAlertThreshold: sliderValue.value.toString(),
          allowPowerMonitoring:
              getSettingValues.setting?.allowPowerMonitoring.toString() ?? "",
          allowLocationTracking:
              getSettingValues.setting?.allowLocationTracking.toString() ?? "",
          showMarkerMode:
              getSettingValues.setting?.showMarkerMode.toString() ?? "",
          distanceUnit: getSettingValues.setting?.distanceUnit.toString() ?? "",
        ),
      );
      // Fluttertoast.showToast(
      //   msg: "Report has been successfully submitted",
      //   toastLength: Toast.LENGTH_SHORT,
      //   gravity: ToastGravity.BOTTOM,
      //   backgroundColor: Colors.green,
      //   textColor: Colors.white,
      // );
    } on ErrorResponse catch (e) {
      Get.back();
      debugPrint(e.toString());

      // Logger().d(e.error?.detail ?? '');
    } catch (e) {
      Get.back();
      Fluttertoast.showToast(
        msg: 'An error occurred',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      Logger().d(e);
    }
  }

//settingsGETAPI

//  late Rx<SettingsResponceDto> getSettingValues;

  final _getSettingValues = SettingsResponceDto().obs;
  SettingsResponceDto get getSettingValues => _getSettingValues.value;
  set getSettingValues(SettingsResponceDto value) =>
      _getSettingValues.value = value;

  Future<void> getSetting(String deviceId, {String? fcmtoken}) async {
    try {
      getSettingValues = await _apiRepostory.getSetting(deviceId);

      debugPrint('>>>> [DEBUG] getSettingValues : $getSettingValues');
      sliderValue.value =
          getSettingValues.setting!.batteryPercentageAlertThreshold!.toDouble();
      getSettingValues.setting?.distanceUnit == "Miles"
          ? customeAlertRadiusSliderMiles.value =
              getSettingValues.setting!.customAlertRadius!.toDouble()
          : customeAlertRadiusSliderKm.value =
              getSettingValues.setting!.customAlertRadius!.toDouble();
    } on ErrorResponse catch (e) {
      Get.back();
      debugPrint(e.toString());

      Logger().d(e.error?.detail ?? '');
    } catch (e) {
      Get.back();
      Logger().d(e);
    }
  }

  /// Method to update settings
  //Low Power Notifications
  void updateSettings(Setting newSetting) {
    _getSettingValues.update((val) {
      val?.setting = newSetting;
    });
  }
}
  //show_marker_mood
  // RxBool isMarkerModeOn = false.obs;
  // RxBool isLongPressStarted = false.obs;
  // Timer? longPressTimer;
  // void startMarkerMode() {
  //   isMarkerModeOn.value = true;

    // Fluttertoast.showToast(
    //   msg: "Marker Mode is ON",
    //   toastLength: Toast.LENGTH_SHORT,
    //   gravity: ToastGravity.BOTTOM,
    //   backgroundColor: AppColors.green,
    //   textColor: AppColors.white,
    // );
  // }

  // void stopMarkerMode() {
  //   isMarkerModeOn.value = false;
  
