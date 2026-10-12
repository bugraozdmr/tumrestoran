import 'dart:convert';

AddressModel addressModelFromJson(String str) =>
    AddressModel.fromJson(json.decode(str));

String addressModelToJson(AddressModel data) => json.encode(data.toJson());

class AddressModel {
  final List<Address>? data;

  AddressModel({this.data});

  factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
    data: json["data"] == null
        ? []
        : List<Address>.from(json["data"]!.map((x) => Address.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Address {
  final int? id;
  final int? userId;
  final String? label;
  final String? address;
  final String? apartment;
  final String? latitude;
  final String? longitude;

  Address({
    this.id,
    this.userId,
    this.label,
    this.address,
    this.apartment,
    this.latitude,
    this.longitude,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    id: json["id"],
    userId: json["user_id"],
    label: json["label"],
    address: json["address"],
    apartment: json["apartment"],
    latitude: json["latitude"],
    longitude: json["longitude"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "label": label,
    "address": address,
    "apartment": apartment,
    "latitude": latitude,
    "longitude": longitude,
  };
}
