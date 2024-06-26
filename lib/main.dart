import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:aircharge/app/core/service/loctions_controller.dart';
import 'package:aircharge/app/core/utils/device_info_util.dart';
import 'package:aircharge/app/data/network/api_controller.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/rendering.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_background_service_ios/flutter_background_service_ios.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app/routes/app_pages.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

const notificationChannelId = 'my_foreground';
SharedPreferences? prefs;
Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'my_foreground', // id
    'MY FOREGROUND SERVICE', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.low, // importance must be at low or higher level
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  if (Platform.isIOS || Platform.isAndroid) {
    await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        iOS: DarwinInitializationSettings(),
        android: AndroidInitializationSettings('ic_bg_service_small'),
      ),
    );
  }

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      // this will be executed when app is in foreground or background in separated isolate
      onStart: onStart,

      // auto start service
      autoStart: true,
      isForegroundMode: true,

      notificationChannelId: 'my_foreground',
      initialNotificationTitle: 'AWESOME SERVICE',
      initialNotificationContent: 'Initializing',
      foregroundServiceNotificationId: 888,
    ),
    iosConfiguration: IosConfiguration(
      // auto start service
      autoStart: true,

      // this will be executed when app is in foreground in separated isolate
      onForeground: onStart,

      // you have to enable background fetch capability on xcode project
      onBackground: onIosBackground,
    ),
  );
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  // bring to foreground
  Timer.periodic(const Duration(seconds: 10), (timer) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Battery battery = Battery();
    var battterylavel = await battery.batteryLevel;
    battery.onBatteryStateChanged.listen((BatteryState state) {
      // Do something with new state
      if (kDebugMode) {
        print("Battery Status is${state.name} $battterylavel");
      }
    });
    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {
        /// OPTIONAL for use custom notification
        if (prefs.getBool("lowpower")!) {
          // 99 is Stored <= 98 battery Lavel
          if (battterylavel <= prefs.getInt("battey")!) {
            flutterLocalNotificationsPlugin.show(
              888,
              'Air Charge',
              'Low Power Notification',
              const NotificationDetails(
                android: AndroidNotificationDetails(
                  'my_foreground',
                  'MY FOREGROUND SERVICE',
                  icon: 'ic_bg_service_small',
                  ongoing: true,
                ),
              ),
            );
          }
        }

        // if you don't using custom notification, uncomment this
        // service.setForegroundNotificationInfo(
        //   title: "Air Charge",
        //   content: "Your Current Battery Level is ${"battterylavel"}",
        // );
      }
    } else if (service is IOSServiceInstance) {
      if (prefs.getBool("lowpower")!) {
        if (battterylavel <= prefs.getInt("battey")!) {
          flutterLocalNotificationsPlugin.show(
            888,
            'Air Charge',
            'Low Power Notification',
            const NotificationDetails(
              android: AndroidNotificationDetails(
                'my_foreground',
                'MY FOREGROUND SERVICE',
                icon: 'ic_bg_service_small',
                ongoing: true,
              ),
            ),
          );
        }
      }
    }

    /// you can see this log in logcat
    print('FLUTTER BACKGROUND SERVICE: ${DateTime.now()}');

    // test using external plugin
    final deviceInfo = Battery();
    String? device;
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.batteryLevel;
      device = androidInfo.toString();
    }

    if (Platform.isIOS) {
      final iosInfo = await deviceInfo.batteryLevel;
      device = iosInfo.toString();
    }

    service.invoke(
      'update',
      {
        "current_date": DateTime.now().toIso8601String(),
        "device": device,
      },
    );
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  RenderErrorBox.backgroundColor = Colors.transparent;
  await initializeService();
  // Workmanager().initialize(schedulePeriodicTask);
  // schedulePeriodicTask();

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
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown,
          ]);
          return GetMaterialApp(
            useInheritedMediaQuery: true,
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
