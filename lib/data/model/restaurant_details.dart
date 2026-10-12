import 'dart:convert';

RestaurantDetailsModel restaurantDetailsModelFromJson(String str) =>
    RestaurantDetailsModel.fromJson(json.decode(str));

String restaurantDetailsModelToJson(RestaurantDetailsModel data) =>
    json.encode(data.toJson());

class RestaurantDetailsModel {
  final Data? data;

  RestaurantDetailsModel({this.data});

  factory RestaurantDetailsModel.fromJson(Map<String, dynamic> json) =>
      RestaurantDetailsModel(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {"data": data?.toJson()};
}

class Data {
  final int? id;
  final String? name;
  final String? phone;
  final String? countryCode;
  final String? address;
  final String? email;
  final String? logo;
  final String? cover;
  final String? latitude;
  final String? longitude;
  final String? today;
  final dynamic distance;
  final int? ratingStar;
  final int? ratingStarCount;
  final String? cuisine;
  final int? availability;
  final List<TimeSlot>? timeSlots;
  final String? singleTimeSlots;
  final OrderSetup? orderSetup;
  final List<Cuisine>? cuisines;
  final List<Review>? reviews;

  Data({
    this.id,
    this.name,
    this.phone,
    this.countryCode,
    this.address,
    this.email,
    this.logo,
    this.cover,
    this.latitude,
    this.longitude,
    this.today,
    this.distance,
    this.ratingStar,
    this.ratingStarCount,
    this.cuisine,
    this.availability,
    this.timeSlots,
    this.singleTimeSlots,
    this.orderSetup,
    this.cuisines,
    this.reviews,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    name: json["name"],
    phone: json["phone"],
    countryCode: json['country_code'],
    email: json["email"],
    address: json["address"],
    logo: json["logo"],
    cover: json["cover"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    today: json["today"],
    distance: json["distance"],
    ratingStar: json["rating_star"],
    ratingStarCount: json["rating_star_count"],
    cuisine: json["cuisine"],
    availability: json["availability"],
    timeSlots: json["time_slots"] == null
        ? []
        : List<TimeSlot>.from(
            json["time_slots"]!.map((x) => TimeSlot.fromJson(x)),
          ),
    singleTimeSlots: json["single_time_slots"],
    orderSetup: json["order_setup"] == null
        ? null
        : OrderSetup.fromJson(json["order_setup"]),
    cuisines: json["cuisines"] == null
        ? []
        : List<Cuisine>.from(json["cuisines"]!.map((x) => Cuisine.fromJson(x))),
    reviews: json["reviews"] == null
        ? []
        : List<Review>.from(json["reviews"]!.map((x) => Review.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "phone": phone,
    "address": address,
    "logo": logo,
    "cover": cover,
    "latitude": latitude,
    "longitude": longitude,
    "today": today,
    "distance": distance,
    "rating_star": ratingStar,
    "rating_star_count": ratingStarCount,
    "cuisine": cuisine,
    "availability": availability,
    "time_slots": timeSlots == null
        ? []
        : List<dynamic>.from(timeSlots!.map((x) => x.toJson())),
    "single_time_slots": singleTimeSlots,
    "order_setup": orderSetup?.toJson(),
    "cuisines": cuisines == null
        ? []
        : List<dynamic>.from(cuisines!.map((x) => x.toJson())),
    "reviews": reviews == null
        ? []
        : List<dynamic>.from(reviews!.map((x) => x.toJson())),
  };
}

class Cuisine {
  final int? id;
  final String? name;

  Cuisine({this.id, this.name});

  factory Cuisine.fromJson(Map<String, dynamic> json) =>
      Cuisine(id: json["id"], name: json["name"]);

  Map<String, dynamic> toJson() => {"id": id, "name": name};
}

class OrderSetup {
  final int? delivery;
  final int? takeaway;
  final int? scheduleOrderSlotDuration;
  final int? foodPreparationTime;
  final int? minimumOrderLimit;
  final String? currencyMinimumOrderLimit;

  OrderSetup({
    this.delivery,
    this.takeaway,
    this.scheduleOrderSlotDuration,
    this.foodPreparationTime,
    this.minimumOrderLimit,
    this.currencyMinimumOrderLimit,
  });

  factory OrderSetup.fromJson(Map<String, dynamic> json) => OrderSetup(
    delivery: json["delivery"],
    takeaway: json["takeaway"],
    scheduleOrderSlotDuration: json["schedule_order_slot_duration"],
    foodPreparationTime: json["food_preparation_time"],
    minimumOrderLimit: json["minimum_order_limit"],
    currencyMinimumOrderLimit: json["currency_minimum_order_limit"],
  );

  Map<String, dynamic> toJson() => {
    "delivery": delivery,
    "takeaway": takeaway,
    "schedule_order_slot_duration": scheduleOrderSlotDuration,
    "food_preparation_time": foodPreparationTime,
    "minimum_order_limit": minimumOrderLimit,
    "currency_minimum_order_limit": currencyMinimumOrderLimit,
  };
}

class Review {
  final int? id;
  final String? name;
  final String? createdAt;
  final int? star;
  final String? review;

  Review({this.id, this.name, this.createdAt, this.star, this.review});

  factory Review.fromJson(Map<String, dynamic> json) => Review(
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

class TimeSlot {
  final int? id;
  final int? restaurantId;
  final String? openingTime;
  final String? closingTime;
  final int? day;

  TimeSlot({
    this.id,
    this.restaurantId,
    this.openingTime,
    this.closingTime,
    this.day,
  });

  factory TimeSlot.fromJson(Map<String, dynamic> json) => TimeSlot(
    id: json["id"],
    restaurantId: json["restaurant_id"],
    openingTime: json["opening_time"],
    closingTime: json["closing_time"],
    day: json["day"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "restaurant_id": restaurantId,
    "opening_time": openingTime,
    "closing_time": closingTime,
    "day": day,
  };
}
