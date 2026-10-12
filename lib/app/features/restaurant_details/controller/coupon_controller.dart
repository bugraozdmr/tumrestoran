import 'package:foodnanny/data/model/coupon_model.dart';
import 'package:foodnanny/data/model/show_coupon_model.dart';
import 'package:foodnanny/data/repository/coupon_repo.dart';
import 'package:get/get.dart';

class CouponController extends GetxController {
  final _repo = CouponRepo();
  final couponModel = CouponModel().obs;
  final showCouponModel = ShowCouponModel().obs;

  Future<void> getCoupons({required String restaurantId}) async {
    final result = await _repo.getCoupons(restaurantId: restaurantId);
    result.fold((error) {}, (coupon) {
      couponModel.value = coupon;
    });
  }

  Future<void> showCoupon({required String couponId}) async {
    final result = await _repo.showCoupon(couponId: couponId);
    result.fold((error) {}, (showCoupon) {
      showCouponModel.value = showCoupon;
    });
  }
}
