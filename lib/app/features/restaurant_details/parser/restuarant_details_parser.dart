import '../../../../data/model/restaurant_details.dart';

RestaurantDetailsModel parseRestaurantDetails(Map<String, dynamic> json) {
  return RestaurantDetailsModel.fromJson(json);
}
