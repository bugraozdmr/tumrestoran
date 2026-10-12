import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../config/theme/app_color.dart';
import '../../../../utils/images.dart';
import '../controller/address_controller.dart';

class AddressDeleteWidget extends StatefulWidget {
  const AddressDeleteWidget({super.key, required this.id});
  final int id;

  @override
  State<AddressDeleteWidget> createState() => _AddressDeleteWidgetState();
}

class _AddressDeleteWidgetState extends State<AddressDeleteWidget> {
  AddressController addressController = Get.put(AddressController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 275.h,
          width: 328.w,
          decoration: BoxDecoration(
            color: AppColor.whiteColor,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.sp),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Are you sure you want to delete?'.tr,
                  style: GoogleFonts.urbanist(
                    color: AppColor.black100,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Image.asset(AppImages.deleteIcon, height: 120.h, width: 120.w),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                        height: 48.h,
                        width: 140.w,
                        decoration: BoxDecoration(
                          color: AppColor.addressColor,
                          borderRadius: BorderRadius.circular(24.r),
                        ),
                        child: Center(
                          child: Text(
                            'Cancel'.tr,
                            style: GoogleFonts.urbanist(
                              color: AppColor.black100,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        await addressController.deleteAddress(id: widget.id);
                      },
                      child: Container(
                        height: 48.h,
                        width: 140.w,
                        decoration: BoxDecoration(
                          color: AppColor.negativeDark,
                          borderRadius: BorderRadius.circular(24.r),
                        ),
                        child: Center(
                          child: Text(
                            'Delete'.tr,
                            style: GoogleFonts.urbanist(
                              color: AppColor.whiteColor,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
