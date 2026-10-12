import 'package:flutter/cupertino.dart';
import 'package:foodnanny/app/features/cart/controller/cart_controller.dart';
import 'package:foodnanny/app/features/profile/controller/profile_controller.dart';
import 'package:foodnanny/data/model/apply_coupon_model.dart';
import 'package:foodnanny/data/model/coupon_model.dart';
import 'package:foodnanny/data/model/delivery_time_model.dart';
import 'package:foodnanny/data/model/payment_model.dart';
import 'package:foodnanny/data/model/setting_model.dart';
import 'package:foodnanny/data/model/tip_model.dart';
import 'package:foodnanny/data/repository/checkout_repo.dart';
import 'package:foodnanny/data/repository/coupon_repo.dart';
import 'package:foodnanny/data/repository/delivery_time_repo.dart';
import 'package:foodnanny/data/repository/payment_repo.dart';
import 'package:foodnanny/utils/helper/format_price_with_currency.dart';
import 'package:get/get.dart';
import '../../../../config/theme/app_color.dart';
import '../../../../widgets/custom_snackbar.dart';

class CheckoutController extends GetxController {
  final _checkoutRepo = CheckoutRepo();
  final DeliveryTimeRepo _deliveryTimeRepo = DeliveryTimeRepo();
  final PaymentRepo _paymentRepo = PaymentRepo();
  final CouponRepo _couponRepo = CouponRepo();
  final couponModel = CouponModel().obs;
  final applyCouponModel = ApplyCouponModel().obs;
  final deliveryTimeModel = DeliveryTimeModel().obs;
  final paymentMethods = <PaymentMethod>[].obs;
  final selectAddress = RxInt(-1);
  final selectTime = RxInt(-1);
  final tipModel = TipModel().obs;
  final isToday = true.obs;
  final selectDesireTime = RxInt(-1);
  int? addressId;
  String? timeNow;
  String? deliveryTime;
  final selectPaymentMethod = Rx(-1);
  String paymentMethodSlug = "";
  int? paymentMethodId;
  TextEditingController couponTextController = TextEditingController();
  final isCouponApply = false.obs;
  final isCutleryActive = false.obs;
  final tipIndex = RxInt(-1);
  final riderTipAmount = 0.obs;
  final deliveryCharge = 0.0.obs;
  final siteServiceFee = 0.0.obs;
  bool orderPlacedFlag = false;
  final freeDeliveryFeeVoucher = false.obs;
  final couponDiscountText = "".obs;
  final isRiderTipStatusActive = false.obs;
  final isCulteryStatusActive = false.obs;

  Future<void> getTodayDeliveryTime({required int restaurantId}) async {
    final response = await _deliveryTimeRepo.getTodaysDeliveryTime(
      restaurantId: restaurantId,
    );
    response.fold((error) => null, (data) {
      deliveryTimeModel.value = data;
    });
  }

  Future<void> getTomorrowDeliveryTime({required int restaurantId}) async {
    final response = await _deliveryTimeRepo.getTomorrowDeliveryTime(
      restaurantId: restaurantId,
    );
    response.fold((error) => null, (data) {
      deliveryTimeModel.value = data;
    });
  }

  Future<void> getPaymentGateways() async {
    final data = await _paymentRepo.getPaymentGateways();
    data.fold((l) => null, (data) {
      final profileController = Get.find<ProfileController>();
      int cashOnDelivery =
          profileController.settingModel.data?.siteCashOnDelivery ?? 5;
      int onlinePayment =
          profileController.settingModel.data?.siteOnlinePaymentGateway ?? 5;

      if (data.data != null) {
        paymentMethods.value = data.data!
            .where((e) => e.slug == "cashondelivery" || e.slug == "paytr")
            .map((e) {
              if (e.slug == "cashondelivery") {
                return PaymentMethod(
                  id: e.id,
                  name: "Kapıda Ödeme",
                  slug: e.slug,
                  status: e.status,
                  image: e.image,
                );
              }
              return e;
            })
            .toList();
      } else {
        paymentMethods.value = [];
      }
    });
  }

  Future<void> getAllCoupons({required String restaurantId}) async {
    final data = await _couponRepo.getCoupons(restaurantId: restaurantId);
    data.fold((l) => null, (data) {
      couponModel.value = data;
    });
  }

  Future<void> applyCoupon({
    required int restaurantId,
    required String code,
    required double total,
  }) async {
    final data = await _couponRepo.applyCoupon(
      restaurantId: restaurantId,
      code: code,
      total: total,
    );

    if (data.isRight()) {
      isCouponApply.value = true;
      Get.back();
      customSnackbar(
        "SUCCESS".tr,
        "Coupon Applied Successfully",
        AppColor.positiveDark,
      );
    } else {
      isCouponApply.value = false;
    }

    data.fold((l) {}, (data) {
      applyCouponModel.value = data;
      freeDeliveryFeeVoucher.value = data.data?.convertDiscount == 0
          ? true
          : false;
    });
  }

  Future<void> riderTips() async {
    final result = await _checkoutRepo.riderTips();

    result.fold((error) {}, (tip) {
      tipModel.value = tip;
    });
  }

  getRiderTipAmount(int amount) {
    riderTipAmount.value = amount;
  }

  double calculateDeliveryCharge(double distance, SettingModel settingModel) {
    double deliveryCharge = 0;
    double deliveryDistance = double.parse(distance.toStringAsFixed(2));
    double basicDeliveryFee = double.parse(
      settingModel.data?.deliverySetupBasicDeliveryFee.toString() ?? "0.0",
    );
    double freeDeliveryKilometer = double.parse(
      settingModel.data?.deliverySetupFreeDeliveryKilometer.toString() ?? "0.0",
    );
    double perKiloDeliveryCharge = double.parse(
      settingModel.data?.deliverySetupChargePerKilo.toString() ?? "0.0",
    );

    if (deliveryDistance <=
        double.parse(
          settingModel.data!.deliverySetupFreeDeliveryKilometer.toString(),
        )) {
      deliveryCharge = basicDeliveryFee;
    } else {
      double overDistance = deliveryDistance - freeDeliveryKilometer;
      deliveryCharge =
          basicDeliveryFee + (overDistance * perKiloDeliveryCharge);
    }

    return deliveryCharge;
  }

  void setCouponDiscountText(double discountAmount) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      couponDiscountText.value = formatPriceWithCurrency(discountAmount);
    });
  }

  reset() {
    selectAddress.value = -1;
    selectTime.value = -1;
    selectDesireTime.value = -1;
    selectPaymentMethod.value = -1;
    paymentMethodId = null;
    isCutleryActive.value = false;
    tipIndex.value = -1;
    riderTipAmount.value = 0;
  }

  allResetAfterPlacedOrder() {
    final cartController = Get.find<CartController>();
    selectAddress.value = -1;
    selectTime.value = -1;
    selectDesireTime.value = -1;
    selectPaymentMethod.value = -1;
    paymentMethodId = null;
    isCutleryActive.value = false;
    tipIndex.value = -1;
    isCouponApply.value = false;
    orderPlacedFlag = true;
    cartController.isDeliver.value = true;
    couponDiscountText.value = "";
    deliveryCharge.value = 0.0;
    siteServiceFee.value = 0.0;
    riderTipAmount.value = 0;
    cartController.taxAmount.value = 0.0;
    cartController.finalTotalAmount.value = 0.0;
  }
}
