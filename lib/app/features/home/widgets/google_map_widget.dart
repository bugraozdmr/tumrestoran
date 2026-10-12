import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tumrestoran/app/features/address/controller/address_controller.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../config/theme/app_color.dart';
import '../../../../utils/images.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({
    super.key,
    this.addressController,
    this.latitude,
    this.longitude,
  });
  final AddressController? addressController;
  final double? latitude;
  final double? longitude;

  @override
  State<MapWidget> createState() => MapWidgetState();
}

class MapWidgetState extends State<MapWidget> {
  LatLng? initialPosition;
  CameraPosition? _cameraPosition;
  final box = GetStorage();

  @override
  void initState() {
    super.initState();

    Get.find<AddressController>().getCurrentLocation();
    initialPosition = LatLng(widget.latitude ?? 0, widget.longitude ?? 0);
    initialPosition = LatLng(
      double.parse(
        Get.find<AddressController>().currentPosition!.latitude.toString(),
      ),
      double.parse(
        Get.find<AddressController>().currentPosition!.longitude.toString(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<AddressController>(
        builder: (controller) => Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  widget.latitude ?? 23.65,
                  widget.longitude ?? 90.1547,
                ),
                zoom: 17,
              ),
              zoomControlsEnabled: false,
              myLocationEnabled: false,
              compassEnabled: false,
              indoorViewEnabled: true,
              mapToolbarEnabled: true,
              minMaxZoomPreference: const MinMaxZoomPreference(0, 16),
              onMapCreated: (GoogleMapController mapController) {
                controller.getCurrentLocation();
              },
              onCameraMove: (CameraPosition cameraPosition) {
                _cameraPosition = cameraPosition;
                controller.updatePosition(_cameraPosition!);
              },
            ),
            Center(
              child: !controller.isLoading.value
                  ? Image.asset(AppImages.marker, height: 50.h, width: 50.w)
                  :  CircularProgressIndicator(
                      color: AppColor.primaryColor,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
