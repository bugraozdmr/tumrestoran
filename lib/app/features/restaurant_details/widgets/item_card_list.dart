import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:foodnanny/app/features/restaurant_details/widgets/caution_dialog.dart';
import 'package:foodnanny/utils/helper/format_price_with_currency.dart';
import 'package:foodnanny/utils/helper/get_item_price.dart';
import 'package:foodnanny/utils/svg_icon.dart';
import 'package:foodnanny/widgets/normal_text.dart';
import 'package:foodnanny/widgets/text_widget.dart';
import 'package:get/get.dart';
import '../../../../config/theme/app_color.dart';

class ItemCardList extends StatelessWidget {
  const ItemCardList({
    super.key,
    this.image,
    this.title,
    this.description,
    required this.originalPrice,
    required this.convertedDiscountPrice,
    this.currencyPrice,
    required this.currencyDiscountedPrice,
    this.cautionName,
    this.caution,
    this.itemSlug,
    required this.discountType,
    this.itemDetailsOnTap,
    required this.discountOption,
    required this.isHalal,
    this.isSingleOffer = false,
    this.singleOfferPercentage = 0,
  });

  final String? image;
  final String? title;
  final String? description;
  final double? originalPrice;
  final double? convertedDiscountPrice;
  final String? currencyPrice;
  final String? currencyDiscountedPrice;
  final String? cautionName;
  final String? caution;
  final String? itemSlug;
  final String? discountOption;
  final String? discountType;
  final String isHalal;
  final void Function()? itemDetailsOnTap;
  final bool isSingleOffer;
  final int singleOfferPercentage;
  @override
  Widget build(BuildContext context) {
    bool hasDiscountOption = false;
    if (isSingleOffer || discountOption?.isNotEmpty == true) {
      hasDiscountOption = true;
    } else {
      hasDiscountOption = false;
    }

    String discountText = "";

    if (isSingleOffer) {
      discountText = 'SINGLE_OFFER_TEXT'.trParams({
        'value': singleOfferPercentage.toString(),
      });
    } else {
      if (discountType == null || discountOption!.isEmpty) {
        discountText = "";
      } else if (discountType == "5") {
        discountText = 'OFFER_TEXT'.trParams({
          'value': discountOption.toString(),
        });
      } else if (discountType == "10") {
        discountText = 'DISCOUNT_TEXT'.trParams({
          'value': discountOption.toString(),
        });
      } else {
        discountText = "";
      }
    }

    final finalPrice = getItemPrice(
      price: originalPrice ?? 0.0,
      isSingleOffer: isSingleOffer,
      singleOfferPercentage: singleOfferPercentage,
      discountedPrice: convertedDiscountPrice,
      discountedOption: discountOption ?? "",
    );

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        width: 328.w,
        decoration: BoxDecoration(
          color: AppColor.whiteColor,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: AppColor.black20),
        ),
        child: Row(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(7.r),
                    bottomLeft: Radius.circular(7.r),
                  ),
                  child: CachedNetworkImage(
                    imageUrl:
                        image ??
                        "https://www.allrecipes.com/thmb/5JVfA7MxfTUPfRerQMdF-nGKsLY=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/25473-the-perfect-basic-burger-DDMFS-4x3-56eaba3833fd4a26a82755bcd0be0c54.jpg",
                    height: 110.h,
                    width: 110.w,
                    fit: BoxFit.fill,
                  ),
                ),
                Positioned(
                  left: 5.w,
                  top: 5.h,
                  child: discountText.isEmpty
                      ? const SizedBox()
                      : Container(
                          height: 20.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.r),
                            color: AppColor.primaryColor,
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 6.w),
                            child: TextWidget(
                              text: discountText,
                              color: AppColor.whiteColor,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                ),
                Positioned(
                  left: 5.w,
                  bottom: 5.h,
                  child: Row(
                    children: [
                      isHalal == "5"
                          ? SvgPicture.asset(SvgIcon.halalLogo)
                          : SizedBox(),
                      SizedBox(width: 8.w),
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextWidget(
                            text: title ?? "",
                            color: AppColor.black100,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        caution == null || caution!.isEmpty
                            ? SizedBox.shrink()
                            : GestureDetector(
                                onTap: () async {
                                  await Get.dialog(
                                    CautionDialog(
                                      name: cautionName ?? "",
                                      cautionText: caution ?? "",
                                    ),
                                  );
                                },
                                child: SvgPicture.asset(
                                  SvgIcon.information,
                                  height: 16.h,
                                ),
                              ),
                      ],
                    ),
                    NormalText(
                      text: description ?? "",
                      fontSize: 12.sp,
                      color: AppColor.black80,
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            if (hasDiscountOption)
                              NormalText(
                                text: formatPriceWithCurrency(
                                  originalPrice ?? 0.0,
                                ),
                                fontSize: 12.sp,
                                color: AppColor.black80,
                                fontWeight: FontWeight.w500,
                                textDecoration: TextDecoration.lineThrough,
                              ),

                            if (hasDiscountOption) SizedBox(width: 8.w),

                            NormalText(
                              text: formatPriceWithCurrency(finalPrice),
                              fontSize: 14.sp,
                              color: AppColor.black100,
                              fontWeight: FontWeight.w500,
                            ),
                          ],
                        ),

                        GestureDetector(
                          onTap: itemDetailsOnTap,
                          child: Container(
                            height: 24.h,
                            width: 58.w,
                            decoration: BoxDecoration(
                              color: AppColor.whiteColor,
                              borderRadius: BorderRadius.circular(12.r),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColor.border,
                                  offset: Offset(0, 4),
                                  blurRadius: 16.r,
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5.w),
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    SvgIcon.bag2,
                                    height: 14.h,
                                    colorFilter: ColorFilter.mode(
                                      AppColor.primaryColor,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                  SizedBox(width: 6.w),
                                  NormalText(
                                    text: "ADD".tr,
                                    fontSize: 12.sp,
                                    color: AppColor.primaryColor,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
