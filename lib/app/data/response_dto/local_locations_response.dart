// To parse this JSON data, do
//
//     final getLocalLocationsResponceDto = getLocalLocationsResponceDtoFromJson(jsonString);

import 'dart:convert';

GetLocalLocationsResponceDto getLocalLocationsResponceDtoFromJson(String str) =>
    GetLocalLocationsResponceDto.fromJson(json.decode(str));

String getLocalLocationsResponceDtoToJson(GetLocalLocationsResponceDto data) =>
    json.encode(data.toJson());

class GetLocalLocationsResponceDto {
  int? code;
  String? message;
  List<Location>? locations;

  GetLocalLocationsResponceDto({
    this.code,
    this.message,
    this.locations,
  });

  factory GetLocalLocationsResponceDto.fromJson(Map<String, dynamic> json) =>
      GetLocalLocationsResponceDto(
          code: json["code"],
          message: json["message"],
          locations: json["locations"] != null
              ? new List<Location>.from(
                  json["locations"].map((x) => Location.fromJson(x)))
              : []
          // locations: List<Location>.from(
          //     json["locations"].map((x) => Location.fromJson(x))),
          );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "locations": List<dynamic>.from(locations!.map((x) => x.toJson())),
      };
}

class Location {
  int locationId;
  String logoUrl;
  String brandName;
  String friendlyName;
  double latitude;
  double longitude;
  String distance;
  int showLocation;

  Location({
    required this.locationId,
    required this.logoUrl,
    required this.brandName,
    required this.friendlyName,
    required this.latitude,
    required this.longitude,
    required this.distance,
    required this.showLocation,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        locationId: json["location_id"],
        logoUrl: json["logo_url"],
        brandName: json["brand_name"],
        friendlyName: json["friendly_name"]!,
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        distance: json["distance"],
        showLocation: json["show_location"],
      );

  Map<String, dynamic> toJson() => {
        "location_id": locationId,
        "logo_url": logoUrl,
        "brand_name": brandName,
        "friendly_name": [friendlyName],
        "latitude": latitude,
        "longitude": longitude,
        "distance": distance,
        "show_location": showLocation,
      };
}
