import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:foodnanny/app/features/address/controller/address_controller.dart';
import 'package:foodnanny/app/features/address/widgets/edit_address_modal_sheet.dart';
import 'package:foodnanny/app/features/home/controller/home_controller.dart';
import 'package:foodnanny/app/features/search_location/view/search_location.dart';
import 'package:foodnanny/main.dart';
import 'package:foodnanny/utils/style.dart';
import 'package:foodnanny/widgets/text_widget.dart';
import 'package:get/get.dart';
import '../../../../config/theme/app_color.dart';
import '../../../../utils/svg_icon.dart';
import '../../../../widgets/divider_widget.dart';

Future locationBottomSheet(BuildContext context) {
  final addressController = Get.put(AddressController());
  final homeController = Get.find<HomeController>();

  return showModalBottomSheet(
    isScrollControlled: true,
    backgroundColor: AppColor.whiteColor,
    context: context,
    builder: (context) {
      return SizedBox(
        height: Get.height * .6,
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("DELIVERY_ADDRESS".tr, style: title16),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: SvgPicture.asset(
                        SvgIcon.closeCircle,
                        height: 20.h,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Container(
                    height: 48.h,
                    width: 268.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: GestureDetector(
                        onTap: () async {
                          final currentContext = context;
                          Navigator.of(
                            currentContext,
                            rootNavigator: true,
                          ).pop();
                          Future.delayed(Duration(milliseconds: 200));

                          Get.to(() => SearchLocation());
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            color: AppColor.black20,
                          ),
                          child: Row(
                            children: [
                              SizedBox(width: 8.w),
                              SvgPicture.asset(
                                SvgIcon.searchNormal,
                                height: 24.h,
                                width: 24.w,
                              ),
                              SizedBox(width: 8.w),
                              TextWidget(
                                text: "Enter a location".tr,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xff6E7191),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  GestureDetector(
                    onTap: () async {
                      final currentContext = context;
                      Navigator.of(currentContext, rootNavigator: true).pop();
                      Future.delayed(Duration(milliseconds: 200));

                      Get.to(() => SearchLocation());
                    },
                    child: Container(
                      height: 48.h,
                      width: 48.w,
                      decoration: BoxDecoration(
                        color: AppColor.primaryColor,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Center(
                        child: SvgPicture.asset(SvgIcon.arrowRight),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              const DividerWidget(),
              SizedBox(height: 16.h),
              box.read("isLoggedIn") != true ||
                      addressController.addressModel.value.data == null
                  ? SizedBox.shrink()
                  : Text("SAVED_ADDRESSES".tr, style: title16),
              SizedBox(height: 16.h),

              box.read("isLoggedIn") != true
                  ? const SizedBox()
                  : Expanded(
                      child: StatefulBuilder(
                        builder: (context, setState) => Obx(
                          () => addressController.selectAddress.value != -2
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: addressController
                                      .addressModel
                                      .value
                                      .data
                                      ?.length,
                                  itemBuilder: (context, index) {
                                    final savedAddress = addressController
                                        .addressModel
                                        .value
                                        .data;
                                    return GestureDetector(
                                      onTap: () async {
                                        addressController.selectAddress.value =
                                            index;

                                        Future.wait([
                                          homeController.getCampaignsAndOffer(
                                            lat: savedAddress![index].latitude
                                                .toString(),
                                            long: savedAddress[index].longitude
                                                .toString(),
                                            deliveryOrderType: '5',
                                          ),

                                          homeController
                                              .getSingleOfferRestaurants(
                                                lat: savedAddress[index]
                                                    .latitude
                                                    .toString(),
                                                long: savedAddress[index]
                                                    .longitude
                                                    .toString(),
                                                deliveryOrderType: '5',
                                              ),

                                          homeController
                                              .getAllRestuarantByLatLong(
                                                lat: savedAddress[index]
                                                    .latitude
                                                    .toString(),
                                                long: savedAddress[index]
                                                    .longitude
                                                    .toString(),
                                                deliveryOrderType: '5',
                                              ),
                                        ]);

                                        await box.write(
                                          "pickAddress",
                                          addressController
                                              .addressModel
                                              .value
                                              .data?[index]
                                              .address,
                                        );

                                        await box.write(
                                          "pickedLat",
                                          savedAddress[index].latitude
                                              .toString(),
                                        );
                                        await box.write(
                                          "pickedLong",
                                          savedAddress[index].longitude
                                              .toString(),
                                        );

                                        addressController
                                            .selectedHomeAddress
                                            .value = box.read(
                                          'pickAddress',
                                        );

                                        Get.back();
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.only(bottom: 16.h),
                                        child: SizedBox(
                                          child: Row(
                                            children: [
                                              Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  addressController
                                                              .selectAddress
                                                              .value ==
                                                          index
                                                      ? SvgPicture.asset(
                                                          SvgIcon
                                                              .radioCircleMarked,
                                                          height: 24.h,
                                                        )
                                                      : SvgPicture.asset(
                                                          SvgIcon.radioCircle,
                                                          height: 24.h,
                                                        ),
                                                ],
                                              ),
                                              SizedBox(width: 12.w),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    TextWidget(
                                                      text:
                                                          addressController
                                                              .addressModel
                                                              .value
                                                              .data?[index]
                                                              .label ??
                                                          "Work",
                                                      color:
                                                          addressController
                                                                  .selectAddress
                                                                  .value ==
                                                              index
                                                          ? AppColor
                                                                .primaryColor
                                                          : AppColor.black100,
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                    addressController
                                                                    .addressModel
                                                                    .value
                                                                    .data?[index]
                                                                    .apartment ==
                                                                null ||
                                                            addressController
                                                                .addressModel
                                                                .value
                                                                .data![index]
                                                                .apartment!
                                                                .isEmpty
                                                        ? const SizedBox()
                                                        : TextWidget(
                                                            text: addressController
                                                                .addressModel
                                                                .value
                                                                .data![index]
                                                                .apartment
                                                                .toString(),
                                                            color:
                                                                addressController
                                                                        .selectAddress
                                                                        .value ==
                                                                    index
                                                                ? AppColor
                                                                      .primaryColor
                                                                : AppColor
                                                                      .black100,
                                                            fontSize: 14.sp,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                    TextWidget(
                                                      text:
                                                          addressController
                                                              .addressModel
                                                              .value
                                                              .data?[index]
                                                              .address ??
                                                          "",
                                                      maxLines: 3,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      color:
                                                          addressController
                                                                  .selectAddress
                                                                  .value ==
                                                              index
                                                          ? AppColor
                                                                .primaryColor
                                                          : AppColor.black100,
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              Column(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () async {
                                                      Get.back();

                                                      await Future.delayed(
                                                        const Duration(
                                                          milliseconds: 100,
                                                        ),
                                                      );
                                                      await editAddressModalSheet(
                                                        // ignore: use_build_context_synchronously
                                                        context: context,
                                                        addressController:
                                                            addressController,
                                                        address:
                                                            addressController
                                                                .addressModel
                                                                .value
                                                                .data![index],
                                                      );
                                                    },
                                                    child: SvgPicture.asset(
                                                      SvgIcon.edit,
                                                      height: 12.h,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                )
                              : const SizedBox(),
                        ),
                      ),
                    ),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      );
    },
  );
}
