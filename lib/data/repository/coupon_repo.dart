import 'package:dartz/dartz.dart';
import 'package:tumrestoran/data/model/apply_coupon_model.dart';
import 'package:tumrestoran/data/model/coupon_model.dart';
import 'package:tumrestoran/data/model/show_coupon_model.dart';
import 'package:tumrestoran/data/server/server.dart';
import 'package:tumrestoran/utils/api_list.dart';
import 'package:get/get.dart';
import '../../config/theme/app_color.dart';
import '../../widgets/custom_snackbar.dart';

class CouponRepo {
  Future<Either<String, CouponModel>> getCoupons({
    required String restaurantId,
  }) async {
    try {
      final response = await Server().getRequest(
        endPoint: ApiList.getCoupon(restaurantId: restaurantId),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        return Right(CouponModel.fromJson(data));
      } else {
        return Left(response.data);
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, ShowCouponModel>> showCoupon({
    required String couponId,
  }) async {
    try {
      final response = await Server().getRequest(
        endPoint: ApiList.showCoupon(couponId: couponId),
      );
      if (response.statusCode == 200) {
        final data = response.data;
        return Right(ShowCouponModel.fromJson(data));
      } else {
        return Left(response.data);
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, ApplyCouponModel>> applyCoupon({
    required int restaurantId,
    required String code,
    required double total,
  }) async {
    try {
      final response = await Server().postRequestWithToken(
        endpoint: ApiList.applyCoupon(restaurantId: restaurantId),
        body: {"code": code, "total": total},
      );

      if (response.statusCode == 200) {
        final data = response.data;

        return Right(ApplyCouponModel.fromJson(data));
      } else {
        customSnackbar(
          "ERROR".tr,
          response.data["message"].toString(),
          AppColor.negativeDark,
        );
        return Left(response.data);
      }
    } catch (e) {
      return Left(e.toString());
    }
  }
}
