// To parse this JSON data, do
//
//     final reportResponceDto = reportResponceDtoFromJson(jsonString);

import 'dart:convert';

ReportResponceDto reportResponceDtoFromJson(String str) => ReportResponceDto.fromJson(json.decode(str));

String reportResponceDtoToJson(ReportResponceDto data) => json.encode(data.toJson());

class ReportResponceDto {
    String? message;

    ReportResponceDto({
        this.message,
    });

    factory ReportResponceDto.fromJson(Map<String, dynamic> json) => ReportResponceDto(
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "message": message,
    };
}
