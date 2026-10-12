import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';

import '../../../config/theme/app_color.dart';
import '../../../utils/svg_icon.dart';
import '../../text_widget.dart';
import '../../title_text.dart';

class AvailableDealsShimmer extends StatelessWidget {
  const AvailableDealsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey[200]!,
          highlightColor: Colors.grey[300]!,
          child: Container(
              height: 16.h,
              width: 170.w,
              color: AppColor.whiteColor,
              child: TitleText(text: "Available Deals", fontSize: 16.sp)),
        ),
        SizedBox(height: 8.h),
        SizedBox(
          height: 84.h,
          child: ListView.builder(
            itemCount: 5,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(right: 16.w),
                child: Container(
                  width: 213.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: AppColor.borderColor),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: 12.w, top: 8.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Shimmer.fromColors(
                                baseColor: Colors.grey[200]!,
                                highlightColor: Colors.grey[300]!,
                                child: SvgPicture.asset(SvgIcon.discountShape)),
                            SizedBox(width: 4.w),
                            Shimmer.fromColors(
                              baseColor: Colors.grey[200]!,
                              highlightColor: Colors.grey[300]!,
                              child: Container(
                                height: 14.h,
                                color: AppColor.whiteColor,
                                child: TextWidget(
                                  text: "25% off",
                                  color: AppColor.primaryColor,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Shimmer.fromColors(
                          baseColor: Colors.grey[200]!,
                          highlightColor: Colors.grey[300]!,
                          child: Container(
                            height: 12.h,
                            color: AppColor.whiteColor,
                            child: TextWidget(
                                text: "Min order \$30, Valid for all items.",
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Shimmer.fromColors(
                          baseColor: Colors.grey[200]!,
                          highlightColor: Colors.grey[300]!,
                          child: Container(
                            height: 10.h,
                            color: AppColor.whiteColor,
                            child: TextWidget(
                              text: "Use in checkout.",
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColor.black80,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
