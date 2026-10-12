import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:foodnanny/data/model/address_model.dart';
import 'package:foodnanny/data/repository/address_repo.dart';
import 'package:foodnanny/widgets/custom_snackbar.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import '../../../../config/theme/app_color.dart';
import '../../../../data/repository/location_repo.dart';
import '../../../../data/model/prediction_model.dart';
import '../../../../main.dart';
import '../model/place_details_model.dart';

class AddressController extends GetxController {
  final AddressRepo _addressRepo = AddressRepo();
  final addressModel = AddressModel().obs;
  final isLoading = false.obs;
  final addNewAddressLoader = false.obs;
  final fakeInt = Rx(-1);
  final selectedHomeAddress = "".obs;

  final selectAddress = RxInt(-1);
  final selectLabel = "".obs;
  final selectLabelIndex = Rx(-1);
  final formkey = GlobalKey<FormState>();
  final addressTextController = TextEditingController();
  final labelTextController = TextEditingController();
  TextEditingController apartmentTextController = TextEditingController();

  List<Placemark>? placemarks;
  LatLng? initialPosition;
  CameraPosition? cameraPosition;
  Position? currentPosition;
  String? currentPositionName;
  String pickAddress = '';
  final pickNewAddress = "".obs;
  final pickEditAddress = "".obs;
  double? pickLat;
  double? pickLong;
  bool changeAddress = true;
  List<PredictionModel> predictionList = [];

  Position position = Position(
    longitude: 0.0,
    latitude: 0.0,
    timestamp: DateTime.now(),
    accuracy: 1,
    altitude: 1,
    heading: 1,
    speed: 1,
    speedAccuracy: 1,
    altitudeAccuracy: 0,
    headingAccuracy: 0,
  );

  Position pickPosition = Position(
    longitude: 0.0,
    latitude: 0.0,
    timestamp: DateTime.now(),
    accuracy: 1,
    altitude: 1,
    heading: 1,
    speed: 1,
    speedAccuracy: 1,
    altitudeAccuracy: 0,
    headingAccuracy: 0,
  );

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
        customSnackbar(
          "ERROR".tr,
          "Location permission is required.",
          AppColor.negativeDark,
        );
        permission = await Geolocator.requestPermission();
      }
    }
    if (permission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();

      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }
    if (permission == LocationPermission.whileInUse) {
      await box.write("isPermissionGranted", true);
    }
    return await Geolocator.getCurrentPosition();
  }

  Future<void> getCurrentLocation({GoogleMapController? mapController}) async {
    try {
      isLoading.value = true;
      update();

      position = await determinePosition();
      currentPosition = position;

      pickLat = position.latitude;
      pickLong = position.longitude;

      await getPlaceName();

      if (mapController != null) {
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: LatLng(pickLat!, pickLong!), zoom: 16),
          ),
        );
      }
    } catch (e) {
      debugPrint('Location error: $e');
    } finally {
      isLoading.value = false;
      update();
    }
  }

  getPlaceName() async {
    isLoading.value = true;
    update();
    placemarks = await placemarkFromCoordinates(
      currentPosition!.latitude,
      currentPosition!.longitude,
    );

    // ignore: prefer_interpolation_to_compose_strings
    pickAddress =
        "${placemarks![0].street!} ${placemarks![0].name!} ${placemarks![0].locality!} , ${placemarks![0].country!}";
    isLoading.value = false;
    update();
  }

  getCurrentLocationWhenTapped(GoogleMapController mapController) async {
    isLoading.value = true;
    update();
    position = await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(accuracy: LocationAccuracy.high),
    );
    currentPosition = position;

    pickPosition = Position(
      latitude: currentPosition!.latitude,
      longitude: currentPosition!.longitude,
      timestamp: DateTime.now(),
      accuracy: 1,
      altitude: 1,
      heading: 1,
      speed: 1,
      speedAccuracy: 1,
      altitudeAccuracy: 0,
      headingAccuracy: 0,
    );

    pickLat = pickPosition.latitude;
    pickLong = pickPosition.longitude;
    isLoading.value = false;
    update();
    getPlaceName();
    // ignore: unnecessary_null_comparison
    if (mapController != null) {
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(pickPosition.latitude, pickPosition.longitude),
            zoom: 16,
          ),
        ),
      );
    }
    isLoading.value = false;
    update();
  }

  Future<List<PredictionModel>> searchLocation(
    BuildContext context,
    String text,
  ) async {
    // ignore: unnecessary_null_comparison
    if (text != null && text.isNotEmpty) {
      http.Response response = await getLocationData(text);

      var data = jsonDecode(response.body.toString());
      isLoading.value = true;
      if (data['status'] == 'OK') {
        predictionList = [];
        data['predictions'].forEach(
          (prediction) =>
              predictionList.add(PredictionModel.fromJson(prediction)),
        );
        isLoading.value = false;
        update();
      } else {}
    }
    return predictionList;
  }

  Future<String> getAddressFromGeocodeData(LatLng latLng) async {
    try {
      isLoading.value = true;
      update();
      http.Response response = await getAddressFromGeocode(latLng);
      var responseData = jsonDecode(response.body);
      if (response.statusCode == 200 &&
          responseData['status'].toString() == 'OK' &&
          responseData['results'] != null &&
          (responseData['results'] as List).isNotEmpty) {
        pickAddress = responseData['results'][0]['formatted_address'].toString();
      } else {
        final placemarks = await placemarkFromCoordinates(latLng.latitude, latLng.longitude);
        if (placemarks.isNotEmpty) {
          final place = placemarks.first;
          final parts = [
            place.street,
            place.subLocality,
            place.locality,
            place.subAdministrativeArea,
            place.administrativeArea
          ].where((p) => p != null && p.trim().isNotEmpty).toList();
          pickAddress = parts.isNotEmpty ? parts.join(', ') : 'UNKNOWN_LOCATION_FOUND'.tr;
        } else {
          pickAddress = 'UNKNOWN_LOCATION_FOUND'.tr;
        }
      }
    } catch (_) {
      try {
        final placemarks = await placemarkFromCoordinates(latLng.latitude, latLng.longitude);
        if (placemarks.isNotEmpty) {
          final place = placemarks.first;
          final parts = [
            place.street,
            place.subLocality,
            place.locality,
            place.subAdministrativeArea,
            place.administrativeArea
          ].where((p) => p != null && p.trim().isNotEmpty).toList();
          pickAddress = parts.isNotEmpty ? parts.join(', ') : 'UNKNOWN_LOCATION_FOUND'.tr;
        } else {
          pickAddress = 'UNKNOWN_LOCATION_FOUND'.tr;
        }
      } catch (_) {
        pickAddress = 'UNKNOWN_LOCATION_FOUND'.tr;
      }
    } finally {
      isLoading.value = false;
      update();
    }
    return pickAddress;
  }

  void updatePosition(CameraPosition position) {
    pickPosition = Position(
      latitude: position.target.latitude,
      longitude: position.target.longitude,
      timestamp: DateTime.now(),
      heading: 1,
      accuracy: 1,
      altitude: 1,
      speedAccuracy: 1,
      speed: 1,
      altitudeAccuracy: 0,
      headingAccuracy: 0,
    );
    pickLat = pickPosition.latitude;
    pickLong = pickPosition.longitude;
    update();
  }

  void onCameraIdle() {
    if (pickLat != null && pickLong != null && pickLat != 0 && pickLong != 0) {
      getAddressFromGeocodeData(LatLng(pickLat!, pickLong!));
    }
  }

  Future<Position> setLocation(String placeID, String address) async {
    isLoading.value = true;

    LatLng latLng = const LatLng(0, 0);

    final response = await getLocationDetails(placeID);
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final placeDetails = PlaceDetailsModel.fromJson(jsonResponse);

      if (placeDetails.status == 'OK') {
        latLng = LatLng(
          placeDetails.result!.geometry!.location!.lat!,
          placeDetails.result!.geometry!.location!.lng!,
        );
      }
    }

    isLoading.value = false;

    return Position(
      latitude: latLng.latitude,
      longitude: latLng.longitude,
      timestamp: DateTime.now(),
      accuracy: 1,
      altitude: 1,
      heading: 1,
      speed: 1,
      speedAccuracy: 1,
      altitudeAccuracy: 0,
      headingAccuracy: 0,
    );
  }

  Future<void> getAddresses() async {
    isLoading(true);
    final data = await _addressRepo.getAddress();
    data.fold(
      (error) {
        isLoading(false);
      },
      (data) {
        addressModel.value = data;
        addressModel.value;
        isLoading(false);
      },
    );
  }

  Future<bool> addNewAddress({
    required String label,
    required double latitude,
    required double longitude,
    required String address,
    String? apartment,
  }) async {
    addNewAddressLoader(true);
    final response = await _addressRepo.addNewAddress(
      label: label,
      latitude: latitude,
      longitude: longitude,
      address: address,
      apartment: apartment,
    );

    if (response.statusCode == 201) {
      addNewAddressLoader(false);

      getAddresses();
      Get.back();
      customSnackbar(
        "SUCCESS".tr,
        "ADDRESS_ADDED_SUCCESSFULLY".tr,
        AppColor.positiveDark,
      );

      return true;
    } else {
      addNewAddressLoader(false);

      String message = response.data['message'];

      customSnackbar("ERROR".tr, message.toString(), AppColor.negativeDark);
      return false;
    }
  }

  Future<void> deleteAddress({required int id}) async {
    final response = await _addressRepo.deleteAddress(id: id);
    if (response.statusCode == 202) {
      getAddresses();
      Get.back();
      customSnackbar(
        "SUCCESS".tr,
        "ADDRESS_DELETED_SUCCESSFULLY".tr,
        AppColor.positiveDark,
      );
    } else {
      customSnackbar(
        "ERROR".tr,
        response.data["message"].toString(),
        AppColor.negativeDark,
      );
    }
  }

  Future<void> editAddress({
    required int id,
    required String label,
    required double latitude,
    required double longitude,
    required String address,
    String? apartment,
  }) async {
    final response = await _addressRepo.editAddress(
      id: id,
      label: label,
      latitude: latitude,
      longitude: longitude,
      address: address,
      apartment: apartment,
    );
    if (response.statusCode == 200) {
      getAddresses();
      Get.back();
      customSnackbar(
        "SUCCESS".tr,
        "ADDRESS_UPDATED_SUCCESSFULLY".tr,
        AppColor.positiveDark,
      );
    } else {
      customSnackbar(
        "ERROR".tr,
        response.data["message"].toString(),
        AppColor.negativeDark,
      );
    }
  }

  reset() {
    selectLabel.value = "";
    pickAddress = "";
    apartmentTextController.clear();
    selectLabelIndex.value = -1;
    addressTextController.clear();
    labelTextController.clear();
  }

  @override
  void onInit() {
    if (box.read('isLoggedIn') == true && box.read('isLoggedIn') != null) {
      getAddresses();
    }
    currentPosition = Position(
      latitude: 37.4133095,
      longitude: -122.1592061,
      timestamp: DateTime.now(),
      accuracy: 1,
      altitude: 1,
      heading: 1,
      speed: 1,
      speedAccuracy: 1,
      altitudeAccuracy: 0,
      headingAccuracy: 0,
    );
    super.onInit();
    super.onInit();
  }
}
