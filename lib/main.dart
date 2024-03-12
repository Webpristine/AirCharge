import 'dart:async';
import 'dart:ui';

import 'package:aircharge/app/core/service/loctions_controller.dart';
import 'package:aircharge/app/core/utils/device_info_util.dart';
import 'package:aircharge/app/data/network/api_controller.dart';
import 'package:aircharge/app/data/repostorys/api_repostory.dart';
import 'package:aircharge/app/data/request_dto/battery-percentage_request.dart';
import 'package:aircharge/app/modules/find_charges_screen/controllers/find_charges_screen_controller.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'app/routes/app_pages.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await initializeService();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  DeviceInfoUtil();
  // await initializeFCM();
  runApp(
    ScreenUtilInit(
        designSize: const Size(372, 812),
        splitScreenMode: false,
        builder: (BuildContext context, Widget? xyz) {
          return GetMaterialApp(
            onInit: () {
              Get.put<LocationController>(LocationController());
              Get.put(ApiControllerV1());
            },
            debugShowCheckedModeBanner: false,
            title: "Application",
            initialRoute: AppPages.INITIAL,
            getPages: AppPages.routes,
            theme: ThemeData(
              fontFamily: "Inter",
            ),
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(textScaler: const TextScaler.linear(1.0)),
                child: child!,
              );
            },
          );
        }),
  );
}

// // this will be used as notification channel id
// const notificationChannelId = 'my_foreground';

// // this will be used for notification id, So you can update your custom notification with this id.
// const notificationId = 888;
// Future<void> initializeService() async {
//   final service = FlutterBackgroundService();

//   const AndroidNotificationChannel channel = AndroidNotificationChannel(
//     notificationChannelId, // id
//     'MY FOREGROUND SERVICE', // title
//     description:
//         'This channel is used for important notifications.', // description
//     importance: Importance.low, // importance must be at low or higher level
//   );

//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   await flutterLocalNotificationsPlugin
//       .resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin>()
//       ?.createNotificationChannel(channel);

//   await service
//       .configure(
//     iosConfiguration: IosConfiguration(),
//     androidConfiguration: AndroidConfiguration(
//       // this will be executed when app is in foreground or background in separated isolate
//       onStart: onStart,

//       // auto start service
//       autoStart: true,
//       isForegroundMode: true,

//       notificationChannelId:
//           notificationChannelId, // this must match with notification channel you created above.
//       initialNotificationTitle: 'AWESOME SERVICE',
//       initialNotificationContent: 'Initializing',
//       foregroundServiceNotificationId: notificationId,
//     ),
//   )
//       .catchError((error, stackTrace) {
//     print("Error is $error");
//   });
// }

// Future<void> onStart(ServiceInstance service) async {
//   // Only available for flutter 3.0.0 and later
//   DartPluginRegistrant.ensureInitialized();

//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//   final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();

//   ApiRepostory _apiRepostory = ApiRepostory(
//     apiControllerV1: Get.put(
//       ApiControllerV1(),
//     ),
//   );
//   Battery battery = Battery();

//   // bring to foreground
//   Timer.periodic(const Duration(minutes: 1), (timer) async {
//     final level = await battery.batteryLevel;

//     await _apiRepostory.battery(
//         requestDTO: BatteryPercentageRequestDto(
//             deviceId:
//                 await _deviceInfoPlugin.androidInfo.then((value) => value.id),
//             latitude: "22.243680372191744",
//             longitude: '73.19719293376608',
//             batteryPercentage: level.toString(),
//             wifi: "on"));
//     // if (await service.isForegroundService()) {
//     flutterLocalNotificationsPlugin.show(
//       notificationId,
//       'COOL SERVICE',
//       'Battery Level is $level',
//       const NotificationDetails(
//         android: AndroidNotificationDetails(
//           notificationChannelId,
//           'MY FOREGROUND SERVICE',
//           icon: 'ic_bg_service_small',
//           ongoing: true,
//         ),
//       ),
//     );
//     //   }
//   });
// }
