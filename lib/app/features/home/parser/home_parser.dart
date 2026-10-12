import 'package:foodnanny/app/features/home/model/single_offer_model.dart';
import 'package:foodnanny/data/model/quisine_model.dart';
import 'package:foodnanny/data/model/restuarant_model.dart';

RestaurantModel parseAllRestaurant(Map<String, dynamic> json) {
  return RestaurantModel.fromJson(json);
}

SingleOfferModel parseSingleOffer(Map<String, dynamic> json) {
  return SingleOfferModel.fromJson(json);
}

QuisineModel parseQuisine(Map<String, dynamic> json) {
  return QuisineModel.fromJson(json);
}
