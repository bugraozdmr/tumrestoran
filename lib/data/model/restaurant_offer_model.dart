import 'dart:convert';

RestaurantOfferModel restaurantOfferModelFromJson(String str) =>
    RestaurantOfferModel.fromJson(json.decode(str));

String restaurantOfferModelToJson(RestaurantOfferModel data) =>
    json.encode(data.toJson());

class RestaurantOfferModel {
  Data? data;

  RestaurantOfferModel({this.data});

  factory RestaurantOfferModel.fromJson(Map<String, dynamic> json) =>
      RestaurantOfferModel(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {"data": data?.toJson()};
}

class Data {
  int? id;
  String? title;
  String? slug;
  int? amount;

  Data({this.id, this.title, this.slug, this.amount});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    title: json["title"],
    slug: json["slug"],
    amount: json["amount"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "slug": slug,
    "amount": amount,
  };
}
