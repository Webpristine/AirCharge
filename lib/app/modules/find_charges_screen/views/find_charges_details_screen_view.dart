// ignore_for_file: must_be_immutable

import 'package:aircharge/app/core/theme/buttons.dart';
import 'package:aircharge/app/core/theme/colors.dart';
import 'package:aircharge/app/core/theme/styles.dart';
import 'package:aircharge/app/modules/find_charges_screen/controllers/find_charges_screen_controller.dart';
import 'package:aircharge/app/modules/setting_screen/controllers/setting_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class FindChargesDetailsScreen extends GetView<FindChargesScreenController> {
  const FindChargesDetailsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    Get.put(FindChargesScreenController());

    SettingScreenController settingScreenController =
        Get.put(SettingScreenController());
    return GetBuilder<FindChargesScreenController>(
        id: "visiblePage",
        builder: (controller) {
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.sp),
            ),
            borderOnForeground: false,
            color: AppColors.white,
            margin: EdgeInsets.only(
              bottom: Get.height * 0.126.h,
              left: 12.w,
              right: 12.w,
              top: 1.h,
            ),
            child: Container(
              decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.iconGreyColor,
                    offset: Offset(0, 0),
                  ),
                ],
                color: AppColors.white,
                borderRadius: BorderRadius.circular(10.sp),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 4.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: GestureDetector(
                              onTap: () {
                                controller.isVisible = true;
                                controller.isOpened.value = false;
                                controller.animationController.reverse();
                                controller.update(["visiblePage"]);
                              },
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  color: Colors.transparent,
                                  height: 50.h,
                                  width: 50.w,
                                  child: Icon(
                                    Icons.arrow_back_ios_new,
                                    size: 18.sp,
                                    color: AppColors.iconGreyColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              radius: 18.sp,
                              child: Image.network(
                                // "assets/images/starbuckslogo.png",
                                controller.findChargesDataDetails.location
                                        ?.brandLogo ??
                                    "",
                                fit: BoxFit.contain,
                              ),
                            ),
                            // child: CircleAvatar(
                            //   radius: 22.sp,
                            //   child: SvgPicture.asset(
                            //     'assets/images/od_logo_starbucks.svg',
                            //     fit: BoxFit.fill,
                            //   ),
                            // ),
                          ),
                          Expanded(
                            flex: 15,
                            child: Text(
                              // "Starbucks",
                              controller.findChargesDataDetails.location
                                      ?.brandName ??
                                  "",
                              style: Styles.interBold(
                                color: AppColors.blackGrey,
                                size: 16.sp,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: GetBuilder<FindChargesScreenController>(
                              id: "reportPage",
                              builder: (cont) => GestureDetector(
                                onTap: () {
                                  controller.findChargesDataDetails.location
                                          ?.locationId ??
                                      0;
                                  // controller.isVisibleReport = false;
                                  // controller.isOpenedReport.value = true;
                                  // controller.reportAnimationController
                                  //     .forward();
                                  // controller
                                  //     .update(["visiblePag", "reportPage"]);
                                  controller.reportAnimation();
                                },
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.report_gmailerrorred,
                                      size: 20.sp,
                                      color: AppColors.red,
                                    ),
                                    Text(
                                      'REPORT',
                                      style: Styles.interRegular(
                                        color: AppColors.red,
                                        size: 12.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0.sp),
                          image: DecorationImage(
                              image: NetworkImage(
                                controller.findChargesDataDetails.location
                                        ?.locationImage ??
                                    "",
                              ),
                              fit: BoxFit.fill),
                        ),
                        height: Get.height / 4.4.h,
                        width: Get.width,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              // "Starbucks",
                              controller.findChargesDataDetails.location
                                      ?.brandName ??
                                  "",
                              style: Styles.interBold(
                                color: AppColors.blackText,
                                size: 15.sp,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.topRight,
                              child: Text(
                                // "Temporarily Closed",
                                controller.findChargesDataDetails.location
                                        ?.businessStatus ??
                                    "",
                                style: Styles.interBold(
                                  color: AppColors.red,
                                  size: 11.sp,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 4.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                      ),
                      child: Text(
                        // "150 Russell sq,\nSouthamton Row London,\nWC1B 5AL, \n2.4 miles",
                        '${controller.findChargesDataDetails.location?.addressLine1 ?? ''}\n${controller.findChargesDataDetails.location?.addressLine2 ?? ''}\n${controller.findChargesDataDetails.location?.addressLine3 ?? ''}',

                        style: Styles.interLight(
                          color: AppColors.offerDetailsAddresTextGrey,
                          size: 13.sp,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                      ),
                      child: Text(
                        '${controller.findChargesDataDetails.location?.addressLine2 ?? ''}\n${controller.findChargesDataDetails.location?.addressLine3 ?? ''}',
                        style: Styles.interLight(
                          color: AppColors.offerDetailsAddresTextGrey,
                          size: 13.sp,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                      ),
                      child: Text(
                        '${controller.findChargesDataDetails.location?.addressLine3 ?? ''}',
                        style: Styles.interLight(
                          color: AppColors.offerDetailsAddresTextGrey,
                          size: 13.sp,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                      ),
                      child: Text(
                        // "150 Russell sq,\nSouthamton Row London,\nWC1B 5AL, \n2.4 miles",
                        controller.findChargesDataDetails.location?.postcode ??
                            '',

                        style: Styles.interLight(
                          color: AppColors.offerDetailsAddresTextGrey,
                          size: 13.sp,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                      ),
                      child: Text(
                        // "150 Russell sq,\nSouthamton Row London,\nWC1B 5AL, \n2.4 miles",
                        '${controller.findChargesDataDetails.location?.distance.toString() ?? ""}',
                        // settingScreenController
                        //             .getSettingValues.setting?.distanceUnit ==
                        //         "Miles"
                        //     ? "Miles"
                        //     : "km",
                        style: Styles.interLight(
                          color: AppColors.offerDetailsAddresTextGrey,
                          size: 13.sp,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    const Spacer(),
                    Center(
                      child: Text(
                        "Google Review Score",
                        style: Styles.interRegular(
                          color: AppColors.blackText,
                          size: 14.sp,
                        ),
                        maxLines: 4,
                      ),
                    ),
                    Center(
                      child: GestureDetector(
                        onTap: () async {
                          String googlePlacesId = controller
                                  .findChargesDataDetails
                                  .location
                                  ?.googlePlacesId ??
                              "";
                          String encodedGooglePlacesId =
                              Uri.encodeComponent(googlePlacesId);
                          controller.ratingBarBtnLink(
                              "https://search.google.com/local/reviews?placeid=$encodedGooglePlacesId");
                        },
                        child: RatingBar.builder(
                          initialRating: (controller.findChargesDataDetails
                                      .location?.ratingScore ??
                                  0)
                              .toDouble(),
                          ignoreGestures: true,
                          itemCount: 5,
                          itemPadding:
                              const EdgeInsets.symmetric(horizontal: 1.0),
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            size: 18.sp,
                            color: AppColors.yellowStarRatingColor,
                          ),
                          onRatingUpdate: (rating) {},
                          allowHalfRating: false,
                          unratedColor: AppColors.whiteStarRatingColor,
                        ),
                      ),
                    ),
                    // SizedBox(
                    //   height: Get.height / 20.h,
                    // ),
                    // const Spacer(),
                    controller.findChargesDataDetails.location?.isOtherButton ==
                            1
                        ? Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6.w,
                            ),
                            child: PrimaryButton(
                              onPressed: () {
                                controller.downloadBtnAppLink(controller
                                        .findChargesDataDetails
                                        .location
                                        ?.buttonLink ??
                                    '');
                              },
                              height: 60.h,
                              width: Get.width,
                              color: AppColors.whiteStarRatingColor,
                              child: Center(
                                child: Text(
                                  // " Download",
                                  controller.findChargesDataDetails.location
                                          ?.buttonText ??
                                      '',
                                  style: Styles.interRegular(
                                    color: AppColors.seeOfferBtnColor,
                                    size: 20.sp,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : const SizedBox(),

                    controller.findChargesDataDetails.location?.isOfferButton ==
                            1
                        ? Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6.w,
                            ),
                            child: GetBuilder<FindChargesScreenController>(
                              id: "sigleOffervisiblePage",
                              builder: (cont) => PrimaryButton(
                                onPressed: () async {
                                  if (controller.findChargesDataDetails.location
                                          ?.isOfferMultiple ==
                                      1) {
                                    await controller.getSingleOfferCard(
                                        id: controller.findChargesDataDetails
                                                .location?.offerId ??
                                            0);
                                    controller.singleOffer();
                                    // controller.update(["visiblePage"]);
                                  } else {
                                    await controller.getMultipleOfferCard(
                                        id: controller.findChargesDataDetails
                                                .location?.brandId ??
                                            0);
                                    controller.multiOffer();
                                  }

                                  // if (controller.findChargesDataDetails.location
                                  //         ?.isOfferMultiple ==
                                  //     1) {
                                  //   await controller.getMultipleOfferCard(
                                  //       id: controller.findChargesDataDetails
                                  //               .location?.brandId ??
                                  //           0);
                                  //   controller.multiOffer();
                                  //   // controller.update(["visiblePage"]);
                                  // } else {
                                  //   await controller.getSingleOfferCard(
                                  //       id: controller.findChargesDataDetails
                                  //               .location?.offerId ??
                                  //           0);
                                  //   controller.singleOffer();
                                  // }
                                },
                                height: 60.h,
                                width: Get.width,
                                color: AppColors.whiteStarRatingColor,
                                child: Center(
                                  child: Text(
                                    " See Offers",
                                    style: Styles.interRegular(
                                      color: AppColors.seeOfferBtnColor,
                                      size: 20.sp,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : const SizedBox(),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.w,
                      ),
                      child: PrimaryButton(
                        onPressed: () async {
                          // Replace these values with your desired latitude and longitude
                          dynamic destinationLatitude = controller
                                  .findChargesDataDetails.location?.latitude ??
                              "";
                          dynamic destinationLongitude = controller
                                  .findChargesDataDetails.location?.longitude ??
                              "";
                          String brandName = controller
                                  .findChargesDataDetails.location?.brandName ??
                              "";
                          // Update the observable variable
                          // controller.location.value =
                          //     '$destinationLatitude, $destinationLongitude';

                          controller.location.value = brandName;
                          // Open Google Maps based on the platform
                          // await controller.launchMap(destinationLatitude,
                          //     destinationLongitude, brandName);

                          controller.directionsLink(
                              'https://www.google.com/maps/dir/?api=1&destination=$destinationLatitude,$destinationLongitude');
                        },
                        height: 60.h,
                        width: Get.width,
                        color: AppColors.green,
                        child: Text(
                          "Directions",
                          style: Styles.interRegular(
                            color: AppColors.blackText,
                            size: 20.sp,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 4.h,
                    ),

                    // Expanded(
                    //   // height: (Get.height * 0.08.h * 2.90.h) + 20.h,
                    //   child: ListView.builder(
                    //     // padding: EdgeInsets.only(bottom: 1.h),
                    //     physics: const NeverScrollableScrollPhysics(),
                    //     // itemBuilder: (context, index) => PrimaryButton(
                    //     //   onPressed: () {},
                    //     //   height: 62.h,
                    //     //   width: Get.width,
                    //     //   color: AppColors.green,
                    //     //   child: const Text("data"),
                    //     // ),
                    //     // itemCount: controller.findChargesDataDetails.location
                    //     //         ?.buttons?.length ??
                    //     //     0,
                    //     // // itemCount: 2,

                    //     itemBuilder: (context, index) {
                    //       if (index < 2) {
                    //         // Display the first two items immediately
                    //         return PrimaryButton(
                    //           onPressed: () {},
                    //           height: 62.h,
                    //           width: Get.width,
                    //           color: AppColors.green,
                    //           child: const Text("data"),
                    //         );
                    //       } else {
                    //         // If there are more than two items, allow scrolling
                    //         return Container(); // You can use an empty container or other widgets as needed
                    //       }
                    //     },
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
