import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:foodnanny/app/features/address/controller/address_controller.dart';
import 'package:foodnanny/app/features/cart/controller/cart_controller.dart';
import 'package:foodnanny/app/features/home/controller/home_controller.dart';
import 'package:foodnanny/main.dart';
import 'package:get/get.dart';
import '../../../../config/theme/app_color.dart';
import '../../../../utils/svg_icon.dart';
import '../../../../utils/images.dart';
import '../../../../widgets/normal_text.dart';
import '../../../../widgets/text_widget.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key, this.onTap, required this.pickedAddress});
  final void Function()? onTap;
  final String pickedAddress;

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(64.h);
}

class _CustomAppBarState extends State<CustomAppBar> {
  final addressController = Get.find<AddressController>();
  final homeController = Get.find<HomeController>();
  bool _isDeliveryApiCalled = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      addressController.selectedHomeAddress.value =
          box.read('pickAddress') ?? 'Konum Belirtilmedi';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 30.h),
      child: Container(
        height: 64.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColor.whiteColor,
          boxShadow: [
            BoxShadow(
              color: AppColor.blackColor.withValues(alpha: 0.04),
              offset: Offset(0, 6),
              blurRadius: 32.r,
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 16.w, right: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                AppImages.logo,
                height: 24.h,
                width: 100.w,
              ),
              Obx(
                () => Container(
                  height: 36.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: AppColor.borderColor),
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          Get.find<CartController>().isDeliver.value = true;

                          if (!_isDeliveryApiCalled) {
                            _isDeliveryApiCalled = true;
                            Future.wait([
                              homeController.getAllRestuarantByLatLong(
                                lat: box.read('pickedLat') ?? '',
                                long: box.read('pickedLong') ?? '',
                                deliveryOrderType: "5",
                              ),
                              homeController.getSingleOfferRestaurants(
                                lat: box.read('pickedLat') ?? '',
                                long: box.read('pickedLong') ?? '',
                                deliveryOrderType: "5",
                              ),
                              homeController.getCampaignsAndOffer(
                                lat: box.read('pickedLat') ?? '',
                                long: box.read('pickedLong') ?? '',
                                deliveryOrderType: "5",
                              ),
                            ]);
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.all(3.r),
                          child: Container(
                            height: 30.h,
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            decoration: BoxDecoration(
                              color:
                                  Get.find<CartController>().isDeliver.value ==
                                      true
                                  ? AppColor.primaryColor
                                  : AppColor.whiteColor,
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            child: Center(
                              child: NormalText(
                                text: "DELIVERY".tr,
                                color:
                                    Get.find<CartController>()
                                            .isDeliver
                                            .value ==
                                        true
                                    ? AppColor.whiteColor
                                    : AppColor.black100,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          Get.find<CartController>().isDeliver.value = false;

                          _isDeliveryApiCalled = false;

                          Future.wait([
                            homeController.getAllRestuarantByLatLong(
                              lat: box.read('pickedLat') ?? '',
                              long: box.read('pickedLong') ?? '',
                              deliveryOrderType: "10",
                            ),
                            homeController.getSingleOfferRestaurants(
                              lat: box.read('pickedLat') ?? '',
                              long: box.read('pickedLong') ?? '',
                              deliveryOrderType: "10",
                            ),
                            homeController.getCampaignsAndOffer(
                              lat: box.read('pickedLat') ?? '',
                              long: box.read('pickedLong') ?? '',
                              deliveryOrderType: "10",
                            ),
                          ]);
                        },
                        child: Padding(
                          padding: EdgeInsets.all(3.r),
                          child: Container(
                            height: 30.h,
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            decoration: BoxDecoration(
                              color:
                                  Get.find<CartController>().isDeliver.value ==
                                      false
                                  ? AppColor.primaryColor
                                  : AppColor.whiteColor,
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            child: Center(
                              child: NormalText(
                                text: "TAKEAWAY".tr,
                                fontSize: 14.sp,
                                color:
                                    Get.find<CartController>()
                                            .isDeliver
                                            .value ==
                                        false
                                    ? AppColor.whiteColor
                                    : AppColor.black100,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
