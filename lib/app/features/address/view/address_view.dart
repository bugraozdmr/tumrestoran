import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tumrestoran/app/features/address/controller/address_controller.dart';
import 'package:tumrestoran/app/features/address/widgets/address_delete_widget.dart';
import 'package:tumrestoran/app/features/address/widgets/address_bottom_modal_sheet.dart';
import 'package:tumrestoran/app/features/address/widgets/edit_address_modal_sheet.dart';
import 'package:tumrestoran/config/theme/app_color.dart';
import 'package:tumrestoran/utils/svg_icon.dart';
import 'package:tumrestoran/widgets/appbar_widget.dart';
import 'package:tumrestoran/widgets/normal_text.dart';
import 'package:tumrestoran/widgets/text_widget.dart';
import 'package:get/get.dart';
import '../../../../widgets/loader/loader.dart';

class AddressView extends StatelessWidget {
  const AddressView({super.key});

  @override
  Widget build(BuildContext context) {
    final addressController = Get.put(AddressController());
    return Stack(
      children: [
        AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
            systemNavigationBarColor: Colors.white,
            systemNavigationBarIconBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.dark,
            statusBarColor: Colors.transparent,
            statusBarBrightness: Brightness.dark,
          ),
          child: Scaffold(
            backgroundColor: AppColor.whiteColor,
            appBar: AppBarWidget(
              isIcon: true,
              iconButton: IconButton(
                icon: Container(
                  height: 24.h,
                  width: 24.w,
                  decoration: BoxDecoration(
                    color: AppColor.whiteColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColor.primaryColor),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(4.r),
                    child: SvgPicture.asset(
                      SvgIcon.arrowLeftCircle,
                      height: 24.h,
                      width: 24.w,
                      colorFilter: ColorFilter.mode(
                        AppColor.primaryColor,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
                onPressed: () {
                  Get.back();
                },
              ),
              text: "ADDRESS".tr,
            ),
            body: RefreshIndicator(
              color: AppColor.primaryColor,
              onRefresh: () async {
                await addressController.getAddresses();
              },
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 16.h,
                  ),
                  child: Column(
                    children: [
                      Obx(
                        () => addressController.isLoading.value == true
                            ? const SizedBox()
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: addressController
                                    .addressModel
                                    .value
                                    .data
                                    ?.length,
                                itemBuilder: (context, index) {
                                  final address = addressController
                                      .addressModel
                                      .value
                                      .data?[index];
                                  return Padding(
                                    padding: EdgeInsets.only(bottom: 16.h),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: AppColor.background,
                                        borderRadius: BorderRadius.circular(
                                          8.r,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(12.r),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Row(
                                                    children: [
                                                      SvgPicture.asset(
                                                        address?.label == "Home"
                                                            ? SvgIcon.home
                                                            : address?.label ==
                                                                  "Work"
                                                            ? SvgIcon.briefcase
                                                            : SvgIcon
                                                                  .moreSquare,
                                                        height: 16.h,
                                                        colorFilter:
                                                            const ColorFilter.mode(
                                                              AppColor
                                                                  .highlightDark,
                                                              BlendMode.srcIn,
                                                            ),
                                                      ),
                                                      SizedBox(width: 8.w),
                                                      Expanded(
                                                        child: TextWidget(
                                                          text:
                                                              address?.label ??
                                                              "Home",
                                                          color: AppColor
                                                              .highlightDark,
                                                          fontSize: 16.sp,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        Get.dialog(
                                                          Dialog(
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent,
                                                            insetPadding:
                                                                EdgeInsets.only(
                                                                  top: 20.h,
                                                                  bottom: 20.h,
                                                                ),
                                                            child:
                                                                AddressDeleteWidget(
                                                                  id: address!
                                                                      .id!,
                                                                ),
                                                          ),
                                                        );
                                                      },
                                                      child: SvgPicture.asset(
                                                        SvgIcon.deleteCircle,
                                                      ),
                                                    ),
                                                    SizedBox(width: 8.w),
                                                    GestureDetector(
                                                      onTap: () async {
                                                        await editAddressModalSheet(
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
                                                        SvgIcon.editCircle,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 8.h),
                                            Row(
                                              children: [
                                                SvgPicture.asset(
                                                  SvgIcon.location,
                                                  colorFilter:
                                                      const ColorFilter.mode(
                                                        AppColor.black80,
                                                        BlendMode.srcIn,
                                                      ),
                                                ),
                                                SizedBox(width: 8.w),
                                                Expanded(
                                                  child: TextWidget(
                                                    text:
                                                        address?.apartment ==
                                                                null ||
                                                            address!
                                                                .apartment!
                                                                .isEmpty
                                                        ? "${address?.address}"
                                                        : "${address.apartment ?? ""}, "
                                                              "${address.address}",
                                                    maxLines: 3,
                                                    overflow:
                                                        TextOverflow.ellipsis,
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
                              ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          addressController.reset();
                          await addressBottomModalSheet(
                            context: context,
                            addressController: addressController,
                          );
                        },
                        child: Container(
                          height: 80.h,
                          width: 328.w,
                          decoration: BoxDecoration(
                            color: AppColor.primaryColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                SvgIcon.addCircleSolid,
                                height: 24.h,
                                colorFilter: ColorFilter.mode(
                                  AppColor.primaryColor,
                                  BlendMode.srcIn,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              NormalText(
                                text: "ADD_NEW".tr,
                                color: AppColor.primaryColor,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Obx(
          () => addressController.isLoading.value == true
              ? Positioned(
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white60,
                    child: const Center(child: LoaderCircle()),
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}
