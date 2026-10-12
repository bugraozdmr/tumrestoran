import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:tumrestoran/app/features/auth/widgets/phone_search_form_field.dart';
import 'package:tumrestoran/app/features/profile/controller/profile_controller.dart';
import 'package:tumrestoran/data/model/profile_model.dart';
import 'package:tumrestoran/utils/usecase/validation_rules.dart';
import 'package:tumrestoran/widgets/appbar_widget.dart';
import 'package:get/get.dart';
import 'package:phone_form_field/phone_form_field.dart';
import '../../../config/theme/app_color.dart';
import '../../../utils/svg_icon.dart';
import '../../../widgets/custom_snackbar.dart';
import '../../../widgets/loader/loader.dart';
import '../../../widgets/primary_button.dart';
import '../../../widgets/text_widget.dart';
import '../auth/widgets/primary_textfield.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key, required this.profileModel});
  final ProfileModel profileModel;

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final profileController = Get.put(ProfileController());

  bool validate = false;
  @override
  void initState() {
    profileController.getProfile();
    profileController.phoneController.text =
        profileController.profileModel.value.data?.phone ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Stack(
        children: [
          Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBarWidget(
              isIcon: true,
              iconButton: IconButton(
                icon: Container(
                  height: 24.h,
                  width: 24.w,
                  decoration: BoxDecoration(
                    color: AppColor.whiteColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColor.primaryColor),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(4.r),
                    child: SvgPicture.asset(
                      SvgIcon.arrowLeftCircle,
                      height: 24.h,
                      width: 24.w,
                      colorFilter: ColorFilter.mode(
                        AppColor.primaryColor,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
                onPressed: () {
                  Get.back();
                },
              ),
              text: "EDIT_PROFILE".tr,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextWidget(
                            text: "FIRST_NAME".tr,
                            fontWeight: FontWeight.w400,
                            fontSize: 12.sp,
                            color: AppColor.black100,
                          ),
                          SizedBox(height: 4.h),
                          PrimaryTextField(
                            controller: profileController.fNameController,
                            keyboardType: TextInputType.text,
                            validator: (value) => value!.isEmpty
                                ? 'PLEASE_TYPE_FIRST_NAME'.tr
                                : null,
                            obscureText: false,
                            passwordVisible: false,
                            suffixIcon: false,
                            prefixIcon: false,
                          ),
                          SizedBox(height: 16.h),
                          TextWidget(
                            text: "LAST_NAME".tr,
                            fontWeight: FontWeight.w400,
                            fontSize: 12.sp,
                            color: AppColor.black100,
                          ),
                          SizedBox(height: 4.h),
                          PrimaryTextField(
                            controller: profileController.lNameController,
                            keyboardType: TextInputType.text,
                            validator: (value) => value!.isEmpty
                                ? 'PLEASE_TYPE_LAST_NAME'.tr
                                : null,
                            obscureText: false,
                            passwordVisible: false,
                            suffixIcon: false,
                            prefixIcon: false,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 16.h),
                              TextWidget(
                                text: "EMAIL".tr,
                                fontWeight: FontWeight.w400,
                                fontSize: 12.sp,
                                color: AppColor.black100,
                              ),
                              SizedBox(height: 4.h),
                              PrimaryTextField(
                                controller: profileController.emailController,
                                keyboardType: TextInputType.text,
                                validator: (value) =>
                                    ValidationRules().email(value),
                                obscureText: false,
                                passwordVisible: false,
                                suffixIcon: false,
                                prefixIcon: false,
                              ),
                            ],
                          ),
                          SizedBox(height: 16.h),
                          TextWidget(
                            text: "PHONE".tr,
                            fontWeight: FontWeight.w400,
                            fontSize: 12.sp,
                            color: AppColor.black100,
                          ),
                          SizedBox(height: 4.h),
                          PhoneSearchFormField(
                            onPhoneChanged: (nsn, countryCode) {
                              profileController.phoneController.text = nsn;
                              profileController.callingCode.value = countryCode;
                            },
                            phoneController: PhoneController(
                              initialValue: PhoneNumber(
                                isoCode: IsoCode.BD,
                                nsn: profileController.phoneController.text,
                              ),
                            ),
                          ),

                          SizedBox(height: 24.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              PrimaryButton(
                                onTap: () async {
                                  if (_formKey.currentState!.validate()) {
                                    await profileController.updateProfile(
                                      firstName: profileController
                                          .fNameController
                                          .text,
                                      lastName: profileController
                                          .lNameController
                                          .text,
                                      email: profileController
                                          .emailController
                                          .text,
                                      phone: profileController
                                          .phoneController
                                          .text,
                                      countryCode: profileController
                                          .countryCodeController
                                          .text,
                                    );
                                    await profileController.getProfile();

                                    Get.back();
                                    customSnackbar(
                                      "SUCCESS".tr,
                                      "Profile updated successfully",
                                      AppColor.positiveDark,
                                    );
                                  }
                                },
                                text: "UPDATE_PROFILE".tr,
                                width: 156.w,
                              ),
                            ],
                          ),
                          SizedBox(height: 20.h),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          profileController.updateProfileLoader.value == true
              ? Positioned(
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white60,
                    child: const Center(child: LoaderCircle()),
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
