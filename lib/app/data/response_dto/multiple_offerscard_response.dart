// To parse this JSON data, do
//
//     final multipleOfferCardResponceDto = multipleOfferCardResponceDtoFromJson(jsonString);

import 'dart:convert';

MultipleOfferCardResponceDto multipleOfferCardResponceDtoFromJson(String str) =>
    MultipleOfferCardResponceDto.fromJson(json.decode(str));

String multipleOfferCardResponceDtoToJson(MultipleOfferCardResponceDto data) =>
    json.encode(data.toJson());

class MultipleOfferCardResponceDto {
  int? code;
  String? message;
  String? brandName;
  String? brandLogo;
  List<Offer>? offers;

  MultipleOfferCardResponceDto({
    this.code,
    this.message,
    this.brandName,
    this.brandLogo,
    this.offers,
  });

  factory MultipleOfferCardResponceDto.fromJson(Map<String, dynamic> json) =>
      MultipleOfferCardResponceDto(
        code: json["code"],
        message: json["message"],
        brandName: json["brand_name"],
        brandLogo: json["brand_logo"],
        offers: json["offers"] == null
            ? []
            : List<Offer>.from(json["offers"]!.map((x) => Offer.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "brand_name": brandName,
        "brand_logo": brandLogo,
        "offers": offers == null
            ? []
            : List<dynamic>.from(offers!.map((x) => x.toJson())),
      };
}

class Offer {
  int? offerId;
  String? headerText;
  String? detailText;
  String? offerImage;
  String? endDate;

  Offer({
    this.offerId,
    this.headerText,
    this.detailText,
    this.offerImage,
    this.endDate,
  });

  factory Offer.fromJson(Map<String, dynamic> json) => Offer(
        offerId: json["offer_id"],
        headerText: json["header_text"],
        detailText: json["detail_text"],
        offerImage: json["offer_image"],
        endDate: json["end_date"],
      );

  Map<String, dynamic> toJson() => {
        "offer_id": offerId,
        "header_text": headerText,
        "detail_text": detailText,
        "offer_image": offerImage,
        "end_date": endDate,
      };
}
