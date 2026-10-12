import 'dart:convert';

TipModel tipModelFromJson(String str) => TipModel.fromJson(json.decode(str));

String tipModelToJson(TipModel data) => json.encode(data.toJson());

class TipModel {
  final List<Tip>? data;

  TipModel({this.data});

  factory TipModel.fromJson(Map<String, dynamic> json) => TipModel(
    data: json["data"] == null
        ? []
        : List<Tip>.from(json["data"]!.map((x) => Tip.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Tip {
  final int? id;
  final String? label;
  final int? amount;

  Tip({this.id, this.label, this.amount});

  factory Tip.fromJson(Map<String, dynamic> json) =>
      Tip(id: json["id"], label: json["label"], amount: json["amount"]);

  Map<String, dynamic> toJson() => {"id": id, "label": label, "amount": amount};
}
