import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:foodnanny/config/theme/app_color.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../../utils/svg_icon.dart';
import '../../normal_text.dart';

class OrderShimmer extends StatelessWidget {
  const OrderShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: 8,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(bottom: 16.h),
                child: SizedBox(
                  child: Row(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Shimmer.fromColors(
                            baseColor: Colors.grey[200]!,
                            highlightColor: Colors.grey[300]!,
                            child: SvgPicture.asset(
                              SvgIcon.reserve,
                              height: 34.h,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Shimmer.fromColors(
                                  baseColor: Colors.grey[200]!,
                                  highlightColor: Colors.grey[300]!,
                                  child: Container(
                                    color: AppColor.whiteColor,
                                    child: NormalText(
                                      text: "ORDER_ID:".tr,
                                      fontSize: 14.sp,
                                      color: AppColor.black80,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 4.w),
                                Shimmer.fromColors(
                                  baseColor: Colors.grey[200]!,
                                  highlightColor: Colors.grey[300]!,
                                  child: Container(
                                    color: AppColor.whiteColor,
                                    child: NormalText(
                                      text: "145784511",
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                Shimmer.fromColors(
                                  baseColor: Colors.grey[200]!,
                                  highlightColor: Colors.grey[300]!,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16.r),
                                      color: AppColor.primaryColor,
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        left: 8.w,
                                        right: 8.w,
                                        top: 1.h,
                                        bottom: 1.h,
                                      ),
                                      child: Center(
                                        child: NormalText(
                                          text: "Cancelled",
                                          fontSize: 10.sp,
                                          color: AppColor.primaryColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 4.h),
                            Shimmer.fromColors(
                              baseColor: Colors.grey[200]!,
                              highlightColor: Colors.grey[300]!,
                              child: Container(
                                color: AppColor.whiteColor,
                                child: NormalText(
                                  text: "10.49 AM, 28-04-2024",
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
                                    color: AppColor.whiteColor,
                                    child: NormalText(
                                      text: "FORM:".tr,
                                      fontSize: 14.sp,
                                      color: AppColor.black80,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 4.w),
                                Expanded(
                                  child: Shimmer.fromColors(
                                    baseColor: Colors.grey[200]!,
                                    highlightColor: Colors.grey[300]!,
                                    child: Container(
                                      color: AppColor.whiteColor,
                                      child: NormalText(
                                        text: "restaurantName.toString()",
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 4.h),
                            Shimmer.fromColors(
                              baseColor: Colors.grey[200]!,
                              highlightColor: Colors.grey[300]!,
                              child: Container(
                                color: AppColor.whiteColor,
                                child: NormalText(
                                  text: "Delivery",
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xff00749B),
                                ),
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Shimmer.fromColors(
                                      baseColor: Colors.grey[200]!,
                                      highlightColor: Colors.grey[300]!,
                                      child: Container(
                                        color: AppColor.whiteColor,
                                        child: NormalText(
                                          text: "TOTAL:".tr,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    Shimmer.fromColors(
                                      baseColor: Colors.grey[200]!,
                                      highlightColor: Colors.grey[300]!,
                                      child: Container(
                                        color: AppColor.whiteColor,
                                        child: NormalText(
                                          text: " {totcyPrice}",
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Shimmer.fromColors(
                                  baseColor: Colors.grey[200]!,
                                  highlightColor: Colors.grey[300]!,
                                  child: Container(
                                    color: AppColor.whiteColor,
                                    child: Row(
                                      children: [
                                        NormalText(
                                          text: "SEE_DETAILS".tr,
                                          fontSize: 12.sp,
                                          color: AppColor.primaryColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        SvgPicture.asset(
                                          SvgIcon.rightArrow,
                                          height: 14.h,
                                          width: 14.w,
                                          colorFilter:  ColorFilter.mode(
                                            AppColor.primaryColor,
                                            BlendMode.srcIn,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
