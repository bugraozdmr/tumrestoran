import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tumrestoran/config/theme/app_color.dart';
import 'package:get/get.dart';
import 'package:phone_form_field/phone_form_field.dart';

class PhoneSearchFormField extends StatelessWidget {
  const PhoneSearchFormField({
    super.key,
    required this.onPhoneChanged,
    this.phoneController,
  });
  final PhoneController? phoneController;

  final void Function(String nsn, String countryCode) onPhoneChanged;

  @override
  Widget build(BuildContext context) {
    return PhoneFormField(
      controller: phoneController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      cursorColor: Theme.of(context).colorScheme.primary,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.black40),
          borderRadius: BorderRadius.circular(8.r),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.primaryColor),
          borderRadius: BorderRadius.circular(8.r),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.black40),
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
      validator: PhoneValidator.compose([
        PhoneValidator.required(context, errorText: "PHONE_IS_REQUIRED".tr),
      ]),
      countrySelectorNavigator:
          const CountrySelectorNavigator.modalBottomSheet(),
      onChanged: (phoneNumber) {
        onPhoneChanged(phoneNumber.nsn, phoneNumber.countryCode);
      },
      enabled: true,
      isCountrySelectionEnabled: true,
      isCountryButtonPersistent: true,
      countryButtonStyle: const CountryButtonStyle(
        showDialCode: true,
        showFlag: true,
        flagSize: 16,
      ),
    );
  }
}
