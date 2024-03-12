// To parse this JSON data, do
//
//     final batteryPercentageRequestDto = batteryPercentageRequestDtoFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

BatteryPercentageRequestDto batteryPercentageRequestDtoFromJson(String str) =>
    BatteryPercentageRequestDto.fromJson(json.decode(str));

String batteryPercentageRequestDtoToJson(BatteryPercentageRequestDto data) =>
    json.encode(data.toJson());

class BatteryPercentageRequestDto {
  String? deviceId;
  String? latitude;
  String? longitude;
  String? batteryPercentage;
  String? wifi;

  BatteryPercentageRequestDto({
    this.deviceId,
    this.latitude,
    this.longitude,
    this.batteryPercentage,
    this.wifi,
  });

  factory BatteryPercentageRequestDto.fromJson(Map<String, dynamic> json) =>
      BatteryPercentageRequestDto(
        deviceId: json["device_id"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        batteryPercentage: json["battery_percentage"],
        wifi: json["wifi"],
      );

  Map<String, dynamic> toJson() => {
        "device_id": deviceId,
        "latitude": latitude,
        "longitude": longitude,
        "battery_percentage": batteryPercentage,
        "wifi": wifi,
      };
}
