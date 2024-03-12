// ignore_for_file: deprecated_member_use

import 'package:aircharge/app/core/service/loctions_controller.dart';
import 'package:aircharge/app/core/theme/colors.dart';
import 'package:aircharge/app/data/models/error_model.dart';
import 'package:aircharge/app/data/network/api_controller.dart';
import 'package:aircharge/app/data/repostorys/api_repostory.dart';
// ignore: library_prefixes
import 'package:aircharge/app/data/response_dto/multiple_offerscard_response.dart'
    as multipleOffers;
import 'package:aircharge/app/data/response_dto/offerscard_response.dart';
import 'package:aircharge/app/data/response_dto/single_offerscard_response.dart'
    as singleOffers;
import 'package:aircharge/app/data/response_dto/sponsers_response.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeController extends GetxController with GetTickerProviderStateMixin {
  late ApiRepostory _apiRepostory;
  final LocationController locationController = Get.find<LocationController>();
  @override
  void onInit() {
    _apiRepostory = ApiRepostory(apiControllerV1: Get.find<ApiControllerV1>());
    super.onInit();
    getSponserCard();
    update(["dot"]);
    scrollController.addListener(_onScroll);
    // final LocationController locationController =
    //     Get.find<LocationController>();

    // scrollController.addListener(_onScroll);
    getOfferCard(
        // latitude: 30.710489,
        // latitude: locationController.latitude.value,
        latitude: locationController.latitude.value ?? 0.0,
        // longitude: locationController.longitude.value,
        // longitude: 76.852386,
        longitude: locationController.longitude.value ?? 0.0,
        pageNumber: pageSize
        // showMarkerMode: 1,
        );
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    animationControllerMultipleOffers = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    animationControllerMSOfferScreen = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    update(["visiblePage"]);
    update(["MultipleOfeervisiblePage"]);
    update(["MSvisiblePage"]);
  }

  @override
  void dispose() {
    animationController.dispose();
    animationControllerMultipleOffers.dispose();
    animationControllerMSOfferScreen.dispose();
    super.dispose();
  }

  ///Call DashbordScreen
  void homeResetState() {
    isVisibleOfferScreen = true;
    isOpenedOfferScreen.value = false;
    update(["visiblePage"]);
    isVisibleMultipleOffers = true;
    isOpenedMultipleOffers.value = false;
    update(['MultipleOfeervisiblePage']);
  }

  /// CarouselSlider
  var currentPage = 0.obs;

  void onPageChanged(int index, CarouselPageChangedReason changeReason) {
    currentPage.value = index;
  }

  RxBool isOpen = false.obs;
  Widget buildDotIndicator(int currentPage) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(sponserCard.sponsors?.length ?? 0, (index) {
        return Container(
          width: 10.0.w,
          height: 10.0.h,
          margin: const EdgeInsets.symmetric(horizontal: 5.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: currentPage == index ? AppColors.black : AppColors.grey,
          ),
        );
      }),
    );
  }

  ///Offers
  final _isVisibleOfferScreen = true.obs;
  bool get isVisibleOfferScreen => _isVisibleOfferScreen.value;
  set isVisibleOfferScreen(bool value) => _isVisibleOfferScreen.value = value;

  RxBool isOpenedOfferScreen = false.obs;

  late final AnimationController animationController;

  ///Multiple Offers
  final _isVisibleMultipleOffers = true.obs;
  bool get isVisibleMultipleOffers => _isVisibleMultipleOffers.value;
  set isVisibleMultipleOffers(bool value) =>
      _isVisibleMultipleOffers.value = value;

  late final AnimationController animationControllerMultipleOffers;

  RxBool isOpenedMultipleOffers = false.obs;

  ///Ms Offers

  final _isVisibleMSOfferScreen = true.obs;
  bool get isVisibleMSOfferScreen => _isVisibleMSOfferScreen.value;
  set isVisibleMSOfferScreen(bool value) =>
      _isVisibleMSOfferScreen.value = value;

  RxBool isOpenedMSOfferScreen = false.obs;

  late final AnimationController animationControllerMSOfferScreen;

//=====================================URL Link Function==================================
  void openSponsersLink(String link) async {
    if (await canLaunch(link)) {
      await launch(link);
    } else {
      throw 'Could not launch $link';
    }
  }

  void openSingleOffferCardBtnLink(String link) async {
    if (await canLaunch(link)) {
      await launch(link);
    } else {
      throw 'Could not launch $link';
    }
  }

  //=====================================API==========================================
  //++++++++++++++++++++++++++++++++++++ 1 Page ++++++++++++++++++++++++++++++++++++++
  ///sponserCard

  final _sponserCard = SponsersResponceDto().obs;
  SponsersResponceDto get sponserCard => _sponserCard.value;
  set sponserCard(SponsersResponceDto value) => _sponserCard.value = value;

  Future<void> getSponserCard() async {
    try {
      sponserCard = await _apiRepostory.sponsersCard();
    } on ErrorResponse catch (e) {
      Get.back();
      debugPrint(e.toString());

      Logger().d(e.error?.detail ?? '');
    } catch (e) {
      Get.back();
      Logger().d(e);
    }
  }

  ///offerCard

  final _offerCard = OfferCardResponceDto().obs;
  OfferCardResponceDto get offerCard => _offerCard.value;
  set offerCard(OfferCardResponceDto value) => _offerCard.value = value;
  var isLoadingOffers = true.obs;

  int pageSize = 0;
  bool hasMorePages = true;
  List offersScroll = <Offer>[].obs;
  final ScrollController scrollController = ScrollController();

  Future<void> getOfferCard({
    required double latitude,
    required double longitude,
    required int pageNumber,
    // required int pageNumber,
  }) async {
    try {
      isLoadingOffers.value = true;
      offerCard = await _apiRepostory.offerCardList(
        latitude,
        longitude,
        pageNumber,
      );
      offersScroll.addAll(offerCard.offers!);
      isLoadingOffers.value = false;
    } on ErrorResponse catch (e) {
      Get.back();
      debugPrint(e.toString());

      Logger().d(e.error?.detail ?? '');
      isLoadingOffers.value = false;
    } catch (e) {
      Get.back();
      Logger().d(e);
      isLoadingOffers.value = false;
    }
  }

  // Function to load more data when scrolling reaches the end
  void loadMoreData() {
    pageSize++;
    // int page = pageSize + pageSize++;
    getOfferCard(
      latitude: locationController.latitude.value ?? 0.0,
      longitude: locationController.longitude.value ?? 0.0,
      pageNumber: pageSize,
      // showMarkerMode: 0,
    );
  }

  void _onScroll() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      // Reach the end of the list, load more data
      loadMoreData();
    }
  }

// ++++++++++++++++++++++++++++++++++++ 2 Page ++++++++++++++++++++++++++++++++++++++++

  ///Single offerCard
  final _singleOfferCard = singleOffers.SingleOfferCardResponceDto().obs;
  singleOffers.SingleOfferCardResponceDto get singleOfferCard =>
      _singleOfferCard.value;
  set singleOfferCard(singleOffers.SingleOfferCardResponceDto value) =>
      _singleOfferCard.value = value;

  var isLoadingSingleOffer = true.obs;

  Future<void> getSingleOfferCard({
    required int id,
  }) async {
    try {
      isLoadingSingleOffer.value = true;
      singleOfferCard = await _apiRepostory.singleOfferCardList(
        id,
      );
      isLoadingSingleOffer.value = false;
    } on ErrorResponse catch (e) {
      Get.back();
      debugPrint(e.toString());

      Logger().d(e.error?.detail ?? '');

      isLoadingSingleOffer.value = false;
    } catch (e) {
      Get.back();
      Logger().d(e);
      isLoadingSingleOffer.value = false;
    }
  }

  ///Animation

  void singleOfferAnimation() {
    isVisibleOfferScreen = false;
    // isOpenedOfferScreen.value = !isOpenedOfferScreen.value;
    isOpenedOfferScreen.value = true;
    if (isOpenedOfferScreen.value) {
      animationController.forward();
    } else {
      animationController.reverse();
    }
    update(["visiblePage"]);
  }

  ///Multiple OfferCard

  final _multipleOfferCard = multipleOffers.MultipleOfferCardResponceDto().obs;
  multipleOffers.MultipleOfferCardResponceDto get multipleOfferCard =>
      _multipleOfferCard.value;
  set multipleOfferCard(multipleOffers.MultipleOfferCardResponceDto value) =>
      _multipleOfferCard.value = value;

  Future<void> getMultipleOfferCard({
    required int id,
  }) async {
    try {
      multipleOfferCard = await _apiRepostory.multipleOfferCardList(
        id,
      );
    } on ErrorResponse catch (e) {
      Get.back();
      debugPrint(e.toString());

      Logger().d(e.error?.detail ?? '');
    } catch (e) {
      Get.back();
      Logger().d(e);
    }
  }

  ///Animation
  void multiOfferAnimation() {
    isVisibleMultipleOffers = false;

    isOpenedMultipleOffers.value = true;
    if (isOpenedMultipleOffers.value) {
      animationControllerMultipleOffers.forward();
    } else {
      animationControllerMultipleOffers.reverse();
    }
    update(["MultipleOfeervisiblePage"]);
  }
}
