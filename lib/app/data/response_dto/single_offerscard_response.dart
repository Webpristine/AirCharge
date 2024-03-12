// To parse this JSON data, do
//
//     final singleOfferCardResponceDto = singleOfferCardResponceDtoFromJson(jsonString);

import 'dart:convert';

SingleOfferCardResponceDto singleOfferCardResponceDtoFromJson(String str) => SingleOfferCardResponceDto.fromJson(json.decode(str));

String singleOfferCardResponceDtoToJson(SingleOfferCardResponceDto data) => json.encode(data.toJson());

class SingleOfferCardResponceDto {
    int? code;
    String? message;
    Offer? offer;

    SingleOfferCardResponceDto({
        this.code,
        this.message,
        this.offer,
    });

    factory SingleOfferCardResponceDto.fromJson(Map<String, dynamic> json) => SingleOfferCardResponceDto(
        code: json["code"],
        message: json["message"],
        offer: json["offer"] == null ? null : Offer.fromJson(json["offer"]),
    );

    Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "offer": offer?.toJson(),
    };
}

class Offer {
    int? code;
    String? brandName;
    String? brandLogo;
    String? offerImage;
    String? headerText;
    String? detailText;
    String? buttonText;
    String? buttonBgColor;
    String? buttonTextColor;
    String? buttonLink;
    String? endDate;

    Offer({
        this.code,
        this.brandName,
        this.brandLogo,
        this.offerImage,
        this.headerText,
        this.detailText,
        this.buttonText,
        this.buttonBgColor,
        this.buttonTextColor,
        this.buttonLink,
        this.endDate,
    });

    factory Offer.fromJson(Map<String, dynamic> json) => Offer(
        code: json["code"],
        brandName: json["brand_name"],
        brandLogo: json["brand_logo"],
        offerImage: json["offer_image"],
        headerText: json["header_text"],
        detailText: json["detail_text"],
        buttonText: json["button_text"],
        buttonBgColor: json["button_bg_color"],
        buttonTextColor: json["button_text_color"],
        buttonLink: json["button_link"],
        endDate: json["end_date"],
    );

    Map<String, dynamic> toJson() => {
        "code": code,
        "brand_name": brandName,
        "brand_logo": brandLogo,
        "offer_image": offerImage,
        "header_text": headerText,
        "detail_text": detailText,
        "button_text": buttonText,
        "button_bg_color": buttonBgColor,
        "button_text_color": buttonTextColor,
        "button_link": buttonLink,
        "end_date": endDate,
    };
}
