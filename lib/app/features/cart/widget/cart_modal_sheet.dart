import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:foodnanny/app/features/profile/controller/profile_controller.dart';
import 'package:foodnanny/app/features/restaurant_details/controller/restaurant_details_controller.dart';
import 'package:foodnanny/data/model/item_details_model.dart';
import 'package:foodnanny/data/model/restuarant_model.dart';
import 'package:foodnanny/utils/helper/format_price_with_currency.dart';
import 'package:foodnanny/utils/helper/get_item_price.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../config/theme/app_color.dart';
import '../../../../utils/style.dart';
import '../../../../utils/svg_icon.dart';
import '../../../../widgets/custom_snackbar.dart';
import '../../../../widgets/normal_text.dart';
import '../controller/cart_controller.dart';
import '../../restaurant_details/widgets/caution_dialog.dart';
import 'addon_list_view.dart';
import 'extras_list_view.dart';

class CartModalSheet extends StatefulWidget {
  const CartModalSheet({
    super.key,
    required this.item,
    required this.restaurant,
    required this.discountType,
    this.isSingleOffer = false,
    this.singleOfferPercentage = 0,
    this.hasDiscount = false,
  });

  final MainItem item;
  final Restaurant? restaurant;
  final String? discountType;
  final bool isSingleOffer;
  final int singleOfferPercentage;
  final bool hasDiscount;

  @override
  State<CartModalSheet> createState() => _CartModalSheetState();
}

class _CartModalSheetState extends State<CartModalSheet> {
  final restaurantDetailsController = Get.find<RestaurantDetailsController>();
  final cartController = Get.find<CartController>();
  final profileController = Get.put(ProfileController());
  var variationList = <Variation>[];

  double offerAmount = 0;
  late double finalPrice;
  final totalItemPrice = 0.0.obs;

  @override
  void initState() {
    super.initState();

    setInitialAttributes();

    offerAmount =
        double.tryParse(
          restaurantDetailsController.restaurantOfferModel.value.data?.amount
                  ?.toString() ??
              "0",
        ) ??
        0.0;
    calculate();
  }

  void setInitialAttributes() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      cartController.numOfItems.value = 1;
      if (restaurantDetailsController.itemDetails.value.data?.itemAttributes !=
          null) {
        for (
          int i = 0;
          i <
              restaurantDetailsController
                  .itemDetails
                  .value
                  .data!
                  .itemAttributes!
                  .length;
          i++
        ) {
          if (restaurantDetailsController
              .itemDetails
              .value
              .data!
              .variations!
              .isNotEmpty) {
            cartController.selectVariation(
              restaurantDetailsController
                  .itemDetails
                  .value
                  .data!
                  .variations![restaurantDetailsController
                  .itemDetails
                  .value
                  .data!
                  .itemAttributes![i]
                  .id
                  .toString()]![0],
              restaurantDetailsController
                  .itemDetails
                  .value
                  .data!
                  .variations![restaurantDetailsController
                      .itemDetails
                      .value
                      .data!
                      .itemAttributes![i]
                      .id
                      .toString()]![0]
                  .convertPrice,
            );

            calculate();
          }
        }
      }
      setState(() {});
    });
  }

  void calculate() {
    final basePrice =
        getItemPrice(
          price: widget.item.convertPrice ?? 0.0,
          isSingleOffer: widget.isSingleOffer,
          singleOfferPercentage: widget.singleOfferPercentage,
          discountedPrice: widget.item.convertDiscountedPrice ?? 0.0,
          discountedOption: widget.item.discountOption ?? "",
        ) *
        cartController.numOfItems.value;

    final variationTotal =
        cartController.selectedVariationList.fold(
          0.0,
          (sum, variation) =>
              sum + double.parse(variation.convertPrice.toString()),
        ) *
        cartController.numOfItems.value;

    final extrasTotal = cartController.selectedExtrasList.fold(
      0.0,
      (sum, extra) =>
          sum +
          double.parse(extra.convertPrice.toString()) *
              cartController.numOfItems.value,
    );

    final addonPrice = cartController.selectedAddonTotal;

    totalItemPrice.value =
        basePrice + variationTotal + extrasTotal + addonPrice;
  }

  @override
  void dispose() {
    restaurantDetailsController.itemDetails.value = ItemDetailsModel();
    cartController.selectedVariationList.clear();
    cartController.selectedExtrasList.clear();
    cartController.selectedAddonList.clear();
    cartController.instructorTextController.clear();

    cartController.extrasText = "";
    cartController.instructorTextController.clear();
    cartController.numOfItems.value = 1;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool hasDiscount = false;
    if (widget.isSingleOffer ||
        (widget.discountType != null && widget.discountType!.isNotEmpty)) {
      hasDiscount = true;
    } else {
      hasDiscount = false;
    }

    finalPrice = getItemPrice(
      price: widget.item.convertPrice ?? 0.0,
      isSingleOffer: widget.isSingleOffer,
      singleOfferPercentage: widget.singleOfferPercentage,
      discountedPrice: widget.item.convertDiscountedPrice ?? 0.0,
      discountedOption: widget.item.discountOption ?? "",
    );

    return SafeArea(
      child: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColor.whiteColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.r),
                  topRight: Radius.circular(16.r),
                ),
                border: Border.all(color: AppColor.border),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.h),
                      child: Row(
                        children: [
                          Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.r),
                                child: CachedNetworkImage(
                                  imageUrl:
                                      widget.item.thumb ??
                                      "https://www.foodandwine.com/thmb/DI29Houjc_ccAtFKly0BbVsusHc=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/crispy-comte-cheesburgers-FT-RECIPE0921-6166c6552b7148e8a8561f7765ddf20b.jpg",
                                  height: 72.h,
                                  width: 72.w,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          NormalText(
                                            text: widget.item.name ?? "",
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w500,
                                            color: AppColor.black100,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 8.w),
                                    widget.item.caution.toString() == "null"
                                        ? SizedBox.shrink()
                                        : GestureDetector(
                                            onTap: () async {
                                              Get.dialog(
                                                CautionDialog(
                                                  name: widget.item.name ?? "",
                                                  cautionText:
                                                      widget.item.caution ?? "",
                                                ),
                                              );
                                            },
                                            child: SvgPicture.asset(
                                              SvgIcon.information,
                                              height: 12.h,
                                            ),
                                          ),
                                  ],
                                ),
                                Text(
                                  widget.item.descriptionAlt ?? "",
                                  style: textLight10,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 4.h),
                                Row(
                                  children: [
                                    if (hasDiscount)
                                      NormalText(
                                        text: widget.item.currencyPrice ?? '',
                                        fontSize: 12.sp,
                                        color: AppColor.black80,
                                        fontWeight: FontWeight.w500,
                                        textDecoration:
                                            TextDecoration.lineThrough,
                                      ),

                                    if (hasDiscount) SizedBox(width: 8.w),

                                    NormalText(
                                      text: formatPriceWithCurrency(finalPrice),
                                      fontSize: 12.sp,
                                      color: AppColor.black100,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    Row(
                      children: [
                        NormalText(
                          text: "QUANTITY".tr,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        const Spacer(),
                        Container(
                          height: 24.h,
                          width: 87.w,
                          decoration: BoxDecoration(
                            color: AppColor.background,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                            child: Obx(
                              () => Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      if (cartController.numOfItems > 1) {
                                        cartController.numOfItems.value--;
                                        calculate();
                                      }
                                    },
                                    child: SvgPicture.asset(
                                      SvgIcon.minusCircle,
                                      colorFilter: ColorFilter.mode(
                                        cartController.numOfItems.value == 1
                                            ? AppColor.black80
                                            : AppColor.primaryColor,
                                        BlendMode.srcIn,
                                      ),
                                      height: 16.h,
                                    ),
                                  ),
                                  const Spacer(),
                                  NormalText(
                                    text: cartController.numOfItems.value
                                        .toString(),
                                    fontSize: 16.sp,
                                  ),
                                  const Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      final maxQnty = double.parse(
                                        widget.item.maximumPurchaseQnty ??
                                            '100',
                                      );
                                      if (cartController.numOfItems.value <
                                          maxQnty) {
                                        cartController.numOfItems.value++;
                                        calculate();
                                      } else {
                                        customSnackbar(
                                          "ERROR".tr,
                                          "MAXIMUM_PURCHASE_QUANTITY_LIMIT_EXCEEDED"
                                              .tr,
                                          AppColor.rejectedTextColor,
                                        );
                                      }
                                    },
                                    child: SvgPicture.asset(
                                      SvgIcon.addCircle,
                                      height: 16.h,
                                      colorFilter: ColorFilter.mode(
                                        AppColor.primaryColor,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(
                          () =>
                              restaurantDetailsController
                                          .itemDetails
                                          .value
                                          .data
                                          ?.itemAttributes ==
                                      null ||
                                  restaurantDetailsController
                                      .itemDetails
                                      .value
                                      .data!
                                      .itemAttributes!
                                      .isEmpty
                              ? const SizedBox()
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Obx(
                                      () =>
                                          restaurantDetailsController
                                                      .itemDetails
                                                      .value
                                                      .data
                                                      ?.variations ==
                                                  null ||
                                              restaurantDetailsController
                                                  .itemDetails
                                                  .value
                                                  .data!
                                                  .variations!
                                                  .isEmpty
                                          ? const SizedBox()
                                          : SizedBox(
                                              child: ListView.builder(
                                                shrinkWrap: true,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                itemCount:
                                                    restaurantDetailsController
                                                        .itemDetails
                                                        .value
                                                        .data
                                                        ?.itemAttributes
                                                        ?.length,
                                                itemBuilder: (context, i) => Padding(
                                                  padding: EdgeInsets.symmetric(
                                                    vertical: 4.h,
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      NormalText(
                                                        text:
                                                            restaurantDetailsController
                                                                .itemDetails
                                                                .value
                                                                .data
                                                                ?.itemAttributes?[i]
                                                                .name ??
                                                            "",
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                      SizedBox(height: 4.h),

                                                      SizedBox(
                                                        height: 60.h,
                                                        child: ListView.builder(
                                                          shrinkWrap: true,
                                                          scrollDirection:
                                                              Axis.horizontal,
                                                          itemCount: restaurantDetailsController
                                                              .itemDetails
                                                              .value
                                                              .data!
                                                              .variations![restaurantDetailsController
                                                                  .itemDetails
                                                                  .value
                                                                  .data!
                                                                  .itemAttributes![i]
                                                                  .id
                                                                  .toString()]!
                                                              .length,
                                                          itemBuilder: (context, index) {
                                                            var variation =
                                                                restaurantDetailsController
                                                                    .itemDetails
                                                                    .value
                                                                    .data!
                                                                    .variations![restaurantDetailsController
                                                                    .itemDetails
                                                                    .value
                                                                    .data!
                                                                    .itemAttributes![i]
                                                                    .id
                                                                    .toString()];
                                                            return GestureDetector(
                                                              onTap: () {
                                                                cartController.selectVariation(
                                                                  variation[index],
                                                                  variation[index]
                                                                      .convertPrice,
                                                                );

                                                                calculate();

                                                                setState(() {});
                                                              },
                                                              child: Padding(
                                                                padding:
                                                                    EdgeInsets.only(
                                                                      right:
                                                                          9.w,
                                                                    ),
                                                                child: Container(
                                                                  height: 52.h,
                                                                  width: 150.w,
                                                                  decoration: BoxDecoration(
                                                                    color:
                                                                        cartController
                                                                            .selectedVariationList
                                                                            .contains(
                                                                              variation![index],
                                                                            )
                                                                        ? AppColor.primaryColor.withValues(
                                                                            alpha:
                                                                                0.1,
                                                                          )
                                                                        : AppColor
                                                                              .black10,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                          8.r,
                                                                        ),
                                                                    border: Border.all(
                                                                      color:
                                                                          cartController.selectedVariationList.contains(
                                                                            variation[index],
                                                                          )
                                                                          ? AppColor.primaryColor
                                                                          : Colors.transparent,
                                                                    ),
                                                                  ),
                                                                  child: Padding(
                                                                    padding:
                                                                        EdgeInsets.only(
                                                                          left:
                                                                              8.w,
                                                                          right:
                                                                              8.w,
                                                                        ),
                                                                    child: Row(
                                                                      children: [
                                                                        SvgPicture.asset(
                                                                          cartController.selectedVariationList.contains(
                                                                                variation[index],
                                                                              )
                                                                              ? SvgIcon.radioCircleMarked
                                                                              : SvgIcon.radioCircle,
                                                                          height:
                                                                              16.h,
                                                                          colorFilter:
                                                                              cartController.selectedVariationList.contains(
                                                                                variation[index],
                                                                              )
                                                                              ? ColorFilter.mode(
                                                                                  AppColor.primaryColor,
                                                                                  BlendMode.srcIn,
                                                                                )
                                                                              : null,
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              8.w,
                                                                        ),
                                                                        Expanded(
                                                                          child: Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              NormalText(
                                                                                text:
                                                                                    variation[index].name ??
                                                                                    "",
                                                                                fontSize: 12.sp,
                                                                              ),
                                                                              SizedBox(
                                                                                height: 4.h,
                                                                              ),
                                                                              NormalText(
                                                                                text: '+${variation[index].currencyPrice}',
                                                                                fontSize: 12.sp,
                                                                                fontWeight: FontWeight.w500,
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                    ),
                                  ],
                                ),
                        ),

                        SizedBox(
                          height:
                              restaurantDetailsController
                                          .itemDetails
                                          .value
                                          .data
                                          ?.extras ==
                                      null ||
                                  restaurantDetailsController
                                      .itemDetails
                                      .value
                                      .data!
                                      .extras!
                                      .isNotEmpty
                              ? 16.h
                              : 0,
                        ),
                        Obx(
                          () =>
                              restaurantDetailsController
                                          .itemDetails
                                          .value
                                          .data
                                          ?.extras ==
                                      null ||
                                  restaurantDetailsController
                                      .itemDetails
                                      .value
                                      .data!
                                      .extras!
                                      .isEmpty
                              ? const SizedBox()
                              : ExtrasListView(
                                  cartController: cartController,
                                  restaurantDetailsController:
                                      restaurantDetailsController,

                                  calculateOnExtrasSelected: () {
                                    calculate();
                                  },
                                ),
                        ),

                        SizedBox(
                          height:
                              restaurantDetailsController
                                          .itemDetails
                                          .value
                                          .data
                                          ?.addons !=
                                      null ||
                                  restaurantDetailsController
                                      .itemDetails
                                      .value
                                      .data!
                                      .addons!
                                      .isNotEmpty
                              ? 16.h
                              : 0,
                        ),

                        Obx(
                          () =>
                              restaurantDetailsController
                                          .itemDetails
                                          .value
                                          .data
                                          ?.addons ==
                                      null ||
                                  restaurantDetailsController
                                      .itemDetails
                                      .value
                                      .data!
                                      .addons!
                                      .isEmpty
                              ? const SizedBox()
                              : AddonListView(
                                  isSingleOffer: widget.isSingleOffer,
                                  singleOfferPercentage:
                                      widget.singleOfferPercentage,
                                  widget: widget,
                                  restaurantDetailsController:
                                      restaurantDetailsController,
                                  calculateOnSelectedAddon: () {
                                    calculate();
                                  },
                                ),
                        ),
                      ],
                    ),

                    SizedBox(height: 24.h),
                    NormalText(
                      text: "SPECIAL_INSTRUCTIONS".tr,
                      fontSize: 12.sp,
                    ),
                    SizedBox(height: 8.h),
                    TextField(
                      controller: cartController.instructorTextController,
                      style: GoogleFonts.urbanist(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColor.black100,
                      ),
                      decoration: InputDecoration(
                        hintText: "AD_NOTE".tr,
                        hintStyle: GoogleFonts.urbanist(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColor.black80,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: const BorderSide(color: AppColor.black40),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: const BorderSide(color: AppColor.black40),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: const BorderSide(color: AppColor.black40),
                        ),
                      ),
                    ),

                    SizedBox(height: 32.h),

                    GestureDetector(
                      onTap: () {
                        double variationTotal = 0.0;
                        double extrasTotal = 0.0;
                        double addonTotal = 0.0;

                        cartController.restaurantName.value =
                            widget.restaurant?.name ?? '';
                        cartController.restId.value =
                            widget.restaurant?.id ?? 0;
                        cartController.foodPreparationTime.value =
                            restaurantDetailsController
                                .restaurantDetails
                                .value
                                .data!
                                .orderSetup!
                                .foodPreparationTime!;
                        var itemVariationObject = cartController
                            .selectedVariationList
                            .map((variation) {
                              cartController.variationId = variation.id ?? 0;

                              variationTotal =
                                  variationTotal +
                                  double.parse(
                                    variation.convertPrice.toString(),
                                  );
                              return Variation(
                                id: variation.id,
                                itemId: variation.itemId,
                                itemAttributeId: variation.itemAttributeId,
                                name: variation.name,
                                itemAttribute: variation.itemAttribute,
                              );
                            })
                            .toList();

                        List<Extra> itemExtrasObject = [];

                        cartController.selectedExtrasList.map((extra) {
                          cartController.extrasList.add(
                            Extra(
                              id: extra.id,
                              itemId: extra.itemId,
                              name: extra.name,
                            ),
                          );
                          itemExtrasObject.add(
                            Extra(
                              id: extra.id,
                              itemId: extra.itemId,
                              name: extra.name,
                            ),
                          );

                          cartController.extrasText += '${extra.name}, ';
                          extrasTotal += double.parse(
                            extra.convertPrice.toString(),
                          );
                          return itemExtrasObject;
                        }).toList();

                        var itemAddonObject = cartController.addonCartList.map((
                          addonCartModel,
                        ) {
                          addonTotal += double.parse(
                            addonCartModel.addon.addonItemConvertPrice
                                .toString(),
                          );

                          return {
                            "item_id": addonCartModel.addon.id,
                            "item_price":
                                addonCartModel.addon.totalConvertPrice,
                            "addon_item_convert_price":
                                addonCartModel.addon.totalConvertPrice,
                            "quantity": addonCartModel.quantity.value,
                            "total_price": addonCartModel.addon.total,
                          };
                        }).toList();

                        cartController.addToCartAddon();

                        cartController.addToCart(
                          restaurantId: widget.restaurant?.id,
                          itemPrice:
                              (finalPrice + variationTotal + extrasTotal),
                          product: widget.item,
                          variationId: cartController.variationId,
                          extrasText: cartController.extrasText,
                          instructionText:
                              cartController.instructorTextController.text,
                          itemPriceForTax:
                              (widget.item.convertPrice! + variationTotal),
                          taxRate: double.parse(
                            (widget.item.tax?.taxConvertRate ?? 0).toString(),
                          ),
                          variationObject: itemVariationObject,
                          extrasObject: itemExtrasObject,
                          addonObject: itemAddonObject,
                          variationTotalPrice: variationTotal,
                          extrasTotalPrice: extrasTotal,
                          addonTotalprice: addonTotal,
                        );

                        cartController.selectedAddonList.clear();

                        Get.back();
                      },
                      child: Container(
                        height: 48.h,
                        width: 328.w,
                        decoration: BoxDecoration(
                          color: AppColor.primaryColor,
                          borderRadius: BorderRadius.circular(24.r),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              SvgIcon.bag2,
                              height: 16.h,
                              colorFilter: const ColorFilter.mode(
                                AppColor.whiteColor,
                                BlendMode.srcIn,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Obx(
                              () => NormalText(
                                text:
                                    '${"ADD_TO_CART".tr} - ${formatPriceWithCurrency(totalItemPrice.value)}',
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColor.whiteColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Positioned(
              top: 16.h,
              right: 16.w,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: SvgPicture.asset(SvgIcon.closeCircle, height: 20.w),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
