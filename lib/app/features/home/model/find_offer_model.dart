import 'dart:convert';

FindOfferModel findOfferModelFromJson(String str) =>
    FindOfferModel.fromJson(json.decode(str));

String findOfferModelToJson(FindOfferModel data) => json.encode(data.toJson());

class FindOfferModel {
  final List<Datum>? data;

  FindOfferModel({this.data});

  factory FindOfferModel.fromJson(Map<String, dynamic> json) => FindOfferModel(
    data: json["data"] == null
        ? []
        : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  final int? id;
  final String? name;
  final String? slug;
  final int? amount;

  Datum({this.id, this.name, this.slug, this.amount});

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    name: json["name"],
    slug: json["slug"],
    amount: json["amount"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "slug": slug,
    "amount": amount,
  };
}
