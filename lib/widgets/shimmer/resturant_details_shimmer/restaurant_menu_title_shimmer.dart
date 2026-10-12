import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../config/theme/app_color.dart';

class RestaurantMenuTitleShimmer extends StatelessWidget {
  const RestaurantMenuTitleShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey[200]!,
          highlightColor: Colors.grey[300]!,
          child: Container(
            height: 24.h,
            width: 150.w,
            decoration: BoxDecoration(
                color: AppColor.whiteColor,
                borderRadius: BorderRadius.circular(4.r)),
          ),
        ),
        Shimmer.fromColors(
          baseColor: Colors.grey[200]!,
          highlightColor: Colors.grey[300]!,
          child: Container(
            height: 32.h,
            width: 32.w,
            decoration: const BoxDecoration(
                color: AppColor.whiteColor, shape: BoxShape.circle),
          ),
        )
      ],
    );
  }
}
