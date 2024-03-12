import 'dart:async';
import 'package:aircharge/app/modules/dashborad_scareen/views/dashborad_scareen_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScareenController extends GetxController
    with GetSingleTickerProviderStateMixin {
  // Text offset animation controller
  late final AnimationController textController;
  late Animation<double> textAnimation;
  final textOpacity = 0.0.obs;
  // Reactive variable for text offset
  var textOffset = 0.0.obs;
  @override
  void onInit() {
    super.onInit();

    textController = AnimationController(
      duration: const Duration(milliseconds: 467),
      vsync: this,
    );
    _animateText();
    // _startTextAnimation();
    // Timer(const Duration(seconds: 2), () {
    //   Get.offAll(
    //     const DashboradScareenView(),
    //   );
    // });
  }

  _animateText() async {
    // Timer(const Duration(seconds: 2),(){
       Future.delayed(
        Duration(milliseconds: 500)); // Delay for initial splash screen view
    textOpacity.value = 1.0; 
    Timer(const Duration(seconds: 2), () {
      Get.offAll(
        const DashboradScareenView(),
      );
    });
    // });
    // Trigger fade-in animation
  }

  void _startTextAnimation() {
    textController.forward();

    textController.addListener(() {
      textOffset.value = Tween<double>(
        begin: 200.0,
        end: -10.0,
      ).animate(textController).value;
    });
  }

  // void _startTextAnimation() {
  //   textAnimation = Tween<double>(
  //     begin: 200.0,
  //     end: -10.0,
  //   ).animate(CurvedAnimation(
  //     parent: textController,
  //     curve: Curves.bounceInOut, // Adjust the curve as needed
  //   ));

  //   textController.forward();
  // }

  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }
}
