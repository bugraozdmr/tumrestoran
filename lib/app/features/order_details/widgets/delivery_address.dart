import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:foodnanny/data/model/order_details_model.dart';
import 'package:get/get_utils/src/extensions/export.dart';

import '../../../../config/theme/app_color.dart';
import '../../../../utils/svg_icon.dart';
import '../../../../widgets/normal_text.dart';

class DeliveryAddressWidget extends StatelessWidget {
  const DeliveryAddressWidget({super.key, required this.address});

  final Data address;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColor.whiteColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColor.black100.withValues(alpha: 0.04),
            offset: Offset(0, 6),
            blurRadius: 32.r,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NormalText(
              text: "DELIVERY_ADDRESS".tr,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
            SizedBox(height: 8.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  SvgIcon.location,
                  height: 16.h,
                  colorFilter: const ColorFilter.mode(
                    AppColor.black80,
                    BlendMode.srcIn,
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      NormalText(text: address.orderAddress?.address ?? ''),
                    ],
                  ),
                ),
              ],
            ),
            address.orderAddress?.apartment == null ||
                    address.orderAddress!.apartment!.isEmpty
                ? SizedBox.shrink()
                : Padding(
                    padding: EdgeInsets.only(left: 16.w),
                    child: Row(
                      children: [
                        NormalText(
                          text: "FLAT:".tr,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              NormalText(
                                text: address.orderAddress?.apartment ?? '',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
