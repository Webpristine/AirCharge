// ignore_for_file: non_constant_identifier_names, library_private_types_in_public_api
import 'package:aircharge/app/core/constants/enums.dart';
import 'package:aircharge/app/core/theme/colors.dart';
import 'package:aircharge/app/core/theme/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';

import '../controllers/splash_scareen_controller.dart';

class SplashScareenView extends GetView<SplashScareenController> {
  const SplashScareenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(SplashScareenController());
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 50.h,
            ),
            SvgPicture.asset(
              'assets/images/splash_aircharge_iconlogo.svg',
              height: 60.h,
              width: 60.h,
            ),
            SizedBox(
              height: 100.h,
            ),
            // Obx(
            //   () => Transform.translate(
            //     offset: Offset(0.0, controller.textOffset.value),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         RichText(
            //           text: TextSpan(
            //             text: 'air',
            //             style: Styles.metaRegular(
            //                 color: AppColors.black,
            //                 size: 40.sp,
            //                 font: FontFamily.meta),
            //           ),
            //         ),
            //         RichText(
            //           text: TextSpan(
            //             text: 'charge',
            //             style: Styles.metaBold(
            //                 color: AppColors.black,
            //                 size: 40.sp,
            //                 font: FontFamily.meta),
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),

            TweenAnimationBuilder(
                tween: Tween<double>(begin: 0.0, end: 1.0),
                duration: Duration(seconds: 1),
                builder: (context, value, child) {
                  return Opacity(
                    opacity: controller.textOpacity.value * value,
                    child: Transform.translate(
                      offset: Offset(0, -50 + (-50 * value)),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RichText(
                              text: TextSpan(
                                text: 'air',
                                style: Styles.metaRegular(
                                    color: AppColors.black,
                                    size: 40.sp,
                                    font: FontFamily.meta),
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                text: 'charge',
                                style: Styles.metaBold(
                                    color: AppColors.black,
                                    size: 40.sp,
                                    font: FontFamily.meta),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // child: Text(
                      //   'Your Text Here',
                      //   style: TextStyle(
                      //     fontSize: 24.0,
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      // ),
                    ),
                  );
                }),
            // ),child: SvgPicture.asset(
            //       'assets/images/splash_aircharge_textlogo.svg',
            //       height: 40.h,
            //       width: 40.h,
          ],
        ),
      ),
    );
  }
}
// class TextColorChangeDemo extends StatefulWidget {
//   const TextColorChangeDemo({super.key});

//   @override
//   _TextColorChangeDemoState createState() => _TextColorChangeDemoState();
// }

// class _TextColorChangeDemoState extends State<TextColorChangeDemo>
//     with TickerProviderStateMixin {
//   Color textColor = AppColors.white; // Initial color

//   @override
//   void initState() {
//     super.initState();
//     _startColorAnimation();
//   }

//   @override
//   dispose() {
//     controller!.dispose();
//     super.dispose();
//   }

//   late final AnimationController? controller = AnimationController(
//     duration: const Duration(seconds: 30),
//     vsync: this,
//   )..repeat();

//   void _startColorAnimation() {
//     const duration = Duration(seconds: 5);
//     const updateInterval = Duration(milliseconds: 100);

//     int steps = duration.inMilliseconds ~/ updateInterval.inMilliseconds;
//     int step = 0;

//     Timer.periodic(updateInterval, (timer) {
//       double fraction = step / steps;
//       textColor = Color.lerp(Colors.white, Colors.black, fraction)!;

//       if (step++ >= steps) {
//         timer.cancel();
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.asset(
//               'assets/images/loading.png',
//               height: 60.h,
//               width: 90.w,
//             ),
//             AnimatedBuilder(
//               animation: controller!,
//               builder: (context, child) {
//                 return Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     RichText(
//                       text: TextSpan(
//                         text: 'air',
//                         style: Styles.metaRegular(
//                             color: textColor,
//                             size: 40.sp,
//                             font: FontFamily.meta),
//                       ),
//                     ),
//                     RichText(
//                       text: TextSpan(
//                         text: 'charge',
//                         style: Styles.metaBold(
//                             color: textColor,
//                             size: 40.sp,
//                             font: FontFamily.meta),
//                       ),
//                     ),
//                   ],
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
