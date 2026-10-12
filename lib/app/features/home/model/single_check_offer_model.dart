import 'dart:convert';

CheckSingleOfferModel checkSingleOfferModelFromJson(String str) =>
    CheckSingleOfferModel.fromJson(json.decode(str));

String checkSingleOfferModelToJson(CheckSingleOfferModel data) =>
    json.encode(data.toJson());

class CheckSingleOfferModel {
  final Data? data;

  CheckSingleOfferModel({this.data});

  factory CheckSingleOfferModel.fromJson(Map<String, dynamic> json) =>
      CheckSingleOfferModel(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {"data": data?.toJson()};
}

class Data {
  final int? id;
  final String? title;
  final String? slug;
  final int? amount;

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
