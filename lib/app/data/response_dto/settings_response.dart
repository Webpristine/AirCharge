// // To parse this JSON data, do
// //
// //     final settingsResponceDto = settingsResponceDtoFromJson(jsonString);

// import 'dart:convert';

// SettingsResponceDto settingsResponceDtoFromJson(String str) =>
//     SettingsResponceDto.fromJson(json.decode(str));

// String settingsResponceDtoToJson(SettingsResponceDto data) =>
//     json.encode(data.toJson());

// class SettingsResponceDto {
//   int? code;
//   String? message;
//   Setting? setting;

//   SettingsResponceDto({
//     this.code,
//     this.message,
//     this.setting,
//   });

//   factory SettingsResponceDto.fromJson(Map<String, dynamic> json) =>
//       SettingsResponceDto(
//         code: json["code"],
//         message: json["message"],
//         setting:
//             json["setting"] == null ? null : Setting.fromJson(json["setting"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "code": code,
//         "message": message,
//         "setting": setting?.toJson(),
//       };
// }

// class Setting {
//   bool? lowPowerNotifications;
//   bool? notificationOnWifi;
//   int? customAlertRadius;
//   int? batteryPercentageAlertThreshold;
//   bool? allowPowerMonitoring;
//   bool? allowLocationTracking;
//   bool? showMarkerMode;
//   String? distanceUnit;

//   Setting({
//     this.lowPowerNotifications,
//     this.notificationOnWifi,
//     this.customAlertRadius,
//     this.batteryPercentageAlertThreshold,
//     this.allowPowerMonitoring,
//     this.allowLocationTracking,
//     this.showMarkerMode,
//     this.distanceUnit,
//   });

//   factory Setting.fromJson(Map<String, dynamic> json) => Setting(
//         lowPowerNotifications: json["low_power_notifications"],
//         notificationOnWifi: json["notification_on_wifi"],
//         customAlertRadius: json["custom_alert_radius"],
//         batteryPercentageAlertThreshold:
//             json["battery_percentage_alert_threshold"],
//         allowPowerMonitoring: json["allow_power_monitoring"],
//         allowLocationTracking: json["allow_location_tracking"],
//         showMarkerMode: json["show_marker_mode"],
//         distanceUnit: json["distance_unit"],
//       );

//   Map<String, dynamic> toJson() => {
//         "low_power_notifications": lowPowerNotifications,
//         "notification_on_wifi": notificationOnWifi,
//         "custom_alert_radius": customAlertRadius,
//         "battery_percentage_alert_threshold": batteryPercentageAlertThreshold,
//         "allow_power_monitoring": allowPowerMonitoring,
//         "allow_location_tracking": allowLocationTracking,
//         "show_marker_mode": showMarkerMode,
//         "distance_unit": distanceUnit,
//       };
// }


// To parse this JSON data, do
//
//     final settingsResponceDto = settingsResponceDtoFromJson(jsonString);

import 'dart:convert';

SettingsResponceDto settingsResponceDtoFromJson(String str) => SettingsResponceDto.fromJson(json.decode(str));

String settingsResponceDtoToJson(SettingsResponceDto data) => json.encode(data.toJson());

class SettingsResponceDto {
    int? code;
    String? message;
    Setting? setting;

    SettingsResponceDto({
        this.code,
        this.message,
        this.setting,
    });

    factory SettingsResponceDto.fromJson(Map<String, dynamic> json) => SettingsResponceDto(
        code: json["code"],
        message: json["message"],
        setting: json["setting"] == null ? null : Setting.fromJson(json["setting"]),
    );

    Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "setting": setting?.toJson(),
    };
}

class Setting {
    bool? lowPowerNotifications;
    bool? notificationOnWifi;
    int? customAlertRadius;
    int? customAlertRadiusKm;
    int? customAlertRadiusMiles;
    String? customAlertDistanceUnit;
    int? batteryPercentageAlertThreshold;
    bool? allowPowerMonitoring;
    bool? allowLocationTracking;
    bool? showMarkerMode;
    String? distanceUnit;

    Setting({
        this.lowPowerNotifications,
        this.notificationOnWifi,
        this.customAlertRadius,
        this.customAlertRadiusKm,
        this.customAlertRadiusMiles,
        this.customAlertDistanceUnit,
        this.batteryPercentageAlertThreshold,
        this.allowPowerMonitoring,
        this.allowLocationTracking,
        this.showMarkerMode,
        this.distanceUnit,
    });

    factory Setting.fromJson(Map<String, dynamic> json) => Setting(
        lowPowerNotifications: json["low_power_notifications"],
        notificationOnWifi: json["notification_on_wifi"],
        customAlertRadius: json["custom_alert_radius"],
        customAlertRadiusKm: json["custom_alert_radius_km"],
        customAlertRadiusMiles: json["custom_alert_radius_miles"],
        customAlertDistanceUnit: json["custom_alert_distance_unit"],
        batteryPercentageAlertThreshold: json["battery_percentage_alert_threshold"],
        allowPowerMonitoring: json["allow_power_monitoring"],
        allowLocationTracking: json["allow_location_tracking"],
        showMarkerMode: json["show_marker_mode"],
        distanceUnit: json["distance_unit"],
    );

    Map<String, dynamic> toJson() => {
        "low_power_notifications": lowPowerNotifications,
        "notification_on_wifi": notificationOnWifi,
        "custom_alert_radius": customAlertRadius,
        "custom_alert_radius_km": customAlertRadiusKm,
        "custom_alert_radius_miles": customAlertRadiusMiles,
        "custom_alert_distance_unit": customAlertDistanceUnit,
        "battery_percentage_alert_threshold": batteryPercentageAlertThreshold,
        "allow_power_monitoring": allowPowerMonitoring,
        "allow_location_tracking": allowLocationTracking,
        "show_marker_mode": showMarkerMode,
        "distance_unit": distanceUnit,
    };
}
