import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tumrestoran/app/features/checkout/controller/checkout_controller.dart';
import 'package:get/get.dart';

import '../../../../config/theme/app_color.dart';
import '../../../../utils/svg_icon.dart';
import '../../../../widgets/normal_text.dart';

class AddEditButtonWidget extends StatelessWidget {
  const AddEditButtonWidget({
    super.key,
    required this.editOnTap,
    required this.addOnTap,
  });
  final VoidCallback editOnTap;
  final VoidCallback addOnTap;
  @override
  Widget build(BuildContext context) {
    final chekcoutController = Get.put(CheckoutController());
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: NormalText(
            text: "DELIVERY_ADDRESS".tr,
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        Row(
          children: [
            Obx(
              () => chekcoutController.selectAddress.value == -1
                  ? const SizedBox()
                  : GestureDetector(
                      onTap: editOnTap,
                      child: Container(
                        height: 28.h,
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(17.r),
                          color: AppColor.highlightLight,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              SvgIcon.edit,
                              colorFilter: const ColorFilter.mode(
                                AppColor.highlightDark,
                                BlendMode.srcIn,
                              ),
                            ),
                            SizedBox(width: 4.w),
                            NormalText(
                              text: "EDIT".tr,
                              color: AppColor.highlightDark,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
            SizedBox(width: 8.w),
            GestureDetector(
              onTap: addOnTap,
              child: Container(
                height: 28.h,
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(17.r),
                  color: AppColor.primaryLight,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      SvgIcon.addCircleSolid,
                      colorFilter:  ColorFilter.mode(
                        AppColor.primaryColor,
                        BlendMode.srcIn,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    NormalText(
                      text: "ADD".tr,
                      color: AppColor.primaryColor,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
