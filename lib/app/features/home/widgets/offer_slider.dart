import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../utils/images.dart';

class OfferSlider extends StatelessWidget {
  const OfferSlider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16.w),
      child: SizedBox(
        height: 156.h,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(
                  right: 16.w,
                ),
                child: Container(
                  height: 156.h,
                  width: 304.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.r),
                    image: const DecorationImage(
                        image: AssetImage(
                          AppImages.offer1,
                        ),
                        fit: BoxFit.cover),
                  ),
                ),
              );
            }),
      ),
    );
  }
}
