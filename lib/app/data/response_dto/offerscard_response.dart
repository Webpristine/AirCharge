// To parse this JSON data, do
//
//     final offerCardResponceDto = offerCardResponceDtoFromJson(jsonString);

import 'dart:convert';

OfferCardResponceDto offerCardResponceDtoFromJson(String str) =>
    OfferCardResponceDto.fromJson(json.decode(str));

String offerCardResponceDtoToJson(OfferCardResponceDto data) =>
    json.encode(data.toJson());

class OfferCardResponceDto {
  int? code;
  String? message;
  List<Offer>? offers;

  OfferCardResponceDto({
    this.code,
    this.message,
    this.offers,
  });

  factory OfferCardResponceDto.fromJson(Map<String, dynamic> json) =>
      OfferCardResponceDto(
        code: json["code"],
        message: json["message"],
        offers: json["offers"] == null
            ? []
            : List<Offer>.from(json["offers"]!.map((x) => Offer.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "offers": offers == null
            ? []
            : List<dynamic>.from(offers!.map((x) => x.toJson())),
      };
}

class Offer {
  int? offerId;
  int? brandId;
  dynamic friendlyName;
  String? headerText;
  String? offerImage;
  int? isMultiple;

  Offer({
    this.offerId,
    this.brandId,
    this.friendlyName,
    this.headerText,
    this.offerImage,
    this.isMultiple,
  });

  factory Offer.fromJson(Map<String, dynamic> json) => Offer(
        offerId: json["offer_id"],
        brandId: json["brand_id"],
        friendlyName: json["friendly_name"],
        headerText: json["header_text"],
        offerImage: json["offer_image"],
        isMultiple: json["is_multiple"],
      );

  Map<String, dynamic> toJson() => {
        "offer_id": offerId,
        "brand_id": brandId,
        "friendly_name": friendlyName,
        "header_text": headerText,
        "offer_image": offerImage,
        "is_multiple": isMultiple,
      };
}
