import 'package:aircharge/app/core/constants/urls.dart';
import 'package:aircharge/app/data/network/api_controller.dart';
import 'package:aircharge/app/data/request_dto/battery-percentage_request.dart';
import 'package:aircharge/app/data/request_dto/report_request.dart';
import 'package:aircharge/app/data/request_dto/setting-request.dart';
import 'package:aircharge/app/data/response_dto/battery_percentage_response.dart';
import 'package:aircharge/app/data/response_dto/local_locations_response.dart';
import 'package:aircharge/app/data/response_dto/loctions_details_response.dart';
import 'package:aircharge/app/data/response_dto/loctions_response.dart';
import 'package:aircharge/app/data/response_dto/multiple_offerscard_response.dart';
import 'package:aircharge/app/data/response_dto/offerscard_response.dart';
import 'package:aircharge/app/data/response_dto/report_response.dart';
import 'package:aircharge/app/data/response_dto/settings_response.dart';
import 'package:aircharge/app/data/response_dto/single_offerscard_response.dart';
import 'package:aircharge/app/data/response_dto/sponsers_response.dart';

class ApiRepostory {
  final ApiControllerV1 apiControllerV1;

  ApiRepostory({required this.apiControllerV1});

  //  ++++++++++++++++++++++++++++ First Page +++++++++++++++++++++++++++++++

//MARK: Sponsers Card
  Future<SponsersResponceDto> sponsersCard() async {
    final response = await apiControllerV1.get(
      path: ApiEndPoints.sponsersCard,
    );
    return SponsersResponceDto.fromJson(response);
  }

//MARK: Offers Card
  Future<OfferCardResponceDto> offerCardList(
    double latitude,
    double longitude,
    int pageNumber,
    // int pageNumber,
    // int showMarkerMode,
  ) async {
    final response = await apiControllerV1.get(
      path: ApiEndPoints.offerCards(latitude, longitude, pageNumber),

      // path: ApiEndPoints.offerCards,
    );
    return OfferCardResponceDto.fromJson(response);
  }

//MARK: Single Offers Card
  Future<SingleOfferCardResponceDto> singleOfferCardList(
    int id,
  ) async {
    final response =
        await apiControllerV1.get(path: ApiEndPoints.singleOfferCards(id)
            // path: ApiEndPoints.offerCards,
            );
    return SingleOfferCardResponceDto.fromJson(response);
  }

//MARK: Multiple Offers Card
  Future<MultipleOfferCardResponceDto> multipleOfferCardList(
    int id,
  ) async {
    final response =
        await apiControllerV1.get(path: ApiEndPoints.multipleOfferCards(id)
            // path: ApiEndPoints.offerCards,
            );
    return MultipleOfferCardResponceDto.fromJson(response);
  }

//  ++++++++++++++++++++++++++++ Second Page +++++++++++++++++++++++++++++++

  //MARK: findChargesLoctionsList
  Future<GetLocationsResponceDto> findChargesLoctionsList({
    required double latitude,
    required double longitude,
    required int pageNumber,
    required double secondlatitude,
    required double secondlongitude,
  }
      // int dataLimit,
      // int showMarkerMode,
      // int pageNumber,
      // [int? page,
      // int? pageSize,
      // int? dynamicItemsPerPage,
      // ]
      // dynamic seacrValue,
      ) async {
    final response = await apiControllerV1.get(
        path: ApiEndPoints.findChargesLoctionsList(
            latitude: latitude,
            longitude: longitude,
            pageNumber: pageNumber,
            secondlatitude: secondlatitude,
            secondlongitude: secondlongitude
            // dataLimit,
            // showMarkerMode,
            // seacrValue
            ));
    return GetLocationsResponceDto.fromJson(response);
  }

  Future<GetLocalLocationsResponceDto> findChargesLoctionsListAll({
    required double latitude,
    required double longitude,
    required int pageNumber,
  }
      // int dataLimit,
      // int showMarkerMode,
      // int pageNumber,
      // [int? page,
      // int? pageSize,
      // int? dynamicItemsPerPage,
      // ]
      // dynamic seacrValue,
      ) async {
    final response = await apiControllerV1.get(
        path: ApiEndPoints.findChargesLoctionsListAll(
      latitude: latitude, longitude: longitude, pageNumber: pageNumber,
      // dataLimit,
      // showMarkerMode,
      // seacrValue
    ));
    return GetLocalLocationsResponceDto.fromJson(response);
  }

  Future<GetLocationsResponceDto> findChargesLoctionSearchsList(
    double latitude,
    double longitude,
    int pageNumber,
    // int dataLimit,
    // int showMarkerMode,
    dynamic seacrValue,
    // int pageNumber
  ) async {
    final response = await apiControllerV1.get(
        path: ApiEndPoints.findChargesLoctionsearchList(
            latitude,
            longitude,
            pageNumber,
            // dataLimit,
            // showMarkerMode,
            seacrValue));
    return GetLocationsResponceDto.fromJson(response);
  }

//MARK: findChargesLoctionsDetails
  Future<LocationsDetailsResponceDto> findChargesLoctionsDetails(
    int id,
    double latitude,
    double longitude,
  ) async {
    final response = await apiControllerV1.get(
        path: ApiEndPoints.findChargesLoctionsDetails(id, latitude, longitude));
    return LocationsDetailsResponceDto.fromJson(response);
  }

//MARK: report
  Future<ReportResponceDto> report(
      {required ReportRequestDto requestDTO}) async {
    final response = await apiControllerV1.post(
        path: ApiEndPoints.report, data: requestDTO.toJson());
    return ReportResponceDto.fromJson(response);
  }

  //MARK: battery
  Future<BatteryPercentageResponceDto> battery(
      {required BatteryPercentageRequestDto requestDTO}) async {
    final response = await apiControllerV1.post(
        path: ApiEndPoints.battery, data: requestDTO.toJson());
    return BatteryPercentageResponceDto.fromJson(response);
  }

//MARK: Settings
  Future<SettingsResponceDto> setting(
      {required SettingRequestDto requestDTO}) async {
    final response = await apiControllerV1.post(
        path: ApiEndPoints.setting, data: requestDTO.toJson());
    return SettingsResponceDto.fromJson(response);
  }

//MARK:Get Setting
  Future<SettingsResponceDto> getSetting(
    String deviceId,
  ) async {
    final response =
        await apiControllerV1.get(path: ApiEndPoints.getsetting(deviceId)
            // path: ApiEndPoints.offerCards,
            );
    return SettingsResponceDto.fromJson(response);
  }
}
