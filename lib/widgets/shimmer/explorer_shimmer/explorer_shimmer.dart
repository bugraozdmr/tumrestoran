import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodnanny/config/theme/app_color.dart';
import 'package:foodnanny/widgets/text_widget.dart';
import 'package:shimmer/shimmer.dart';

import '../../title_text.dart';

class ExplorerShimmer extends StatelessWidget {
  const ExplorerShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.r),
      child: Column(
        children: [
          Container(
            height: 48.h,
            width: 328.w,
            decoration: BoxDecoration(
                color: AppColor.whiteColor,
                borderRadius: BorderRadius.circular(24.r)),
          ),
          SizedBox(height: 16.h),
          Shimmer.fromColors(
            baseColor: Colors.grey[200]!,
            highlightColor: Colors.grey[300]!,
            child: Container(
              color: AppColor.whiteColor,
              child: TitleText(
                  text: "67 restaurants match \"burger\" ", fontSize: 18.sp),
            ),
          ),
          SizedBox(height: 12.h),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) => Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: Container(
                  height: 282.h,
                  width: 328.w,
                  decoration: BoxDecoration(
                    color: AppColor.whiteColor,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: AppColor.black20),
                  ),
                  child: Column(
                    children: [
                      Shimmer.fromColors(
                        baseColor: Colors.grey[200]!,
                        highlightColor: Colors.grey[300]!,
                        child: Container(
                          height: 173.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16.r),
                              topRight: Radius.circular(16.r),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Padding(
                        padding: EdgeInsets.only(left: 16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Shimmer.fromColors(
                              baseColor: Colors.grey[200]!,
                              highlightColor: Colors.grey[300]!,
                              child: Container(
                                color: AppColor.whiteColor,
                                child: TitleText(
                                    text: "Tongue Thai'd Eatery",
                                    fontSize: 14.sp),
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Shimmer.fromColors(
                              baseColor: Colors.grey[200]!,
                              highlightColor: Colors.grey[300]!,
                              child: Container(
                                color: AppColor.whiteColor,
                                child: const TextWidget(
                                    text: "\$12.50 Delivery * fee 40-45 min"),
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Shimmer.fromColors(
                              baseColor: Colors.grey[200]!,
                              highlightColor: Colors.grey[300]!,
                              child: Container(
                                color: AppColor.whiteColor,
                                child: const TextWidget(text: "* 4.8 (224)"),
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
        ],
      ),
    );
  }
}
