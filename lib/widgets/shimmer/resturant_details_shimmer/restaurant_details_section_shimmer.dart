import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:foodnanny/config/theme/app_color.dart';
import 'package:shimmer/shimmer.dart';

import '../../../app/features/restaurant_details/widgets/circle_icon_button.dart';
import '../../../utils/svg_icon.dart';
import '../../normal_text.dart';
import '../../title_text.dart';

class RestaurantDeliverySectionShimmer extends StatelessWidget {
  const RestaurantDeliverySectionShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          right: 16.w,
          top: 36.h,
          child: Shimmer.fromColors(
            baseColor: Colors.grey[200]!,
            highlightColor: Colors.grey[300]!,
            child: CircleIconButton(icon: SvgIcon.infoCircle, onTap: () {}),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8.h),
            Shimmer.fromColors(
              baseColor: Colors.grey[200]!,
              highlightColor: Colors.grey[300]!,
              child: Container(
                width: 200.w,
                height: 24.h,
                color: AppColor.whiteColor,
                child: const TitleText(text: "La Pizza Napoletana"),
              ),
            ),
            SizedBox(height: 4.h),
            Shimmer.fromColors(
              baseColor: Colors.grey[200]!,
              highlightColor: Colors.grey[300]!,
              child: Container(
                width: 180.w,
                height: 14.h,
                color: AppColor.whiteColor,
                child: NormalText(
                  text: "PIzza, American, Italian",
                  color: AppColor.black80,
                  fontSize: 12.sp,
                ),
              ),
            ),
            SizedBox(height: 4.h),

            Row(
              children: [
                Shimmer.fromColors(
                  baseColor: Colors.grey[200]!,
                  highlightColor: Colors.grey[300]!,
                  child: Container(
                    width: 20.w,
                    height: 14.h,
                    color: AppColor.whiteColor,
                  ),
                ),
                SizedBox(width: 4.w),
                Shimmer.fromColors(
                  baseColor: Colors.grey[200]!,
                  highlightColor: Colors.grey[300]!,
                  child: Container(
                    width: 6.w,
                    height: 6.h,
                    decoration: const BoxDecoration(
                      color: AppColor.whiteColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                SizedBox(width: 4.w),
                Shimmer.fromColors(
                  baseColor: Colors.grey[200]!,
                  highlightColor: Colors.grey[300]!,
                  child: SvgPicture.asset(SvgIcon.star, height: 12.h),
                ),
                SizedBox(width: 4.w),
                Shimmer.fromColors(
                  baseColor: Colors.grey[200]!,
                  highlightColor: Colors.grey[300]!,
                  child: Container(
                    width: 60.w,
                    height: 14.h,
                    color: AppColor.whiteColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Shimmer.fromColors(
                  baseColor: Colors.grey[200]!,
                  highlightColor: Colors.grey[300]!,
                  child: Container(
                    height: 14.h,
                    width: 50.w,
                    color: AppColor.whiteColor,
                  ),
                ),
                SizedBox(width: 4.w),
                Shimmer.fromColors(
                  baseColor: Colors.grey[200]!,
                  highlightColor: Colors.grey[300]!,
                  child: Container(
                    height: 14.h,
                    width: 50.w,
                    color: AppColor.whiteColor,
                  ),
                ),
                SizedBox(width: 4.w),
                Shimmer.fromColors(
                  baseColor: Colors.grey[200]!,
                  highlightColor: Colors.grey[300]!,
                  child: Container(
                    height: 14.h,
                    width: 100.w,
                    color: AppColor.whiteColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 4.h),
            Shimmer.fromColors(
              baseColor: Colors.grey[200]!,
              highlightColor: Colors.grey[300]!,
              child: Container(
                height: 14.h,
                width: 160.w,
                color: AppColor.whiteColor,
                child: NormalText(
                  text: "Minimum order limit: \$10",
                  fontSize: 12.sp,
                  color: AppColor.black80,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
