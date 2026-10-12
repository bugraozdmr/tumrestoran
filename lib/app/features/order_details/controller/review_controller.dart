import 'package:foodnanny/app/features/order_details/model/review_model.dart';
import 'package:foodnanny/config/theme/app_color.dart';
import 'package:foodnanny/data/server/server.dart';
import 'package:foodnanny/utils/api_list.dart';
import 'package:foodnanny/widgets/custom_snackbar.dart';
import 'package:get/get.dart';

class ReviewController extends GetxController {
  final deliveryBoyReview = ReviewModel().obs;
  final restaurantReview = ReviewModel().obs;
  final submitReviewLoading = false.obs;
  Future<void> submitDeliveryBoyReview({
    required String orderId,
    required String star,
    required String reviewText,
  }) async {
    Map<String, dynamic> mapBody = {'star': star, 'review': reviewText};

    submitReviewLoading.value = true;

    final response = await Server().postRequestWithToken(
      endpoint: ApiList.submitDeliveryBoyReview(orderId: orderId),
      body: mapBody,
    );

    submitReviewLoading.value = false;

    if (response.statusCode == 200) {
      getDeliveryBoyReview(orderId: orderId);
      Get.back();
    } else {
      String errorMessage = response.data['message'];
      customSnackbar("ERROR".tr, errorMessage, AppColor.rejectedTextColor);
    }
  }

  Future<void> getDeliveryBoyReview({required String orderId}) async {
    final response = await Server().getRequestWithToken(
      endPoint: ApiList.submitDeliveryBoyReview(orderId: orderId),
    );

    if (response.statusCode == 200) {
      final data = response.data as dynamic;
      deliveryBoyReview.value = ReviewModel.fromJson(data);
    }
  }

  Future<void> submitRestaurantReview({
    required String orderId,
    required String star,
    required String reviewText,
  }) async {
    Map<String, dynamic> mapBody = {'star': star, 'review': reviewText};
    submitReviewLoading.value = true;
    final response = await Server().postRequestWithToken(
      endpoint: ApiList.submitRestaurantReview(orderId: orderId),
      body: mapBody,
    );
    submitReviewLoading.value = false;

    if (response.statusCode == 200) {
      getRestauantReview(orderId: orderId);
      Get.back();
    } else {
      String errorMessage = response.data['message'];
      customSnackbar("ERROR".tr, errorMessage, AppColor.rejectedTextColor);
    }
  }

  Future<void> getRestauantReview({required String orderId}) async {
    final response = await Server().getRequestWithToken(
      endPoint: ApiList.submitRestaurantReview(orderId: orderId),
    );

    if (response.statusCode == 200) {
      final data = response.data;
      restaurantReview.value = ReviewModel.fromJson(data);
    }
  }
}
