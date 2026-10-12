import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:foodnanny/app/features/cart/model/cart_model.dart';
import 'package:foodnanny/utils/helper/format_price_with_currency.dart';
import 'package:foodnanny/utils/helper/get_addon_item_price.dart';
import 'package:get/get.dart';
import '../../../../config/theme/app_color.dart';
import '../../../../utils/svg_icon.dart';
import '../../../../widgets/normal_text.dart';
import '../../../../widgets/text_widget.dart';
import '../../restaurant_details/controller/restaurant_details_controller.dart';
import '../../restaurant_details/widgets/caution_dialog.dart';
import '../controller/cart_controller.dart';
import 'cart_modal_sheet.dart';

class AddonListView extends StatefulWidget {
  const AddonListView({
    super.key,
    required this.widget,
    required this.restaurantDetailsController,
    required this.calculateOnSelectedAddon,
    this.isSingleOffer = false,
    this.singleOfferPercentage = 0,
  });

  final bool isSingleOffer;
  final int singleOfferPercentage;

  final CartModalSheet widget;
  final RestaurantDetailsController restaurantDetailsController;
  final Function() calculateOnSelectedAddon;

  @override
  State<AddonListView> createState() => _AddonListViewState();
}

class _AddonListViewState extends State<AddonListView> {
  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        NormalText(
          text: "ADDONS".tr,
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
        SizedBox(height: 8.h),
        SizedBox(
          height: 64.h,
          child: Obx(() {
            return widget
                        .restaurantDetailsController
                        .itemDetails
                        .value
                        .data
                        ?.addons ==
                    null
                ? const SizedBox()
                : ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: widget
                        .restaurantDetailsController
                        .itemDetails
                        .value
                        .data
                        ?.addons
                        ?.length,
                    itemBuilder: (context, index) {
                      var addon = widget
                          .restaurantDetailsController
                          .itemDetails
                          .value
                          .data
                          ?.addons;

                      final isSelected = cartController.isAddonSelected(
                        addon![index],
                      );

                      final addonCartItem = cartController.getAddonCartItem(
                        addon[index],
                      );

                      final addonCurrentPrice = getAddonItemPrice(
                        isSingleOffer: widget.isSingleOffer,
                        singleOfferPercentage: widget.singleOfferPercentage,
                        addonItemPrice: double.parse(
                          addon[index].addonItemConvertPrice.toString(),
                        ),

                        variationTotal: double.parse(
                          addon[index].variationTotalConvertPrice.toString(),
                        ),
                        totalConvertPrice:
                            addon[index].totalConvertPrice ?? 0.0,
                      );

                      return Padding(
                        padding: EdgeInsets.only(right: 9.w),
                        child: Container(
                          height: 60.h,
                          width: 190.w,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColor.primaryColor.withValues(alpha: 0.1)
                                : AppColor.black10,
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(
                              color: isSelected
                                  ? AppColor.primaryColor
                                  : AppColor.border,
                            ),
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8.r),
                                  bottomLeft: Radius.circular(8.r),
                                ),
                                child: CachedNetworkImage(
                                  width: 50.w,
                                  imageUrl:
                                      widget
                                          .restaurantDetailsController
                                          .itemDetails
                                          .value
                                          .data
                                          ?.addons?[index]
                                          .thumb ??
                                      "https://imgs.search.brave.com/IAPSVyYRKYkFrolVhshMQkZPDTy3Sp4khVmF0Ylc5GY/rs:fit:860:0:0/g:ce/aHR0cHM6Ly90My5m/dGNkbi5uZXQvanBn/LzA2LzI3Lzc5LzM0/LzM2MF9GXzYyNzc5/MzQ2Ml9VSTlsTFFz/b3Y2QTU2QjFkNWYw/UVNERVBqVnFpZjNy/di5qcGc",
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: TextWidget(
                                            text:
                                                widget
                                                    .restaurantDetailsController
                                                    .itemDetails
                                                    .value
                                                    .data
                                                    ?.addons?[index]
                                                    .addonItemName ??
                                                "",
                                            fontSize: 12.sp,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        SizedBox(width: 8.w),
                                        widget
                                                        .restaurantDetailsController
                                                        .itemDetails
                                                        .value
                                                        .data!
                                                        .addons![index]
                                                        .caution ==
                                                    null ||
                                                widget
                                                    .restaurantDetailsController
                                                    .itemDetails
                                                    .value
                                                    .data!
                                                    .addons![index]
                                                    .caution!
                                                    .isEmpty
                                            ? SizedBox.shrink()
                                            : GestureDetector(
                                                onTap: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) => CautionDialog(
                                                      name:
                                                          widget
                                                              .restaurantDetailsController
                                                              .itemDetails
                                                              .value
                                                              .data!
                                                              .addons![index]
                                                              .itemName ??
                                                          "",
                                                      cautionText:
                                                          widget
                                                              .restaurantDetailsController
                                                              .itemDetails
                                                              .value
                                                              .data!
                                                              .addons![index]
                                                              .caution ??
                                                          "",
                                                    ),
                                                  );
                                                },
                                                child: SvgPicture.asset(
                                                  SvgIcon.information,
                                                  height: 12.h,
                                                ),
                                              ),
                                        SizedBox(width: 4.w),
                                      ],
                                    ),
                                    SizedBox(height: 4.h),

                                    Row(
                                      children: widget
                                          .restaurantDetailsController
                                          .itemDetails
                                          .value
                                          .data!
                                          .addons![index]
                                          .variationNames!
                                          .map((e) {
                                            return Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  TextWidget(
                                                    text: e.name ?? "",
                                                    fontSize: 11.sp,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                            );
                                          })
                                          .toList(),
                                    ),
                                    SizedBox(height: 4.h),
                                    Padding(
                                      padding: EdgeInsets.only(right: 4.w),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          NormalText(
                                            text: formatPriceWithCurrency(
                                              addonCurrentPrice,
                                            ),
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          !isSelected
                                              ? GestureDetector(
                                                  onTap: () {
                                                    cartController.selectedAddon(
                                                      AddonCartModel(
                                                        addon: addon[index],
                                                        addonCurrentPrice:
                                                            addonCurrentPrice,
                                                      ),
                                                    );

                                                    widget
                                                        .calculateOnSelectedAddon();
                                                    setState(() {});
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color:
                                                          AppColor.whiteColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            12.r,
                                                          ),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color:
                                                              AppColor.border,
                                                          blurRadius: 4.r,
                                                        ),
                                                      ],
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                            horizontal: 6.w,
                                                          ),
                                                      child: Row(
                                                        children: [
                                                          SvgPicture.asset(
                                                            SvgIcon.bag2,
                                                            height: 12.h,
                                                            colorFilter:
                                                                ColorFilter.mode(
                                                                  AppColor
                                                                      .primaryColor,
                                                                  BlendMode
                                                                      .srcIn,
                                                                ),
                                                          ),
                                                          SizedBox(width: 4.w),
                                                          NormalText(
                                                            text: "ADD".tr,
                                                            fontSize: 10.sp,
                                                            color: AppColor
                                                                .primaryColor,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : Row(
                                                  children: [
                                                    Obx(
                                                      () => GestureDetector(
                                                        onTap: () {
                                                          if (addonCartItem
                                                                  .quantity
                                                                  .value ==
                                                              1) {
                                                            cartController
                                                                .removeAddon(
                                                                  addon[index],
                                                                );
                                                          } else {
                                                            cartController
                                                                .decrementAddon(
                                                                  addon[index],
                                                                );
                                                          }
                                                          widget
                                                              .calculateOnSelectedAddon();
                                                          setState(() {});
                                                        },
                                                        child: SvgPicture.asset(
                                                          addonCartItem!
                                                                      .quantity
                                                                      .value ==
                                                                  1
                                                              ? SvgIcon
                                                                    .deleteCircle
                                                              : SvgIcon
                                                                    .minusCircle,
                                                          height: 12.h,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 8.w),
                                                    Obx(() {
                                                      final selected = cartController
                                                          .selectedAddonList
                                                          .firstWhere(
                                                            (e) =>
                                                                e.addon.id ==
                                                                addon[index].id,
                                                            orElse: () =>
                                                                AddonCartModel(
                                                                  addon:
                                                                      addon[index],
                                                                  quantity: 0,
                                                                  addonCurrentPrice:
                                                                      0.0,
                                                                ),
                                                          );

                                                      return NormalText(
                                                        text:
                                                            (selected
                                                                    .quantity
                                                                    .value)
                                                                .toString(),
                                                        fontSize: 12.sp,
                                                      );
                                                    }),

                                                    SizedBox(width: 8.w),
                                                    GestureDetector(
                                                      onTap: () {
                                                        cartController
                                                            .incrementAddon(
                                                              addon[index],
                                                            );
                                                        widget
                                                            .calculateOnSelectedAddon();
                                                      },
                                                      child: SvgPicture.asset(
                                                        SvgIcon.addCircle,
                                                        height: 12.h,
                                                        colorFilter:
                                                            ColorFilter.mode(
                                                              AppColor
                                                                  .primaryColor,
                                                              BlendMode.srcIn,
                                                            ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 8.w),
                                                  ],
                                                ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
          }),
        ),
      ],
    );
  }
}
