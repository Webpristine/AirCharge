import 'dart:io';

import 'package:aircharge/app/core/theme/colors.dart';
import 'package:aircharge/app/core/theme/styles.dart';
import 'package:aircharge/app/modules/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MultipleOffers extends GetView<HomeController> {
  const MultipleOffers({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      id: "MultipleOfeervisiblePage",
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
              boxShadow: [
                BoxShadow(
                  color: AppColors.grey.withOpacity(0.1),
                  spreadRadius: -2.26,
                  blurRadius: 1.0,
                  offset: const Offset(-4.0, -2.0),
                ),
                BoxShadow(
                  color: AppColors.grey.withOpacity(0.1),
                  blurRadius: 1.0,
                  spreadRadius: -2.26,
                  offset: const Offset(5.0, 1.0),
                ),
              ],
              color: AppColors.white,
              borderRadius: BorderRadius.circular(10.sp),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 4.h),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: GestureDetector(
                          onTap: () {
                            controller.isVisibleMultipleOffers = true;
                            controller.isOpenedMultipleOffers.value = false;
                            controller.animationControllerMultipleOffers
                                .reverse();
                            controller.update(["MultipleOfeervisiblePage"]);
                          },
                          child: Container(
                            height: 50.h,
                            width: 50.w,
                            color: Colors.transparent,
                            child: Icon(
                              Icons.arrow_back_ios_new,
                              size: 18.sp,
                              color: AppColors.iconGreyColor,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: EdgeInsets.only(top: 4.h),
                          child: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            radius: 20.sp,
                            child: Image.network(
                              // 'assets/images/od_logo_costa.svg',
                              controller.multipleOfferCard.brandLogo ?? "",
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 15,
                        child: Center(
                          child: Text(
                            // "Costa Coffee",
                            controller.multipleOfferCard.brandName ?? "",
                            style: Styles.interBold(
                              color: AppColors.blackGrey,
                              size: 16.sp,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: SizedBox(
                          width: 6.w,
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.all(2.sp),
                      itemCount:
                          controller.multipleOfferCard.offers?.length ?? 0,
                      // itemCount: 4,
                      itemBuilder: (context, index) =>
                          // Text('dfghjk,.'),
                          Obx(() => GestureDetector(
                                onTap: () async {
                                  await controller.getSingleOfferCard(
                                      id: controller.multipleOfferCard
                                              .offers?[index].offerId ??
                                          0);
                                  controller.singleOfferAnimation();
                                  // controller.getSingleOfferCard(
                                  //     id: controller.offerCard.offers?[index].offerId ??
                                  //         0);
                                  // controller.singleOffer();
                                  // controller.update(["visiblePage"]);
                                },
                                child: Card(
                                  // elevation: 2.sp,
                                  child: Container(
                                    height: 90.h,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                        8.sp,
                                      ),
                                      color: AppColors.white,
                                    ),
                                    padding: EdgeInsets.all(4.sp),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: AspectRatio(
                                            aspectRatio: 4 / 3,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: NetworkImage(
                                                        // "assets/images/firstoffer.png",
                                                        controller
                                                                .multipleOfferCard
                                                                .offers?[index]
                                                                .offerImage ??
                                                            ""),
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.sp)),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                left: 4.w, right: 8.w),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  flex: 3,
                                                  child: Text(
                                                    // "Exclusive Festive Menu in \nCosta Club App",
                                                    controller
                                                            .multipleOfferCard
                                                            .offers?[index]
                                                            .headerText ??
                                                        "",
                                                    style: Styles.interBold(
                                                      color:
                                                          AppColors.blackText,
                                                      size: 12.sp,
                                                    ),
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 3,
                                                  child: Text(
                                                    // "McDonald's Monopoly is back! \nPeel. Play. Win?",
                                                    controller
                                                            .multipleOfferCard
                                                            .offers?[index]
                                                            .detailText ??
                                                        "",
                                                    style: Styles.interRegular(
                                                      color: AppColors.black,
                                                      size: 11.sp,
                                                    ),
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Visibility(
                                                    visible: controller
                                                            .multipleOfferCard
                                                            .offers?[index]
                                                            .endDate ==
                                                        null,
                                                    child: Text(
                                                      "offer ends:${controller.multipleOfferCard.offers?[index].endDate ?? ""} ",
                                                      style:
                                                          Styles.interRegular(
                                                        color: AppColors.black,
                                                        size: 9.sp,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
