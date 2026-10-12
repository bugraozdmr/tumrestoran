import 'dart:async';
import 'package:flutter/material.dart';
import 'package:foodnanny/app/features/search_location/controller/location_controller.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SearchLocationMapWidget extends StatefulWidget {
  const SearchLocationMapWidget({super.key, this.locationController});
  final LocationController? locationController;
  @override
  State<SearchLocationMapWidget> createState() =>
      SearchLocationMapWidgetState();
}

class SearchLocationMapWidgetState extends State<SearchLocationMapWidget> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  double lat = 0;
  double long = 0;
  CameraPosition initialCameraPosition = const CameraPosition(
    target: LatLng(23, 90),
    zoom: 14,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        lat = widget.locationController?.latitude.value ?? 23.65;
        long = widget.locationController?.longitude.value ?? 90.65;
        var setMarker = {
          Marker(markerId: const MarkerId("1"), position: LatLng(lat, long)),
        };
        _updateCameraPosition();
        return GoogleMap(
          zoomControlsEnabled: false,
          mapType: MapType.normal,
          initialCameraPosition: initialCameraPosition,
          markers: setMarker,
          onMapCreated: (GoogleMapController controller) async {
            _controller.complete(controller);
          },
        );
      }),
    );
  }

  Future<void> _updateCameraPosition() async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, long), zoom: 14),
      ),
    );
  }
}
