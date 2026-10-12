// ignore_for_file: constant_identifier_names

import 'dart:convert';

OfferModel offerModelFromJson(String str) =>
    OfferModel.fromJson(json.decode(str));

String offerModelToJson(OfferModel data) => json.encode(data.toJson());

class OfferModel {
  final List<Datum>? data;

  OfferModel({this.data});

  factory OfferModel.fromJson(Map<String, dynamic> json) => OfferModel(
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
  final int? restaurantId;
  final Name? name;
  final Slug? slug;
  final String? amount;
  final String? flatAmount;
  final int? convertAmount;
  final ConvertStartDate? convertStartDate;
  final ConvertEndDate? convertEndDate;
  final DateTime? startDate;
  final DateTime? endDate;
  final int? status;
  final String? image;

  Datum({
    this.id,
    this.restaurantId,
    this.name,
    this.slug,
    this.amount,
    this.flatAmount,
    this.convertAmount,
    this.convertStartDate,
    this.convertEndDate,
    this.startDate,
    this.endDate,
    this.status,
    this.image,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    restaurantId: json["restaurant_id"],
    name: nameValues.map[json["name"]]!,
    slug: slugValues.map[json["slug"]]!,
    amount: json["amount"],
    flatAmount: json["flat_amount"],
    convertAmount: json["convert_amount"],
    convertStartDate: convertStartDateValues.map[json["convert_start_date"]]!,
    convertEndDate: convertEndDateValues.map[json["convert_end_date"]]!,
    startDate: json["start_date"] == null
        ? null
        : DateTime.parse(json["start_date"]),
    endDate: json["end_date"] == null ? null : DateTime.parse(json["end_date"]),
    status: json["status"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "restaurant_id": restaurantId,
    "name": nameValues.reverse[name],
    "slug": slugValues.reverse[slug],
    "amount": amount,
    "flat_amount": flatAmount,
    "convert_amount": convertAmount,
    "convert_start_date": convertStartDateValues.reverse[convertStartDate],
    "convert_end_date": convertEndDateValues.reverse[convertEndDate],
    "start_date": startDate?.toIso8601String(),
    "end_date": endDate?.toIso8601String(),
    "status": status,
    "image": image,
  };
}

enum ConvertEndDate { THE_0451_PM_19022025 }

final convertEndDateValues = EnumValues({
  "04:51 PM, 19-02-2025": ConvertEndDate.THE_0451_PM_19022025,
});

enum ConvertStartDate { THE_0451_PM_20022024 }

final convertStartDateValues = EnumValues({
  "04:51 PM, 20-02-2024": ConvertStartDate.THE_0451_PM_20022024,
});

enum Name { SAVORY_AND_SATISFYING, UPLIFTING_ANYTIME }

final nameValues = EnumValues({
  "Savory and Satisfying": Name.SAVORY_AND_SATISFYING,
  "Uplifting Anytime": Name.UPLIFTING_ANYTIME,
});

enum Slug { SAVORY_AND_SATISFYING, UPLIFTING_ANYTIME }

final slugValues = EnumValues({
  "savory-and-satisfying": Slug.SAVORY_AND_SATISFYING,
  "uplifting-anytime": Slug.UPLIFTING_ANYTIME,
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
