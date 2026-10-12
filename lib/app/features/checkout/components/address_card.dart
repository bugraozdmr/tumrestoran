import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tumrestoran/app/features/cart/controller/cart_controller.dart';
import 'package:tumrestoran/app/features/profile/controller/profile_controller.dart';
import 'package:tumrestoran/data/model/address_model.dart';
import 'package:tumrestoran/main.dart';
import 'package:tumrestoran/utils/helper/distance_calculator.dart';
import 'package:tumrestoran/widgets/custom_snackbar.dart';
import 'package:get/get.dart';
import '../../../../config/theme/app_color.dart';
import '../../../../utils/svg_icon.dart';
import '../../../../widgets/text_widget.dart';
import '../controller/checkout_controller.dart';

class AddressCard extends StatelessWidget {
  const AddressCard({
    super.key,
    required this.checkoutController,
    required this.addressModel,
  });

  final CheckoutController checkoutController;
  final AddressModel addressModel;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemCount: addressModel.data!.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () async {
            final settingModel = Get.find<ProfileController>().settingModel;

            double addressLat = double.parse(
              addressModel.data?[index].latitude.toString() ?? "0",
            );
            double addressLong = double.parse(
              addressModel.data?[index].longitude.toString() ?? "0",
            );
            double restaurantLat = double.parse(box.read('restaurantLat'));
            double restaurantLong = double.parse(box.read('restaurantLong'));

            double distance = calculateDistance(
              addressLat: addressLat,
              addressLong: addressLong,
              restaurantLat: restaurantLat,
              restaurantLong: restaurantLong,
            );

            if (distance <=
                settingModel.data!.siteDeliveryBoyOrderRadius!.toDouble()) {
              checkoutController.selectAddress.value = index;
              checkoutController.addressId = addressModel.data?[index].id;

              checkoutController.deliveryCharge.value = checkoutController
                  .calculateDeliveryCharge(distance, settingModel);

              Get.find<CartController>().extraDeliveryFee.value =
                  checkoutController.calculateDeliveryCharge(
                    distance,
                    settingModel,
                  );
            } else {
              checkoutController.selectAddress.value = -1;
              checkoutController.addressId = null;
              checkoutController.deliveryCharge.value = 0.0;

              customSnackbar(
                "ERROR".tr,
                'SORRY_THIS_RESTAURANT_DOES_NOT_DELIVERY_TO_YOUR_LOCATION'.tr,
                AppColor.rejectedTextColor,
              );
            }
          },
          child: Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: Container(
              width: 212.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                color: checkoutController.selectAddress.value == index
                    ? AppColor.primaryLight
                    : AppColor.black10,
                border: Border.all(
                  color: checkoutController.selectAddress.value == index
                      ? AppColor.primaryColor
                      : Colors.transparent,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 8.w, top: 12.h, right: 8.w),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          addressModel.data?[index].label == "Home"
                              ? SvgIcon.home
                              : addressModel.data?[index].label == "Work"
                              ? SvgIcon.briefcase
                              : SvgIcon.moreSquare,
                          height: 16.h,
                          colorFilter: const ColorFilter.mode(
                            AppColor.highlightDark,
                            BlendMode.srcIn,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            addressModel.data?[index].label ?? "Home",
                            style: TextStyle(
                              fontFamily: 'Rubik',
                              color: AppColor.highlightDark,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 8.w, top: 12.h, right: 8.w),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          SvgIcon.location,
                          colorFilter: ColorFilter.mode(
                            checkoutController.selectAddress.value == index
                                ? AppColor.primaryColor
                                : AppColor.black80,
                            BlendMode.srcIn,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  width: double.infinity,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      addressModel.data?[index].apartment ==
                                                  null ||
                                              addressModel
                                                  .data![index]
                                                  .apartment!
                                                  .isEmpty
                                          ? const SizedBox()
                                          : TextWidget(
                                              text: addressModel
                                                  .data![index]
                                                  .apartment!,
                                              fontSize: 14.sp,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                      TextWidget(
                                        text:
                                            addressModel.data?[index].address ??
                                            "Gulshan-2",
                                        maxLines: 3,
                                        fontSize: 14.sp,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SvgPicture.asset(
                          checkoutController.selectAddress.value == index
                              ? SvgIcon.radioCircleMarked
                              : SvgIcon.radioCircle,
                          height: 16.h,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
