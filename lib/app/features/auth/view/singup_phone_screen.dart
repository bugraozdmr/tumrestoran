// ignore_for_file: prefer_const_constructors_in_immutables
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:foodnanny/app/features/auth/view/login_screen.dart';
import 'package:foodnanny/utils/helper/get_country_iso.dart';
import 'package:foodnanny/utils/svg_icon.dart';
import 'package:foodnanny/widgets/normal_text.dart';
import 'package:get/get.dart';
import 'package:phone_form_field/phone_form_field.dart';
import '../../../../config/theme/app_color.dart';
import '../../../../widgets/primary_button.dart';
import '../../../../widgets/text_widget.dart';
import '../../profile/controller/profile_controller.dart';
import '../controller/auth_controller.dart';
import '../widgets/phone_search_form_field.dart';

class SingupPhoneScreen extends StatefulWidget {
  SingupPhoneScreen({super.key});

  @override
  State<SingupPhoneScreen> createState() => _SingupPhoneScreenState();
}

class _SingupPhoneScreenState extends State<SingupPhoneScreen> {
  AuthController authController = Get.put(AuthController());
  ProfileController profileController = Get.put(ProfileController());
  final formKey = GlobalKey<FormState>();
  String companyCountryCode = "";

  @override
  void initState() {
    super.initState();
    authController.regPhoneTextController.clear();
    companyCountryCode =
        Get.find<ProfileController>().settingModel.data?.companyCountryCode ??
        "";
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppColor.whiteColor,
          appBar: AppBar(
            backgroundColor: AppColor.whiteColor,
            surfaceTintColor: AppColor.whiteColor,
            elevation: 0,
            leading: IconButton(
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
          ),
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SvgPicture.asset(
                            SvgIcon.logo,
                            height: 32.h,
                            width: 133.w,
                            fit: BoxFit.contain,
                          ),
                        ],
                      ),
                      SizedBox(height: 24.h),
                      Padding(
                        padding: EdgeInsets.only(bottom: 16.h),
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              width: double.infinity,
                              child: TextWidget(
                                text: 'LETS_GET_STARTED'.tr,
                                color: AppColor.black100,
                                fontWeight: FontWeight.w600,
                                fontSize: 22.sp,
                              ),
                            ),

                            Form(
                              key: formKey,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  top: 32.h,
                                  left: 16.w,
                                  right: 16.w,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    FittedBox(
                                      child: Row(
                                        children: [
                                          TextWidget(
                                            text: 'PHONE'.tr,
                                            color: AppColor.black100,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12.sp,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 4.h),

                                    PhoneSearchFormField(
                                      onPhoneChanged: (nsn, countryCode) {
                                        authController
                                                .regPhoneTextController
                                                .text =
                                            nsn;
                                        Get.find<ProfileController>()
                                                .callingCode
                                                .value =
                                            countryCode;
                                      },
                                      phoneController: PhoneController(
                                        initialValue: PhoneNumber(
                                          isoCode: getIsoCodeFromString(
                                            companyCountryCode,
                                          ),

                                          //  IsoCode.BD,
                                          nsn: "",
                                        ),
                                      ),
                                    ),

                                    SizedBox(height: 24.h),
                                    Center(
                                      child: PrimaryButton(
                                        width: 328.w,
                                        onTap: () async {
                                          if (formKey.currentState!
                                              .validate()) {
                                            await authController.singupPhone(
                                              phone: authController
                                                  .regPhoneTextController
                                                  .text,
                                            );
                                          }
                                        },
                                        text: 'NEXT'.tr,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          NormalText(
                            text: "ALREADY_HAVE_AN_ACCOUNT?".tr,
                            fontSize: 12.sp,
                            color: AppColor.black80,
                          ),
                          SizedBox(width: 4.w),
                          GestureDetector(
                            onTap: () {
                              Get.to(() => LoginScreen());
                            },
                            child: NormalText(
                              text: "LOGIN".tr,
                              fontSize: 12.sp,
                              color: AppColor.primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
