import 'dart:convert';

CountryFlagModel countryFlagModelFromJson(String str) =>
    CountryFlagModel.fromJson(json.decode(str));

String countryFlagModelToJson(CountryFlagModel data) =>
    json.encode(data.toJson());

class CountryFlagModel {
  final Data? data;

  CountryFlagModel({this.data});

  factory CountryFlagModel.fromJson(Map<String, dynamic> json) =>
      CountryFlagModel(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {"data": data?.toJson()};
}

class Data {
  final String? callingCode;
  final String? flagEmoji;
  final String? flagSvg;
  final String? flagSvgPath;
  final String? capital;
  final String? nationality;

  Data({
    this.callingCode,
    this.flagEmoji,
    this.flagSvg,
    this.flagSvgPath,
    this.capital,
    this.nationality,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    callingCode: json["calling_code"],
    flagEmoji: json["flag_emoji"],
    flagSvg: json["flag_svg"],
    flagSvgPath: json["flag_svg_path"],
    capital: json["capital"],
    nationality: json["nationality"],
  );

  Map<String, dynamic> toJson() => {
    "calling_code": callingCode,
    "flag_emoji": flagEmoji,
    "flag_svg": flagSvg,
    "flag_svg_path": flagSvgPath,
    "capital": capital,
    "nationality": nationality,
  };
}
