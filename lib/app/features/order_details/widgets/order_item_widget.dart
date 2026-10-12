import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tumrestoran/data/model/order_details_model.dart';
import 'package:tumrestoran/widgets/text_widget.dart';
import 'package:get/get.dart';

import '../../../../config/theme/app_color.dart';
import '../../../../widgets/divider_widget.dart';
import '../../../../widgets/normal_text.dart';

class OrderItemWidget extends StatelessWidget {
  const OrderItemWidget({
    super.key,
    required this.order,
    required this.index,
    required this.length,
  });
  final OrderItem? order;
  final int? index;
  final int? length;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 13.w),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.centerLeft,
                clipBehavior: Clip.none,
                children: [
                  Row(
                    children: [
                      Column(
                        children: [
                          CachedNetworkImage(
                            imageUrl:
                                order?.itemImage ??
                                "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?q=80&w=1998&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                            imageBuilder: (context, imageProvider) => Container(
                              height: 64.h,
                              width: 64.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.r),
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            NormalText(
                              text: order?.itemName ?? '',
                              fontSize: 14.sp,
                            ),
                            order?.itemVariations != null
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: order!.itemVariations!
                                        .where(
                                          (variation) => variation.name != null,
                                        )
                                        .map(
                                          (v) => TextWidget(
                                            text:
                                                "${v.attributeName}: ${v.name}",
                                            fontSize: 12.sp,
                                            color: AppColor.black80,
                                          ),
                                        )
                                        .toList(),
                                  )
                                : const SizedBox(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                NormalText(
                                  text: order?.price ?? '',
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    left: -12.w,
                    child: Container(
                      height: 26.h,
                      width: 26.w,
                      decoration: const BoxDecoration(
                        color: AppColor.black100,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: NormalText(
                          text: order?.quantity.toString() ?? '',
                          fontSize: 14.sp,
                          color: AppColor.whiteColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 9.h),
              order?.itemExtras != null && order!.itemExtras!.isNotEmpty
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        NormalText(text: "EXTRAS".tr, fontSize: 12.sp),
                        order?.itemExtras != null &&
                                order!.itemExtras!.isNotEmpty
                            ? Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextWidget(
                                      text: order!.itemExtras!
                                          .map((e) => e.name ?? "")
                                          .where((name) => name.isNotEmpty)
                                          .join(", "),
                                      fontSize: 12.sp,
                                      color: AppColor.black80,
                                    ),
                                  ],
                                ),
                              )
                            : const SizedBox(),
                      ],
                    )
                  : const SizedBox(),

              order?.instruction != null && order!.instruction!.isNotEmpty
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        NormalText(text: "INSTRUCTIONS:".tr, fontSize: 12.sp),
                        Expanded(
                          child: TextWidget(
                            text: order?.instruction ?? '',
                            fontSize: 12.sp,
                            color: AppColor.black80,
                          ),
                        ),
                      ],
                    )
                  : const SizedBox(),
            ],
          ),
        ),
        SizedBox(height: 12.h),
        index != length! - 1 ? const DividerWidget() : SizedBox(),
        SizedBox(height: 12.h),
      ],
    );
  }
}
