import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tumrestoran/config/theme/app_color.dart';
import 'package:shimmer/shimmer.dart';

class RestuarantMenuShimmer extends StatelessWidget {
  const RestuarantMenuShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8.h),
        Padding(
          padding: EdgeInsets.only(left: 16.w),
          child: SizedBox(
            height: 24.h,
            width: double.infinity,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: 6,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(right: 16.w),
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[200]!,
                    highlightColor: Colors.grey[300]!,
                    child: Container(
                      height: 24.h,
                      width: 60.w,
                      decoration: BoxDecoration(
                        color: AppColor.whiteColor,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        SizedBox(height: 8.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[200]!,
            highlightColor: Colors.grey[300]!,
            child: Container(
              height: 24.h,
              width: 80.w,
              decoration: BoxDecoration(
                color: AppColor.whiteColor,
                borderRadius: BorderRadius.circular(25.r),
              ),
              child: const Text("Non Veg"),
            ),
          ),
        ),

        /* ----------[ Item Card ]----------- */
      ],
    );
  }
}
