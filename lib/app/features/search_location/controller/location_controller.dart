import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:foodnanny/config/theme/app_color.dart';
import 'package:foodnanny/widgets/custom_snackbar.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LocationController extends GetxController {
  final box = GetStorage();
  final currentAddress = "".obs;
  final latitude = RxDouble(0);
  final longitude = RxDouble(0);
  TextEditingController locationTextController = TextEditingController();
  final fakeInt = Rx(-1);
  final initialLocationLoader = false.obs;

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        customSnackbar("ERROR".tr, "Location permission is required.",
            AppColor.negativeDark);
        permission = await Geolocator.requestPermission();
      }
    }
    if (permission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();

      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    if (permission == LocationPermission.whileInUse) {
      await box.write("isPermissionGranted", true);
      customSnackbar("SUCCESS".tr, "Location permission is granted",
          AppColor.positiveDark);
    }
    return await Geolocator.getCurrentPosition();
  }

  getAddressFromLatLong() async {
    String address;
    Position currentPosition = await determinePosition();

    if (currentPosition.latitude.toString().isNotEmpty) {
      initialLocationLoader(true);
      latitude.value = currentPosition.latitude;
      longitude.value = currentPosition.longitude;
      List<Placemark> placemarks = await placemarkFromCoordinates(
          currentPosition.latitude, currentPosition.longitude);
      Placemark place = placemarks[0];

      address = place.street!;
      address = "$address, ${place.subLocality}";
      address = " $address  ${place.locality}";
      address = " $address  ${place.postalCode}";
      currentAddress.value = address;
      await box.write("initialAddress", currentAddress.value);
    }
    initialLocationLoader(false);
  }
}
