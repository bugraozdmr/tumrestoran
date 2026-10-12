import 'dart:convert';

import 'package:foodnanny/data/model/restuarant_model.dart';

CampaingModel campaingModelFromJson(String str) =>
    CampaingModel.fromJson(json.decode(str));

String campaingModelToJson(CampaingModel data) => json.encode(data.toJson());

class CampaingModel {
  final List<Campaign>? data;

  CampaingModel({this.data});

  factory CampaingModel.fromJson(Map<String, dynamic> json) => CampaingModel(
    data: json["data"] == null
        ? []
        : List<Campaign>.from(json["data"]!.map((x) => Campaign.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
  };

  @override
  String toString() => 'CampaingModel(data: $data)';
}

class Campaign {
  final int? id;
  final String? title;
  final String? slug;
  final String? type;
  final String? startTime;
  final String? endTime;
  final String? startDate;
  final String? endDate;
  final String? thumb;
  final String? cover;
  final List<Restaurant>? restaurants;
  final String? description;
  final String? percentage;

  Campaign({
    this.id,
    this.title,
    this.slug,
    this.type,
    this.startTime,
    this.endTime,
    this.startDate,
    this.endDate,
    this.percentage,
    this.thumb,
    this.cover,
    this.restaurants,
    this.description,
  });

  factory Campaign.fromJson(Map<String, dynamic> json) => Campaign(
    id: json["id"],
    title: json["title"],
    slug: json["slug"],
    type: json["type"],
    startTime: json["start_time"],
    endTime: json["end_time"],
    startDate: json["start_date"],
    endDate: json["end_date"],
    thumb: json["thumb"],
    cover: json["cover"],
    percentage: json["percentage"] ?? "",
    description: json['description'] ?? "",
    restaurants: json["restaurants"] == null
        ? []
        : List<Restaurant>.from(
            json["restaurants"]!.map((x) => Restaurant.fromJson(x)),
          ),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "slug": slug,
    "type": type,
    "start_time": startTime,
    "end_time": endTime,
    "start_date": startDate,
    "end_date": endDate,
    "thumb": thumb,
    "cover": cover,
  };

  @override
  String toString() {
    return 'Campaign(id: $id, title: $title, slug: $slug, type: $type, startTime: $startTime, endTime: $endTime, startDate: $startDate, endDate: $endDate, thumb: $thumb, cover: $cover, restaurants: $restaurants, description: $description)';
  }
}
