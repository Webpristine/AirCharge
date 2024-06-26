import 'package:aircharge/app/core/constants/enums.dart';
import 'package:aircharge/app/core/service/env_service.dart';

class URLs {
  static String get base {
    final environment = EnvServices.environment;
    switch (environment) {
      case Environment.dev:
        return 'http://34.70.241.7/api/';
      case Environment.stage:
        return 'http://34.70.241.7/api/';
      case Environment.production:
        return 'http://34.70.241.7/api/';
    }
  }

  // static String initateURL = "https://webpristine.com/Aircharge/api/";
}

abstract class ApiEndPoints {
  // static const String findChargesLoctionsList =
  //     "/locations/30.710489/76.852386/0/2/";
  static const String sponsersCard = "sponsors";
  static String offerCards(
    double latitude,
    double longitude,
    int pageNumber,
    // int pageNumber,
    // int showMarkerMode,
  ) =>
      'offers/$latitude/$longitude/$pageNumber';
  static String singleOfferCards(int id) => 'offer/$id';
  static String multipleOfferCards(int id) => 'multiple_offers/$id';
  static String findChargesLoctionsList({
    required double latitude,
    required double longitude,
    required int pageNumber,
    required double secondlatitude,
    required double secondlongitude,
  }

          // int dataLimit,
          // int showMarkerMode,
          ) =>
      '/locations/$latitude/$longitude/$pageNumber/${secondlatitude == 0.0 ? 0 : secondlatitude}/${secondlongitude == 0.0 ? 0 : secondlongitude}';

  static String findChargesLoctionsListAll({
    required double latitude,
    required double longitude,
    required int pageNumber,
    // required double secondlatitude,
    // required double secondlongitude,
  }

          // int dataLimit,
          // int showMarkerMode,
          ) =>
      '/map_locations/$latitude/$longitude/$pageNumber';

  static String findChargesLoctionsearchList(
    double latitude,
    double longitude,
    // int dataLimit,
    // int showMarkerMode,
    int pageNumber,
    dynamic seacrValue,
  ) =>
      '/locations/$latitude/$longitude/$pageNumber/$seacrValue';

  static String findChargesLoctionsDetails(
    int id,
    double latitude,
    double longitude,
  ) =>
      'location/$id/$latitude/$longitude';
  static const String report = "reports";
  static const String battery = "battery";
  static const String setting = "settings";
  static String getsetting(
    String deviceId,
  ) =>
      'setting/$deviceId';
}
