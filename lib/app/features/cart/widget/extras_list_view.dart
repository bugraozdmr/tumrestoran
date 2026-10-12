import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../config/theme/app_color.dart';
import '../../../../utils/svg_icon.dart';
import '../../../../widgets/normal_text.dart';
import '../../restaurant_details/controller/restaurant_details_controller.dart';
import '../controller/cart_controller.dart';

class ExtrasListView extends StatelessWidget {
  const ExtrasListView({
    super.key,
    required this.cartController,
    required this.restaurantDetailsController,
    required this.calculateOnExtrasSelected,
  });

  final CartController cartController;
  final RestaurantDetailsController restaurantDetailsController;
  final void Function() calculateOnExtrasSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        NormalText(
          text: "Extras".tr,
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
        SizedBox(height: 8.h),
        SizedBox(
          height: 60.h,
          child: Obx(
            () =>
                cartController.selectedExtrasList
                // ignore: collection_methods_unrelated_type
                .contains(-1)
                ? const SizedBox()
                : ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: restaurantDetailsController
                        .itemDetails
                        .value
                        .data
                        ?.extras
                        ?.length,
                    itemBuilder: (context, index) {
                      var extras = restaurantDetailsController
                          .itemDetails
                          .value
                          .data
                          ?.extras;
                      return GestureDetector(
                        onTap: () {
                          cartController.selectExtras(extras[index]);
                          calculateOnExtrasSelected();
                        },
                        child: Padding(
                          padding: EdgeInsets.only(right: 9.w),
                          child: Container(
                            height: 52.h,
                            width: extras!.length > 2 ? 120.w : 154.w,
                            decoration: BoxDecoration(
                              color:
                                  cartController.selectedExtrasList.contains(
                                    extras[index],
                                  )
                                  ? AppColor.primaryColor.withValues(alpha: 0.1)
                                  : AppColor.black10,
                              borderRadius: BorderRadius.circular(8.r),
                              border: Border.all(
                                color:
                                    cartController.selectedExtrasList.contains(
                                      extras[index],
                                    )
                                    ? AppColor.primaryColor
                                    : Colors.transparent,
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(left: 8.w, right: 8.w),
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    cartController.selectedExtrasList.contains(
                                          extras[index],
                                        )
                                        ? SvgIcon.tickSquareMarked
                                        : SvgIcon.tickSquare,
                                    height: 16.h,
                                    colorFilter:
                                        cartController.selectedExtrasList
                                            .contains(extras[index])
                                        ? ColorFilter.mode(
                                            AppColor.primaryColor,
                                            BlendMode.srcIn,
                                          )
                                        : null,
                                  ),
                                  SizedBox(width: 8.w),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        NormalText(
                                          text:
                                              extras[index].name ??
                                              "Extra Cheese",
                                          fontSize: 12.sp,
                                        ),
                                        SizedBox(height: 4.h),
                                        NormalText(
                                          text:
                                              extras[index].currencyPrice ??
                                              "\$1.00",
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ),
      ],
    );
  }
}
