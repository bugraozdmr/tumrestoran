import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_dashed_line/dotted_dashed_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodnanny/app/features/address/controller/address_controller.dart';
import 'package:foodnanny/app/features/cart/controller/cart_controller.dart';
import 'package:foodnanny/app/features/checkout/controller/checkout_controller.dart';
import 'package:foodnanny/app/features/checkout/components/coupon_applied.dart';
import 'package:foodnanny/app/features/payment/payment_view.dart';
import 'package:foodnanny/app/features/profile/controller/profile_controller.dart';
import 'package:foodnanny/app/features/restaurant_details/controller/restaurant_details_controller.dart';
import 'package:foodnanny/config/theme/app_color.dart';
import 'package:foodnanny/main.dart';
import 'package:foodnanny/utils/helper/discount_calculation.dart';
import 'package:foodnanny/utils/helper/format_price_with_currency.dart';
import 'package:foodnanny/utils/helper/format_variations_by_group.dart';
import 'package:foodnanny/utils/svg_icon.dart';
import 'package:foodnanny/widgets/appbar_widget.dart';
import 'package:foodnanny/widgets/custom_snackbar.dart';
import 'package:foodnanny/widgets/divider_widget.dart';
import 'package:foodnanny/widgets/normal_text.dart';
import 'package:foodnanny/widgets/text_widget.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../components/coupon.dart';
import '../components/coupon_dialog.dart';

import 'widgets/delivery_address_section.dart';
import 'widgets/delivery_time_section.dart';
import 'widgets/payment_method_section.dart';
import 'widgets/rider_tip_section.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final checkoutController = Get.put(CheckoutController());
  final cartController = Get.find<CartController>();
  final addressController = Get.put(AddressController());
  final restaurantDetailsController = Get.put(RestaurantDetailsController());
  final profileController = Get.find<ProfileController>();
  GoogleMapController? controller;

  double serviceFee = 0.0;

  @override
  void initState() {
    super.initState();

    checkoutInit();
  }

  checkoutInit() async {
    checkoutController.deliveryCharge.value = 0.0;
    checkoutController.isCouponApply.value = false;
    await profileController.getSettings();
    serviceFee = double.parse(
      profileController.settingModel.data?.siteServiceFee.toString() ?? "0.0",
    );

    final getSetting = Get.find<ProfileController>().getSettings();
    final address = addressController.getAddresses();
    final payment = checkoutController.getPaymentGateways();
    final riderTips = checkoutController.riderTips();
    final allCoupon = checkoutController.getAllCoupons(
      restaurantId: cartController.restId.value.toString(),
    );

    Future.wait([getSetting, address, payment, riderTips, allCoupon]);

    checkoutController.isRiderTipStatusActive.value =
        profileController.settingModel.data?.siteRidertip == 5 ? true : false;

    checkoutController.isCulteryStatusActive.value =
        profileController.settingModel.data?.siteCutlery == 5 ? true : false;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      checkoutController.reset();
    });
    super.dispose();
  }

  CameraPosition initialCameraPosition = CameraPosition(
    target: LatLng(
      double.parse((box.read('pickedLat') ?? '0.0').toString()),
      double.parse((box.read('pickedLong') ?? '0.0').toString()),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,

      appBar: AppBarWidget(
        isIcon: true,
        iconButton: IconButton(
          icon: Container(
            height: 24.h,
            width: 24.w,
            decoration: BoxDecoration(
              color: AppColor.whiteColor,
              shape: BoxShape.circle,
              border: Border.all(color: AppColor.primaryColor),
            ),
            child: Padding(
              padding: EdgeInsets.all(4.r),
              child: SvgPicture.asset(
                SvgIcon.arrowLeftCircle,
                height: 24.h,
                width: 24.w,
                colorFilter: ColorFilter.mode(
                  AppColor.primaryColor,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          onPressed: () {
            Get.back();
          },
        ),
        text: "CHECKOUT".tr,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: RefreshIndicator(
            color: AppColor.primaryColor,
            onRefresh: () async {
              profileController.getSettings();

              await checkoutInit();
              checkoutController.reset();
            },
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16.h),

                  pickUpAddressSection(),
                  SizedBox(height: 8.h),

                  DeliveryAddressSection(
                    addressController: addressController,
                    checkoutController: checkoutController,
                    cartController: cartController,
                  ),

                  SizedBox(height: 16.h),
                  const DividerWidget(),
                  SizedBox(height: 16.h),

                  DeliveryTimeSection(
                    checkoutController: checkoutController,
                    cartController: cartController,
                  ),

                  PaymentMethodSection(checkoutController: checkoutController),

                  Obx(
                    () => checkoutController.isRiderTipStatusActive.value
                        ? Padding(
                            padding: EdgeInsets.only(bottom: 24.h),
                            child: RiderTipSection(
                              cartController: cartController,
                              checkoutController: checkoutController,
                            ),
                          )
                        : SizedBox.shrink(),
                  ),

                  orderSummarySection(),

                  SizedBox(height: 28.h),
                  /*--------- [ Place Order Button ] ---------*/
                  GestureDetector(
                    onTap: () async {
                      var itemJson = cartController.cartItems.map((e) {
                        var itemVariationJson = e.variationObject?.map((
                          variation,
                        ) {
                          return {
                            "id": variation.id ?? 0,
                            "name": variation.name ?? "",
                            "attribute_name":
                                variation.itemAttribute?.name ?? "",
                          };
                        }).toList();

                        return {
                          "item_id": e.product.id,
                          "item_price": e.product.convertPrice,
                          "item_name": e.product.name,
                          "instruction": e.instructionText,
                          "quantity": e.quantity.value,
                          "discount": 0,
                          "total_price": e.getItemTotal(),
                          "item_variation_total": e.variationTotalPrice,
                          "item_extra_total": e.extrasTotalPrice,
                          "item_variations": itemVariationJson,
                          "item_extras": e.extrasObject,
                          "tax_rate": e.taxRate ?? 0,
                          "tax_name": e.product.tax?.name,
                          "tax_type": e.product.tax?.type,
                          "tax_amount": cartController.taxAmount.value,
                        };
                      }).toList();

                      itemJson += cartController.addonCartList.map((e) {
                        var addonVariationJson = e.addon.variationNames?.map((
                          variation,
                        ) {
                          return {
                            "id": variation.id ?? 0,
                            "name": variation.name ?? "",
                            "attribute_name": variation.attributeName ?? "",
                          };
                        }).toList();

                        return {
                          "item_id": e.addon.itemAddonId,
                          "item_name": e.addon.addonItemName,
                          "item_price": e.addon.addonItemConvertPrice,
                          "instruction": "",
                          "quantity": e.quantity.value,
                          "discount": 0,
                          "total_price": e.addon.totalConvertPrice,
                          "item_variation_total": 0,
                          "item_extra_total": 0,
                          "item_variations": addonVariationJson,
                          "item_extras": [],
                          "tax_rate": e.addon.addonItemTax?.taxRate ?? 0,
                          "tax_name": e.addon.addonItemTax?.name,
                          "tax_type": e.addon.addonItemTax?.type,
                          "tax_amount": cartController.taxAmount.value,
                        };
                      }).toList();

                      var itemData = jsonEncode(itemJson);

                      if (cartController.isDeliver.value &&
                          checkoutController.selectAddress.value == -1) {
                        customSnackbar(
                          "ERROR".tr,
                          "PLEASE_SELECT_AN_ADDRESS".tr,
                          AppColor.negativeDark,
                        );
                        return;
                      }

                      if (!checkTimeValidation()) {
                        customSnackbar(
                          "ERROR".tr,
                          "PLEASE_SELECT_DELIVERY_TIME".tr,
                          AppColor.negativeDark,
                        );
                        return;
                      }

                      if (checkoutController.paymentMethodId == null) {
                        customSnackbar(
                          "ERROR".tr,
                          "PLEASE_SELECT_A_PAYMENT_METHOD".tr,
                          AppColor.negativeDark,
                        );
                        return;
                      }

                      if (checkoutController.paymentMethodSlug == "credit") {
                        final creditBalance = double.parse(
                          profileController.profileModel.value.data?.balance
                                  .toString() ??
                              "0.0",
                        );
                        if (cartController.finalTotalAmount.value >
                            creditBalance) {
                          customSnackbar(
                            "ERROR".tr,
                            "INSUFFICIENT_BALANCE".tr,
                            AppColor.negativeDark,
                          );
                          return;
                        }
                      }

                      bool orderSuccessful = await cartController.placeOrder(
                        addressId: cartController.isDeliver.value
                            ? checkoutController.addressId
                            : 0,
                        couponId:
                            checkoutController.applyCouponModel.value.data?.id,
                        cutlery: checkoutController.isCutleryActive.value
                            ? 5
                            : 10,
                        deliveryFee:
                            cartController.isDeliver.value &&
                                !(checkoutController.isCouponApply.value &&
                                    checkoutController
                                        .freeDeliveryFeeVoucher
                                        .value)
                            ? checkoutController.deliveryCharge.value
                            : 0,
                        extraDeliveryFee: cartController.extraDeliveryFee.value,
                        deliveryTime: cartController.isDeliver.value
                            ? checkoutController.deliveryTime
                            : 0,
                        discount:
                            checkoutController
                                .applyCouponModel
                                .value
                                .data
                                ?.convertDiscount
                                ?.toDouble() ??
                            0.0,
                        isAdvancedOrder:
                            checkoutController.selectTime.value == 5 ? 10 : 5,
                        items: itemData.toString(),
                        orderType: cartController.isDeliver.value ? 5 : 10,
                        paymentMethod: checkoutController.paymentMethodId,
                        restaurantId: cartController.restId.value,
                        riderTip: double.parse(
                          checkoutController.riderTipAmount.value.toString(),
                        ),
                        serviceFee: serviceFee,

                        source: 10,
                        subtotal:
                            cartController.totalPrice +
                            cartController.addonCartTotal,
                        tax: cartController.taxAmount.value,
                        total: cartController.finalTotalAmount.value,
                      );

                      if (orderSuccessful) {
                        Get.to(
                          () => PaymentView(
                            slug: checkoutController.paymentMethodSlug,
                            orderId: box.read("orderId"),
                          ),
                        );
                      }
                    },

                    /*------[ End Place Order ]------ */
                    child: Container(
                      height: 48.h,
                      width: 328.w,
                      decoration: BoxDecoration(
                        color: AppColor.primaryColor,
                        borderRadius: BorderRadius.circular(24.r),
                      ),
                      child: Center(
                        child: NormalText(
                          text: "PLACE_ORDER".tr,
                          color: AppColor.whiteColor,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Obx pickUpAddressSection() {
    return Obx(
      () => cartController.isDeliver.value == false
          ? Column(
              children: [
                Container(
                  height: 110.h,
                  width: 328.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child: Container(
                          color: AppColor.primaryLight,
                          child: Center(
                            child: Icon(Icons.location_on, color: AppColor.primaryColor, size: 40),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8.h),
                SizedBox(
                  child: Row(
                    children: [
                      Column(
                        children: [
                          SvgPicture.asset(SvgIcon.shop, height: 24.h),
                        ],
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            NormalText(
                              text: box.read('pickAddress') ?? "",
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : const SizedBox(),
    );
  }

  Container orderSummarySection() {
    return Container(
      width: 328.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: AppColor.whiteColor,
        boxShadow: [
          BoxShadow(
            color: AppColor.black10,
            blurRadius: 2.r,
            spreadRadius: 1.r,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NormalText(
              text: "ORDER_SUMMARY_FROM".tr,
              color: AppColor.black80,
              fontSize: 12.sp,
            ),
            NormalText(
              text: cartController.restaurantName.value,
              fontSize: 22.sp,
              fontWeight: FontWeight.w500,
              color: AppColor.black100,
            ),
            SizedBox(height: 16.h),
            Obx(
              () =>
                  cartController.deliveryStatus.value != 5 &&
                      cartController.takewayStatus.value != 5
                  ? SizedBox.shrink()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 42.h,
                          decoration: BoxDecoration(
                            color: AppColor.background,
                            borderRadius: BorderRadius.circular(21.r),
                            border: Border.all(color: AppColor.black20),
                          ),
                          child: Row(
                            children: [
                              if (cartController.deliveryStatus.value == 5)
                                GestureDetector(
                                  onTap: () {
                                    cartController.isDeliver.value = true;
                                  },
                                  child: Container(
                                    height: 42.h,
                                    width: 88.w,
                                    decoration: BoxDecoration(
                                      color:
                                          cartController.isDeliver.value == true
                                          ? AppColor.black100
                                          : AppColor.background,
                                      borderRadius: BorderRadius.circular(21.r),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 16.w,
                                      ),
                                      child: Center(
                                        child: NormalText(
                                          text: "DELIVERY".tr,
                                          color:
                                              cartController.isDeliver.value ==
                                                  true
                                              ? AppColor.whiteColor
                                              : AppColor.black100,
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              if (cartController.takewayStatus.value == 5)
                                GestureDetector(
                                  onTap: () {
                                    cartController.isDeliver.value = false;
                                    checkoutController.selectAddress.value = -1;

                                    checkoutController.deliveryCharge.value =
                                        0.0;

                                    checkoutController.tipIndex.value = -1;
                                    checkoutController.riderTipAmount.value = 0;
                                  },
                                  child: Container(
                                    height: 42.h,
                                    width: 88.w,
                                    decoration: BoxDecoration(
                                      color:
                                          cartController.isDeliver.value ==
                                              false
                                          ? AppColor.black100
                                          : AppColor.background,
                                      borderRadius: BorderRadius.circular(21.r),
                                    ),
                                    child: Center(
                                      child: NormalText(
                                        text: "TAKEAWAY".tr,
                                        fontSize: 14.sp,
                                        color:
                                            cartController.isDeliver.value ==
                                                false
                                            ? AppColor.whiteColor
                                            : AppColor.black100,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
            ),

            SizedBox(height: 16.h),
            const DividerWidget(),
            SizedBox(height: 12.h),
            Stack(
              children: [
                Column(
                  children: [
                    Obx(
                      () => ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: cartController.cartItems.length,
                        itemBuilder: (context, index) {
                          cartController.itemsTotalPrice.value =
                              double.parse(
                                cartController
                                    .cartItems[index]
                                    .product
                                    .convertPrice
                                    .toString(),
                              ) *
                              cartController.cartItems[index].quantity.value;
                          return Column(
                            children: [
                              Row(
                                children: [
                                  Stack(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 12.w,
                                        ),
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              cartController
                                                  .cartItems[index]
                                                  .product
                                                  .thumb ??
                                              "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?q=80&w=1998&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  Container(
                                                    height: 54.h,
                                                    width: 54.w,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8.r,
                                                          ),
                                                      image: DecorationImage(
                                                        image: imageProvider,
                                                        fit: BoxFit.fill,
                                                      ),
                                                    ),
                                                  ),
                                        ),
                                      ),

                                      Positioned(
                                        top: 12.h,
                                        left: 0.w,
                                        child: Container(
                                          height: 26.h,
                                          width: 26.w,
                                          decoration: BoxDecoration(
                                            color: AppColor.black100,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Center(
                                            child: NormalText(
                                              text: cartController
                                                  .cartItems[index]
                                                  .quantity
                                                  .toString(),
                                              color: AppColor.whiteColor,
                                              fontSize: 14.sp,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        NormalText(
                                          text:
                                              cartController
                                                  .cartItems[index]
                                                  .product
                                                  .name ??
                                              "Creamy Cheese Burger",
                                          fontSize: 14.sp,
                                        ),

                                        cartController
                                                .cartItems[index]
                                                .variationObject!
                                                .isNotEmpty
                                            ? Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children:
                                                    cartController
                                                        .cartItems[index]
                                                        .variationObject
                                                        ?.where(
                                                          (variation) =>
                                                              variation.name !=
                                                              null,
                                                        )
                                                        .map(
                                                          (v) => TextWidget(
                                                            text:
                                                                "${v.itemAttribute?.name}: ${v.name}",
                                                            fontSize: 12.sp,
                                                            color: AppColor
                                                                .black80,
                                                          ),
                                                        )
                                                        .toList() ??
                                                    [],
                                              )
                                            : SizedBox.shrink(),

                                        Obx(() {
                                          final itemPrice = cartController
                                              .cartItems[index]
                                              .getItemTotal();
                                          return NormalText(
                                            text: formatPriceWithCurrency(
                                              itemPrice,
                                            ),
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w500,
                                          );
                                        }),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 9.h),

                              cartController
                                      .cartItems[index]
                                      .extrasText!
                                      .isEmpty
                                  ? const SizedBox()
                                  : Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        NormalText(
                                          text: "Extras: ".tr,
                                          fontSize: 12.sp,
                                        ),
                                        Expanded(
                                          child: TextWidget(
                                            text:
                                                cartController
                                                    .cartItems[index]
                                                    .extrasText ??
                                                "",
                                            fontSize: 12.sp,
                                            color: AppColor.black80,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),

                              cartController
                                      .cartItems[index]
                                      .instructionText!
                                      .isEmpty
                                  ? const SizedBox()
                                  : Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        NormalText(
                                          text: "Instructions: ".tr,
                                          fontSize: 12.sp,
                                        ),
                                        Expanded(
                                          child: TextWidget(
                                            text:
                                                cartController
                                                    .cartItems[index]
                                                    .instructionText ??
                                                "",
                                            fontSize: 12.sp,
                                            color: AppColor.black80,
                                          ),
                                        ),
                                      ],
                                    ),
                            ],
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            child: const DividerWidget(),
                          );
                        },
                      ),
                    ),

                    SizedBox(height: 8.h),

                    cartController.addonCartList.isEmpty
                        ? const SizedBox()
                        : Obx(
                            () => ListView.separated(
                              shrinkWrap: true,
                              itemCount: cartController.addonCartList.length,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    Row(
                                      children: [
                                        Stack(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 12.w,
                                              ),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    cartController
                                                        .addonCartList[index]
                                                        .addon
                                                        .thumb ??
                                                    "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?q=80&w=1998&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                                                imageBuilder:
                                                    (
                                                      context,
                                                      imageProvider,
                                                    ) => Container(
                                                      height: 54.h,
                                                      width: 54.w,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              8.r,
                                                            ),
                                                        image: DecorationImage(
                                                          image: imageProvider,
                                                          fit: BoxFit.fill,
                                                        ),
                                                      ),
                                                    ),
                                              ),
                                            ),

                                            Positioned(
                                              top: 12.h,
                                              left: 0.w,
                                              child: Container(
                                                height: 26.h,
                                                width: 26.w,
                                                decoration: BoxDecoration(
                                                  color: AppColor.black100,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Center(
                                                  child: NormalText(
                                                    text: cartController
                                                        .addonCartList[index]
                                                        .quantity
                                                        .toString(),
                                                    color: AppColor.whiteColor,
                                                    fontSize: 14.sp,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),

                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              NormalText(
                                                text:
                                                    cartController
                                                        .addonCartList[index]
                                                        .addon
                                                        .addonItemName ??
                                                    "Creamy Cheese Burger",
                                                fontSize: 14.sp,
                                              ),

                                              TextWidget(
                                                text:
                                                    formatVariationsByAttribute(
                                                      cartController
                                                          .addonCartList[index]
                                                          .addon
                                                          .variationNames,
                                                    ),
                                                fontSize: 12.sp,
                                                color: AppColor.black80,
                                              ),

                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Obx(() {
                                                    final addonPrice =
                                                        cartController
                                                            .addonCartList[index]
                                                            .addonCurrentPrice *
                                                        cartController
                                                            .addonCartList[index]
                                                            .quantity
                                                            .value;
                                                    return NormalText(
                                                      text:
                                                          formatPriceWithCurrency(
                                                            addonPrice,
                                                          ),
                                                      fontSize: 12.sp,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    );
                                                  }),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 9.h),
                                  ],
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                    return Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 12.h,
                                      ),
                                      child: const DividerWidget(),
                                    );
                                  },
                            ),
                          ),
                  ],
                ),
              ],
            ),

            SizedBox(height: 16.h),

            Obx(
              () => checkoutController.isCulteryStatusActive.value
                  ? Padding(
                      padding: EdgeInsetsGeometry.only(bottom: 16.h),
                      child: Row(
                        children: [
                          Column(
                            children: [
                              SvgPicture.asset(SvgIcon.cutlery, height: 24.h),
                            ],
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextWidget(
                                  text: "CUTLERY".tr,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                                TextWidget(
                                  text: 'CUTLERY_WILL_PROVIDE_WITH_YOUR_ORDER'.tr,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              Obx(
                                () => SizedBox(
                                  height: 32.h,
                                  child: FittedBox(
                                    child: Switch(
                                      activeThumbColor: AppColor.primaryColor,
                                      inactiveThumbColor: Colors.grey.shade100,
                                      inactiveTrackColor: AppColor.black100
                                          .withAlpha(102),
                                      value: checkoutController
                                          .isCutleryActive
                                          .value,
                                      onChanged: (active) {
                                        checkoutController
                                                .isCutleryActive
                                                .value =
                                            active;
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  : SizedBox.shrink(),
            ),

            Obx(() {
              return checkoutController.isCouponApply.value
                  ? CouponAppliedWidget(
                      type:
                          checkoutController
                              .applyCouponModel
                              .value
                              .data
                              ?.type ??
                          5,
                      discount: checkoutController
                          .applyCouponModel
                          .value
                          .data
                          ?.discountAlt,

                      deleteCoupon: () {
                        checkoutController.isCouponApply.value = false;
                        checkoutController.couponDiscountText.value = "";
                      },
                    )
                  : GestureDetector(
                      onTap: () {
                        Get.dialog(
                          CouponDialog(
                            applyCoupon: () async {
                              await checkoutController.applyCoupon(
                                restaurantId: cartController.restId.value,
                                code: checkoutController
                                    .couponTextController
                                    .text,
                                total:
                                    cartController.totalPrice +
                                    cartController.addonTotalPrice.value +
                                    0,
                              );
                            },
                            checkoutController: checkoutController,
                            cartController: cartController,
                          ),
                        );
                      },
                      child: const CouponWidget(),
                    );
            }),
            SizedBox(height: 16.h),

            Obx(() {
              final addonCartTotal = cartController.addonCartTotal;
              final subTotal = cartController.totalPrice + addonCartTotal;
              final deliveryFee =
                  (checkoutController.isCouponApply.value &&
                      checkoutController.freeDeliveryFeeVoucher.value)
                  ? 0.0
                  : checkoutController.deliveryCharge.value;

              final serviceFee = double.parse(
                profileController.settingModel.data?.siteServiceFee
                        .toString() ??
                    "0.00",
              );
              final isTipZero =
                  checkoutController.tipIndex.value == -1 ||
                  (checkoutController
                              .tipModel
                              .value
                              .data?[checkoutController.tipIndex.value]
                              .amount ??
                          0) ==
                      0;
              final tipAmount = isTipZero
                  ? 0.0
                  : checkoutController.riderTipAmount.value;

              final taxAmount = cartController.taxAmount;

              final maximumDiscountAmount = double.parse(
                checkoutController
                        .applyCouponModel
                        .value
                        .data
                        ?.maximumDiscount ??
                    '0.0',
              );

              final discount = calculateDiscount(
                isCouponApplied: checkoutController.isCouponApply.value,
                subTotal: subTotal,
                discountType:
                    checkoutController.applyCouponModel.value.data?.discountType
                        .toString() ??
                    "5",
                discountValue:
                    checkoutController
                        .applyCouponModel
                        .value
                        .data
                        ?.convertDiscount
                        ?.toDouble() ??
                    0.0,
                maximumDiscount: maximumDiscountAmount,
              );

              checkoutController.setCouponDiscountText(discount);

              final subtotalText = formatPriceWithCurrency(subTotal);
              final deliveryFeeText = formatPriceWithCurrency(deliveryFee);

              final serviceFeeText = formatPriceWithCurrency(serviceFee);

              final tipAmountText = formatPriceWithCurrency(
                tipAmount.toDouble(),
              );
              final taxAmountText = formatPriceWithCurrency(taxAmount.value);
              final discountText = formatPriceWithCurrency(discount.toDouble());

              return Container(
                width: 296.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: AppColor.black20),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: 12.w,
                        right: 12.h,
                        top: 12.h,
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              NormalText(text: "SUBTOTAL".tr, fontSize: 14.sp),
                              NormalText(text: subtotalText, fontSize: 14.sp),
                            ],
                          ),

                          cartController.isDeliver.value
                              ? Padding(
                                  padding: EdgeInsets.only(top: 8.h),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      NormalText(
                                        text: "DELIVERY_FEE".tr,
                                        fontSize: 14.sp,
                                      ),
                                      NormalText(
                                        text: deliveryFeeText,

                                        fontSize: 14.sp,
                                        color: AppColor.positiveDark,
                                      ),
                                    ],
                                  ),
                                )
                              : SizedBox(),

                          SizedBox(height: 8.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              NormalText(
                                text: "SERVICE_FEE".tr,
                                fontSize: 14.sp,
                              ),
                              NormalText(
                                text: serviceFeeText,

                                fontSize: 14.sp,
                                color: AppColor.black100,
                              ),
                            ],
                          ),

                          cartController.isDeliver.value
                              ? Padding(
                                  padding: EdgeInsets.only(top: 8.h),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      NormalText(
                                        text: "RIDER_TIP".tr,
                                        fontSize: 14.sp,
                                      ),
                                      NormalText(
                                        text: tipAmountText,
                                        fontSize: 14.sp,
                                        color: AppColor.black100,
                                      ),
                                    ],
                                  ),
                                )
                              : SizedBox(),

                          SizedBox(height: 8.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              NormalText(text: "TAX".tr, fontSize: 14.sp),

                              NormalText(
                                text: taxAmountText,
                                fontSize: 14.sp,
                                color: AppColor.black100,
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),

                          Obx(
                            () =>
                                checkoutController.isCouponApply.value &&
                                    checkoutController
                                            .applyCouponModel
                                            .value
                                            .data!
                                            .type !=
                                        10
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      NormalText(
                                        text: "DISCOUNT".tr,
                                        fontSize: 14.sp,
                                      ),
                                      NormalText(
                                        text: discountText,
                                        fontSize: 14.sp,
                                      ),
                                    ],
                                  )
                                : SizedBox(),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 12.h),
                    const DottedDashedLine(
                      height: 0,
                      width: double.infinity,
                      axis: Axis.horizontal,
                      dashColor: AppColor.black20,
                    ),
                    SizedBox(height: 12.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: 8.h),
                            child: Row(
                              children: [
                                NormalText(
                                  text: "TOTAL".tr,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                                SizedBox(width: 4.w),
                                NormalText(
                                  text: "INCLUDE_FEES_AND_TAX".tr,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ],
                            ),
                          ),
                          Obx(() {
                            final finalDeliveryCharge =
                                checkoutController.isCouponApply.value &&
                                    checkoutController
                                        .freeDeliveryFeeVoucher
                                        .value
                                ? 0.0
                                : checkoutController.deliveryCharge.value;
                            cartController.finalTotalAmount.value =
                                serviceFee +
                                double.parse(
                                  ((finalDeliveryCharge +
                                              cartController.totalPrice +
                                              addonCartTotal +
                                              cartController.taxAmount.value +
                                              checkoutController
                                                  .riderTipAmount
                                                  .value) -
                                          (checkoutController
                                                      .isCouponApply
                                                      .value ==
                                                  false
                                              ? 0
                                              : discount))
                                      .toStringAsFixed(2),
                                );

                            return NormalText(
                              text: formatPriceWithCurrency(
                                cartController.finalTotalAmount.value,
                              ),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            );
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  bool checkTimeValidation() {
    bool isValidated = false;

    if (checkoutController.selectTime.value != -1) {
      isValidated = true;
    } else {
      isValidated = false;
    }

    if (isValidated) {
      if (checkoutController.selectTime.value == 5) {
      } else if (checkoutController.selectTime.value == 10) {
        if (checkoutController.selectDesireTime.value == -1) {
          isValidated = false;
        }
      }
    }

    return isValidated;
  }
}
