// To parse this JSON data, do
//
//     final sponsersResponceDto = sponsersResponceDtoFromJson(jsonString);

import 'dart:convert';

SponsersResponceDto sponsersResponceDtoFromJson(String str) => SponsersResponceDto.fromJson(json.decode(str));

String sponsersResponceDtoToJson(SponsersResponceDto data) => json.encode(data.toJson());

class SponsersResponceDto {
    int? code;
    String? message;
    List<Sponsor>? sponsors;

    SponsersResponceDto({
        this.code,
        this.message,
        this.sponsors,
    });

    factory SponsersResponceDto.fromJson(Map<String, dynamic> json) => SponsersResponceDto(
        code: json["code"],
        message: json["message"],
        sponsors: json["sponsors"] == null ? [] : List<Sponsor>.from(json["sponsors"]!.map((x) => Sponsor.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "sponsors": sponsors == null ? [] : List<dynamic>.from(sponsors!.map((x) => x.toJson())),
    };
}

class Sponsor {
    String? imageUrl;
    String? linkUrl;

    Sponsor({
        this.imageUrl,
        this.linkUrl,
    });

    factory Sponsor.fromJson(Map<String, dynamic> json) => Sponsor(
        imageUrl: json["image_url"],
        linkUrl: json["link_url"],
    );

    Map<String, dynamic> toJson() => {
        "image_url": imageUrl,
        "link_url": linkUrl,
    };
}
