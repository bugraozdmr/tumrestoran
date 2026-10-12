import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tumrestoran/app/features/address/controller/address_controller.dart';
import 'package:tumrestoran/app/features/address/widgets/update_pick_location_view.dart';
import 'package:tumrestoran/app/features/home/widgets/label_button.dart';
import 'package:tumrestoran/data/model/address_model.dart';
import 'package:tumrestoran/widgets/primary_button.dart';
import 'package:tumrestoran/widgets/text_widget.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../config/theme/app_color.dart';
import '../../../../utils/images.dart';
import '../../../../utils/svg_icon.dart';
import '../../../../widgets/normal_text.dart';

var labelIcon = [SvgIcon.homeDark, SvgIcon.briefcase, SvgIcon.moreSquare];
var labelName = ["Home", "Work", "Other"];

const CameraPosition initialPosition = CameraPosition(
  target: LatLng(37.42796133580664, -122.085749655962),
  zoom: 14.4746,
);

final Completer<GoogleMapController> controller =
    Completer<GoogleMapController>();

class EditAddressModalSheet extends StatefulWidget {
  const EditAddressModalSheet({super.key, required this.address});
  final Address address;

  @override
  State<EditAddressModalSheet> createState() => _EditAddressModalSheetState();
}

class _EditAddressModalSheetState extends State<EditAddressModalSheet> {
  GoogleMapController? _mapController;
  final addressController = Get.find<AddressController>();
  late double initialLat;
  late double initialLong;
  late String initialAddress;

  @override
  void initState() {
    super.initState();
    initialLat = double.parse(widget.address.latitude ?? '0');
    initialLong = double.parse(widget.address.longitude ?? '0');
    initialAddress = widget.address.address ?? '';

    WidgetsBinding.instance.addPostFrameCallback((_) {
      addressController.apartmentTextController.text =
          widget.address.apartment ?? "";
      addressController.selectLabel.value = widget.address.label ?? "";

      if (widget.address.label != labelName[0] &&
          widget.address.label != labelName[1]) {
        addressController.labelTextController.text = widget.address.label ?? "";
        addressController.selectLabel.value = labelName[2];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        height: Get.height * .9,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColor.whiteColor,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Padding(
                    padding: EdgeInsets.only(top: 12.h),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: SvgPicture.asset(
                        SvgIcon.closeCircle,
                        height: 20.h,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 28.h),
                InkWell(
                  onTap: () async {
                    final result = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => UpdatePickLocationView(
                          initialLat: initialLat,
                          initialLong: initialLong,
                          initialAddress: initialAddress,
                        ),
                      ),
                    );

                    if (result != null) {
                      initialLat = result['lat'];
                      initialLong = result['lng'];
                      initialAddress = result['address'];

                      _mapController?.animateCamera(
                        CameraUpdate.newLatLngZoom(
                          LatLng(initialLat, initialLong),
                          16,
                        ),
                      );

                      setState(() {});
                    }
                  },
                  child: Container(
                    height: 48.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      color: AppColor.whiteColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(10),
                          blurRadius: 32,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          NormalText(
                            text: "ENTER_YOUR_LOCATION".tr,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColor.black80,
                          ),
                          Padding(
                            padding: EdgeInsets.all(4.r),
                            child: Container(
                              height: 28.h,
                              width: 28.w,
                              decoration: BoxDecoration(
                                color: AppColor.primaryColor,
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                              child: Center(
                                child: SvgPicture.asset(
                                  SvgIcon.gps,
                                  height: 16.h,
                                  colorFilter: const ColorFilter.mode(
                                    Colors.white,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),

                Stack(
                  alignment: AlignmentGeometry.center,
                  children: [
                    SizedBox(
                      height: 210.h,
                      child: Container(
                        color: AppColor.primaryLight,
                        child: Center(
                          child: Icon(Icons.location_on, color: AppColor.primaryColor, size: 40),
                        ),
                      ),
                    ),
                    !addressController.isLoading.value
                        ? Image.asset(AppImages.marker, height: 50, width: 50)
                        :  CircularProgressIndicator(
                            color: AppColor.primaryColor,
                          ),
                  ],
                ),

                SizedBox(height: 16.h),
                Row(
                  children: [
                    SvgPicture.asset(SvgIcon.location, height: 24.h),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: TextWidget(
                        text: initialAddress,
                        fontSize: 14.sp,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                NormalText(text: "APARTMENT_AND_FLAT_NO".tr, fontSize: 12.sp),
                SizedBox(height: 4.h),
                Form(
                  key: addressController.formkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: addressController.apartmentTextController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                            borderSide: BorderSide(
                              color: AppColor.inputBorderColor,
                              width: 1.w,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                            borderSide: BorderSide(
                              color: AppColor.inputBorderColor,
                              width: 1.w,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                            borderSide: BorderSide(
                              color: AppColor.primaryColor,
                              width: 1.w,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "ADDRESS_IS_REQUIRED".tr;
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.h),
                      NormalText(
                        text: "ADD_LABEL".tr,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      SizedBox(height: 9.h),
                      SizedBox(
                        height: 48.h,
                        child: Obx(
                          () => addressController.selectLabel.value == "-1"
                              ? const SizedBox()
                              : ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: labelIcon.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: EdgeInsets.only(right: 12.w),
                                      child: LabelButton(
                                        onTap: () {
                                          addressController.selectLabel.value =
                                              labelName[index];
                                        },
                                        svgIcon: labelIcon[index],
                                        text: labelName[index],
                                        backgroundColor:
                                            addressController
                                                    .selectLabel
                                                    .value ==
                                                labelName[index]
                                            ? AppColor.primaryLight
                                            : AppColor.black20,
                                        borderColor:
                                            addressController
                                                    .selectLabel
                                                    .value ==
                                                labelName[index]
                                            ? AppColor.primaryColor
                                            : Colors.transparent,
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ),

                      SizedBox(height: 16.h),
                      Obx(
                        () =>
                            addressController.selectLabel.value != labelName[2]
                            ? const SizedBox()
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  NormalText(
                                    text: "ADD_LABEL_NAME".tr,
                                    fontSize: 12.sp,
                                  ),
                                  SizedBox(height: 4.h),
                                  TextFormField(
                                    controller:
                                        addressController.labelTextController,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                          8.r,
                                        ),
                                        borderSide: BorderSide(
                                          color: AppColor.inputBorderColor,
                                          width: 1.w,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                          8.r,
                                        ),
                                        borderSide: BorderSide(
                                          color: AppColor.inputBorderColor,
                                          width: 1.w,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                          8.r,
                                        ),
                                        borderSide: BorderSide(
                                          color: AppColor.primaryColor,
                                          width: 1.w,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),
                PrimaryButton(
                  onTap: () async {
                    await addressController.editAddress(
                      id: widget.address.id ?? 0,
                      label: addressController.selectLabel.value == labelName[2]
                          ? addressController.labelTextController.text
                          : addressController.selectLabel.value,
                      latitude: initialLat,
                      longitude: initialLong,
                      address: initialAddress,
                      apartment: addressController.apartmentTextController.text,
                    );

                    addressController.pickLat = null;
                    addressController.pickLong = null;
                  },
                  text: "UPDATE_LOCATION".tr,
                  width: double.infinity,
                ),
                SizedBox(height: 16.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> editAddressModalSheet({
  required BuildContext context,
  required AddressController addressController,
  Address? address,
  double? updatePickLat,
  double? updatepickLong,
  String? updatePickAddress,
}) {
  return showModalBottomSheet(
    isScrollControlled: true,
    backgroundColor: AppColor.whiteColor,
    context: context,
    builder: (context) {
      return EditAddressModalSheet(address: address ?? Address());
    },
  );
}
