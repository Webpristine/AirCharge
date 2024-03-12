// To parse this JSON data, do
//
//     final getLocationsResponceDto = getLocationsResponceDtoFromJson(jsonString);

import 'dart:convert';

GetLocationsResponceDto getLocationsResponceDtoFromJson(String str) =>
    GetLocationsResponceDto.fromJson(json.decode(str));

String getLocationsResponceDtoToJson(GetLocationsResponceDto data) =>
    json.encode(data.toJson());

class GetLocationsResponceDto {
  int? code;
  String? message;
  List<Location>? locations;

  GetLocationsResponceDto({
    this.code,
    this.message,
    this.locations,
  });

  factory GetLocationsResponceDto.fromJson(Map<String, dynamic> json) =>
      GetLocationsResponceDto(
        code: json["code"],
        message: json["message"],
        locations: json["locations"] == null
            ? []
            : List<Location>.from(
                json["locations"]!.map((x) => Location.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "locations": locations == null
            ? []
            : List<dynamic>.from(locations!.map((x) => x.toJson())),
      };
}

class Location {
  int? locationId;
  String? logoUrl;
  String? brandName;
  String? friendlyName;
  dynamic latitude;
  dynamic longitude;
  String? distance;
  int? showLocation;

  Location({
    this.locationId,
    this.logoUrl,
    this.brandName,
    this.friendlyName,
    this.latitude,
    this.longitude,
    this.distance,
    this.showLocation,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        locationId: json["location_id"],
        logoUrl: json["logo_url"],
        // brandName: brandNameValues.map[json["brand_name"]]!,
        brandName: json["brand_name"],
        friendlyName: json["friendly_name"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        distance: json["distance"],
        showLocation: json["show_location"],
      );

  Map<String, dynamic> toJson() => {
        "location_id": locationId,
        "logo_url": logoUrl,
        // "brand_name": brandNameValues.reverse[brandName],
        "brand_name": brandName,
        "friendly_name": friendlyName,
        "latitude": latitude,
        "longitude": longitude,
        "distance": distance,
        "show_location": showLocation,
      };
}

enum BrandName { IBIS, IBIS_BUDGET, MC_DONALD_S }

final brandNameValues = EnumValues({
  "Ibis": BrandName.IBIS,
  "Ibis Budget": BrandName.IBIS_BUDGET,
  "McDonald's": BrandName.MC_DONALD_S
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
