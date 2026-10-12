import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tumrestoran/utils/svg_icon.dart';
import 'package:tumrestoran/widgets/primary_button.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../config/theme/app_color.dart';
import '../../../../utils/images.dart';
import '../controller/address_controller.dart';
import 'location_search_dialouge.dart';

class UpdatePickLocationView extends StatefulWidget {
  const UpdatePickLocationView({
    super.key,
    required this.initialLat,
    required this.initialLong,
    required this.initialAddress,
  });
  final double initialLat;
  final double initialLong;
  final String initialAddress;
  @override
  State<UpdatePickLocationView> createState() => _UpdatePickLocationViewState();
}

class _UpdatePickLocationViewState extends State<UpdatePickLocationView> {
  LatLng? initialPosition;
  CameraPosition? _cameraPosition;
  GoogleMapController? _mapController;
  final box = GetStorage();
  final addressController = Get.find<AddressController>();

  late double pickLat;
  late double pickLong;
  late String pickAddress;
  @override
  void initState() {
    super.initState();

    pickLat = widget.initialLat;
    pickLong = widget.initialLong;
    pickAddress = widget.initialAddress;
  }

  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        key: scaffoldKey,
        body: SafeArea(
          child: Center(
            child: GetBuilder<AddressController>(
              builder: (controller) => Stack(
                children: [
                  Container(
                    color: AppColor.primaryLight,
                  ),
                  Center(
                    child: !controller.isLoading.value
                        ? Image.asset(AppImages.marker, height: 50, width: 50)
                        : const CircularProgressIndicator(),
                  ),
                  Positioned(
                    top: 10.h,
                    left: 10.w,
                    right: 10.w,
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: box.read('languageCode') == 'ar'
                                ? BorderRadius.only(
                                    topRight: Radius.circular(16.r),
                                    bottomRight: Radius.circular(16.r),
                                  )
                                : BorderRadius.only(
                                    topLeft: Radius.circular(16.r),
                                    bottomLeft: Radius.circular(16.r),
                                  ),
                          ),
                          child: IconButton(
                            icon: SvgPicture.asset(SvgIcon.arrowLeft),
                            onPressed: () {
                              Get.back();
                            },
                          ),
                        ),
                        SizedBox(
                          height: 48,
                          width: Get.width - 70.w,
                          child: InkWell(
                            onTap: () async {
                              final result = await Get.dialog(
                                LocationSearchDialog(
                                  addressController: addressController,
                                  mapController: _mapController,
                                ),
                              );

                              if (result != null) {
                                setState(() {
                                  pickLat = result['lat'];
                                  pickLong = result['lng'];
                                  pickAddress = result['address'];
                                });

                                _mapController?.animateCamera(
                                  CameraUpdate.newLatLngZoom(
                                    LatLng(pickLat, pickLong),
                                    16,
                                  ),
                                );
                              }
                            },
                            child: Container(
                              height: 48.h,
                              padding: EdgeInsets.symmetric(horizontal: 10.h),
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: box.read('languageCode') == 'ar'
                                    ? BorderRadius.only(
                                        topLeft: Radius.circular(16.r),
                                        bottomLeft: Radius.circular(16.r),
                                      )
                                    : BorderRadius.only(
                                        topRight: Radius.circular(16.r),
                                        bottomRight: Radius.circular(16.r),
                                      ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    size: 25,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(width: 10.h),
                                  Expanded(
                                    child: Text(
                                      controller.pickAddress,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SizedBox(width: 10.h),
                                  const Icon(
                                    Icons.search,
                                    size: 25,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 80,
                    right: 10,
                    child: FloatingActionButton(
                      mini: true,
                      backgroundColor: Theme.of(context).cardColor,
                      onPressed: () {
                        controller.getCurrentLocationWhenTapped(
                          _mapController!,
                        );
                      },
                      child: Icon(
                        Icons.my_location,
                        color: AppColor.primaryColor,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    left: 10,
                    right: 10,
                    child: PrimaryButton(
                      onTap: () async {
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context, {
                            'lat': controller.pickLat,
                            'lng': controller.pickLong,
                            'address': controller.pickAddress,
                          });
                        }
                        Future.delayed(const Duration(milliseconds: 100));
                      },
                      text: "CONFIRM_LOCATION".tr,
                      width: 328.w,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
