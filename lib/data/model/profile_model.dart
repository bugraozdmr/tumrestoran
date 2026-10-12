import 'dart:convert';

ProfileModel profileModelFromJson(String str) =>
    ProfileModel.fromJson(json.decode(str));

String profileModelToJson(ProfileModel data) => json.encode(data.toJson());

class ProfileModel {
  final Data? data;

  ProfileModel({this.data});

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {"data": data?.toJson()};
}

class Data {
  final int? id;
  final int? restaurantId;
  final String? name;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? email;
  final String? username;
  final String? balance;
  final String? currencyBalance;
  final String? image;
  final int? roleId;
  final String? countryCode;
  final int? order;
  final String? createDate;
  final String? updateDate;

  Data({
    this.id,
    this.restaurantId,
    this.name,
    this.firstName,
    this.lastName,
    this.phone,
    this.email,
    this.username,
    this.balance,
    this.currencyBalance,
    this.image,
    this.roleId,
    this.countryCode,
    this.order,
    this.createDate,
    this.updateDate,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    restaurantId: json["restaurant_id"],
    name: json["name"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    phone: json["phone"],
    email: json["email"],
    username: json["username"],
    balance: json["balance"],
    currencyBalance: json["currency_balance"],
    image: json["image"],
    roleId: json["role_id"],
    countryCode: json["country_code"],
    order: json["order"],
    createDate: json["create_date"],
    updateDate: json["update_date"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "restaurant_id": restaurantId,
    "name": name,
    "first_name": firstName,
    "last_name": lastName,
    "phone": phone,
    "email": email,
    "username": username,
    "balance": balance,
    "currency_balance": currencyBalance,
    "image": image,
    "role_id": roleId,
    "country_code": countryCode,
    "order": order,
    "create_date": createDate,
    "update_date": updateDate,
  };
}
