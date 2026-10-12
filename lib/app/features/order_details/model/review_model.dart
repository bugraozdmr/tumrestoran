import 'dart:convert';

ReviewModel reviewModelFromJson(String str) =>
    ReviewModel.fromJson(json.decode(str));

String reviewModelToJson(ReviewModel data) => json.encode(data.toJson());

class ReviewModel {
  final Data? data;

  ReviewModel({this.data});

  factory ReviewModel.fromJson(Map<String, dynamic> json) => ReviewModel(
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {"data": data?.toJson()};
}

class Data {
  final int? id;
  final String? name;
  final String? createdAt;
  final int? star;
  final String? review;

  Data({this.id, this.name, this.createdAt, this.star, this.review});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    name: json["name"],
    createdAt: json["created_at"],
    star: json["star"],
    review: json["review"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "created_at": createdAt,
    "star": star,
    "review": review,
  };
}
