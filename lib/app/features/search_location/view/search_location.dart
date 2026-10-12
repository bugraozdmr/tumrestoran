import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tumrestoran/app/features/cart/controller/cart_controller.dart';
import 'package:tumrestoran/utils/images.dart';
import 'package:tumrestoran/widgets/custom_snackbar.dart';
import 'package:tumrestoran/widgets/primary_button.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../config/theme/app_color.dart';
import '../../../../utils/svg_icon.dart';
import '../../address/controller/address_controller.dart';
import '../../address/widgets/location_search_dialouge.dart';
import '../../bottom_navbar/views/bottom_navigation.dart';
import '../../home/controller/home_controller.dart';

class SearchLocation extends StatefulWidget {
  const SearchLocation({super.key});
  @override
  State<SearchLocation> createState() => _SearchLocationState();
}

class _SearchLocationState extends State<SearchLocation> {
  final homeController = Get.put(HomeController());
  final cartController = Get.find<CartController>();
  LatLng? initialPosition;
  CameraPosition? _cameraPosition;
  GoogleMapController? _mapController;
  final box = GetStorage();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late double lat;
  late double long;

  @override
  void initState() {
    super.initState();
    initialized();
  }

  initialized() {
    lat = double.parse(box.read("pickedLat").toString());
    long = double.parse(box.read("pickedLong").toString());
    Get.find<AddressController>().pickAddress = box.read("pickAddress");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          key: scaffoldKey,
          body: SafeArea(
            child: Center(
              child: GetBuilder<AddressController>(
                builder: (controller) => Stack(
                  children: [
                    GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: LatLng(lat, long),

                        zoom: 17,
                      ),
                      zoomControlsEnabled: false,
                      myLocationEnabled: false,
                      compassEnabled: false,
                      indoorViewEnabled: true,
                      mapToolbarEnabled: true,
                      minMaxZoomPreference: const MinMaxZoomPreference(0, 16),
                      onMapCreated: (GoogleMapController mapController) {
                        _mapController = mapController;
                      },
                      onCameraMove: (CameraPosition cameraPosition) {
                        _cameraPosition = cameraPosition;
                        controller.updatePosition(_cameraPosition!);
                      },
                      onTap: (latLong) {
                        controller.pickLat = latLong.latitude;
                        controller.pickLong = latLong.longitude;

                        _mapController!.animateCamera(
                          CameraUpdate.newLatLngZoom(
                            LatLng(controller.pickLat!, controller.pickLong!),
                            16,
                          ),
                        );
                      },
                    ),

                    Center(
                      child: !controller.isLoading.value
                          ? Image.asset(
                              AppImages.marker,
                              height: 50.h,
                              width: 50.w,
                            )
                          :  CircularProgressIndicator(
                              color: AppColor.primaryColor,
                            ),
                    ),
                    Positioned(
                      top: 10.h,
                      left: 10.w,
                      right: 10.w,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(15.r),
                          border: Border.all(color: AppColor.primaryColor),
                        ),
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
                                onTap: () {
                                  Get.dialog(
                                    LocationSearchDialog(
                                      mapController: _mapController,
                                    ),
                                  );
                                },
                                child: Container(
                                  height: 48.h,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                    borderRadius:
                                        box.read('languageCode') == 'ar'
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
                                          style: TextStyle(fontFamily: 'Rubik'),
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
                    ),
                    Positioned(
                      bottom: 80.h,
                      right: 10.w,
                      child: FloatingActionButton(
                        mini: true,
                        backgroundColor: Theme.of(context).cardColor,
                        onPressed: () {
                          controller.getCurrentLocationWhenTapped(
                            _mapController!,
                          );
                        },
                        child:  Icon(
                          Icons.my_location,
                          color: AppColor.primaryColor,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 10.h,
                      left: 10.w,
                      right: 10.w,
                      child: PrimaryButton(
                        onTap: () async {
                          if (!controller.pickAddress.contains(
                            "Unknown Location Found",
                          )) {
                            box.write("pickAddress", controller.pickAddress);

                            String pickedLat = Get.find<AddressController>()
                                .pickLat
                                .toString();
                            String pickedLong = Get.find<AddressController>()
                                .pickLong
                                .toString();
                            await homeController.getAllRestuarantByLatLong(
                              lat: pickedLat,
                              long: pickedLong,
                              deliveryOrderType: cartController.isDeliver.value
                                  ? "5"
                                  : "10",
                            );

                            if (homeController.restuarantModel.value.data !=
                                null) {
                              await box.write("isConfirmed", true);
                              await box.write("pickedLat", pickedLat);
                              await box.write("pickedLong", pickedLong);
                              Get.off(() => const BottomNavigationScreen());
                            }
                          } else {
                            customSnackbar(
                              "ERROR".tr,
                              "PLEASE_SELECT_YOUR_ADDRESS_FIRST".tr,
                              AppColor.negativeDark,
                            );
                          }
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
      ],
    );
  }
}
