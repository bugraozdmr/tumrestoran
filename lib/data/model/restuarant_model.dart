import 'dart:convert';

RestaurantModel restaurantModelFromJson(String str) =>
    RestaurantModel.fromJson(json.decode(str));

String restaurantModelToJson(RestaurantModel data) =>
    json.encode(data.toJson());

class RestaurantModel {
  final List<Restaurant>? data;
  final Links? links;
  final Meta? meta;

  RestaurantModel({this.data, this.links, this.meta});

  factory RestaurantModel.fromJson(Map<String, dynamic> json) =>
      RestaurantModel(
        data: json["data"] == null
            ? []
            : List<Restaurant>.from(
                json["data"]!.map((x) => Restaurant.fromJson(x)),
              ),
        links: json["links"] == null ? null : Links.fromJson(json["links"]),
        meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
    "links": links?.toJson(),
    "meta": meta?.toJson(),
  };
}

class Restaurant {
  final int? id;
  final String? name;
  final String? slug;
  final String? thumb;
  final int? preparationTime;
  final dynamic ratingStar;
  final dynamic ratingStarCount;
  final dynamic distance;
  final int? status;
  final bool? favorite;
  final int? availability;
  final int amount;

  Restaurant({
    this.id,
    this.name,
    this.slug,
    this.thumb,
    this.preparationTime,
    this.ratingStar,
    this.ratingStarCount,
    this.distance,
    this.status,
    this.favorite,
    this.availability,
    this.amount = 0,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
    id: json["id"],
    name: json["name"],
    slug: json["slug"],
    thumb: json["thumb"],
    preparationTime: json["preparation_time"],
    ratingStar: json["rating_star"],
    ratingStarCount: json["rating_star_count"],
    distance: json["distance"],
    status: json["status"],
    favorite: json["favorite"],
    availability: json["availability"],
    amount: 0,
  );

  Restaurant copyWith({int? amount}) {
    return Restaurant(
      id: id,
      name: name,
      slug: slug,
      thumb: thumb,
      preparationTime: preparationTime,
      ratingStar: ratingStar,
      ratingStarCount: ratingStarCount,
      distance: distance,
      status: status,
      favorite: favorite,
      availability: availability,
      amount: amount ?? this.amount,
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "slug": slug,
    "thumb": thumb,
    "preparation_time": preparationTime,
    "rating_star": ratingStar,
    "rating_star_count": ratingStarCount,
    "distance": distance,
    "status": status,
    "favorite": favorite,
    "availability": availability,
  };
}

class Links {
  final String? first;
  final String? last;
  final dynamic prev;
  final dynamic next;

  Links({this.first, this.last, this.prev, this.next});

  factory Links.fromJson(Map<String, dynamic> json) => Links(
    first: json["first"],
    last: json["last"],
    prev: json["prev"],
    next: json["next"],
  );

  Map<String, dynamic> toJson() => {
    "first": first,
    "last": last,
    "prev": prev,
    "next": next,
  };
}

class Meta {
  final int? currentPage;
  final int? from;
  final int? lastPage;
  final List<Link>? links;
  final String? path;
  final int? perPage;
  final int? to;
  final int? total;

  Meta({
    this.currentPage,
    this.from,
    this.lastPage,
    this.links,
    this.path,
    this.perPage,
    this.to,
    this.total,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    currentPage: json["current_page"],
    from: json["from"],
    lastPage: json["last_page"],
    links: json["links"] == null
        ? []
        : List<Link>.from(json["links"]!.map((x) => Link.fromJson(x))),
    path: json["path"],
    perPage: json["per_page"],
    to: json["to"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "current_page": currentPage,
    "from": from,
    "last_page": lastPage,
    "links": links == null
        ? []
        : List<dynamic>.from(links!.map((x) => x.toJson())),
    "path": path,
    "per_page": perPage,
    "to": to,
    "total": total,
  };
}

class Link {
  final String? url;
  final String? label;
  final bool? active;

  Link({this.url, this.label, this.active});

  factory Link.fromJson(Map<String, dynamic> json) =>
      Link(url: json["url"], label: json["label"], active: json["active"]);

  Map<String, dynamic> toJson() => {
    "url": url,
    "label": label,
    "active": active,
  };
}
