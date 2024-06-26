// To parse this JSON data, do
//
//     final locationsDetailsResponceDto = locationsDetailsResponceDtoFromJson(jsonString);

import 'dart:convert';

LocationsDetailsResponceDto locationsDetailsResponceDtoFromJson(String str) =>
    LocationsDetailsResponceDto.fromJson(json.decode(str));

String locationsDetailsResponceDtoToJson(LocationsDetailsResponceDto data) =>
    json.encode(data.toJson());

class LocationsDetailsResponceDto {
  dynamic code;
  dynamic message;
  Location? location;

  LocationsDetailsResponceDto({
    this.code,
    this.message,
    this.location,
  });

  factory LocationsDetailsResponceDto.fromJson(Map<String, dynamic> json) =>
      LocationsDetailsResponceDto(
        code: json["code"],
        message: json["message"],
        location: json["location"] == null
            ? null
            : Location.fromJson(json["location"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "location": location?.toJson(),
      };
}

class Location {
  dynamic locationId;
  dynamic brandName;
  dynamic brandLogo;
  dynamic friendlyname;
  dynamic locationImage;
  dynamic addressLine1;
  dynamic addressLine2;
  dynamic addressLine3;
  dynamic town;
  dynamic county;
  dynamic postcode;
  dynamic country;
  dynamic googlePlacesId;
  dynamic businessStatus;
  dynamic latitude;
  dynamic longitude;
  dynamic distance;
  dynamic ratingScore;
  dynamic isOtherButton;
  dynamic buttonText;
  dynamic buttonLink;
  dynamic isOfferButton;
  dynamic isOfferMultiple;
  dynamic offerId;
  dynamic brandId;

  Location({
    this.locationId,
    this.brandName,
    this.brandLogo,
    this.locationImage,
    this.addressLine1,
    this.addressLine2,
    this.addressLine3,
    this.town,
    this.friendlyname,
    this.county,
    this.postcode,
    this.country,
    this.googlePlacesId,
    this.businessStatus,
    this.latitude,
    this.longitude,
    this.distance,
    this.ratingScore,
    this.isOtherButton,
    this.buttonText,
    this.buttonLink,
    this.isOfferButton,
    this.isOfferMultiple,
    this.offerId,
    this.brandId,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        locationId: json["location_id"],
        brandName: json["brand_name"],
        brandLogo: json["brand_logo"],
        locationImage: json["location_image"],
        addressLine1: json["address_line1"],
        friendlyname: json["friendly_name"],
        addressLine2: json["address_line2"],
        addressLine3: json["address_line3"],
        town: json["town"],
        county: json["county"],
        postcode: json["postcode"],
        country: json["country"],
        googlePlacesId: json["google_places_id"],
        businessStatus: json["business_status"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        distance: json["distance"],
        ratingScore: json["rating_score"],
        isOtherButton: json["is_other_button"],
        buttonText: json["button_text"],
        buttonLink: json["button_link"],
        isOfferButton: json["is_offer_button"],
        isOfferMultiple: json["is_offer_multiple"],
        offerId: json["offer_id"],
        brandId: json["brand_id"],
      );

  Map<String, dynamic> toJson() => {
        "location_id": locationId,
        "brand_name": brandName,
        "brand_logo": brandLogo,
        "location_image": locationImage,
        "address_line1": addressLine1,
        "address_line2": addressLine2,
        "address_line3": addressLine3,
        "town": town,
        "county": county,
        "postcode": postcode,
        "country": country,
        "google_places_id": googlePlacesId,
        "business_status": businessStatus,
        "latitude": latitude,
        "longitude": longitude,
        "distance": distance,
        "rating_score": ratingScore,
        "is_other_button": isOtherButton,
        "button_text": buttonText,
        "button_link": buttonLink,
        "is_offer_button": isOfferButton,
        "is_offer_multiple": isOfferMultiple,
        "offer_id": offerId,
        "brand_id": brandId,
      };
}
