import 'package:aircharge/app/core/service/loctions_controller.dart';
import 'package:aircharge/app/core/theme/colors.dart';
import 'package:aircharge/app/core/theme/styles.dart';
import 'package:aircharge/app/modules/find_charges_screen/views/comman_listtile.dart';
import 'package:aircharge/app/modules/find_charges_screen/views/find_charges_details_screen_view.dart';
import 'package:aircharge/app/modules/find_charges_screen/views/multiple_offer_details.dart';
import 'package:aircharge/app/modules/find_charges_screen/views/report.dart';
import 'package:aircharge/app/modules/find_charges_screen/views/single_offer_details.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../controllers/find_charges_screen_controller.dart';

class FindChargesScreenView extends GetView<FindChargesScreenController> {
  const FindChargesScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(FindChargesScreenController());
    final LocationController locationController =
        Get.find<LocationController>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawerEnableOpenDragGesture: false,
      endDrawerEnableOpenDragGesture: false,
      backgroundColor: AppColors.white,
      drawerScrimColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned(
            top: controller.isMapViewVisible ? 0.0.h : 84.h,
            child: Obx(
              () => Visibility(
                visible: controller.isMapViewVisible,
                replacement: SizedBox(
                  height: Get.height,
                  width: Get.width,
                  child: Obx(
                    () => Visibility(
                      visible: controller.isVisible,
                      child: GoogleMap(
                        myLocationEnabled: false,
                        compassEnabled: false,
                        onTap: (position) {
                          controller
                              .customInfoWindowController.hideInfoWindow!();
                        },
                        onCameraMove: (position) {
                          controller.customInfoWindowController.onCameraMove!();
                        },
                        markers: controller.mapMarker.toSet(),
                        onMapCreated: (mapController) {
                          controller.googleMapController = mapController;
                          mapController
                              .moveCamera(CameraUpdate.scrollBy(10, 170));
                          controller.customInfoWindowController
                              .googleMapController = mapController;
                        },
                        initialCameraPosition: CameraPosition(
                          target: LatLng(
                            locationController.latitude.value!,
                            locationController.longitude.value!,
                          ),
                          zoom: 15.0,
                        ),
                      ),
                    ),
                  ),
                ),
                child: Container(
                  height: Get.height,
                  width: Get.width,
                  color: AppColors.bgGreyColor,
                ),
              ),
            ),
          ),
          if (controller.isMapViewVisible)
            CustomInfoWindow(
              controller: controller.customInfoWindowController,
              //      margin: 84.0.h,
              offset: 50.h,
              height: 50.h,
            ),
          Column(
            children: [
              Container(
                width: double.infinity,
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: Card(
                    color: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.sp),
                    ),
                    borderOnForeground: false,
                    elevation: 1.sp,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(8.sp),
                      ),
                      padding: EdgeInsets.only(left: 14.w),
                      child: TextFormField(
                        controller: controller.searchTextEditingController,
                        onTap: () async {
                          if (!controller.isMapViewVisible) {
                            controller.googleMapController!.animateCamera(
                                CameraUpdate.newCameraPosition(CameraPosition(
                                    tilt: 20,
                                    target: LatLng(
                                      locationController.latitude.value!,
                                      locationController.longitude.value!,
                                    ),
                                    zoom: 15)));
                          }
                        },
                        onChanged: (searchValue) async {
                          if (searchValue.isEmpty) {
                            controller.searchResults.clear();
                            controller.searchResults
                                .addAll(controller.locations);
                            // controller.isSearchempty.value = false ;
                          } else {
                            await controller
                                .getFindChargesListLoctionSearchsList(
                              latitude: controller
                                      .locationController.latitude.value ??
                                  0.0,
                              longitude: controller
                                      .locationController.longitude.value ??
                                  0.0,
                              // showMarkerMode: 0,
                              pageNumber: controller.pageSize,
                              seacrhValue: searchValue,
                            );
                          }
                          controller.update();
                        },
                        expands: false,
                        autofocus: false,
                        cursorColor: AppColors.iconGreyColor,
                        decoration: InputDecoration(
                          prefixIcon: const ImageIcon(
                            AssetImage(
                              "assets/images/search.png",
                            ),
                          ),
                          prefixIconConstraints:
                              BoxConstraints(maxWidth: 30.sp),
                          prefixIconColor: AppColors.iconGreyColor,
                          hintText: 'Search Public Charging Locations',
                          hintStyle: Styles.interRegular(
                              size: 14.sp, color: AppColors.iconGreyColor),
                          helperStyle: const TextStyle(color: AppColors.grey),
                          fillColor: AppColors.white,
                          filled: true,
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.fromLTRB(
                              20.0.w, 10.0..h, 20.0.w, 10.0.h),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0.sp),
                            borderSide: const BorderSide(
                                color: Colors.white, width: 3.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    color: Colors.white,
                    height: 30.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              controller.currentLoctionOnTapFunctions();
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6.sp),
                              ),
                              color: AppColors.white,
                              child: Container(
                                height: 46.h,
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(6.0.sp),
                                ),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 8.w, right: 4.w),
                                      child: Obx(
                                        () => SvgPicture.asset(
                                          'assets/images/fc_locations_toggle.svg',
                                          width: 24.0.w,
                                          height: 24.0.h,
                                          // ignore: deprecated_member_use
                                          color: controller.locationController
                                                  .isAccessingLocation.value
                                              ? AppColors.iconGreyColor
                                              : controller.locationController
                                                          .latitude.value !=
                                                      null
                                                  ? AppColors.green
                                                  : AppColors.iconGreyColor,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: Get.width / 2 - 60,
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          'Current Location',
                                          style: Styles.interRegular(
                                            color: AppColors.iconGreyColor,
                                            size: 15.sp,
                                          ),
                                          maxLines: 1,
                                          softWrap: true,
                                          overflow: TextOverflow.clip,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              controller.isMapViewVisible =
                                  !controller.isMapViewVisible;
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6.sp),
                              ),
                              color: AppColors.white,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                height: 46.h,
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(6.0.sp),
                                ),
                                child: Obx(
                                  () => Row(
                                    children: [
                                      SvgPicture.asset(
                                        !controller.isMapViewVisible
                                            ? "assets/images/fc_list_icon.svg"
                                            : "assets/images/fc_map_icon.svg",
                                        width: 22.w,
                                        height: 22.h,
                                      ),
                                      SizedBox(
                                        width: 6.w,
                                      ),
                                      FittedBox(
                                        child: Text(
                                          !controller.isMapViewVisible
                                              ? " List View"
                                              : ' Map View',
                                          style: Styles.interRegular(
                                            color: AppColors.iconGreyColor,
                                            size: 15.sp,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Obx(
                  () => Visibility(
                    visible: controller.isMapViewVisible,
                    replacement: SizedBox(
                      height: Get.height,
                      width: Get.width,
                      child: Obx(
                        () => Visibility(
                          visible: controller.isVisible,
                          child: Column(
                            children: [
                              const Spacer(),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12.w),
                                child: SizedBox(
                                  height: (Get.height * 0.08.h * 3) + 20.h,
                                  child: listViewWidget(),
                                ),
                              ),
                              SizedBox(height: 76.h + 10)
                            ],
                          ),
                        ),
                      ),
                    ),
                    child: Obx(
                      () => Visibility(
                        visible: controller.isVisible,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          child: listViewWidget(),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Obx(
            () => Visibility(
              visible: controller.isVisibleReport &&
                  controller.isVisibleOfferScreen &&
                  controller.isVisibleMultipleOffers,
              replacement: SizedBox(
                height: Get.height,
                width: Get.width,
              ),
              child: GetBuilder<FindChargesScreenController>(
                id: "visiblePage",
                builder: (cont) => AnimatedPositioned(
                  curve: Curves.easeInOut,
                  top: 0,
                  bottom: 0,
                  right: 2,
                  left: controller.isOpened.value ? 2 : Get.width,
                  duration: const Duration(milliseconds: 200),
                  child: const FindChargesDetailsScreen(),
                ),
              ),
            ),
          ),
          GetBuilder<FindChargesScreenController>(
            id: "reportPage",
            builder: (cont) {
              return AnimatedPositioned(
                curve: Curves.easeInOut,
                top: 0,
                bottom: 0,
                right: 2,
                left: controller.isOpenedReport.value ? 2 : Get.width,
                duration: const Duration(milliseconds: 200),
                child: const ReportView(),
              );
            },
          ),
          GetBuilder<FindChargesScreenController>(
            id: "sigleOffervisiblePage",
            builder: (cont) {
              return AnimatedPositioned(
                curve: Curves.easeInOut,
                top: 0,
                bottom: 0,
                right: 2,
                left: controller.isOpenedOfferScreen.value ? 2 : Get.width,
                duration: const Duration(milliseconds: 200),
                child: const SingleOfferDetailsLoction(),
              );
            },
          ),
          GetBuilder<FindChargesScreenController>(
            id: "multiplervisiblePage",
            builder: (cont) {
              return AnimatedPositioned(
                curve: Curves.easeInOut,
                top: 0,
                bottom: 0,
                right: 2,
                left: controller.isOpenedMultipleOffers.value ? 2 : Get.width,
                duration: const Duration(milliseconds: 200),
                child: const MultipleOffersLoctions(),
              );
            },
          ),
          GetBuilder<FindChargesScreenController>(
            id: "sigleOffervisiblePage",
            builder: (cont) {
              return AnimatedPositioned(
                curve: Curves.easeInOut,
                top: 0,
                bottom: 0,
                right: 2,
                left: controller.isOpenedOfferScreen.value ? 2 : Get.width,
                duration: const Duration(milliseconds: 200),
                child: const SingleOfferDetailsLoction(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget listViewWidget(//   bool displayAllItems,
      ) {
    return SizedBox(
      height: Get.height,
      width: Get.width,
      child: Obx(
        () {
          if (controller.isLoading.value && controller.searchResults.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.black,
              ),
            );
          } else {
            return NotificationListener<ScrollNotification>(
              onNotification: (scrollNotification) {
                // if (scrollNotification is ScrollEndNotification &&
                //     controller.scrollController.position.extentAfter == 0) {}
                if (scrollNotification is ScrollEndNotification &&
                    controller.scrollController.position.extentAfter == 0) {
                  // Reach the end of the list, load more data
                  controller.loadMoreData();
                }
                return false;
              },
              child: ListView.builder(
                  // reverse: true,
                  padding: EdgeInsets.only(
                    top: 0.h,
                    bottom: 84.h,
                  ),
                  controller: controller.scrollController,
                  // itemCount: controller.locations.length + 1,
                  itemCount: controller.searchResults.length + 1,
                  // itemCount: controller.searchResults.length,
                  itemBuilder: (context, index) {
                    if (index == controller.searchResults.length) {
                      if (!controller.isSearchempty.value) {
                        return controller.isMoreLoading.value
                            ? Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.black,
                                ),
                              )
                            : SizedBox();
                      } else {
                        return SizedBox();
                      }
                    } else {
                      var location = controller.searchResults[index];
                      return Card(
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.sp),
                        ),
                        child: GetBuilder<FindChargesScreenController>(
                          id: "visiblePage",
                          builder: (cont) => GestureDetector(
                              onTap: () async {
                                try {
                                  await controller
                                      .getFindChargesListLoctionsDetails(
                                    id: location.locationId ?? 0,
                                    latitude: controller.locationController
                                            .latitude.value ??
                                        0.0,
                                    longitude: controller.locationController
                                            .longitude.value ??
// =======
                                        // .latitude
                                        // .value ??
                                        0.0,
//                                           longitude: controller
//                                                   .locationController
//                                                   .longitude
//                                                   .value ??
// >>>>>>> Stashed changes
                                    //   0.0
                                  );
                                  controller.loctiondetailsAnimation();
                                } catch (e) {
                                  print("Error: $e");
                                }
                              },
                              child: CommanListTile(
                                img: location.logoUrl ?? "",
                                title: location.brandName ?? "",
                                subTitle: location.friendlyName ?? "",
                                thirdTitle: location.distance ?? 0.0,
                              )),
                        ),
                      );
                    }
                  }),
            );
          }
        },
      ),
    );
  }
}
