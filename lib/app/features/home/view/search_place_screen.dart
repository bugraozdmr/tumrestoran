import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:foodnanny/config/theme/app_color.dart';
import 'package:foodnanny/data/model/place_auto_complete_response.dart';
import 'package:foodnanny/data/repository/search_places_repo.dart';
import 'package:foodnanny/utils/api_list.dart';
import 'package:foodnanny/utils/svg_icon.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SearchPlaceScreen extends StatefulWidget {
  const SearchPlaceScreen({super.key});

  @override
  State<SearchPlaceScreen> createState() => _SearchPlaceScreenState();
}

class _SearchPlaceScreenState extends State<SearchPlaceScreen> {
  String? query;
  CameraPosition initialCameraPosition = const CameraPosition(
    target: LatLng(23.8223, 90.3654),
  );
  Set<Marker> markerList = {};
  late GoogleMapController googleMapController;
  final homeScaffoldKey = GlobalKey<ScaffoldState>();

  List<Prediction> placePredictions = [];

  void placeAutoComplete(String query) async {
    Uri uri = Uri.https(
      "maps.googleapis.com",
      "maps/api/place/autocomplete/json",
      {"input": query, "key": ApiList.mapKey},
    );

    String? response = await SearchPlacesRepo.fetchUrl(uri);

    if (response != null) {
      PlaceAutocompleteResponse result = placeAutocompleteResponseFromJson(
        response,
      );

      setState(() {
        placePredictions = result.predictions ?? [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: initialCameraPosition,
              markers: markerList,
              mapType: MapType.normal,
              onMapCreated: (controller) {
                googleMapController = controller;
              },
            ),
            Container(
              height: 88.h,
              width: double.infinity,
              decoration: const BoxDecoration(color: AppColor.whiteColor),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24.r),
                        border: Border.all(color: AppColor.primaryColor),
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Padding(
                            padding: EdgeInsets.only(
                              left: 12.w,
                              top: 12.h,
                              bottom: 12.h,
                              right: 12.w,
                            ),
                            child: SvgPicture.asset(
                              SvgIcon.location,
                              height: 16.h,
                              fit: BoxFit.fill,
                              colorFilter: const ColorFilter.mode(
                                AppColor.black80,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                          hintText: "SEARCH_LOCATION".tr,
                          suffixIcon: GestureDetector(
                            onTap: () {},
                            child: GestureDetector(
                              onTap: () {},
                              child: Padding(
                                padding: EdgeInsets.only(
                                  left: 12.w,
                                  top: 12.h,
                                  bottom: 12.h,
                                  right: 12.w,
                                ),
                                child: SvgPicture.asset(
                                  SvgIcon.closeCircleSolid,
                                  height: 16.h,
                                  fit: BoxFit.fill,
                                  colorFilter: const ColorFilter.mode(
                                    AppColor.black100,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        onChanged: (value) {
                          placeAutoComplete(value);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: placePredictions.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    placePredictions[index].description.toString(),
                    style: TextStyle(fontFamily: 'Rubik'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
