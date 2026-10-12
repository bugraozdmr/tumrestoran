import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:foodnanny/app/features/auth/controller/auth_controller.dart';
import 'package:foodnanny/app/features/profile/controller/profile_controller.dart';
import 'package:foodnanny/app/features/profile/view/show_pages.dart';
import 'package:foodnanny/widgets/custom_snackbar.dart';
import 'package:get/get.dart';

import '../../../../config/theme/app_color.dart';
import '../../../../utils/svg_icon.dart';
import '../../../../utils/usecase/validation_rules.dart';
import '../../../../widgets/loader/loader.dart';
import '../../../../widgets/primary_button.dart';
import '../../../../widgets/text_widget.dart';
import '../../bottom_navbar/controller/navbar_controller.dart';
import '../widgets/primary_textfield.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  bool passwordVisible = false;
  final navController = Get.find<NavbarController>();
  final authController = Get.find<AuthController>();
  final profileController = Get.find<ProfileController>();

  final formKey = GlobalKey<FormState>();
  bool isAccept = true;

  @override
  void initState() {
    passwordVisible = true;

    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      authController.emailController.clear();
      authController.passwordController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Stack(
        children: [
          AnnotatedRegion<SystemUiOverlayStyle>(
            value: const SystemUiOverlayStyle(
              systemNavigationBarColor: Colors.white,
              systemNavigationBarIconBrightness: Brightness.dark,
              statusBarIconBrightness: Brightness.dark,
              statusBarColor: Colors.transparent,
              statusBarBrightness: Brightness.dark,
            ),
            child: Scaffold(
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          SvgIcon.logo,
                          height: 32.h,
                          width: 133.w,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(height: 24.h),
                        Padding(
                          padding: EdgeInsets.only(left: 16.w, right: 16.w),
                          child: Column(
                            children: [
                              Container(
                                alignment: Alignment.center,
                                width: double.infinity,
                                child: TextWidget(
                                  text: 'CREATE_ACCOUNT'.tr,
                                  color: AppColor.black100,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 22.sp,
                                ),
                              ),
                              SizedBox(height: 32.h),
                              Form(
                                key: formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextWidget(
                                      text: 'FIRST_NAME'.tr,
                                      color: AppColor.black100,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12.sp,
                                    ),
                                    SizedBox(height: 4.h),
                                    PrimaryTextField(
                                      controller:
                                          authController.firstNameController,
                                      obscureText: false,
                                      keyboardType: TextInputType.text,
                                      passwordVisible: false,
                                      suffixIcon: false,
                                      prefixIcon: false,
                                      validator: (value) =>
                                          ValidationRules().firstName(value),
                                    ),
                                    SizedBox(height: 16.h),
                                    TextWidget(
                                      text: 'LAST_NAME'.tr,
                                      color: AppColor.black100,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12.sp,
                                    ),
                                    SizedBox(height: 4.h),
                                    PrimaryTextField(
                                      controller:
                                          authController.lastNameController,
                                      obscureText: true,
                                      prefixIcon: false,
                                      passwordVisible: false,
                                      suffixIcon: false,
                                      keyboardType: TextInputType.text,
                                      validator: (value) =>
                                          ValidationRules().lastName(value),
                                    ),
                                    SizedBox(height: 16.h),
                                    TextWidget(
                                      text: 'EMAIL'.tr,
                                      color: AppColor.black100,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12.sp,
                                    ),
                                    SizedBox(height: 4.h),
                                    PrimaryTextField(
                                      controller:
                                          authController.emailController,
                                      obscureText: false,
                                      keyboardType: TextInputType.emailAddress,
                                      passwordVisible: false,
                                      suffixIcon: false,
                                      prefixIcon: false,
                                      validator: (value) =>
                                          ValidationRules().email(value),
                                    ),
                                    SizedBox(height: 16.h),
                                    TextWidget(
                                      text: 'PASSWORD'.tr,
                                      color: AppColor.black100,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12.sp,
                                    ),
                                    SizedBox(height: 4.h),
                                    PrimaryTextField(
                                      controller:
                                          authController.passwordController,
                                      obscureText: true,
                                      prefixIcon: false,
                                      passwordVisible: passwordVisible,
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      suffixIcon: true,
                                      validator: (value) =>
                                          ValidationRules().password(value),
                                    ),
                                    SizedBox(height: 16.h),

                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        GestureDetector(
                                          onTap: () => setState(
                                            () => isAccept = !isAccept,
                                          ),
                                          child: SizedBox(
                                            width: 16.w,
                                            height: 16.h,
                                            child: SvgPicture.asset(
                                              isAccept
                                                  ? SvgIcon.tickSquareMarked
                                                  : SvgIcon.tickSquare,
                                              fit: BoxFit.cover,
                                              colorFilter: ColorFilter.mode(
                                                AppColor.primaryColor,
                                                BlendMode.srcIn,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 6.w),
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              for (
                                                int i = 0;
                                                i <
                                                    profileController
                                                        .pageDataList
                                                        .length;
                                                i++
                                              ) {
                                                if (profileController
                                                        .pageDataList[i]
                                                        .id ==
                                                    profileController
                                                        .settingModel
                                                        .data!
                                                        .termsAndConditionCustomerId) {
                                                  Get.to(
                                                    () => ShowPages(
                                                      pageData:
                                                          profileController
                                                              .pageDataList[i],
                                                    ),
                                                  );
                                                  break;
                                                }
                                              }
                                            },
                                            child: RichText(
                                              text: TextSpan(
                                                text:
                                                    'BY_SIGNIN_UP_YOU_ARE_AGREE_TO_OUR'
                                                        .tr,
                                                style: TextStyle(
                                                  color: AppColor.fontColor,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 12.sp,
                                                  fontFamily: 'Rubik',
                                                ),
                                                children: [
                                                  TextSpan(text: ' '),
                                                  TextSpan(
                                                    text: 'TERMS_AND_CONDITIONS'
                                                        .tr,
                                                    style: TextStyle(
                                                      fontFamily: 'Rubik',
                                                      color:
                                                          AppColor.primaryColor,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 12.sp,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    SizedBox(height: 24.h),
                                    Center(
                                      child: PrimaryButton(
                                        width: 328.w,
                                        onTap: () async {
                                          if (formKey.currentState!
                                              .validate()) {
                                            if (isAccept == false) {
                                              customSnackbar(
                                                'ERROR'.tr,
                                                "PLEASE_ACCEPT_THE_TERMS_AND_CONDITIONS"
                                                    .tr,
                                                AppColor.rejectedTextColor,
                                              );
                                              return;
                                            }
                                            await authController
                                                .signupWithPhone(
                                                  firstName: authController
                                                      .firstNameController
                                                      .text,
                                                  lastName: authController
                                                      .lastNameController
                                                      .text,
                                                  email: authController
                                                      .emailController
                                                      .text,
                                                  phoneNumber: authController
                                                      .regPhoneTextController
                                                      .text,
                                                  password: authController
                                                      .passwordController
                                                      .text,
                                                  termsAndCondition: isAccept
                                                      ? 5
                                                      : "",
                                                );
                                          }
                                        },
                                        text: 'SIGN_UP'.tr,
                                      ),
                                    ),
                                    SizedBox(height: 40.h),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          authController.signUpLoader.value
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
