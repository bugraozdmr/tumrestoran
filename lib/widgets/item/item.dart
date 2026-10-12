import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tumrestoran/app/features/favorite/controller/favorite_controller.dart';
import 'package:tumrestoran/data/model/restuarant_model.dart';
import 'package:tumrestoran/utils/style.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../config/theme/app_color.dart';
import '../../utils/svg_icon.dart';
import '../text_widget.dart';

const dummyImage =
    "https://img.freepik.com/free-photo/top-view-arrangement-with-food-wooden-background_23-2148308806.jpg?size=626&ext=jpg&ga=GA1.1.1269040533.1709078400&semt=ais";

class ItemWidget extends StatelessWidget {
  const ItemWidget({
    super.key,
    this.height,
    this.width,
    required this.onTap,
    this.restaurant,
    this.favTap,
    this.isToggle,
    this.isClosed = false,
    required this.restaurantOfferText,
  });

  final double? height;
  final double? width;
  final void Function() onTap;
  final void Function()? favTap;
  final Restaurant? restaurant;
  final bool? isToggle;
  final bool isClosed;
  final String restaurantOfferText;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              color: AppColor.whiteColor,
              borderRadius: BorderRadius.all(Radius.circular(15.r)),
              border: Border.all(color: AppColor.borderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15.r),
                    topRight: Radius.circular(15.r),
                  ),
                  child: Stack(
                    children: [
                      Stack(
                        alignment: AlignmentGeometry.center,
                        children: [
                          CachedNetworkImage(
                            imageUrl: restaurant?.thumb ?? dummyImage,
                            imageBuilder: (context, imageProvider) => Container(
                              height: 148.w,
                              width: width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15.r),
                                  topRight: Radius.circular(15.r),
                                ),
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.fill,
                                  colorFilter: isClosed
                                      ? ColorFilter.mode(
                                          AppColor.blackColor.withAlpha(180),
                                          BlendMode.darken,
                                        )
                                      : null,
                                ),
                              ),
                            ),
                            placeholder: (context, url) => Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                height: 148.w,
                                width: width,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15.r),
                                    topRight: Radius.circular(15.r),
                                  ),
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  child: Container(
                                    height: 148.w,
                                    width: width,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15.r),
                                        topRight: Radius.circular(15.r),
                                      ),
                                    ),
                                  ),
                                ),
                          ),
                          Positioned(
                            left: 5.w,
                            top: 5.h,
                            child: restaurantOfferText == "0" || isClosed
                                ? const SizedBox.shrink()
                                : Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4.r),
                                      color: AppColor.primaryColor,
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 6.w,
                                        vertical: 4.h,
                                      ),
                                      child: TextWidget(
                                        text: 'SINGLE_OFFER_TEXT'.trParams({
                                          'value': restaurantOfferText,
                                        }),
                                        color: AppColor.whiteColor,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                          ),
                          isClosed
                              ? Column(
                                  children: [
                                    Text(
                                      "CLOSE_NOW".tr,
                                      style: TextStyle(
                                        fontFamily: 'Rubik',
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w500,
                                        color: AppColor.whiteColor,
                                      ),
                                    ),
                                    SizedBox(height: 8.h),
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          15.r,
                                        ),
                                        color: AppColor.background,
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8.w,
                                          vertical: 4.h,
                                        ),
                                        child: Text(
                                          "SCHEDULE_ORDER".tr,
                                          style: TextStyle(
                                            fontFamily: 'Rubik',
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w500,
                                            color: AppColor.primaryColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : SizedBox.shrink(),
                        ],
                      ),

                      restaurant?.status == 10
                          ? Positioned.fill(
                              child: ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15.r),
                                  topRight: Radius.circular(15.r),
                                ),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                    sigmaX: 4,
                                    sigmaY: 4,
                                  ),
                                  child: Container(
                                    alignment: Alignment.center,
                                    color: Colors.black.withValues(alpha: 0.4),
                                    child: Text(
                                      "TEMPORARY_CLOSED".tr,
                                      style: TextStyle(
                                        fontFamily: 'Rubik',
                                        color: Colors.white,
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : SizedBox(),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        restaurant?.name ?? "",
                        style: title16,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                              // Removed distance text
                          SizedBox(width: 4.w),
                          Text(
                            restaurant?.preparationTime.toString() != null
                                ? 'MINUTE'.trParams({
                                    'time':
                                        restaurant?.preparationTime
                                            .toString() ??
                                        "",
                                  })
                                : "0 min",
                            style: textLight14,
                          ),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      restaurant?.ratingStar.toString() != '0'
                          ? Row(
                              children: [
                                SvgPicture.asset(
                                  SvgIcon.star,
                                  height: 14.h,
                                  width: 14.w,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  (double.parse(
                                            restaurant?.ratingStar.toString() ??
                                                "0",
                                          ) /
                                          double.parse(
                                            restaurant?.ratingStarCount
                                                    .toString() ??
                                                "0",
                                          ))
                                      .toStringAsFixed(1),
                                  style: textNormal14,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  restaurant?.ratingStarCount.toString() !=
                                          "null"
                                      ? "(${restaurant?.ratingStarCount.toString()})"
                                      : "(0)",
                                  style: textLight14,
                                ),
                              ],
                            )
                          : SizedBox(),
                      SizedBox(height: 12.h),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 9.h,
          right: 14.w,
          child: GestureDetector(
            onTap: favTap,
            child: Obx(
              () => Container(
                height: 24.h,
                width: 24.w,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColor.whiteColor,
                ),
                child: Padding(
                  padding: EdgeInsets.all(4.r),
                  child:
                      Get.find<FavoriteController>().isFavorite(
                        restaurantId: restaurant!.id!,
                        modelValue: restaurant?.favorite ?? false,
                      )
                      ? SvgPicture.asset(SvgIcon.heartBold)
                      : SvgPicture.asset(SvgIcon.heart),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
