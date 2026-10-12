import 'dart:convert';

DeliveryTimeModel deliveryTimeModelFromJson(String str) =>
    DeliveryTimeModel.fromJson(json.decode(str));

String deliveryTimeModelToJson(DeliveryTimeModel data) =>
    json.encode(data.toJson());

class DeliveryTimeModel {
  final List<Datum>? data;

  DeliveryTimeModel({this.data});

  factory DeliveryTimeModel.fromJson(Map<String, dynamic> json) =>
      DeliveryTimeModel(
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  final String? label;
  final String? fromTime;
  final String? toTime;
  final String? time;

  Datum({this.label, this.fromTime, this.toTime, this.time});

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    label: json["label"],
    fromTime: json["from_time"],
    toTime: json["to_time"],
    time: json["time"],
  );

  Map<String, dynamic> toJson() => {
    "label": label,
    "from_time": fromTime,
    "to_time": toTime,
    "time": time,
  };
}
