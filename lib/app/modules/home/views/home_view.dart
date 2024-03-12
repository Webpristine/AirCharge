// ignore_for_file: unnecessary_null_comparison

import 'package:aircharge/app/core/theme/colors.dart';
import 'package:aircharge/app/core/theme/styles.dart';
import 'package:aircharge/app/modules/home/views/multiple_offer_details.dart';
import 'package:aircharge/app/modules/home/views/single_offer_details.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

GlobalKey<ScaffoldState> homeScffoldKey = GlobalKey<ScaffoldState>();

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(
      HomeController(),
    );

    return PopScope(
      onPopInvoked: (value) {
        debugPrint('>>> [DEBUG] onPopInvoked:  $value');
      },
      child: Scaffold(
        key: homeScffoldKey,
        backgroundColor: AppColors.white,
        body: const ContentWidget(),
      ),
    );
  }
}

class ContentWidget extends GetView<HomeController> {
  const ContentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 84.h,
          child: Container(
            height: Get.height,
            width: Get.width,
            color: AppColors.bgGreyColor,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 12.w,
          ),
          // child: Obx(
          //   () => Visibility(
          //     visible: controller.isVisibleOfferScreen &&
          //         controller.isVisibleMultipleOffers,
          //     replacement: Container(
          //         child: controller.isVisibleOfferScreen
          //             ? const MultipleOffers()
          //             : const OfferDetails()),
          child: Column(
            children: [
              Card(
                color: AppColors.offerBgWhiteColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.sp),
                ),
                borderOnForeground: false,
                // elevation: 3.sp,
                margin: EdgeInsets.symmetric(
                  horizontal: 4.0.w,
                ),
                child: Container(
                  height: 50.h,
                  width: Get.width,
                  decoration: BoxDecoration(
                    color: AppColors.offerBgWhiteColor,
                    borderRadius: BorderRadius.circular(6.sp),
                  ),
                  child: Center(
                    child: Text(
                      'Offers',
                      style: Styles.interBold(
                          size: 16.sp, color: AppColors.blackText),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 7.h),
              Card(
                color: AppColors.offerBgWhiteColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.sp),
                ),
                borderOnForeground: false,
                // elevation: 3.sp,
                margin: EdgeInsets.symmetric(
                  horizontal: 4.0.w,
                ),
                child: Container(
                  height: 50.h,
                  width: Get.width,
                  decoration: BoxDecoration(
                    color: AppColors.offerBgWhiteColor,
                    borderRadius: BorderRadius.circular(6.sp),
                  ),
                  child: Center(
                    child: Text(
                      'All locations shown in the list below have wireless chargers installed on the premises.',
                      textAlign: TextAlign.center,
                      style: Styles.interRegular(
                          size: 11.sp, color: AppColors.grey),
                    ),
                  ),
                ),
              ),
              // SizedBox(
              //   height: 6.sp,
              // ),
              // Text(
              //   'Browse Nearby Offers',
              //   style: Styles.interBold(
              //     color: AppColors.blackText,
              //     size: 14.sp,
              //   ),
              // ),
              // Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 30.sp, vertical: 2.sp),
              //   child: Text(
              //     "All locations shown in the list below, have wireless chargers installed on the premises.",
              //     textAlign: TextAlign.center,
              //     style: Styles.interRegular(
              //       color: AppColors.grey,
              //       size: 10.sp,
              //     ),
              //     maxLines: 2,
              //   ),
              // ),
              // SizedBox(
              //   height: 10.h,
              // ),
              Expanded(
                child: Obx(
                  () => Visibility(
                    visible: controller.isVisibleOfferScreen &&
                        controller.isVisibleMultipleOffers &&
                        controller.isVisibleMSOfferScreen,
                    // replacement: SizedBox(
                    //   height: Get.height,
                    //   width: Get.width,
                    // ),
                    child: ListView(
                      physics: const SlowScrollPhysics(),
                      padding: EdgeInsets.only(top: 18.h, bottom: 86.h),
                      children: [
                        CarouselSlider.builder(
                          itemCount:
                              controller.sponserCard.sponsors?.length ?? 0,
                          // itemCount: controller.itemsDemo.length,
                          options: CarouselOptions(
                            aspectRatio: 2.8,
                            onPageChanged: controller.onPageChanged,
                            viewportFraction: 1.0,
                            autoPlay: true,
                          ),
                          itemBuilder: (
                            context,
                            index,
                            realIdx,
                          ) {
                            // final url = index.isEven
                            //     ? "https://www.air-charge.com/shop/wireless-chargers"
                            //     : "https://www.air-charge.com/products/business-solutions";

                            return Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 4.w,
                              ),
                              child: GestureDetector(
                                onTap: () async {
                                  controller.openSponsersLink(controller
                                          .sponserCard
                                          .sponsors?[index]
                                          .linkUrl ??
                                      "");
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.sp),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.sp),
                                    ),
                                    child: Image.network(
//                                     // controller.itemsDemo[index],
                                      controller.sponserCard.sponsors?[index]
                                              .imageUrl ??
                                          "",
                                      fit: BoxFit.cover,
                                      width: Get.width,
                                    ),
                                    // child: CachedNetworkImage(
                                    //   // controller.itemsDemo[index],
                                    //   imageUrl: controller.sponserCard
                                    //           .sponsors?[index].imageUrl ??
                                    //       "",

                                    //   fit: BoxFit.cover,
                                    //   width: Get.width,
                                    //   errorWidget: (context, url, error) =>
                                    //       Container(
                                    //     height: 100,
                                    //     width: 100,
                                    //     color: Colors.red,
                                    //     child: Text("$url===>$error"),
                                    //   ),
                                    // ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 4.h),
                        Obx(
                          () => controller
                              .buildDotIndicator(controller.currentPage.value),
                        ),
                        SizedBox(height: 20.h),
                        Center(
                          child: Text(
                            'Browse Nearby Offers',
                            style: Styles.interBold(
                                size: 16.sp, color: AppColors.blackText),
                          ),
                        ),
                        Obx(() {
                          if (controller.isLoadingOffers.value &&
                              controller.offersScroll.isEmpty) {
                            return const Center(
                                child: CircularProgressIndicator(
                              color: AppColors.black,
                            ));
                          } else {
                            return NotificationListener<ScrollNotification>(
                                onNotification: (scrollNotification) {
                                  if (scrollNotification
                                          is ScrollEndNotification &&
                                      controller.scrollController.position
                                              .extentAfter ==
                                          0) {
                                    controller.getOfferCard(
                                      latitude: controller.locationController
                                              .latitude.value ??
                                          0.0,
                                      longitude: controller.locationController
                                              .longitude.value ??
                                          0.0,
                                      pageNumber: controller.pageSize,
                                    );
                                  }

                                  return false;
                                },
                                child: ListView.builder(
                                    controller: controller.scrollController,
                                    // : (context, index) =>
                                    //     SizedBox(height: 14.sp),
                                    // controller: controller.scrollController,
                                    padding: EdgeInsets.only(
                                      top: 3.sp,
                                    ),
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    // itemCount: offers.length,
                                    // itemCount: controller.offerCard.offers?.length ?? 0,
                                    itemCount: controller.isLoadingOffers.value
                                        ? 1 // Display a single item for loading indicator
                                        : controller.offerCard.offers?.length ??
                                            0,
                                    itemBuilder: (context, index) {
                                      // return controller.isLoadingOffers.value
                                      //     ? SizedBox(
                                      //         height: MediaQuery.of(context).size.height /
                                      //             2.5,
                                      //         child: const Center(
                                      //           child: CircularProgressIndicator(
                                      //             color: AppColors.black,
                                      //           ),
                                      //         ),
                                      //       )
                                      //     : controller.offerCard.offers!.isEmpty
                                      //         ? const Text('No data available')
                                      //         : GetBuilder<HomeController>(
                                      //             id: "visible",
                                      //             builder: (cont) => InkWell(
                                      //               onTap: () async {
                                      //                 if (controller
                                      //                         .offerCard
                                      //                         .offers?[index]
                                      //                         .isMultiple ==
                                      //                     1) {
                                      //                   await controller
                                      //                       .getSingleOfferCard(
                                      //                           id: controller
                                      //                                   .offerCard
                                      //                                   .offers?[index]
                                      //                                   .offerId ??
                                      //                               0);
                                      //                   controller.singleOffer();

                                      //                 } else {
                                      //                   await controller
                                      //                       .getMultipleOfferCard(
                                      //                           id: controller
                                      //                                   .offerCard
                                      //                                   .offers?[index]
                                      //                                   .brandId ??
                                      //                               0);
                                      //                   controller.multiOffer();
                                      //                 }
                                      //               },
                                      //               child: ClipRRect(
                                      //                 borderRadius:
                                      //                     BorderRadius.circular(8.sp),
                                      //                 child: Card(
                                      //                   shape: RoundedRectangleBorder(
                                      //                     borderRadius:
                                      //                         BorderRadius.circular(8.sp),
                                      //                   ),
                                      //                   // elevation: 3,
                                      //                   child: Container(
                                      //                     decoration: BoxDecoration(
                                      //                         borderRadius:
                                      //                             BorderRadius.circular(
                                      //                           8.0.sp,
                                      //                         ),
                                      //                         color: AppColors.white),
                                      //                     width: Get.width,
                                      //                     child: Column(
                                      //                       crossAxisAlignment:
                                      //                           CrossAxisAlignment.start,
                                      //                       children: [
                                      //                         Container(
                                      //                           decoration: BoxDecoration(
                                      //                             borderRadius:
                                      //                                 BorderRadius.only(
                                      //                               topLeft:
                                      //                                   Radius.circular(
                                      //                                       8.0.sp),
                                      //                               topRight:
                                      //                                   Radius.circular(
                                      //                                       8.0.sp),
                                      //                             ),
                                      //                             image: DecorationImage(
                                      //                                 image: NetworkImage(
                                      //                                   // "${offers[index]['image']}"
                                      //                                   controller
                                      //                                           .offerCard
                                      //                                           .offers?[
                                      //                                               index]
                                      //                                           .offerImage ??
                                      //                                       "",
                                      //                                 ),
                                      //                                 fit: BoxFit.fill),
                                      //                           ),
                                      //                           height: 210.h,
                                      //                           width: Get.width,
                                      //                         ),
                                      //                         Padding(
                                      //                           padding: EdgeInsets.only(
                                      //                               left: 10.w,
                                      //                               bottom: 14.h,
                                      //                               top: 2.h),
                                      //                           child: Text(
                                      //                             // "${offers[index]['title']}",
                                      //                             controller
                                      //                                     .offerCard
                                      //                                     .offers?[index]
                                      //                                     .friendlyName ??
                                      //                                 "",
                                      //                             style: Styles.interBold(
                                      //                               color:
                                      //                                   AppColors.black,
                                      //                               size: 12.sp,
                                      //                             ),
                                      //                           ),
                                      //                         ),
                                      //                         Padding(
                                      //                           padding: EdgeInsets.only(
                                      //                               left: 10.w,
                                      //                               bottom: 14.h),
                                      //                           child: Text(
                                      //                             // "${offers[index]['subtitle']}",
                                      //                             controller
                                      //                                     .offerCard
                                      //                                     .offers?[index]
                                      //                                     .headerText ??
                                      //                                 "",
                                      //                             style:
                                      //                                 Styles.interRegular(
                                      //                               color:
                                      //                                   AppColors.black,
                                      //                               size: 12.sp,
                                      //                             ),
                                      //                           ),
                                      //                         ),
                                      //                       ],
                                      //                     ),
                                      //                   ),
                                      //                 ),
                                      //               ),
                                      //             ),
                                      //           );
                                      if (index ==
                                          controller.offersScroll.length) {
                                        return const Center(
                                          child: CircularProgressIndicator(
                                            color: AppColors.black,
                                          ),
                                        );
                                      } else {
                                        var offer =
                                            controller.offersScroll[index];

                                        return GetBuilder<HomeController>(
                                          id: "visible",
                                          builder: (cont) => InkWell(
                                            onTap: () async {
                                              if (controller
                                                      .offerCard
                                                      .offers?[index]
                                                      .isMultiple ==
                                                  1) {
                                                await controller
                                                    .getSingleOfferCard(
                                                        id: controller
                                                                .offerCard
                                                                .offers?[index]
                                                                .offerId ??
                                                            0);
                                                controller
                                                    .singleOfferAnimation();
                                              } else {
                                                await controller
                                                    .getMultipleOfferCard(
                                                        id: controller
                                                                .offerCard
                                                                .offers?[index]
                                                                .brandId ??
                                                            0);
                                                controller
                                                    .multiOfferAnimation();
                                              }
                                            },
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8.sp),
                                              child: Card(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.sp),
                                                ),
                                                // elevation: 3,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        8.0.sp,
                                                      ),
                                                      color: AppColors.white),
                                                  width: Get.width,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    8.0.sp),
                                                            topRight:
                                                                Radius.circular(
                                                                    8.0.sp),
                                                          ),
                                                          image: DecorationImage(
                                                              image: NetworkImage(
                                                                // "${offers[index]['image']}"
                                                                controller
                                                                        .offerCard
                                                                        .offers?[
                                                                            index]
                                                                        .offerImage ??
                                                                    "",
                                                              ),
                                                              fit: BoxFit.fill),
                                                        ),
                                                        height: 210.h,
                                                        width: Get.width,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 10.w,
                                                                bottom: 14.h,
                                                                top: 2.h),
                                                        child: Text(
                                                          // "${offers[index]['title']}",
                                                          controller
                                                                  .offerCard
                                                                  .offers?[
                                                                      index]
                                                                  .friendlyName ??
                                                              "",
                                                          style:
                                                              Styles.interBold(
                                                            color:
                                                                AppColors.black,
                                                            size: 12.sp,
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 10.w,
                                                                bottom: 14.h),
                                                        child: Text(
                                                          // "${offers[index]['subtitle']}",
                                                          controller
                                                                  .offerCard
                                                                  .offers?[
                                                                      index]
                                                                  .headerText ??
                                                              "",
                                                          style: Styles
                                                              .interRegular(
                                                            color:
                                                                AppColors.black,
                                                            size: 12.sp,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                    }));
                          }
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        GetBuilder<HomeController>(
          id: "visiblePage",
          builder: (cont) => AnimatedPositioned(
            curve: Curves.easeInOut,
            top: 0,
            bottom: 0,
            right: 2,
            left: controller.isOpenedOfferScreen.value ? 2 : Get.width,
            duration: const Duration(milliseconds: 300),
            // child: const SingleOfferDetails(),
            child: controller.isLoadingSingleOffer.value
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.black,
                    ),
                  ) // Show loading indicator
                : controller.singleOfferCard == null
                    ? const Center(
                        child: Text('No Data Found'),
                      ) // Show "No Data Found" message
                    : const SingleOfferDetails(),
          ),
        ),
        GetBuilder<HomeController>(
          id: "MultipleOfeervisiblePage",
          builder: (cont) => AnimatedPositioned(
            curve: Curves.easeInOut,
            top: 0,
            bottom: 0,
            right: 2,
            left: controller.isOpenedMultipleOffers.value ? 2 : Get.width,
            duration: const Duration(milliseconds: 300),
            child: const MultipleOffers(),
          ),
        ),
        GetBuilder<HomeController>(
          id: "visiblePage",
          builder: (cont) => AnimatedPositioned(
            curve: Curves.easeInOut,
            top: 0,
            bottom: 0,
            right: 2,
            left: controller.isOpenedOfferScreen.value ? 2 : Get.width,
            duration: const Duration(milliseconds: 300),
            child: const SingleOfferDetails(),
          ),
        ),
        // GetBuilder<HomeController>(
        //   id: "visiblePage",
        //   builder: (cont) => AnimatedPositioned(
        //     curve: Curves.easeInOut,
        //     top: 0,
        //     bottom: 0,
        //     right: 2,
        //     left: controller.isOpenedMSOfferScreen.value ? 2 : Get.width,
        //     duration: const Duration(milliseconds: 300),
        //     child: const MsOfferDetails(),
        //   ),
        // ),
      ],
    );
  }
}

class SlowScrollPhysics extends ScrollPhysics {
  const SlowScrollPhysics({ScrollPhysics? parent}) : super(parent: parent);

  @override
  ScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return SlowScrollPhysics(
      parent: buildParent(ancestor),
    );
  }

  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    // Adjust the scroll offset to slow down the scrolling
    return super.applyPhysicsToUserOffset(position, offset * 0.9);
  }
}
