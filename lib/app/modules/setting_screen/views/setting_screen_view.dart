import 'package:aircharge/app/core/theme/colors.dart';
import 'package:aircharge/app/core/theme/styles.dart';
import 'package:aircharge/app/core/utils/device_info_util.dart';
import 'package:aircharge/app/modules/find_charges_screen/controllers/find_charges_screen_controller.dart';
import 'package:aircharge/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../controllers/setting_screen_controller.dart';

class SettingScreenView extends GetView<SettingScreenController> {
  const SettingScreenView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    SettingScreenController settingScreenController =
        Get.put(SettingScreenController());
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Padding(
        padding: EdgeInsets.only(bottom: 72.h),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.only(
                  top: 15.h,
                ),
                children: [
                  Center(
                    child: Text(
                      "Settings",
                      style: Styles.interBold(
                        color: AppColors.blackText,
                        size: 16.sp,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Divider(
                    color: AppColors.grey.withOpacity(0.1),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
                    child: Text(
                      "Notification Settings",
                      style: Styles.interBold(
                        color: AppColors.black,
                        size: 15.sp,
                      ),
                    ),
                  ),
                  ListTile(
                    visualDensity: const VisualDensity(vertical: -4),
                    contentPadding: EdgeInsets.fromLTRB(12.w, 2, 12.w, 0),
                    title: Text(
                      "Low power Notifications",
                      style: Styles.interRegular(
                        color: AppColors.black,
                        size: 14.sp,
                      ),
                    ),
                    subtitle: Padding(
                      padding: EdgeInsets.only(top: 3.h, bottom: 2.h),
                      child: Text(
                        "Notify me of nearby charging locations",
                        style: Styles.interRegular(
                          color: AppColors.settingScreenSubTitleColor,
                          size: 11.sp,
                        ),
                      ),
                    ),
                    trailing: Obx(
                      () => SizedBox(
                        height: 46.h,
                        width: 46.w,
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: CupertinoSwitch(
                            // value: controller.lowPowerNotifications.value,
                            value: controller.getSettingValues.setting
                                    ?.lowPowerNotifications ??
                                false,
                            onChanged: (bool value) async {
                              final currentSetting =
                                  controller.getSettingValues.setting;
                              if (currentSetting != null) {
                                currentSetting.lowPowerNotifications = value;
                                controller.updateLowPowerNotifications(
                                    currentSetting);
                              }

                              // await  controller
                              //       .findChargesScreenController
                              //       .getSetting(DeviceInfoUtil.deviceId);
                              await controller.postSetting();
                              prefs!.setBool("lowpower", value);
                            },
                            activeColor: AppColors.settingScreenSwitchOnColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                    ),
                    child: Divider(
                      color: AppColors.grey.withOpacity(0.1),
                      height: 1.8,
                    ),
                  ),
                  ListTile(
                    visualDensity: const VisualDensity(vertical: -4),
                    contentPadding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 0),
                    title: Text(
                      "Disable notifications on Wifi",
                      style: Styles.interRegular(
                        color: AppColors.black,
                        size: 14.sp,
                      ),
                    ),
                    subtitle: Padding(
                      padding: EdgeInsets.only(top: 2.h, bottom: 2.h),
                      child: Text(
                        "Nearby chargers will only alert on mobile data",
                        style: Styles.interRegular(
                          color: AppColors.settingScreenSubTitleColor,
                          size: 11.sp,
                        ),
                      ),
                    ),
                    trailing: Obx(
                      () => SizedBox(
                        height: 46.h,
                        width: 46.w,
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: CupertinoSwitch(
                            value: controller.getSettingValues.setting
                                    ?.notificationOnWifi ??
                                false,
                            onChanged: (bool value) async {
                              final currentSetting =
                                  controller.getSettingValues.setting;
                              if (currentSetting != null) {
                                currentSetting.notificationOnWifi = value;
                                controller.updatDisableNotificationsOnWifi(
                                    currentSetting);
                              }
                              await controller.postSetting();
                            },
                            activeColor: AppColors.settingScreenSwitchOnColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: Divider(
                      color: AppColors.grey.withOpacity(0.1),
                      height: 0.0,
                    ),
                  ),
                  ListTile(
                    visualDensity: const VisualDensity(vertical: -4),
                    contentPadding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 0),
                    title: Text(
                      "Custom Alert Radius",
                      style: Styles.interRegular(
                        color: AppColors.blackText,
                        size: 14.sp,
                      ),
                    ),
                    subtitle: Padding(
                      padding: EdgeInsets.only(top: 4.h),
                      child: Text(
                        "Only show me nearby chargers within a specific distance",
                        style: Styles.interRegular(
                          color: AppColors.settingScreenSubTitleColor,
                          size: 11.sp,
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(right: 16.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Obx(
                          () => SizedBox(
                            width: Get.width / 1.26.w,
                            child: Slider(
                              value: controller.getSettingValues.setting
                                          ?.distanceUnit ==
                                      "Miles"
                                  ? settingScreenController
                                      .customeAlertRadiusSliderMiles.value
                                  : settingScreenController
                                      .customeAlertRadiusSliderKm.value,
                              onChanged: (value) {
                                controller.getSettingValues.setting
                                            ?.distanceUnit ==
                                        "Miles"
                                    ? settingScreenController
                                        .customeAlertRadiusSliderMiles
                                        .value = value.round().toDouble()
                                    : settingScreenController
                                        .customeAlertRadiusSliderKm
                                        .value = value.round().toDouble();
                                controller.updateCustomAlertRadius(value);
                              },
                              onChangeEnd: (value) async {
                                await FindChargesScreenController()
                                    .getSetting(DeviceInfoUtil.deviceId);
                                await controller.postSetting();
                              },
                              min: 1.0,
                              max: controller.getSettingValues.setting
                                          ?.distanceUnit ==
                                      "Miles"
                                  ? 12.0
                                  : 20.0,
                              divisions: 1000,
                              activeColor: AppColors.blue,
                              inactiveColor: AppColors.grey.withOpacity(0.2),
                            ),
                          ),
                        ),
                        Obx(
                          () => Text(
                            // "1km",
                            controller.getSettingValues.setting?.distanceUnit ==
                                    "Miles"
                                ? '${controller.customeAlertRadiusSliderMiles.value.toInt()}miles'
                                : '${controller.customeAlertRadiusSliderKm.value.toInt()}km',
                            style: Styles.metaRegular(
                              color: AppColors.blackText,
                              size: 14.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.sp, vertical: 0),
                    child: Divider(
                      color: AppColors.grey.withOpacity(0.1),
                      height: 0.0,
                    ),
                  ),
                  ListTile(
                    visualDensity: const VisualDensity(vertical: -4),
                    contentPadding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 0),
                    title: Text(
                      "Battery Percentage Alert Threshold",
                      style: Styles.interRegular(
                        color: AppColors.blackText,
                        size: 14.sp,
                      ),
                    ),
                    subtitle: Padding(
                      padding: EdgeInsets.only(top: 4.h),
                      child: Text(
                        "The battery percentage at which an alert will trigger",
                        style: Styles.interRegular(
                          color: AppColors.settingScreenSubTitleColor,
                          size: 11.sp,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 18.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: Get.width / 1.26.w,
                          child: Obx(
                            () => Slider(
                              // value: settingScreenController
                              //     .batteryPercentageAlerSlider.value,
                              value: controller.sliderValue.value,
                              onChangeEnd: (value) async {
                                await controller.postSetting();
                                prefs!.setInt("battey", value.toInt());
                              },
                              // onChanged: (value) {
                              //   settingScreenController
                              //       .batteryPercentageAlerSlider.value = value;},
                              onChanged: (value) async {
                                controller.sliderValue.value =
                                    value.round().toDouble();
                                controller.updateBatteryLevelFromSlider(value);
                                // await controller.postSetting();
                              },

                              min: 1.0,
                              max: 60.0,
                              activeColor: AppColors.blue,
                              inactiveColor: AppColors.grey.withOpacity(0.2),
                            ),
                          ),
                        ),
                        Obx(() => Text(
                              // "20%",

                              '${controller.sliderValue.value.toInt()}%',

                              style: Styles.interRegular(
                                color: AppColors.blackText,
                                size: 14.sp,
                              ),
                            ))
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.sp, vertical: 0),
                    child: Divider(
                      color: AppColors.grey.withOpacity(0.1),
                      height: 0.0,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 10.w,
                      right: 10.w,
                      top: 18.h,
                    ),
                    child: Text(
                      "Data Tracking",
                      style: Styles.interBold(
                        color: AppColors.black,
                        size: 16.sp,
                      ),
                    ),
                  ),
                  ListTile(
                    visualDensity: const VisualDensity(vertical: -4),
                    contentPadding: EdgeInsets.fromLTRB(12.w, 2, 12.w, 0),
                    title: Text(
                      "Allow power monitoring",
                      style: Styles.interRegular(
                        color: AppColors.black,
                        size: 14.sp,
                      ),
                    ),
                    subtitle: Padding(
                      padding: EdgeInsets.only(top: 3.h, bottom: 2.h),
                      child: Text(
                        "Send battery and charge data to Aircharge",
                        style: Styles.interRegular(
                          color: AppColors.settingScreenSubTitleColor,
                          size: 11.sp,
                        ),
                      ),
                    ),
                    trailing: Obx(
                      () => SizedBox(
                        height: 46.h,
                        width: 46.w,
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: CupertinoSwitch(
                            // value: controller.allowPowerMonitoring.value,
                            value: controller.getSettingValues.setting
                                    ?.allowPowerMonitoring ??
                                false,
                            onChanged: (bool value) async {
                              final currentSetting =
                                  controller.getSettingValues.setting;
                              if (currentSetting != null) {
                                currentSetting.allowPowerMonitoring = value;
                                controller
                                    .updateAllowPowerMonitoring(currentSetting);
                              }
                              await controller.postSetting();
                            },
                            activeColor: AppColors.settingScreenSwitchOnColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                    ),
                    child: Divider(
                      color: AppColors.grey.withOpacity(0.1),
                      height: 1.8,
                    ),
                  ),
                  ListTile(
                    visualDensity: const VisualDensity(vertical: -4),
                    contentPadding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 0),
                    title: Text(
                      "Allow location tracking",
                      style: Styles.interRegular(
                        color: AppColors.black,
                        size: 14.sp,
                      ),
                    ),
                    subtitle: Padding(
                      padding: EdgeInsets.only(top: 2.h, bottom: 2.h),
                      child: Text(
                        "Used to show nearby chargers",
                        style: Styles.interRegular(
                          color: AppColors.settingScreenSubTitleColor,
                          size: 11.sp,
                        ),
                      ),
                    ),
                    trailing: Obx(
                      () => SizedBox(
                        height: 46.h,
                        width: 46.w,
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: CupertinoSwitch(
                            // value: controller.allowloctiontracking.value,
                            value: controller.getSettingValues.setting
                                    ?.allowLocationTracking ??
                                false,
                            onChanged: (bool value) async {
                              // // controller.allowloctiontracking.value = value;
                              // controller.updateAllowLoctionTracking(Setting(
                              //   allowLocationTracking: value,
                              // ));
                              final currentSetting =
                                  controller.getSettingValues.setting;
                              if (currentSetting != null) {
                                currentSetting.allowLocationTracking = value;
                                controller
                                    .updateAllowLoctionTracking(currentSetting);
                              }
                              await controller.postSetting();
                            },

                            activeColor: AppColors.settingScreenSwitchOnColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                    ),
                    child: Divider(
                      color: AppColors.grey.withOpacity(0.1),
                      height: 1.8,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 10.w,
                      right: 10.w,
                      top: 10.h,
                    ),
                    child: Text(
                      "Misc Settings",
                      style: Styles.interBold(
                        color: AppColors.black,
                        size: 16.sp,
                      ),
                    ),
                  ),
                  // Padding(
                  //   padding:
                  //       EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       Text(
                  //         "Ditance unit",
                  //         style: Styles.interRegular(
                  //           color: AppColors.black,
                  //           size: 14.sp,
                  //         ),
                  //       ),
                  //       Text(
                  //         "Kilometers",
                  //         // '${controller.sliderValue.value.toInt()}%',

                  //         style: Styles.interRegular(
                  //           color: AppColors.grey,
                  //           size: 14.sp,
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  ListTile(
                    visualDensity: const VisualDensity(vertical: -4),
                    contentPadding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 0),
                    title: Text(
                      "Distance unit",
                      style: Styles.interRegular(
                        color: AppColors.black,
                        size: 14.sp,
                      ),
                    ),
                    // trailing: Text(
                    //   "Kilometers",
                    //   // '${controller.sliderValue.value.toInt()}%',
                    //   // controller.getSettingValues.setting?.distanceUnit ?? "",
                    //   style: Styles.interRegular(
                    //     color: AppColors.grey,
                    //     size: 14.sp,
                    //   ),
                    // ),
                    trailing: Obx(
                      () => DropdownButton<String>(
                        // value: controller.selectedDistanceUnit,
                        value:
                            controller.getSettingValues.setting?.distanceUnit ??
                                'Kilometers',
                        icon: const Icon(Icons.arrow_drop_down),
                        iconSize: 24,
                        elevation: 16,
                        style: Styles.interRegular(
                          color: AppColors.grey,
                          size: 14.sp,
                        ),
                        underline: Container(),
                        onChanged: (String? newValue) async {
                          final currentSetting =
                              controller.getSettingValues.setting;
                          if (currentSetting != null) {
                            currentSetting.distanceUnit = newValue;
                            controller.updateDistanceMiles(currentSetting);
                          }
                          await controller.postSetting();
                          if (controller
                              .findChargesScreenController.isOpened.value) {
                            controller.findChargesScreenController
                                .refreshFindChargesDetail(
                              id: controller.findChargesScreenController
                                  .findChargesDataDetails.location!.locationId!,
                              latitude: controller
                                      .locationController.latitude.value ??
                                  0.0,
                              longitude: controller
                                      .locationController.longitude.value ??
                                  0.0,
                            );
                          }
                          controller.findChargesScreenController
                              .refreshFindChargesList(
                            latitude:
                                controller.locationController.latitude.value ??
                                    0.0,
                            longitude:
                                controller.locationController.longitude.value ??
                                    0.0,
                          );
                        },

                        items: <String>['Kilometers', 'Miles']
                            .map<DropdownMenuItem<String>>(
                          (String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          },
                        ).toList(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: Divider(
                      color: AppColors.grey.withOpacity(0.1),
                      height: 0.0,
                    ),
                  ),

                  ListTile(
                    visualDensity: const VisualDensity(vertical: -4),
                    contentPadding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 0),
                    title: Text(
                      "Show digital engagement locations",
                      style: Styles.interRegular(
                        color: AppColors.black,
                        size: 14.sp,
                      ),
                    ),
                    trailing: Obx(
                      () => SizedBox(
                        height: 46.h,
                        width: 46.w,
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: CupertinoSwitch(
                            value: controller
                                    .getSettingValues.setting?.showMarkerMode ??
                                false,
                            onChanged: (bool value) async {
                              final currentSetting =
                                  controller.getSettingValues.setting;
                              if (currentSetting != null) {
                                currentSetting.showMarkerMode = value;
                                controller.updateShowMarkerMode(currentSetting);
                              }
                              await controller.postSetting();

                              controller.getSettingValues.setting
                                          ?.showMarkerMode ==
                                      true
                                  ? controller.findChargesScreenController
                                      .getFindChargesListLoctionsList(
                                      latitude: controller.locationController
                                              .latitude.value ??
                                          0.0,
                                      longitude: controller.locationController
                                              .longitude.value ??
                                          0.0,
                                      secondlatitude: controller
                                          .findChargesScreenController
                                          .placedetails
                                          .value
                                          .latitude,
                                      secondlongitude: controller
                                          .findChargesScreenController
                                          .placedetails
                                          .value
                                          .longitude,
                                      // showMarkerMode: 1,
                                    )
                                  : controller.findChargesScreenController
                                      .getFindChargesListLoctionsList(
                                      latitude: controller.locationController
                                              .latitude.value ??
                                          0.0,
                                      longitude: controller.locationController
                                              .longitude.value ??
                                          0.0,
                                      secondlatitude: controller
                                          .findChargesScreenController
                                          .placedetails
                                          .value
                                          .latitude,
                                      secondlongitude: controller
                                          .findChargesScreenController
                                          .placedetails
                                          .value
                                          .longitude,
                                      // showMarkerMode: 0,
                                    );
                            },
                            activeColor: AppColors.settingScreenSwitchOnColor,
                          ),
                        ),
                      ),
                    ),
                  ),

                  //     ],
                  //   ),
                  // ),
                  // GestureDetector(
                  //     onLongPress: () {
                  //       Timer(const Duration(seconds: 3), () {
                  //         controller.startMarkerMode();
                  //         controller.findChargesScreenController
                  //             .getFindChargesListLoctionsList(
                  //           latitude: controller.locationController.userLocation.value
                  //                   ?.latitude ??
                  //               0.0,
                  //           longitude: controller.locationController.userLocation
                  //                   .value?.longitude ??
                  //               0.0,
                  //           showMarkerMode: 1,
                  //           // pageNumber: 1
                  //         );
                  //       });
                  //     },
                  //     onLongPressEnd: (details) {
                  //       controller.isLongPressStarted.value = false;

                  //       controller.longPressTimer?.cancel();
                  //     },
                  //     child: Text(
                  //       'Show Marker Mode',
                  //       style: Styles.interBold(
                  //           size: 14.sp,
                  //           // color: controller.isMarkerModeOn.value
                  //           //     ? AppColors.black
                  //           //     : AppColors.settingScreenSwitchOffColor,
                  //           color: AppColors.settingScreenSwitchOffColor),
                  //       textAlign: TextAlign.center,
                  //     )),
                  SizedBox(
                    height: 16.h,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}






// import 'dart:async';

// import 'package:aircharge/app/core/theme/colors.dart';
// import 'package:aircharge/app/core/theme/styles.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// import 'package:get/get.dart';

// import '../../../data/response_dto/settings_response.dart';
// import '../controllers/setting_screen_controller.dart';

// class SettingScreenView extends GetView<SettingScreenController> {
//   const SettingScreenView({Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     SettingScreenController settingScreenController =
//         Get.put(SettingScreenController());
//     return Scaffold(
//       backgroundColor: AppColors.white,
//       body: Padding(
//         padding: EdgeInsets.only(bottom: 72.h),
//         child: Column(
//           children: [
//             Expanded(
//               child: ListView(
//                 padding: EdgeInsets.only(
//                   top: 15.h,
//                 ),
//                 children: [
//                   Center(
//                     child: Text(
//                       "Settings",
//                       style: Styles.interBold(
//                         color: AppColors.blackText,
//                         size: 16.sp,
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 20.h,
//                   ),
//                   Divider(
//                     color: AppColors.grey.withOpacity(0.1),
//                   ),
//                   Padding(
//                     padding:
//                         EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
//                     child: Text(
//                       "Notification Settings",
//                       style: Styles.interBold(
//                         color: AppColors.black,
//                         size: 15.sp,
//                       ),
//                     ),
//                   ),
//                   ListTile(
//                     visualDensity: const VisualDensity(vertical: -4),
//                     contentPadding: EdgeInsets.fromLTRB(12.w, 2, 12.w, 0),
//                     title: Text(
//                       "Low power Notifications",
//                       style: Styles.interRegular(
//                         color: AppColors.black,
//                         size: 14.sp,
//                       ),
//                     ),
//                     subtitle: Padding(
//                       padding: EdgeInsets.only(top: 3.h, bottom: 2.h),
//                       child: Text(
//                         "Notify me of nearby charging locations",
//                         style: Styles.interRegular(
//                           color: AppColors.settingScreenSubTitleColor,
//                           size: 11.sp,
//                         ),
//                       ),
//                     ),
//                     trailing: Obx(
//                       () => SizedBox(
//                         height: 46.h,
//                         width: 46.w,
//                         child: FittedBox(
//                           fit: BoxFit.contain,
//                           child: CupertinoSwitch(
//                             // value: controller.lowPowerNotifications.value,
//                             value: controller.getSettingValues.setting
//                                     ?.lowPowerNotifications ??
//                                 false,
//                             onChanged: (bool value) {
//                               // Update the setting in the controller
//                               controller.updateSettings(
//                                 Setting(
//                                   lowPowerNotifications: value,
//                                   // Other properties as needed
//                                 ),
//                               );

//                               // You can also call an API here to update the settings on the server
//                               controller.postSetting();
//                               // api.updateSettings(controller.getSettingValues.setting);
//                             },
//                             activeColor: AppColors.settingScreenSwitchOnColor,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.symmetric(
//                       horizontal: 12.w,
//                     ),
//                     child: Divider(
//                       color: AppColors.grey.withOpacity(0.1),
//                       height: 1.8,
//                     ),
//                   ),
//                   ListTile(
//                     visualDensity: const VisualDensity(vertical: -4),
//                     contentPadding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 0),
//                     title: Text(
//                       "Disable notifications on Wifi",
//                       style: Styles.interRegular(
//                         color: AppColors.black,
//                         size: 14.sp,
//                       ),
//                     ),
//                     subtitle: Padding(
//                       padding: EdgeInsets.only(top: 2.h, bottom: 2.h),
//                       child: Text(
//                         "Nearby chargers will only alert on mobile data",
//                         style: Styles.interRegular(
//                           color: AppColors.settingScreenSubTitleColor,
//                           size: 11.sp,
//                         ),
//                       ),
//                     ),
//                     trailing: Obx(
//                       () => SizedBox(
//                         height: 46.h,
//                         width: 46.w,
//                         child: FittedBox(
//                           fit: BoxFit.contain,
//                           child: CupertinoSwitch(
//                             value: controller.disableNotification.value,
//                             onChanged: (bool value) {
//                               controller.disableNotification.value = value;
//                             },
//                             activeColor: AppColors.settingScreenSwitchOnColor,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 12.w),
//                     child: Divider(
//                       color: AppColors.grey.withOpacity(0.1),
//                       height: 0.0,
//                     ),
//                   ),
//                   ListTile(
//                     visualDensity: const VisualDensity(vertical: -4),
//                     contentPadding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 0),
//                     title: Text(
//                       "Custom Alert Radius",
//                       style: Styles.interRegular(
//                         color: AppColors.blackText,
//                         size: 14.sp,
//                       ),
//                     ),
//                     subtitle: Padding(
//                       padding: EdgeInsets.only(top: 4.h),
//                       child: Text(
//                         "Only show me nearby chargers within a specific distanc",
//                         style: Styles.interRegular(
//                           color: AppColors.settingScreenSubTitleColor,
//                           size: 11.sp,
//                         ),
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.only(right: 16.w),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Obx(
//                           () => SizedBox(
//                             width: Get.width / 1.2.w,
//                             child: Slider(
//                               value: settingScreenController
//                                   .customeAlertRadiusSlider.value,
//                               onChanged: (value) {
//                                 settingScreenController
//                                     .customeAlertRadiusSlider.value = value;
//                               },
//                               min: 0.0,
//                               max: 100.0,
//                               activeColor: AppColors.blue,
//                               inactiveColor: AppColors.grey.withOpacity(0.2),
//                             ),
//                           ),
//                         ),
//                         Text(
//                           "1km",
//                           style: Styles.metaRegular(
//                             color: AppColors.blackText,
//                             size: 14.sp,
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                   Padding(
//                     padding:
//                         EdgeInsets.symmetric(horizontal: 16.sp, vertical: 0),
//                     child: Divider(
//                       color: AppColors.grey.withOpacity(0.1),
//                       height: 0.0,
//                     ),
//                   ),
//                   ListTile(
//                     visualDensity: const VisualDensity(vertical: -4),
//                     contentPadding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 0),
//                     title: Text(
//                       "Battery Percentage Alert Threshold",
//                       style: Styles.interRegular(
//                         color: AppColors.blackText,
//                         size: 14.sp,
//                       ),
//                     ),
//                     subtitle: Padding(
//                       padding: EdgeInsets.only(top: 4.h),
//                       child: Text(
//                         "The battery percentage at which an alert will trigger",
//                         style: Styles.interRegular(
//                           color: AppColors.settingScreenSubTitleColor,
//                           size: 11.sp,
//                         ),
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.only(right: 18.w),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Obx(
//                           () => SizedBox(
//                             width: Get.width / 1.2.w,
//                             child: Slider(
//                               // value: settingScreenController
//                               //     .batteryPercentageAlerSlider.value,
//                               value: settingScreenController
//                                   .batteryPercentageAlerSlider.value,
//                               // onChanged: (value) {
//                               //   settingScreenController
//                               //       .batteryPercentageAlerSlider.value = value;},
//                               onChanged: (value) {
//                                 settingScreenController
//                                     .batteryPercentageAlerSlider.value = value;
//                                 // Update the battery level based on the slider value
//                                 controller.updateBatteryLevelFromSlider(value);
//                               },

//                               min: 0.0,
//                               max: 100.0,
//                               activeColor: AppColors.blue,
//                               inactiveColor: AppColors.grey.withOpacity(0.2),
//                             ),
//                           ),
//                         ),
//                         Obx(() => Text(
//                               // "20%",
//                               '${controller.batteryLevel.value}%',
//                               style: Styles.interRegular(
//                                 color: AppColors.blackText,
//                                 size: 14.sp,
//                               ),
//                             ))
//                       ],
//                     ),
//                   ),
//                   Padding(
//                     padding:
//                         EdgeInsets.symmetric(horizontal: 16.sp, vertical: 0),
//                     child: Divider(
//                       color: AppColors.grey.withOpacity(0.1),
//                       height: 0.0,
//                     ),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.only(
//                       left: 10.w,
//                       right: 10.w,
//                       top: 18.h,
//                     ),
//                     child: Text(
//                       "Data Tracking",
//                       style: Styles.interBold(
//                         color: AppColors.black,
//                         size: 16.sp,
//                       ),
//                     ),
//                   ),
//                   ListTile(
//                     visualDensity: const VisualDensity(vertical: -4),
//                     contentPadding: EdgeInsets.fromLTRB(12.w, 2, 12.w, 0),
//                     title: Text(
//                       "Allow power monitoring",
//                       style: Styles.interRegular(
//                         color: AppColors.black,
//                         size: 14.sp,
//                       ),
//                     ),
//                     subtitle: Padding(
//                       padding: EdgeInsets.only(top: 3.h, bottom: 2.h),
//                       child: Text(
//                         "Send battery and charge data to Aircharge",
//                         style: Styles.interRegular(
//                           color: AppColors.settingScreenSubTitleColor,
//                           size: 11.sp,
//                         ),
//                       ),
//                     ),
//                     trailing: Obx(
//                       () => SizedBox(
//                         height: 46.h,
//                         width: 46.w,
//                         child: FittedBox(
//                           fit: BoxFit.contain,
//                           child: CupertinoSwitch(
//                             value: controller.allowPowerMonitoring.value,
//                             onChanged: (bool value) {
//                               controller.allowPowerMonitoring.value = value;
//                             },
//                             activeColor: AppColors.settingScreenSwitchOnColor,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.symmetric(
//                       horizontal: 12.w,
//                     ),
//                     child: Divider(
//                       color: AppColors.grey.withOpacity(0.1),
//                       height: 1.8,
//                     ),
//                   ),
//                   ListTile(
//                     visualDensity: const VisualDensity(vertical: -4),
//                     contentPadding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 0),
//                     title: Text(
//                       "Allow location tracking",
//                       style: Styles.interRegular(
//                         color: AppColors.black,
//                         size: 14.sp,
//                       ),
//                     ),
//                     subtitle: Padding(
//                       padding: EdgeInsets.only(top: 2.h, bottom: 2.h),
//                       child: Text(
//                         "Used to show nearby chargers",
//                         style: Styles.interRegular(
//                           color: AppColors.settingScreenSubTitleColor,
//                           size: 11.sp,
//                         ),
//                       ),
//                     ),
//                     trailing: Obx(
//                       () => SizedBox(
//                         height: 46.h,
//                         width: 46.w,
//                         child: FittedBox(
//                           fit: BoxFit.contain,
//                           child: CupertinoSwitch(
//                             value: controller.allowloctiontracking.value,
//                             onChanged: (bool value) {
//                               controller.allowloctiontracking.value = value;
//                             },
//                             activeColor: AppColors.settingScreenSwitchOnColor,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 12.w),
//                     child: Divider(
//                       color: AppColors.grey.withOpacity(0.1),
//                       height: 0.0,
//                     ),
//                   ),
//                   // SizedBox(height: Get.height / 15.h),
//                 ],
//               ),
//             ),
//             GestureDetector(
//                 onLongPress: () {
//                   Timer(const Duration(seconds: 3), () {
//                     controller.startMarkerMode();
//                     controller.findChargesScreenController
//                         .getFindChargesListLoctionsList(
//                             latitude: controller.locationController.userLocation
//                                     .value?.latitude ??
//                                 0.0,
//                             longitude: controller.locationController
//                                     .userLocation.value?.longitude ??
//                                 0.0,
//                             showMarkerMode: 1);
//                   });
//                 },
//                 onLongPressEnd: (details) {
//                   controller.isLongPressStarted.value = false;

//                   controller.longPressTimer?.cancel();
//                 },
//                 child: Text(
//                   'Show Marker Mode',
//                   style: Styles.interBold(
//                       size: 14.sp,
//                       // color: controller.isMarkerModeOn.value
//                       //     ? AppColors.black
//                       //     : AppColors.settingScreenSwitchOffColor,
//                       color: AppColors.settingScreenSwitchOffColor),
//                   textAlign: TextAlign.center,
//                 )),
//             SizedBox(
//               height: 16.h,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
