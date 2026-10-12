import 'dart:convert';

SearchMenuModel searchMenuModelFromJson(String str) =>
    SearchMenuModel.fromJson(json.decode(str));

String searchMenuModelToJson(SearchMenuModel data) =>
    json.encode(data.toJson());

class SearchMenuModel {
  final List<Item>? data;

  SearchMenuModel({this.data});

  factory SearchMenuModel.fromJson(Map<String, dynamic> json) =>
      SearchMenuModel(
        data: json["data"] == null
            ? []
            : List<Item>.from(json["data"]!.map((x) => Item.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Item {
  final int? id;
  final String? name;
  final String? slug;
  final int? itemType;
  final String? flatPrice;
  final double? convertPrice;
  final String? currencyPrice;
  final String? description;
  final String? caution;
  final String? thumb;
  final String? cover;
  final List<Offer>? offer;

  Item({
    this.id,
    this.name,
    this.slug,
    this.itemType,
    this.flatPrice,
    this.convertPrice,
    this.currencyPrice,
    this.description,
    this.caution,
    this.thumb,
    this.cover,
    this.offer,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    id: json["id"],
    name: json["name"],
    slug: json["slug"],
    itemType: json["item_type"],
    flatPrice: json["flat_price"],
    convertPrice: json["convert_price"]?.toDouble(),
    currencyPrice: json["currency_price"],
    description: json["description"],
    caution: json["caution"],
    thumb: json["thumb"],
    cover: json["cover"],
    offer: json["offer"] == null
        ? []
        : List<Offer>.from(json["offer"]!.map((x) => Offer.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "slug": slug,
    "item_type": itemType,
    "flat_price": flatPrice,
    "convert_price": convertPrice,
    "currency_price": currencyPrice,
    "description": description,
    "caution": caution,
    "thumb": thumb,
    "cover": cover,
    "offer": offer == null
        ? []
        : List<dynamic>.from(offer!.map((x) => x.toJson())),
  };
}

class Offer {
  final int? id;
  final int? restaurantId;
  final String? name;
  final String? amount;
  final String? flatPrice;
  final double? convertPrice;
  final String? currencyPrice;

  Offer({
    this.id,
    this.restaurantId,
    this.name,
    this.amount,
    this.flatPrice,
    this.convertPrice,
    this.currencyPrice,
  });

  factory Offer.fromJson(Map<String, dynamic> json) => Offer(
    id: json["id"],
    restaurantId: json["restaurant_id"],
    name: json["name"],
    amount: json["amount"],
    flatPrice: json["flat_price"],
    convertPrice: json["convert_price"]?.toDouble(),
    currencyPrice: json["currency_price"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "restaurant_id": restaurantId,
    "name": name,
    "amount": amount,
    "flat_price": flatPrice,
    "convert_price": convertPrice,
    "currency_price": currencyPrice,
  };
}
