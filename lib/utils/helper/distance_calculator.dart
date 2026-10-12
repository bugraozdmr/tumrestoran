import 'dart:math' as math;

double calculateDistance({
  required double addressLat,
  required double addressLong,
  required double restaurantLat,
  required double restaurantLong,
}) {
  double radAddressLat = addressLat * (math.pi / 180);
  double radRestaurantLat = restaurantLat * (math.pi / 180);
  double theta = addressLong - restaurantLong;
  double radTheta = theta * (math.pi / 180);

  double dist =
      math.sin(radAddressLat) * math.sin(radRestaurantLat) +
      math.cos(radAddressLat) * math.cos(radRestaurantLat) * math.cos(radTheta);
  dist = math.acos(dist);
  dist = dist * (180 / math.pi);
  dist = dist * 60 * 1.1515;
  dist = dist * 1.609344;

  return dist;
}
