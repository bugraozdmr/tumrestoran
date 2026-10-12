import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tumrestoran/config/theme/app_color.dart';
import 'package:shimmer/shimmer.dart';

import '../../../app/features/restaurant_details/widgets/custom_cliper.dart';
import '../../../utils/svg_icon.dart';

class RestaurantImageSectionShimmer extends StatelessWidget {
  const RestaurantImageSectionShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: AppColor.whiteColor,
          child: Stack(
            children: [
              Shimmer.fromColors(
                baseColor: Colors.grey[200]!,
                highlightColor: Colors.grey[300]!,
                child: ClipPath(
                  clipper: Customshape(),
                  child: Container(
                    height: 180.h,
                    width: double.infinity,
                    decoration: const BoxDecoration(color: AppColor.whiteColor),
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[200]!,
                      highlightColor: Colors.grey[300]!,
                      child: Stack(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.w, vertical: 8.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Shimmer.fromColors(
                                    baseColor: Colors.grey[200]!,
                                    highlightColor: Colors.grey[300]!,
                                    child: Container(
                                      height: 32.h,
                                      width: 32.w,
                                      decoration: const BoxDecoration(
                                        color: AppColor.whiteColor,
                                      ),
                                      child: Center(
                                        child:
                                            SvgPicture.asset(SvgIcon.arrowLeft),
                                      ),
                                    ),
                                  ),
                                ),
                                Shimmer.fromColors(
                                  baseColor: Colors.grey[200]!,
                                  highlightColor: Colors.grey[300]!,
                                  child: Container(
                                    height: 32.h,
                                    width: 32.w,
                                    decoration: const BoxDecoration(
                                        color: AppColor.whiteColor,
                                        shape: BoxShape.circle),
                                    child: Padding(
                                      padding: EdgeInsets.all(8.r),
                                      child: SvgPicture.asset(
                                        SvgIcon.heart,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0.h,
                left: 16.w,
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[200]!,
                  highlightColor: Colors.grey[300]!,
                  child: Container(
                    height: 48.h,
                    width: 48.w,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColor.whiteColor,
                        border: Border.all(color: Colors.red)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
