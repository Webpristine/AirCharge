// To parse this JSON data, do
//
//     final SettingRequestDto = SettingRequestDtoFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

SettingRequestDto settingRequestDtoFromJson(String str) =>
    SettingRequestDto.fromJson(json.decode(str));

String settingRequestDtoToJson(SettingRequestDto data) =>
    json.encode(data.toJson());

class SettingRequestDto {
  String? deviceId;
  String? fcmId;
  String? lowPowerNotifications;
  String? notificationOnWifi;
  String? customAlertRadius;
  String? customAlertRadiusKm;
  String? customAlertRadiusMiles;
  String? batteryPercentageAlertThreshold;
  String? allowPowerMonitoring;
  String? allowLocationTracking;
  String? showMarkerMode;
  String? distanceUnit;

  SettingRequestDto({
    this.deviceId,
    this.fcmId,
    this.lowPowerNotifications,
    this.notificationOnWifi,
    this.customAlertRadius,
    this.customAlertRadiusKm,
    this.customAlertRadiusMiles,
    this.batteryPercentageAlertThreshold,
    this.allowPowerMonitoring,
    this.allowLocationTracking,
    this.showMarkerMode,
    this.distanceUnit,
  });

  factory SettingRequestDto.fromJson(Map<String, dynamic> json) =>
      SettingRequestDto(
        deviceId: json["device_id"],
        fcmId: json["fcm_id"],
        lowPowerNotifications: json["low_power_notifications"],
        notificationOnWifi: json["notification_on_wifi"],
        customAlertRadius: json["custom_alert_radius"],
        customAlertRadiusKm: json["custom_alert_radius_km"],
        customAlertRadiusMiles: json["custom_alert_radius_miles"],
        batteryPercentageAlertThreshold:
            json["battery_percentage_alert_threshold"],
        allowPowerMonitoring: json["allow_power_monitoring"],
        allowLocationTracking: json["allow_location_tracking"],
        showMarkerMode: json["show_marker_mode"],
        distanceUnit: json["distance_unit"],
      );

  Map<String, dynamic> toJson() => {
        "device_id": deviceId,
        "fcm_id": fcmId,
        "low_power_notifications": lowPowerNotifications,
        "notification_on_wifi": notificationOnWifi,
        "custom_alert_radius": customAlertRadius,
        "custom_alert_radius_km": customAlertRadiusKm,
        "custom_alert_radius_miles":customAlertRadiusMiles,
        "battery_percentage_alert_threshold": batteryPercentageAlertThreshold,
        "allow_power_monitoring": allowPowerMonitoring,
        "allow_location_tracking": allowLocationTracking,
        "show_marker_mode": showMarkerMode,
        "distance_unit": distanceUnit,
      };
}
