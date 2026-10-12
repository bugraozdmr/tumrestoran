import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:tumrestoran/app/features/address/controller/address_controller.dart';
import 'package:tumrestoran/config/theme/app_color.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../data/model/prediction_model.dart';

class LocationSearchDialog extends StatelessWidget {
  final GoogleMapController? mapController;
  const LocationSearchDialog({
    super.key,
    this.mapController,
    this.addressController,
  });

  final AddressController? addressController;

  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
      ),
      child: Container(
        margin: const EdgeInsets.only(top: 0),
        padding: EdgeInsets.all(10.r),
        alignment: Alignment.topCenter,
        child: Material(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: SizedBox(
            width: double.infinity,
            child: TypeAheadField(
              suggestionsCallback: (search) async =>
                  await Get.find<AddressController>().searchLocation(
                    context,
                    search,
                  ),
              builder: (context, controller, focusNode) {
                return TextField(
                  controller: controller,
                  textInputAction: TextInputAction.search,
                  autofocus: true,
                  textCapitalization: TextCapitalization.words,
                  keyboardType: TextInputType.streetAddress,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide(color: AppColor.primaryColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),

                      borderSide: BorderSide(color: AppColor.primaryColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),

                      borderSide: BorderSide(color: AppColor.primaryColor),
                    ),
                    hintText: 'SEARCH_LOCATION'.tr,
                  ),
                );
              },
              itemBuilder: (context, PredictionModel suggestion) {
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      const Icon(Icons.location_on),
                      Expanded(
                        child: Text(
                          suggestion.description!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              },
              onSelected: (PredictionModel suggestion) async {
                final position = await Get.find<AddressController>()
                    .setLocation(suggestion.placeId!, suggestion.description!);

                Get.back(
                  result: {
                    'lat': position.latitude,
                    'lng': position.longitude,
                    'address': suggestion.description,
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
