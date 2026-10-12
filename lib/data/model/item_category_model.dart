import 'dart:convert';

ItemCategoryDetailsModel itemCategoryDetailsModelFromJson(String str) =>
    ItemCategoryDetailsModel.fromJson(json.decode(str));

String itemCategoryDetailsModelToJson(ItemCategoryDetailsModel data) =>
    json.encode(data.toJson());

class ItemCategoryDetailsModel {
  final List<ItemCategoryDetails>? data;

  ItemCategoryDetailsModel({this.data});

  factory ItemCategoryDetailsModel.fromJson(Map<String, dynamic> json) =>
      ItemCategoryDetailsModel(
        data: json["data"] == null
            ? []
            : List<ItemCategoryDetails>.from(
                json["data"]!.map((x) => ItemCategoryDetails.fromJson(x)),
              ),
      );

  Map<String, dynamic> toJson() => {
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class ItemCategoryDetails {
  final int? id;
  final String? name;
  final String? slug;
  final List<Item>? items;

  ItemCategoryDetails({this.id, this.name, this.slug, this.items});

  factory ItemCategoryDetails.fromJson(Map<String, dynamic> json) =>
      ItemCategoryDetails(
        id: json["id"],
        name: json["name"],
        slug: json["slug"],
        items: json["items"] == null
            ? []
            : List<Item>.from(json["items"]!.map((x) => Item.fromJson(x))),
      );

  ItemCategoryDetails copyWith({
    int? id,
    String? name,
    String? slug,
    List<Item>? items,
  }) {
    return ItemCategoryDetails(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      items: items ?? this.items,
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "slug": slug,
    "items": items == null
        ? []
        : List<dynamic>.from(items!.map((x) => x.toJson())),
  };
}

class Item {
  final int? id;
  final String? name;
  final String? slug;
  final dynamic itemType;
  final String? flatPrice;
  final dynamic convertPrice;
  final String? currencyPrice;
  final String? description;
  final String? descriptionAlt;
  final String? caution;
  final String? thumb;
  final String? cover;
  final dynamic halal;
  final String? discount;
  final String? discountOption;
  final dynamic discountType;
  final String? flatDiscountedPrice;
  final dynamic convertDiscountedPrice;
  final String? currencyDiscountedPrice;

  Item({
    this.id,
    this.name,
    this.slug,
    this.itemType,
    this.flatPrice,
    this.convertPrice,
    this.currencyPrice,
    this.description,
    this.descriptionAlt,
    this.caution,
    this.thumb,
    this.cover,
    this.halal,
    this.discount,
    this.discountOption,
    this.discountType,
    this.flatDiscountedPrice,
    this.convertDiscountedPrice,
    this.currencyDiscountedPrice,
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
    descriptionAlt: json["description_alt"],
    caution: json["caution"],
    thumb: json["thumb"],
    cover: json["cover"],
    halal: json["halal"],
    discount: json["discount"],
    discountOption: json["discount_option"],
    discountType: json["discount_type"],
    flatDiscountedPrice: json["flat_discounted_price"],
    convertDiscountedPrice: json["convert_discounted_price"]?.toDouble(),
    currencyDiscountedPrice: json["currency_discounted_price"],
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
    "description_alt": descriptionAlt,
    "caution": caution,
    "thumb": thumb,
    "cover": cover,
    "halal": halal,
    "discount": discount,
    "discount_option": discountOption,
    "discount_type": discountType,
    "flat_discounted_price": flatDiscountedPrice,
    "convert_discounted_price": convertDiscountedPrice,
    "currency_discounted_price": currencyDiscountedPrice,
  };
}
