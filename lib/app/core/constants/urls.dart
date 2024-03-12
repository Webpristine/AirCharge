import 'package:aircharge/app/core/constants/enums.dart';
import 'package:aircharge/app/core/service/env_service.dart';

class URLs {
  static String get base {
    final environment = EnvServices.environment;
    switch (environment) {
      case Environment.dev:
        return 'https://webpristine.com/Aircharge/api/';
      case Environment.stage:
        return 'https://webpristine.com/Aircharge/api/';
      case Environment.production:
        return 'https://webpristine.com/Aircharge/api/';
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
  static String findChargesLoctionsList(
    double latitude,
    double longitude,
        int pageNumber,

    // int dataLimit,
    // int showMarkerMode,
  ) =>
      '/locations/$latitude/$longitude/$pageNumber/';

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
