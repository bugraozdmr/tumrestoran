import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tumrestoran/app/features/auth/view/login_screen.dart';
import 'package:tumrestoran/app/features/checkout/view/checkout_screen.dart';
import 'package:tumrestoran/app/features/profile/controller/profile_controller.dart';
import 'package:tumrestoran/app/features/restaurant_details/controller/restaurant_details_controller.dart';
import 'package:tumrestoran/config/theme/app_color.dart';
import 'package:tumrestoran/main.dart';
import 'package:tumrestoran/utils/helper/format_price_with_currency.dart';
import 'package:tumrestoran/widgets/custom_snackbar.dart';
import 'package:tumrestoran/widgets/divider_widget.dart';
import 'package:tumrestoran/widgets/normal_text.dart';
import 'package:tumrestoran/widgets/title_text.dart';
import 'package:get/get.dart';
import '../../../../utils/svg_icon.dart';
import '../../../../widgets/primary_button.dart';
import '../../../../widgets/text_widget.dart';
import '../controller/cart_controller.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final cartController = Get.find<CartController>();
  final profileController = Get.put(ProfileController());
  final restaurantDetailsController = Get.put(RestaurantDetailsController());

  double minimumOrder = 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      minimumOrder = double.parse(box.read("minimumOrder").toString());
      cartController.isDeliver.value = cartController.deliveryStatus.value == 5
          ? true
          : false;

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 12.h),
              NormalText(
                text: "YOUR_CART_FROM".tr,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: AppColor.black80,
              ),
              TitleText(
                text: cartController.restaurantName.value,
                fontSize: 22.sp,
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
                                      decoration: BoxDecoration(
                                        color:
                                            cartController.isDeliver.value ==
                                                true
                                            ? AppColor.black100
                                            : AppColor.background,
                                        borderRadius: BorderRadius.circular(
                                          21.r,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 16.w,
                                        ),
                                        child: Center(
                                          child: NormalText(
                                            text: "DELIVERY".tr,
                                            color:
                                                cartController
                                                        .isDeliver
                                                        .value ==
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
                                    },
                                    child: Container(
                                      height: 42.h,
                                      decoration: BoxDecoration(
                                        color:
                                            cartController.isDeliver.value ==
                                                false
                                            ? AppColor.black100
                                            : AppColor.background,
                                        borderRadius: BorderRadius.circular(
                                          21.r,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 16.w,
                                        ),
                                        child: Center(
                                          child: NormalText(
                                            text: "TAKEAWAY".tr,
                                            fontSize: 14.sp,
                                            color:
                                                cartController
                                                        .isDeliver
                                                        .value ==
                                                    false
                                                ? AppColor.whiteColor
                                                : AppColor.black100,
                                          ),
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
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
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
                                    Column(
                                      children: [
                                        CachedNetworkImage(
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
                                      ],
                                    ),
                                    SizedBox(width: 12.w),
                                    /*--------- [ Product Info ] ---------*/
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

                                          /*--------- [ Variation Text ] ---------*/
                                          Column(
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
                                                        color: AppColor.black80,
                                                      ),
                                                    )
                                                    .toList() ??
                                                [],
                                          ),

                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
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
                                              SizedBox(
                                                child: Row(
                                                  children: [
                                                    Obx(
                                                      () =>
                                                          cartController
                                                                  .cartItems[index]
                                                                  .quantity
                                                                  .value !=
                                                              1
                                                          ? GestureDetector(
                                                              onTap: () {
                                                                cartController
                                                                    .decrementItem(
                                                                      cartController
                                                                          .cartItems[index],
                                                                    );
                                                              },
                                                              child: SvgPicture.asset(
                                                                SvgIcon
                                                                    .minusCircle,
                                                                height: 16.h,
                                                              ),
                                                            )
                                                          : GestureDetector(
                                                              onTap: () {
                                                                cartController
                                                                    .cartItems
                                                                    .remove(
                                                                      cartController
                                                                          .cartItems[index],
                                                                    );
                                                              },
                                                              child:
                                                                  SvgPicture.asset(
                                                                    SvgIcon
                                                                        .trash,
                                                                    height:
                                                                        16.h,
                                                                  ),
                                                            ),
                                                    ),
                                                    SizedBox(width: 12.w),
                                                    Obx(
                                                      () => NormalText(
                                                        text: cartController
                                                            .cartItems[index]
                                                            .quantity
                                                            .value
                                                            .toString(),
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    SizedBox(width: 12.w),
                                                    GestureDetector(
                                                      onTap: () {
                                                        cartController
                                                            .incrementItem(
                                                              cartController
                                                                  .cartItems[index],
                                                            );
                                                      },
                                                      child: SvgPicture.asset(
                                                        SvgIcon.addCircle,
                                                        height: 16.h,
                                                        colorFilter:
                                                            ColorFilter.mode(
                                                              AppColor
                                                                  .primaryColor,
                                                              BlendMode.srcIn,
                                                            ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
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
                                            child: NormalText(
                                              text:
                                                  cartController
                                                      .cartItems[index]
                                                      .extrasText ??
                                                  "",
                                              fontSize: 12.sp,
                                              color: AppColor.black80,
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
                                            child: Text(
                                              cartController
                                                      .cartItems[index]
                                                      .instructionText ??
                                                  "",
                                              style: TextStyle(
                                                fontFamily: 'Rubik',
                                                fontSize: 12.sp,
                                                color: AppColor.black80,
                                              ),
                                              softWrap: true,
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
                                  cartController.addonTotalPrice.value =
                                      cartController
                                          .addonCartList[index]
                                          .addonCurrentPrice *
                                      cartController
                                          .addonCartList[index]
                                          .quantity
                                          .value;
                                  return Column(
                                    children: [
                                      Row(
                                        children: [
                                          Column(
                                            children: [
                                              CachedNetworkImage(
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
                                            ],
                                          ),
                                          SizedBox(width: 12.w),

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

                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: cartController
                                                      .addonCartList[index]
                                                      .addon
                                                      .variationNames!
                                                      .where(
                                                        (variation) =>
                                                            variation.name !=
                                                            null,
                                                      )
                                                      .map(
                                                        (v) => TextWidget(
                                                          text:
                                                              "${v.attributeName}: ${v.name}",

                                                          fontSize: 12.sp,
                                                          color:
                                                              AppColor.black80,
                                                        ),
                                                      )
                                                      .toList(),
                                                ),

                                                SizedBox(height: 4.h),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Obx(() {
                                                      final price =
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
                                                              price,
                                                            ),
                                                        fontSize: 12.sp,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      );
                                                    }),

                                                    SizedBox(
                                                      child: Row(
                                                        children: [
                                                          Obx(
                                                            () =>
                                                                cartController
                                                                        .addonCartList[index]
                                                                        .quantity
                                                                        .value !=
                                                                    1
                                                                ? GestureDetector(
                                                                    onTap: () {
                                                                      if (cartController
                                                                              .addonCartList[index]
                                                                              .quantity
                                                                              .value >
                                                                          1) {
                                                                        cartController
                                                                            .addonCartList[index]
                                                                            .quantity
                                                                            .value--;
                                                                      }
                                                                    },
                                                                    child: SvgPicture.asset(
                                                                      SvgIcon
                                                                          .minusCircle,
                                                                      height:
                                                                          16.h,
                                                                    ),
                                                                  )
                                                                : GestureDetector(
                                                                    onTap: () {
                                                                      cartController
                                                                          .addonCartList
                                                                          .remove(
                                                                            cartController.addonCartList[index],
                                                                          );
                                                                    },
                                                                    child: SvgPicture.asset(
                                                                      SvgIcon
                                                                          .trash,
                                                                      height:
                                                                          16.h,
                                                                    ),
                                                                  ),
                                                          ),
                                                          SizedBox(width: 12.w),
                                                          Obx(
                                                            () => NormalText(
                                                              text: cartController
                                                                  .addonCartList[index]
                                                                  .quantity
                                                                  .value
                                                                  .toString(),
                                                              fontSize: 14.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                          SizedBox(width: 12.w),
                                                          GestureDetector(
                                                            onTap: () {
                                                              final maxQnty = double.parse(
                                                                cartController
                                                                        .addonCartList[index]
                                                                        .addon
                                                                        .addonMaximumPurchaseQnty ??
                                                                    '100',
                                                              );

                                                              if (cartController
                                                                      .addonCartList[index]
                                                                      .quantity
                                                                      .value <
                                                                  maxQnty) {
                                                                cartController
                                                                    .addonCartList[index]
                                                                    .quantity
                                                                    .value++;
                                                              } else {
                                                                customSnackbar(
                                                                  "ERROR".tr,
                                                                  "MAXIMUM_PURCHASE_QUANTITY_LIMIT_EXCEEDED"
                                                                      .tr,
                                                                  AppColor
                                                                      .rejectedTextColor,
                                                                );
                                                              }
                                                            },
                                                            child: SvgPicture.asset(
                                                              SvgIcon.addCircle,
                                                              height: 16.h,
                                                              colorFilter:
                                                                  ColorFilter.mode(
                                                                    AppColor
                                                                        .primaryColor,
                                                                    BlendMode
                                                                        .srcIn,
                                                                  ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
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
                ),
              ),
              SizedBox(height: 16.h),
              Container(
                height: 48.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: AppColor.black20),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      NormalText(text: "SUBTOTAL".tr, fontSize: 14.sp),
                      Obx(() {
                        final subTotal =
                            cartController.totalPrice +
                            cartController.addonCartTotal;

                        return NormalText(
                          text: formatPriceWithCurrency(subTotal),
                          color: AppColor.green,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        );
                      }),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Obx(() {
                return cartController.cartItems.isEmpty ||
                        ((cartController.totalPrice +
                                cartController.addonCartTotal) <
                            minimumOrder)
                    ? PrimaryButton(
                        onTap: () {},
                        text: cartController.cartItems.isEmpty
                            ? "PROCEED_TO_CHECKOUT".tr
                            : "PROCEED_TO_CHECKOUT".tr +
                                  " (Min. order: ${formatPriceWithCurrency(minimumOrder)})"
                                      .tr,
                        width: 328.w,
                        color: AppColor.black40,
                      )
                    : PrimaryButton(
                        width: 328.w,
                        onTap: () {
                          if (box.read("isLoggedIn") == true) {
                            if (cartController.cartItems.isEmpty) {
                              customSnackbar(
                                "ERROR".tr,
                                "CART_IS_EMPTY".tr,
                                AppColor.negativeDark,
                              );
                            } else {
                              double itemTax = 0.0;
                              double addonItemTax = 0.0;
                              cartController.cartItems.map((item) {
                                itemTax +=
                                    ((item.itemPrice! * item.quantity.value) /
                                        100) *
                                    item.taxRate!;
                              }).toList();

                              cartController.addonCartList.map((
                                addonCartModel,
                              ) {
                                addonItemTax +=
                                    ((addonCartModel.addonCurrentPrice *
                                            addonCartModel.quantity.value) /
                                        100) *
                                    double.parse(
                                      addonCartModel
                                              .addon
                                              .addonItemTax
                                              ?.taxConvertRate
                                              .toString() ??
                                          "1",
                                    );
                              }).toList();

                              cartController.taxAmount.value =
                                  itemTax + addonItemTax;

                              Get.to(() => const CheckoutScreen());
                            }
                          } else {
                            Get.to(() => LoginScreen());
                          }
                        },
                        text: "PROCEED_TO_CHECKOUT".tr,
                      );
              }),
              SizedBox(height: 36.h),
            ],
          ),
        ),
      ),
    );
  }
}
