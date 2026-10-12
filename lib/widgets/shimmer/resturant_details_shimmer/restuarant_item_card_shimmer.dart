import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tumrestoran/config/theme/app_color.dart';
import 'package:shimmer/shimmer.dart';
import '../../../utils/svg_icon.dart';
import '../../normal_text.dart';

class RestaurantItemCardShimmer extends StatelessWidget {
  const RestaurantItemCardShimmer({super.key});
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Container(
            height: 113.h,
            width: 328.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: AppColor.black20),
            ),
            child: Row(
              children: [
                Column(
                  children: [
                    Shimmer.fromColors(
                      baseColor: Colors.grey[200]!,
                      highlightColor: Colors.grey[300]!,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(7.r),
                          bottomLeft: Radius.circular(7.r),
                        ),
                        child: Container(
                          height: 110.h,
                          width: 110.w,
                          color: AppColor.whiteColor,
                          child: const Text("Image"),
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 8.h,
                      horizontal: 8.w,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Shimmer.fromColors(
                                baseColor: Colors.grey[200]!,
                                highlightColor: Colors.grey[300]!,
                                child: Container(
                                  height: 16.h,
                                  width: 150.w,
                                  color: AppColor.whiteColor,
                                  child: const Text("Item Title"),
                                ),
                              ),
                            ),
                            SizedBox(width: 8.w),
                          ],
                        ),
                        SizedBox(height: 4.h),
                        Shimmer.fromColors(
                          baseColor: Colors.grey[200]!,
                          highlightColor: Colors.grey[300]!,
                          child: Container(
                            height: 12.h,
                            color: AppColor.whiteColor,
                            child: NormalText(
                              text: "description line 1",
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Shimmer.fromColors(
                          baseColor: Colors.grey[200]!,
                          highlightColor: Colors.grey[300]!,
                          child: Container(
                            height: 12.h,
                            color: AppColor.whiteColor,
                            child: NormalText(
                              text: "description line 2",
                              fontSize: 12.sp,
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
                                    height: 12.h,
                                    width: 50.w,
                                    color: AppColor.whiteColor,
                                    child: NormalText(
                                      text: "\$5.60",
                                      fontSize: 12.sp,
                                      color: AppColor.black80,
                                      fontWeight: FontWeight.w500,
                                      textDecoration:
                                          TextDecoration.lineThrough,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Shimmer.fromColors(
                                  baseColor: Colors.grey[200]!,
                                  highlightColor: Colors.grey[300]!,
                                  child: Container(
                                    height: 12.h,
                                    width: 50.w,
                                    color: AppColor.whiteColor,
                                    child: NormalText(
                                      text: "\$4.70",
                                      fontSize: 12.sp,
                                      color: AppColor.black80,
                                      fontWeight: FontWeight.w500,
                                      textDecoration:
                                          TextDecoration.lineThrough,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            InkWell(
                              borderRadius: BorderRadius.circular(12.r),
                              child: Shimmer.fromColors(
                                baseColor: Colors.grey[200]!,
                                highlightColor: Colors.grey[300]!,
                                child: Container(
                                  height: 24.h,
                                  width: 58.w,
                                  decoration: BoxDecoration(
                                    color: AppColor.whiteColor,
                                    borderRadius: BorderRadius.circular(12.r),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColor.border,
                                        blurRadius: 4.r,
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 5.w,
                                    ),
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
                                          text: "Add",
                                          fontSize: 12.sp,
                                          color: AppColor.primaryColor,
                                        ),
                                      ],
                                    ),
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
      },
    );
  }
}
