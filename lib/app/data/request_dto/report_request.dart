// To parse this JSON data, do
//
//     final SettingRequestDto = SettingRequestDtoFromJson(jsonString);

import 'dart:convert';

ReportRequestDto reportRequestDtoFromJson(String str) =>
    ReportRequestDto.fromJson(json.decode(str));

String reportRequestDtoToJson(ReportRequestDto data) =>
    json.encode(data.toJson());

class ReportRequestDto {
  String? locationId;
  String? comment;

  ReportRequestDto({
    this.locationId,
    this.comment,
  });

  factory ReportRequestDto.fromJson(Map<String, dynamic> json) =>
      ReportRequestDto(
        locationId: json["location_id"],
        comment: json["comment"],
      );

  Map<String, dynamic> toJson() => {
        "location_id": locationId,
        "comment": comment,
      };
}

