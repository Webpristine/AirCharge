// To parse this JSON data, do
//
//     final batteryPercentageResponceDto = batteryPercentageResponceDtoFromJson(jsonString);

import 'dart:convert';

BatteryPercentageResponceDto batteryPercentageResponceDtoFromJson(String str) => BatteryPercentageResponceDto.fromJson(json.decode(str));

String batteryPercentageResponceDtoToJson(BatteryPercentageResponceDto data) => json.encode(data.toJson());

class BatteryPercentageResponceDto {
    int? code;

    BatteryPercentageResponceDto({
        this.code,
    });

    factory BatteryPercentageResponceDto.fromJson(Map<String, dynamic> json) => BatteryPercentageResponceDto(
        code: json["code"],
    );

    Map<String, dynamic> toJson() => {
        "code": code,
    };
}
