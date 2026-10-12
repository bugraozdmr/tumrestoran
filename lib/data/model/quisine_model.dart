import 'dart:convert';

QuisineModel quisineModelFromJson(String str) =>
    QuisineModel.fromJson(json.decode(str));

String quisineModelToJson(QuisineModel data) => json.encode(data.toJson());

class QuisineModel {
  final List<Quisine>? data;

  QuisineModel({this.data});

  factory QuisineModel.fromJson(Map<String, dynamic> json) => QuisineModel(
    data: json["data"] == null
        ? []
        : List<Quisine>.from(json["data"]!.map((x) => Quisine.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Quisine {
  final int? id;
  final String? name;
  final String? slug;
  final dynamic description;
  final int? status;
  final String? image;

  Quisine({
    this.id,
    this.name,
    this.slug,
    this.description,
    this.status,
    this.image,
  });

  factory Quisine.fromJson(Map<String, dynamic> json) => Quisine(
    id: json["id"],
    name: json["name"],
    slug: json["slug"],
    description: json["description"],
    status: json["status"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "slug": slug,
    "description": description,
    "status": status,
    "image": image,
  };
}
