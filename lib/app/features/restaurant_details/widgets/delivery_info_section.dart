import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tumrestoran/app/features/restaurant_details/controller/restaurant_details_controller.dart';
import 'package:tumrestoran/widgets/text_widget.dart';
import 'package:get/get.dart';
import '../../../../config/theme/app_color.dart';
import '../../../../utils/svg_icon.dart';
import '../../../../widgets/title_text.dart';
import 'circle_icon_button.dart';
import 'info_dialog.dart';

class DeliveryInfoSection extends StatefulWidget {
  const DeliveryInfoSection({
    super.key,
    required this.restaurantTitle,
    required this.quisine,
    required this.distance,
    required this.rating,
    required this.totalRatings,
    required this.availability,
    required this.today,
    required this.deliveryTime,
    required this.orderLimit,
    required this.restaurantController,
  });

  final String restaurantTitle;
  final String quisine;
  final String distance;
  final String rating;
  final String totalRatings;
  final String availability;
  final String today;
  final String deliveryTime;
  final String orderLimit;
  final RestaurantDetailsController restaurantController;

  @override
  State<DeliveryInfoSection> createState() => _DeliveryInfoSectionState();
}

class _DeliveryInfoSectionState extends State<DeliveryInfoSection> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 300.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                TitleText(text: widget.restaurantTitle),
                TextWidget(
                  text: widget.quisine,
                  color: AppColor.black80,
                  fontSize: 12.sp,
                ),
                Row(
                  children: [
                    SvgPicture.asset(SvgIcon.smallCircle),
                    SizedBox(width: 4.w),
                    TextWidget(
                      text: widget.distance,
                      color: AppColor.black80,
                      fontSize: 12.sp,
                    ),
                    SizedBox(width: 4.w),
                    SvgPicture.asset(SvgIcon.smallCircle),
                    SizedBox(width: 4.w),
                    SvgPicture.asset(SvgIcon.star, height: 12.h),
                    SizedBox(width: 4.w),
                    TextWidget(text: widget.rating, fontSize: 12.sp),
                    TextWidget(
                      text: widget.totalRatings,
                      fontSize: 12.sp,
                      color: AppColor.black80,
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 3.h),
                      child: SvgPicture.asset(
                        SvgIcon.clock,
                        colorFilter: ColorFilter.mode(
                          widget.availability == 'Closed'
                              ? AppColor.rejectedTextColor
                              : AppColor.green,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    TextWidget(
                      text: widget.availability,
                      fontSize: 12.sp,
                      color: widget.availability == 'Closed'
                          ? AppColor.rejectedTextColor
                          : AppColor.green,
                    ),
                    SizedBox(width: 4.w),
                    Padding(
                      padding: EdgeInsets.only(top: 6.h),
                      child: SvgPicture.asset(SvgIcon.smallCircle),
                    ),
                    SizedBox(width: 4.w),
                    TextWidget(
                      text: widget.today,
                      maxLines: 2,
                      fontSize: 12.sp,
                      color: AppColor.black80,
                    ),
                  ],
                ),

                SizedBox(width: 4.w),
                TextWidget(
                  text: widget.deliveryTime,
                  maxLines: 2,
                  fontSize: 12.sp,
                  color: AppColor.black80,
                ),
                Row(
                  children: [
                    SvgPicture.asset(SvgIcon.smallCircle),
                    SizedBox(width: 4.w),
                    TextWidget(
                      text: 'MINIMUM_ORDER_LIMIT'.trParams({
                        "limit": widget.orderLimit,
                      }),
                      fontSize: 12.sp,
                      color: AppColor.black80,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        Expanded(
          child: Column(
            children: [
              CircleIconButton(
                icon: SvgIcon.infoCircle,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => InfoDialog(
                      restaurantController: widget.restaurantController,
                      timeSlots: widget
                          .restaurantController
                          .restaurantDetails
                          .value
                          .data
                          ?.timeSlots,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
