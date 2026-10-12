import 'dart:convert';

PaymentModel paymentModelFromJson(String str) =>
    PaymentModel.fromJson(json.decode(str));

String paymentModelToJson(PaymentModel data) => json.encode(data.toJson());

class PaymentModel {
  final List<PaymentMethod>? data;

  PaymentModel({this.data});

  factory PaymentModel.fromJson(Map<String, dynamic> json) => PaymentModel(
    data: json["data"] == null
        ? []
        : List<PaymentMethod>.from(
            json["data"]!.map((x) => PaymentMethod.fromJson(x)),
          ),
  );

  Map<String, dynamic> toJson() => {
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class PaymentMethod {
  final int? id;
  final String? name;
  final String? slug;
  final int? status;
  final String? image;

  PaymentMethod({this.id, this.name, this.slug, this.status, this.image});

  factory PaymentMethod.fromJson(Map<String, dynamic> json) => PaymentMethod(
    id: json["id"],
    name: json["name"],
    slug: json["slug"],
    status: json["status"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "slug": slug,
    "status": status,
    "image": image,
  };
}
