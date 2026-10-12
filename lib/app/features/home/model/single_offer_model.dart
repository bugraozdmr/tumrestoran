import 'dart:convert';

import '../../../../data/model/restuarant_model.dart';

SingleOfferModel singleOfferModelFromJson(String str) =>
    SingleOfferModel.fromJson(json.decode(str));

String singleOfferModelToJson(SingleOfferModel data) =>
    json.encode(data.toJson());

class SingleOfferModel {
  final Data? data;

  SingleOfferModel({this.data});

  factory SingleOfferModel.fromJson(Map<String, dynamic> json) =>
      SingleOfferModel(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {"data": data?.toJson()};
}

class Data {
  final int? id;
  final String? title;
  final String? slug;
  final int? amount;
  final String? percentage;
  final String? option;
  final String? type;
  final String? startTime;
  final String? endTime;
  final String? startDate;
  final String? endDate;
  final String? thumb;
  final String? cover;
  final List<Restaurant>? restaurants;
  final String? description;

  Data({
    this.id,
    this.title,
    this.slug,
    this.amount,
    this.percentage,
    this.option,
    this.type,
    this.startTime,
    this.endTime,
    this.startDate,
    this.endDate,
    this.thumb,
    this.cover,
    this.restaurants,
    this.description,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    title: json["title"],
    slug: json["slug"],
    amount: json["amount"],
    percentage: json["percentage"],
    option: json["option"],
    type: json["type"],
    startTime: json["start_time"],
    endTime: json["end_time"],
    startDate: json["start_date"],
    endDate: json["end_date"],
    thumb: json["thumb"],
    cover: json["cover"],
    restaurants: json["restaurants"] == null
        ? []
        : List<Restaurant>.from(
            json["restaurants"]!.map((x) => Restaurant.fromJson(x)),
          ),
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "slug": slug,
    "amount": amount,
    "percentage": percentage,
    "option": option,
    "type": type,
    "start_time": startTime,
    "end_time": endTime,
    "start_date": startDate,
    "end_date": endDate,
    "thumb": thumb,
    "cover": cover,
    "restaurants": restaurants == null
        ? []
        : List<dynamic>.from(restaurants!.map((x) => x.toJson())),
    "description": description,
  };
}
