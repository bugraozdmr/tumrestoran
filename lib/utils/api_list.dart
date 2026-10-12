class ApiList {
  static const baseUrl = "https://tumrestoran.com";
  // Yerel test için:
  // static const baseUrl = "http://10.0.2.2:8000"; // Android Emülatör
  // static const baseUrl = "http://127.0.0.1:8000"; // iOS Simülatör
  static const licenseKey = "b6d68vy2-m7g5-20r0-5275-h103w73453q120";
  static const mapKey = "AIzaSyBaY6jg8aoeQ1sQLP0xUdhXqAiMIa4HYcU";
  static const login = "$baseUrl/api/auth/login";
  static const postDeviceToken = "$baseUrl/api/frontend/device-token/mobile";
  static const sendOtp = "$baseUrl/api/auth/signup/otp";
  static const sendGuestOtp = "$baseUrl/api/auth/guest-signup/phone";
  static const verifyOtp = "$baseUrl/api/auth/signup/verify";
  static const verifyGuestOtp = "$baseUrl/api/auth/guest-signup/verify";
  static const signup = "$baseUrl/api/auth/signup/register";
  static const signupWithPhone = "$baseUrl/api/auth/signup/phone";
  static const forgotPassword = "$baseUrl/api/auth/forgot-password";

  static const verifyForgotPasswordOTP =
      "$baseUrl/api/auth/forgot-password/verify-code";
  static const resetPassword =
      "$baseUrl/api/auth/forgot-password/reset-password";
  static const logout = "$baseUrl/api/auth/logout";
  static const language = "$baseUrl/api/frontend/language";
  static const pages = "$baseUrl/api/frontend/page";
  static const setting = "$baseUrl/api/frontend/setting";
  static const countryFlag = "$baseUrl/api/frontend/country-code/show/";
  static const address = "$baseUrl/api/frontend/address";
  static const changeImage = "$baseUrl/api/profile/change-image";
  static const placeOrder = "$baseUrl/api/frontend/order";
  static String cancelOrder({required int id}) =>
      "$baseUrl/api/frontend/order/cancel/$id";

  static const profile = "$baseUrl/api/profile";
  static const changePassword = "$baseUrl/api/profile/change-password";
  static String editAddress({required int id}) =>
      "$baseUrl/api/frontend/address/$id";

  static String deleteAddress({required int id}) =>
      "$baseUrl/api/frontend/address/$id";

  static const quisine =
      "$baseUrl/api/frontend/cuisine?order_column=sort&order_type=asc&status=5";

  static offerForRestaurant({
    required String restaurantId,
    required String lat,
    required String long,
  }) =>
      "$baseUrl/api/frontend/offer/check/$restaurantId?id=$restaurantId&latitude=$lat&longitude=$long";
  static allRestaurantByLatLong({
    required String lat,
    required String long,
    required String deliveryOrderType,
  }) =>
      "$baseUrl/api/frontend/restaurant/restaurant-by-lat-long-radius?order_column=distance&latitude=$lat&longitude=$long&delivery_order_type=$deliveryOrderType&order_type=asc&status=5";

  static String findOffer({
    required String lat,
    required String long,
    required String deliveryOrderType,
  }) =>
      "$baseUrl/api/frontend/offer/find?latitude=$lat&longitude=$long&delivery_order_type=$deliveryOrderType";

  static allRestaurantBySearch({
    required String lat,
    required String long,
    required String deliveryOrderType,
    required String query,
  }) =>
      "$baseUrl/api/frontend/restaurant/restaurant-by-lat-long-radius?latitude=$lat&longitude=$long&delivery_order_type=$deliveryOrderType&order_type=asc&status=5&name=$query";

  static String restaurantDetails({required String slug}) =>
      "$baseUrl/api/frontend/restaurant/show/$slug";
  static const activeOrders = "$baseUrl/api/frontend/order?excepts=13|16|19|22";

  static const currentActiveOrder =
      "$baseUrl/api/frontend/order?excepts=13|16|19|22|1&order_column=id&order_by=asc";
  static String previousOrders() =>
      "$baseUrl/api/frontend/order?paginate=0&excepts=1|4|7|8|10";
  static String orderDetails({required String id}) =>
      "$baseUrl/api/frontend/order/show/$id";

  static String restaurantByCuisine({
    required String lat,
    required String long,
    required String deliveryOrderType,
    required String cuisineId,
  }) =>
      "$baseUrl/api/frontend/restaurant/restaurant-by-lat-long-radius?order_type=asc&latitude=$lat&longitude=$long&delivery_order_type=$deliveryOrderType&cuisine_id=$cuisineId";

  static String campaing({
    required String lat,
    required String long,
    required String deliveryOrderType,
  }) =>
      "$baseUrl/api/frontend/campaign?latitude=$lat&longitude=$long&delivery_order_type=$deliveryOrderType";

  static String offer({
    required String lat,
    required String long,
    required String deliveryOrderType,
  }) =>
      "$baseUrl/api/frontend/offer?latitude=$lat&longitude=$long&delivery_order_type=$deliveryOrderType";

  static String showCampaign({
    required String slug,
    required String lat,
    required String long,
    required String deliveryOrderType,
  }) =>
      "$baseUrl/api/frontend/campaign/show/$slug?slug=$slug&latitude=$lat&longitude=$long&delivery_order_type=$deliveryOrderType";

  static String showOffer({
    required String slug,
    required String lat,
    required String long,
    required String deliveryOrderType,
  }) =>
      "$baseUrl/api/frontend/offer/show/$slug?slug=$slug&latitude=$lat&longitude=$long&delivery_order_type=$deliveryOrderType";

  static String singleOffer({
    required String lat,
    required String long,
    required String deliveryOrderType,
  }) =>
      "$baseUrl/api/frontend/offer/single?latitude=$lat&longitude=$long&delivery_order_type=$deliveryOrderType";
  static String itemCategoryDetails({required String slug}) =>
      "$baseUrl/api/frontend/item-category/items/$slug?slug=$slug&order_column=sort&order_type=asc";

  static String itemDetails({required String slug}) =>
      "$baseUrl/api/frontend/item/show/$slug";

  static String todayTime({required int restaurantId}) =>
      "$baseUrl/api/frontend/time-slot/today/$restaurantId";
  static String tomorrowTime({required int restaurantId}) =>
      "$baseUrl/api/frontend/time-slot/tomorrow/$restaurantId";
  static String paymentGateway = "$baseUrl/api/frontend/payment-gateway";
  static String getCoupon({required String restaurantId}) =>
      "$baseUrl/api/frontend/coupon/$restaurantId";
  static String showCoupon({required String couponId}) =>
      "$baseUrl/api/frontend/coupon/$couponId/show";
  static String applyCoupon({required int restaurantId}) =>
      "$baseUrl/api/frontend/coupon/$restaurantId/coupon-checking";

  static String searchMenu({required String restaurantName}) =>
      "$baseUrl/api/frontend/item/search-items/$restaurantName";
  static String riderTip =
      "$baseUrl/api/frontend/rider-tip?order_column=id&order_type=asc";

  static String favorite = "$baseUrl/api/frontend/favorite/toggle";
  static String favoriteRestaurants({
    required int perPage,
    required int page,
  }) =>
      '$baseUrl/api/frontend/restaurant/favorite?paginate=1&per_page=$perPage&page=$page';

  static String deleteAccount = "$baseUrl/api/auth/delete-account";
  static String checkSingleOffer({required String restaurantId}) =>
      "$baseUrl/api/frontend/offer/check/$restaurantId";

  static String submitDeliveryBoyReview({required String orderId}) =>
      "$baseUrl/api/frontend/delivery-boy-review/$orderId";

  static String submitRestaurantReview({required String orderId}) =>
      "$baseUrl/api/frontend/restaurant-review/$orderId";
}
