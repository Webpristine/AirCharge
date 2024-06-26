// ignore: unused_import
// ignore_for_file: deprecated_member_use, library_prefixes

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';
import 'dart:ui' as ui;
import 'dart:ui';
import 'package:aircharge/app/data/response_dto/local_locations_response.dart'
    as LL;
import 'package:http/http.dart' as client;

import 'package:aircharge/app/core/service/loctions_controller.dart';
import 'package:aircharge/app/core/service/loctions_services.dart';
import 'package:aircharge/app/core/theme/colors.dart';
import 'package:aircharge/app/core/utils/device_info_util.dart';
import 'package:aircharge/app/data/models/error_model.dart';
import 'package:aircharge/app/data/network/api_controller.dart';
import 'package:aircharge/app/data/repostorys/api_repostory.dart';
import 'package:aircharge/app/data/request_dto/battery-percentage_request.dart';
import 'package:aircharge/app/data/request_dto/report_request.dart';
import 'package:aircharge/app/data/request_dto/setting-request.dart';
import 'package:aircharge/app/data/response_dto/battery_percentage_response.dart';
import 'package:aircharge/app/data/response_dto/loctions_details_response.dart'
    as LoctionDetails;
import 'package:aircharge/app/data/response_dto/loctions_response.dart';
import 'package:aircharge/app/data/response_dto/multiple_offerscard_response.dart';
import 'package:aircharge/app/data/response_dto/report_response.dart';
import 'package:aircharge/app/data/response_dto/settings_response.dart';
import 'package:aircharge/app/data/response_dto/single_offerscard_response.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_google_maps_webservices/places.dart' as ws;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:logger/logger.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../data/response_dto/locationsuggestions.dart';

class FindChargesScreenController extends GetxController
    with GetTickerProviderStateMixin {
  late ApiRepostory _apiRepostory;
  final formkey = GlobalKey<FormState>();

  FocusNode cardFocus = FocusNode();
  late final AnimationController listFadeController;

  final RxBool isTextFieldSelected = false.obs;
  RxBool ismapCreated = false.obs;

  final GlobalKey focusKey = GlobalKey();

  final LocationController locationController = Get.find<LocationController>();

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{}.obs;
  RxSet<Marker> mapMarker = <Marker>{}.obs;

  Future<BitmapDescriptor> createCustomMarkerBitmap(context) async {
    // String _iconImage = 'assets/images/' + bla['q'].toString() + '.png';
    String imagePath = "assets/images/current-location.svg";
    // final bitmapIcon = await BitmapDescriptor.fromAsset(_iconImage);
    ImageConfiguration configuration = createLocalImageConfiguration(context);
    BitmapDescriptor bitmapDescriptor = await BitmapDescriptor.fromAssetImage(
      configuration,
      imagePath,
    );
    return bitmapDescriptor;
  }

  // final List<Uint8List> _markersList = [];
  String? token; // fcmtoken

  Future<void> initializeFCM() async {
    final FirebaseMessaging messaging = FirebaseMessaging.instance;
    final NotificationSettings settings = await messaging.requestPermission();
    token = await messaging.getToken();
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('>>>> [DEBUG] calling fcm api');
      // await sendFcm(id: DateTime.now().toIso8601String(), fcmToken: token!);
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        debugPrint('>>>> [DEBUG] Got a message whilst in the foreground!');
        debugPrint('>>>> [DEBUG] Message data: ${message.data}');

        if (message.notification != null) {
          debugPrint(
              '>>>> [DEBUG] Message also contained a notification: ${message.notification}');
        }
      });
      // FirebaseMessaging.onBackgroundMessage(
      //     _firebaseMessagingBackgroundHandler);
    } else {}
    if (kDebugMode) {
      print('>>>> [DEBUG] Permission granted: ${settings.authorizationStatus}');
    }

    if (kDebugMode) {
      print('>>>> [DEBUG] Registration Token=$token');
    }
  }

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    // If you're going to use other Firebase services in the background, such as Firestore..
    // make sure you call `initializeApp` before using other Firebase services.
    // await Firebase.initializeApp();

    debugPrint(
        ">>>> [DEBUG] Handling a background message: ${message.messageId}");
  }

  final _getSettingValues = SettingsResponceDto().obs;
  SettingsResponceDto get getSettingValues => _getSettingValues.value;
  set getSettingValues(SettingsResponceDto value) =>
      _getSettingValues.value = value;

  Future<void> getSetting(String deviceId, {String? fcmtoken}) async {
    try {
      var getSettingValues = await _apiRepostory.setting(
          requestDTO: SettingRequestDto(
        deviceId: DeviceInfoUtil.deviceInfo,
        fcmId: token,
      ));
      debugPrint('>>>> [DEBUG] getSettingValues : $getSettingValues');
    } on ErrorResponse catch (e) {
      Get.back();
      debugPrint(e.toString());

      Logger().d(e.error?.detail ?? '');
    } catch (e) {
      Get.back();
      Logger().d(e);
    }
  }

  final _batteryPercentageValues = BatteryPercentageResponceDto().obs;
  BatteryPercentageResponceDto get batteryPercentageValues =>
      _batteryPercentageValues.value;
  set batteryPercentageValues(BatteryPercentageResponceDto value) =>
      _batteryPercentageValues.value = value;

  Future<void> getBatteryPercentage() async {
    try {
      batteryPercentageValues = await _apiRepostory.battery(
          requestDTO: BatteryPercentageRequestDto(
        deviceId: DeviceInfoUtil.deviceInfo,
        latitude: locationController.latitude.value.toString(),
        longitude: locationController.longitude.value.toString(),
        batteryPercentage: batteryLevel.toString(),
      ));
      debugPrint('>>>> [DEBUG] batteryLevel : ${DeviceInfoUtil.deviceInfo}');
    } on ErrorResponse catch (e) {
      Get.back();
      debugPrint(e.toString());

      Logger().d(e.error?.detail ?? '');
    } catch (e) {
      Get.back();
      Logger().d(e);
    }
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    await initializeFCM();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    // final SettingScreenController settingController =
    // Get.find<SettingScreenController>();

    scrollController.addListener(_onScroll);

    // scrollController.addListener(() {
    //   if (scrollController.position.pixels ==
    //       scrollController.position.maxScrollExtent) {
    //          getFindChargesListLoctionsList(
    //     latitude: locationController.userLocation.value?.latitude ?? 0.0,
    //     longitude: locationController.userLocation.value?.longitude ?? 0.0,
    //     // showMarkerMode:
    //     //     settingController.getSettingValues.setting?.showMarkerMode == false
    //     //         ? 0
    //     //         : 1,
    //     pageNumber: pageSize ~/ 20+1,
    //   );
    //     // fetchLocations(locations.length ~/ 20 + 1);
    //   }
    // });
    // loadMoreData();
    _apiRepostory = ApiRepostory(apiControllerV1: Get.find<ApiControllerV1>());
    await LocationService.instance
        .getUserLocation(controller: locationController);

    if (locationController.latitude.value != null &&
        locationController.longitude.value != null) {
      debugPrint(
          '>>>> [DEBUG] location is Latitude: ${locationController.latitude.value}, Longitude: ${locationController.longitude.value}');
      await getFindChargesListLoctionsList(
        latitude: locationController.latitude.value ?? 0.0,
        secondlatitude: placedetails.value.latitude,
        secondlongitude: placedetails.value.longitude,
        longitude: locationController.longitude.value ?? 0.0,
        // showMarkerMode:
        //     settingController.getSettingValues.setting?.showMarkerMode == false
        //         ? 0
        //         : 1,
        pageNumber: pageSize,
      );

      await getFindChargesListLoctionsListForMap(
          lat: locationController.latitude.value ?? 0,
          long: locationController.longitude.value ?? 0);
    } else {
      debugPrint(
          '>>>> [DEBUG] location is Latitude: ${locationController.latitude.value}, Longitude: ${locationController.longitude.value}');
    }
    debugPrint(
        'Latitude: ${locationController.latitude.value}, Longitude: ${locationController.longitude.value}');
    // _markersList.add(await _loadSvgAsBitmap(1));
    // _markersList.add(await _loadSvgAsBitmap(2));
    // debugPrint('>>>> [DEBUG] markers list is  ${_markersList.length}');
    // scrollController.addListener(() {
    //   if (scrollController.position.pixels ==
    //       scrollController.position.maxScrollExtent) {
    //     // User has reached the end of the list, load more data
    //     if (!hasMorePages.value) {
    //       hasMorePages.value = true;
    //       getFindChargesListLoctionsList(
    //         // id: findChargesData.locations?.last.locationId ?? 0,
    //         latitude: locationController.userLocation.value?.latitude ?? 0.0,
    //         longitude: locationController.userLocation.value?.longitude ?? 0.0,
    //         // showMarkerMode: 2,
    //       );
    //     }
    //   }
    // }

    // );
    if (token != null && token!.isNotEmpty) {
      await getSetting(DeviceInfoUtil.deviceInfo!, fcmtoken: token!);
    }
    // scrollController.addListener(_onScroll);
    battery = Battery();
    batterySubscription =
        battery.onBatteryStateChanged.listen((BatteryState state) {
      updateBatteryLevel();
    });
    updateBatteryLevel();
    getBatteryPercentage();

    reportAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    singlrOfferAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    animationControllerMultipleOffers = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    //  update(
    //   ["searchbar"],
    // );
    _getUserLocation();
    final Uint8List markerIcon =
        await getBytesFromAsset('assets/images/current-location.png', 100);
    final bitmapIcon = BitmapDescriptor.fromBytes(
        // const ImageConfiguration(size: Size(4, 4)),
        markerIcon);
    final Marker marker = Marker(
      markerId: const MarkerId("CurrentLocation"),
      icon: bitmapIcon,
      consumeTapEvents: true,
      // onTap: () {

      //   googleMapController!.animateCamera(
      //     CameraUpdate.newCameraPosition(
      //       CameraPosition(
      //         zoom: 15,
      //         target: LatLng(
      //           locationController.latitude.value!,
      //           locationController.longitude.value!,
      //         ),
      //       ),
      //     ),
      //   );
      // },
      position: LatLng(
        locationController.latitude.value!,
        locationController.longitude.value!,
      ),
    );

    mapMarker.add(markers[const MarkerId("CurrentLocation")] = marker).obs;
  }

  Future<void> changenewmarker({
    required double lat,
    required double long,
    required double secondlatitude,
    required double secondlongitude,
  }) async {
    locations.clear();
    await getFindChargesListLoctionsList(
        latitude: lat,
        longitude: long,
        pageNumber: pageSize,
        secondlatitude: secondlatitude,
        secondlongitude: secondlongitude);
  }

  @override
  void dispose() {
    animationController.dispose();
    reportAnimationController.dispose();
    // scrollController.dispose();
    textarea.dispose();
    super.dispose();
    locationController.updateIsAccessingLocation(false);
  }

  @override
  void onClose() {
    batterySubscription.cancel();
    super.onClose();
  }

  void onTextFieldFocused() {
    isTextFieldSelected.value = true;
    update();
  }

  void onTextFieldUnfocused() {
    isTextFieldSelected.value = false;
    update();
  }

  //Battery Percentage
  RxInt batteryLevel = 0.obs;

  late Battery battery;
  late StreamSubscription<BatteryState> batterySubscription;

  void updateBatteryLevel() async {
    final level = await battery.batteryLevel;
    log("Batery Level is $level");
    batteryLevel.value = level;
  }

  ///Call DashbordScreen
  void findChargesResetState() {
    isVisible = true;
    isOpened.value = false;
    update(
      [
        "visiblePage",
      ],
    );
    isVisibleReport = true;
    isOpenedReport.value = false;
    update(
      [
        "reportPage",
      ],
    );

    update(["multiplervisiblePage"]);
  }

  TextEditingController textarea = TextEditingController();
  var searchTextEditingController = TextEditingController();
  CustomInfoWindowController customInfoWindowController =
      CustomInfoWindowController();

  ///For Details Screens
  RxBool isOpened = false.obs;

  late final AnimationController animationController;

  final _isVisible = true.obs;
  bool get isVisible => _isVisible.value;
  set isVisible(bool value) => _isVisible.value = value;

  ///For Report Screen
  RxBool isOpenedReport = false.obs;

  final _maxCharacters = 500.obs;
  int get maxCharacters => _maxCharacters.value;
  set maxCharacters(int value) => _maxCharacters.value = value;

  late final AnimationController reportAnimationController;

  final _isVisibleReport = true.obs;
  bool get isVisibleReport => _isVisibleReport.value;
  set isVisibleReport(bool value) => _isVisibleReport.value = value;

  ///For Map View
  final _isMapViewVisible = true.obs;
  bool get isMapViewVisible => _isMapViewVisible.value;
  set isMapViewVisible(bool value) => _isMapViewVisible.value = value;

  // For List Visiblity
  final _isListViewVisible = true.obs;
  bool get isListViewVisible => _isListViewVisible.value;
  set isListViewVisible(bool value) => _isListViewVisible.value = value;

  //For Map List View
  final _isMapListViewVisible = true.obs;
  bool get isMapListViewVisible => _isMapListViewVisible.value;
  set isMapListViewVisible(bool value) => _isMapListViewVisible.value = value;

  GoogleMapController? googleMapController;
  Rx<Location?> currentLocation = Rx<Location?>(null);

  loc.LocationData? currentLocationes;

  _getUserLocation() async {
    loc.Location location = loc.Location();
    currentLocationes = (await location.getLocation());
  }

  currentLoctionOnTapFunctions() async {
    // isMapViewVisible = !isMapViewVisible;
    placedetails = Rx(LatLng(0, 0));
    await Future.delayed(const Duration(milliseconds: 500));

    // Move the camera to the current location
    if (!isMapViewVisible) {
      searchTextEditingController.clear();
      selectedaddress.value = "";

      if (googleMapController != null && currentLocationes != null) {
        locations.clear();

        await getFindChargesListLoctionsList(
          latitude: locationController.latitude.value!,
          longitude: locationController.longitude.value!,
          secondlatitude: 0,
          secondlongitude: 0,
          // showMarkerMode:
          //     settingController.getSettingValues.setting?.showMarkerMode == false
          //         ? 0
          //         : 1,
          pageNumber: pageSize,
        );
        mapMarker.remove(
          markers[const MarkerId("CurrentLocation")],
        );

        markers = <MarkerId, Marker>{};
        final Uint8List markerIcon = await getBytesFromAsset(
          'assets/images/current-location.png',
          100,
        );
        final bitmapIcon = BitmapDescriptor.fromBytes(
            // const ImageConfiguration(size: Size(4, 4)),
            markerIcon);
        final Marker marker = Marker(
          draggable: false,
          consumeTapEvents: true,
          markerId: const MarkerId("CurrentLocation"),
          icon: bitmapIcon,
          position: LatLng(locationController.latitude.value!,
              locationController.longitude.value!),
        );

        mapMarker.add(markers[const MarkerId("CurrentLocation")] = marker).obs;
        // googleMapController!.moveCamera(
        //   CameraUpdate.scrollBy(-40, -70),
        // );
        customInfoWindowController.googleMapController!.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
                target: LatLng(
                  locationController.latitude.value! - 0.007,
                  locationController.longitude.value! - 0.00001,
                ),
                zoom: 15),
          ),
        );
      }
    } else {
      scrollController.jumpTo(0);
      if (searchTextEditingController.value.text.isNotEmpty) {
        locations.clear();

        await getFindChargesListLoctionsList(
          latitude: locationController.latitude.value!,
          longitude: locationController.longitude.value!,
          secondlatitude: 0,
          secondlongitude: 0,
          // showMarkerMode:
          //     settingController.getSettingValues.setting?.showMarkerMode == false
          //         ? 0
          //         : 1,
          pageNumber: pageSize,
        );
        selectedaddress.value = "";

        searchTextEditingController.clear();
      }
    }
  }

  final _isVisibleMapView = false.obs;
  bool get isVisibleMapView => _isVisibleMapView.value;
  set isVisibleMapView(bool value) => _isVisibleMapView.value = value;

  final _drowerIndex = 0.obs;
  int get drowerIndex => _drowerIndex.value;
  set drowerIndex(int value) => _drowerIndex.value = value;

  ///=====================================URL Link Function=====================================
  void openSingleOffferCardBtnLink(String link) async {
    if (await canLaunch(link)) {
      await launch(link);
    } else {
      throw 'Could not launch $link';
    }
  }

  void ratingBarBtnLink(String link) async {
    if (await canLaunch(link)) {
      await launch(link);
    } else {
      throw 'Could not launch $link';
    }
  }

  void downloadBtnAppLink(String link) async {
    if (await canLaunch(link)) {
      await launch(link);
    } else {
      throw 'Could not launch $link';
    }
  }

  void directionsLink(String link) async {
    if (await canLaunch(link)) {
      await launch(link);
    } else {
      throw 'Could not launch $link';
    }
  }

  //=====================================API==========================================

// ++++++++++++++++++++++++++++++++++++ 1 Page ++++++++++++++++++++++++++++++++++++++++

  ///findChargesLoctionsData

  final _findChargesData = GetLocationsResponceDto().obs;
  GetLocationsResponceDto get findChargesData => _findChargesData.value;
  set findChargesData(GetLocationsResponceDto value) =>
      _findChargesData.value = value;

  final _findChargesDataAll = LL.GetLocalLocationsResponceDto().obs;
  LL.GetLocalLocationsResponceDto get findChargesDataAll =>
      _findChargesDataAll.value;
  set findChargesDataAll(LL.GetLocalLocationsResponceDto value) =>
      _findChargesDataAll.value = value;
  var isLoading = true.obs;
  var isMoreLoading = true.obs;
  var isSearchempty = false.obs;

  int pageSize = 0;
  int mapPageSize = 0;
  bool hasMorePages = true;
  RxList<Location> locations = <Location>[].obs;
  final ScrollController scrollController = ScrollController();

  Future<void> getFindChargesListLoctionsListForMap(
      {required double lat, required double long}) async {
    try {
      // markers = <MarkerId, Marker>{};
      // isLoading.value = true;
      findChargesDataAll = await _apiRepostory.findChargesLoctionsListAll(
          latitude: lat, longitude: long, pageNumber: mapPageSize);
      for (var i in findChargesDataAll.locations!) {
        if (!markers.containsKey(i.locationId)) {
          final Uint8List markerIcon = i.showLocation == 1
              ? await getBytesFromAsset(
                  'assets/images/charger-loc-pin.png',
                  80,
                )
              : await getBytesFromAsset(
                  'assets/images/marker-loc-pin.png',
                  80,
                );
          final bitmapIcon = BitmapDescriptor.fromBytes(
              // const ImageConfiguration(size: Size(4, 4)),
              markerIcon);
          final Marker marker1 = Marker(
            onTap: () {
              googleMapController!.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: LatLng(i.latitude, i.longitude),
                    zoom: 15,
                  ),
                ),
              );
              // googleMapController!.moveCamera(
              //   CameraUpdate.scrollBy(0, -10),
              // );
              changenewmarker(
                lat: locationController.latitude.value!,
                long: locationController.longitude.value!,
                secondlatitude: i.latitude,
                secondlongitude: i.longitude,
              );
              customInfoWindowController.addInfoWindow!(
                Column(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(32),
                        ),
                        width: double.infinity,
                        height: double.infinity,
                        child: Center(
                          child: Text(
                            i.brandName,
                            style: const TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    ClipPath(
                      clipper: TriangleClipper(),
                      child: Container(
                        color: Colors.black,
                        width: 20.0,
                        height: 10.0,
                      ),
                    ),
                  ],
                ),
                LatLng(i.latitude, i.longitude),
              );
            },
            markerId: MarkerId(i.locationId.toString()),
            icon: bitmapIcon,
            position: LatLng(i.latitude, i.longitude),
            //infoWindow: InfoWindow(title: '${i.brandName}')
          );

          mapMarker
              .add(markers[MarkerId(i.locationId.toString())] = marker1)
              .obs;
        }
      }
      mapPageSize++;

      // locations.addAll(findChargesData.locations!);
      // isLoading.value = false;
      Future.delayed(Duration(seconds: 5), () async {
        await getFindChargesListLoctionsListForMap(
          lat: lat,
          long: long,
          //   latitude: locationController.latitude.value ?? 0.0,
          // longitude: locationController.longitude.value ?? 0.0,
          // // showMarkerMode:
          // //     settingController.getSettingValues.setting?.showMarkerMode == false
          // //         ? 0
          // //         : 1,
          // pageNumber: mapPageSize,
        );
      });
    } on ErrorResponse catch (e) {
      Get.back();
      debugPrint(
        e.toString(),
      );

      Logger().d(e.error?.detail ?? '');
      isLoading.value = false;
    } catch (e) {
      Get.back();
      Logger().d(e);
      // isLoading.value = false;
    } finally {}
  }

  Future<void> getFindChargesListLoctionsList({
    required double latitude,
    required double longitude,

    // required int showMarkerMode,
    dynamic pageNumber,
    required double secondlatitude,
    required double secondlongitude,
  }) async {
    try {
      // markers = <MarkerId, Marker>{};
      isSearchempty.value = false;

      isLoading.value = true;
      findChargesData = await _apiRepostory.findChargesLoctionsList(
        latitude: latitude,
        longitude: longitude,
        secondlatitude: secondlatitude,
        secondlongitude: secondlongitude,
        pageNumber: pageNumber ?? 0,

        // showMarkerMode,
      );
      locations.addAll(findChargesData.locations!);
      searchResults.clear();
      searchResults.addAll(locations);
      debugPrint('>>>> [DEBUG] markers map is  ${markers.values.length}');
      isLoading.value = false;
      update();
    } on ErrorResponse catch (e) {
      Get.back();
      debugPrint(
        e.toString(),
      );

      Logger().d(e.error?.detail ?? '');
      isLoading.value = false;
    } catch (e) {
      Get.back();
      Logger().d(e);
      isLoading.value = false;
    }
  }

  // Function to load more data when scrolling reaches the end

  Future<void> loadMoreData() async {
    if (searchTextEditingController.value.text.isEmpty) {
      pageSize++;
      isMoreLoading.value = true;
      await getFindChargesListLoctionsList(
        latitude: locationController.latitude.value ?? 0.0,
        secondlatitude: placedetails.value.latitude,
        secondlongitude: placedetails.value.longitude,
        longitude: locationController.longitude.value ?? 0.0,
        pageNumber: pageSize,
      );
      isMoreLoading.value = false;
    }
  }

  void _onScroll() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      // Reach the end of the list, load more data
      loadMoreData();
    }
  }

  Future<void> refreshFindChargesList(
      {required double latitude,
      required double longitude,
      dynamic pageNumber}) async {
    try {
      isLoading.value = true;

      // Reset data before fetching new data
      locations.clear();
      searchResults.clear();

      findChargesData = await _apiRepostory.findChargesLoctionsList(
          latitude: latitude,
          longitude: longitude,
          pageNumber: pageNumber ?? 0,
          secondlatitude: placedetails.value.latitude,
          secondlongitude: placedetails.value.longitude);

      locations.addAll(findChargesData.locations!);
      searchResults.addAll(locations);

      // Trigger UI update
      update();

      debugPrint('>>>> [DEBUG] markers map is  ${markers.values.length}');
    } on ErrorResponse catch (e) {
      Get.back();
      debugPrint(e.toString());
      Logger().d(e.error?.detail ?? '');
    } catch (e) {
      Get.back();
      Logger().d(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshFindChargesDetail(
      {required double latitude,
      required int id,
      required double longitude,
      dynamic pageNumber}) async {
    try {
      isLoading.value = true;

      findChargesDataDetails = await _apiRepostory.findChargesLoctionsDetails(
        id,
        latitude,
        longitude,
      );

      // Trigger UI update
      update();

      debugPrint('>>>> [DEBUG] markers map is  ${markers.values.length}');
    } on ErrorResponse catch (e) {
      Get.back();
      debugPrint(e.toString());
      Logger().d(e.error?.detail ?? '');
    } catch (e) {
      Get.back();
      Logger().d(e);
    } finally {
      isLoading.value = false;
    }
  }

  // Other methods...

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  ///findChargesLoctionsSearchData
  RxList<Location> searchResults = <Location>[].obs;
  FutureOr<void> getFindChargesListLoctionSearchsList({
    required double latitude,
    required double longitude,
    required int pageNumber,
    // required int showMarkerMode,
    required dynamic seacrhValue,
  }) async {
    try {
      searchResults.clear();
      isLoading.value = true;
      findChargesData = await _apiRepostory.findChargesLoctionSearchsList(
        latitude,
        longitude,
        // showMarkerMode,
        0,
        seacrhValue!,
      );
      // var data = json.decode(findChargesData.locations.toString());

      // predictionList = [];
      // data['predictions'].forEach(
      //     (prediction) => predictionList.add(Prediction.fromJson(prediction)));

      // print("Search Length is ${searchResults.length}");
      searchResults.addAll(findChargesData.locations!);
      if (searchResults.isEmpty) {
        isSearchempty.value = true;
      } else {
        isSearchempty.value = false;
      }

      isLoading.value = false;
      // return predictionList;
    } on ErrorResponse catch (e) {
      Get.back();
      debugPrint(
        e.toString(),
      );

      Logger().d(e.error?.detail ?? '');
      isLoading.value = false;
    } catch (e) {
      Get.back();
      Logger().d(e);
      isLoading.value = false;
    }
    // return <Prediction>[];
  }

  void setIsLoading(bool value) {
    isLoading.value = value;
  }

  Future<List<Location>> getSuggestions(pattern) async {
    return searchResults; // Replace with your actual suggestions
  }

// ++++++++++++++++++++++++++++++++++ 2 Page ++++++++++++++++++++++++++++++++++++++++++
  ///findChargesLoctionsDataDetails
  final _findChargesDataDetails =
      LoctionDetails.LocationsDetailsResponceDto().obs;
  LoctionDetails.LocationsDetailsResponceDto get findChargesDataDetails =>
      _findChargesDataDetails.value;
  set findChargesDataDetails(
          LoctionDetails.LocationsDetailsResponceDto value) =>
      _findChargesDataDetails.value = value;

  Future<void> getFindChargesListLoctionsDetails({
    required int id,
    required double latitude,
    required double longitude,
  }) async {
    // try {
    findChargesDataDetails =
        await _apiRepostory.findChargesLoctionsDetails(id, latitude, longitude);
    // } on ErrorResponse catch (e) {
    //   Get.back();
    //   debugPrint(e.toString());

    //   Logger().d(e.error?.detail ?? '');
    // } catch (e) {
    //   Get.back();
    //   Logger().d(e);
    // }
  }

  ///Animation
  void loctiondetailsAnimation() {
    isVisible = false;
    isOpened.value = true;
    if (isOpened.value) {
      animationController.forward();
    } else {
      animationController.reverse();
    }
    update([
      "visiblePage",
    ]);
  }

// +++++++++++++++++++++++++++++++++++++++ 3 page++++++++++++++++++++++++++++++++++++++++++++++++

  /// repot

  final _report = ReportResponceDto().obs;
  ReportResponceDto get report => _report.value;
  set report(ReportResponceDto value) => _report.value = value;

  RxBool isLoadingReport = false.obs;

  Future<void> postReport({
    required int id,
  }) async {
    try {
      isLoadingReport.value = true;

      report = await _apiRepostory.report(
        requestDTO: ReportRequestDto(
          locationId:
              findChargesDataDetails.location?.locationId.toString() ?? '',
          comment: textarea.text,
        ),
      );
      Fluttertoast.showToast(
        msg: "Report has been successfully submitted",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppColors.green,
        textColor: AppColors.white,
      );
      textarea.clear();
    } on ErrorResponse catch (e) {
      Get.back();
      debugPrint(e.toString());

      Logger().d(e.error?.detail ?? '');
    } catch (e) {
      Get.back();
      Fluttertoast.showToast(
        msg: 'An error occurred',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppColors.red,
        textColor: AppColors.white,
      );
      Logger().d(e);
    } finally {
      // Set loading to false when the request is completed (whether it succeeds or fails)
      isLoadingReport.value = false;
    }
  }

  ///Animation
  void reportAnimation() {
    isVisibleReport = false;
    isOpenedReport.value = true;
    reportAnimationController.forward();

    update(["visiblePag", "reportPage"]);
  }

  ///Singleoffer
  final _singleOfferCard = SingleOfferCardResponceDto().obs;
  SingleOfferCardResponceDto get singleOfferCard => _singleOfferCard.value;
  set singleOfferCard(SingleOfferCardResponceDto value) =>
      _singleOfferCard.value = value;

  final _isVisibleOfferScreen = true.obs;
  bool get isVisibleOfferScreen => _isVisibleOfferScreen.value;
  set isVisibleOfferScreen(bool value) => _isVisibleOfferScreen.value = value;

  var isLoadingSingleOffer = true.obs;

  RxBool isOpenedOfferScreen = false.obs;

  late final AnimationController singlrOfferAnimationController;

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

  void singleOffer() {
    isVisibleOfferScreen = false;
    isOpenedOfferScreen.value = true;
    singlrOfferAnimationController.forward();
    update(["sigleOffervisiblePage"]);
  }

//Multiple Offer
  final _multipleOfferCard = MultipleOfferCardResponceDto().obs;
  MultipleOfferCardResponceDto get multipleOfferCard =>
      _multipleOfferCard.value;
  set multipleOfferCard(MultipleOfferCardResponceDto value) =>
      _multipleOfferCard.value = value;

  final _isVisibleMultipleOffers = true.obs;
  bool get isVisibleMultipleOffers => _isVisibleMultipleOffers.value;
  set isVisibleMultipleOffers(bool value) =>
      _isVisibleMultipleOffers.value = value;

  late final AnimationController animationControllerMultipleOffers;
  Rx<String> selectedaddress = "".obs;
  RxBool isOpenedMultipleOffers = false.obs;

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
  void multiOffer() {
    isVisibleMultipleOffers = false;
    isOpenedMultipleOffers.value = true;
    animationControllerMultipleOffers.forward();
    update(["multiplervisiblePage"]);
  }

  /// Google Map
  final RxString location = ''.obs;
  Future<void> launchMap(
      String latitude, String longitude, String barnName) async {
    // Define the Google Maps URL with the destination
    String googleMapsUrl =
        'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(location.value)}';

    // Check the platform and launch the appropriate URL
    if (GetPlatform.isAndroid) {
      // Open in Google Maps on Android
      await launch(googleMapsUrl);
    } else if (GetPlatform.isIOS) {
      // Open in Apple Maps on iOS
      await launch(
          'https://maps.apple.com/?q=${Uri.encodeComponent(location.value)}');
    } else {
      // Handle unsupported platform, e.g., show a snackbar
      Get.snackbar('Error', 'Unsupported platform');
    }
  }

  /// For Fetch Location Suggestions

  ws.GoogleMapsPlaces places =
      ws.GoogleMapsPlaces(apiKey: 'AIzaSyCpL_AnZNobvqT2VnkL2lG7EjoPGD0h348');
  Rx<LatLng> placedetails = const LatLng(0, 0).obs;
  final _locationsuggestionsData = LocationSuggestion().obs;
  LocationSuggestion get locationSuggestionsData =>
      _locationsuggestionsData.value;
  set locationSuggestionsData(LocationSuggestion value) =>
      _locationsuggestionsData.value = value;
  Future<LatLng> getPlaceLatLng(String placeId, BuildContext context) async {
    locationSuggestionsData.predictions!.clear();
    // searchResults.clear();
    FocusScope.of(context).unfocus();

    final placeDetails = await places.getDetailsByPlaceId(placeId);

    if (placeDetails.hasNoResults) {
      return LatLng(placeDetails.result.geometry!.location.lat,
          placeDetails.result.geometry!.location.lng);
    }

    locations.clear();
    isLoading.value = true;
    selectedaddress.value = placeDetails.result.name;
    searchTextEditingController.text = placeDetails.result.name;

    if (ismapCreated.value) {
      // googleMapController!.moveCamera(
      //   CameraUpdate.newLatLng(
      //     LatLng(placeDetails.result.geometry!.location.lat,
      //         placeDetails.result.geometry!.location.lng),
      //   ),
      // );
    }

    getFindChargesListLoctionsList(
      latitude: locationController.latitude.value!,
      longitude: locationController.longitude.value!,
      secondlatitude: placeDetails.result.geometry!.location.lat,
      secondlongitude: placeDetails.result.geometry!.location.lng,
    );

    await getFindChargesListLoctionsListForMap(
        long: placeDetails.result.geometry!.location.lng,
        lat: placeDetails.result.geometry!.location.lat);

    isListViewVisible = true;
    isMapListViewVisible = true;
    placedetails = Rx(LatLng(
      placeDetails.result.geometry!.location.lat,
      placeDetails.result.geometry!.location.lng,
    ));
    update();

    googleMapController!
        .moveCamera(
          CameraUpdate.newLatLng(
            LatLng(placeDetails.result.geometry!.location.lat,
                placeDetails.result.geometry!.location.lng),
          ),
        )
        .obs;

    return LatLng(placeDetails.result.geometry!.location.lat,
        placeDetails.result.geometry!.location.lng);
  }

  Future<void> fetchSuggestions(String query) async {
    isLoading.value = true;
    final request =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&location=${locationController.latitude},${locationController.longitude}&key=AIzaSyCpL_AnZNobvqT2VnkL2lG7EjoPGD0h348';
    final response = await client.get(
      Uri.parse(request),
    );

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['status'] == 'OK') {
        locationSuggestionsData = LocationSuggestion.fromJson(result);
        isLoading.value = false;
        // return LocationSuggestion.fromJson(result);
      }
    } else {
      isLoading.value = false;

      throw Exception('Failed to fetch suggestion');
    }
    isLoading.value = false;

    throw UnimplementedError();
  }
}

// class Place with ClusterItem {
//   final String name;
//   final bool isClosed;
//   final LatLng latLng;

//   Place({required this.name, required this.latLng, this.isClosed = false});

//   @override
//   String toString() {
//     return 'Place $name (closed : $isClosed)';
//   }

//   @override
//   LatLng get location => latLng;
// }
