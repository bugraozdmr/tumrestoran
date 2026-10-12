// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:foodnanny/app/features/auth/view/guest_login_screen.dart';
import 'package:foodnanny/app/features/auth/view/singup_phone_screen.dart';
import 'package:foodnanny/app/features/bottom_navbar/controller/navbar_controller.dart';
import 'package:foodnanny/app/features/bottom_navbar/views/bottom_navigation.dart';
import 'package:foodnanny/main.dart';
import 'package:foodnanny/utils/usecase/validation_rules.dart';
import 'package:foodnanny/widgets/loader/loader.dart';
import 'package:get/get.dart';
import '../../../../config/theme/app_color.dart';
import '../../../../utils/svg_icon.dart';
import '../../../../widgets/primary_button.dart';
import '../../../../widgets/secondary_button.dart';
import '../../../../widgets/text_widget.dart';
import '../controller/auth_controller.dart';
import '../widgets/primary_textfield.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key, this.fromOrderHistory = false});

  final bool fromOrderHistory;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AuthController authController = Get.put(AuthController());
  final navController = Get.find<NavbarController>();
  final formKey = GlobalKey<FormState>();

  bool passwordVisible = false;
  bool rememberMe = false;

  @override
  void initState() {
    super.initState();
    passwordVisible = true;
    rememberMe = box.read('remember_me') ?? false;
    if (rememberMe == false) {
      authController.emailController.clear();
      authController.passwordController.clear();
    }
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
            child: PopScope(
              canPop: !widget.fromOrderHistory,
              onPopInvokedWithResult: (didPop, result) {
                if (!didPop && widget.fromOrderHistory) {
                  navController.changePage(0);
                  Get.off(() => const BottomNavigationScreen());
                }
              },
              child: Scaffold(
                backgroundColor: AppColor.whiteColor,
                body: SafeArea(
                  child: Center(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Column(
                          children: [
                            SvgPicture.asset(
                              SvgIcon.logo,
                              height: 32.h,
                              width: 133.w,
                              fit: BoxFit.contain,
                            ),
                            SizedBox(height: 24.h),
                            Container(
                              alignment: Alignment.center,
                              width: double.infinity,
                              child: TextWidget(
                                text: 'WELCOME_BACK'.tr,
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
                                    text: 'EMAIL'.tr,
                                    color: AppColor.black100,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12.sp,
                                  ),
                                  SizedBox(height: 4.h),
                                  PrimaryTextField(
                                    controller: authController.emailController,
                                    obscureText: false,
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (value) =>
                                        ValidationRules().email(value),
                                    passwordVisible: false,
                                    suffixIcon: false,
                                    prefixIcon: false,
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
                                    keyboardType: TextInputType.visiblePassword,
                                    suffixIcon: true,
                                    validator: (password) =>
                                        ValidationRules().password(password),
                                  ),
                                  SizedBox(height: 16.h),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            rememberMe = !rememberMe;
                                          });
                                          box.write('remember_me', rememberMe);
                                        },
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: 16.w,
                                              height: 16.h,
                                              child: rememberMe
                                                  ? SvgPicture.asset(
                                                      SvgIcon.tickSquareMarked,
                                                      fit: BoxFit.cover,
                                                      colorFilter:
                                                          ColorFilter.mode(
                                                            AppColor
                                                                .primaryColor,
                                                            BlendMode.srcIn,
                                                          ),
                                                    )
                                                  : SvgPicture.asset(
                                                      SvgIcon.tickSquare,
                                                      fit: BoxFit.cover,
                                                    ),
                                            ),
                                            SizedBox(width: 6.w),
                                            TextWidget(
                                              text: 'REMEMBER_ME'.tr,
                                              color: AppColor.black100,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12.sp,
                                            ),
                                          ],
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Get.to(() => ForgotPasswordScreen());
                                        },
                                        child: TextWidget(
                                          text: 'FORGOT_PASSWORD'.tr,
                                          color: AppColor.primaryColor,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 24.h),
                                  Center(
                                    child: PrimaryButton(
                                      width: 328.w,
                                      onTap: () async {
                                        if (formKey.currentState!.validate()) {
                                          await authController.userLogin(
                                            email: authController
                                                .emailController
                                                .text,
                                            password: authController
                                                .passwordController
                                                .text,
                                          );
                                        }
                                      },
                                      text: 'LOGIN'.tr,
                                    ),
                                  ),
                                  SizedBox(height: 24.h),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextWidget(
                                        text: 'DONT_HAVE_AN_ACCOUNT?'.tr,
                                        color: AppColor.black80,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12.sp,
                                      ),
                                      SizedBox(width: 8.w),
                                      GestureDetector(
                                        onTap: () {
                                          Get.to(() => SingupPhoneScreen());
                                        },
                                        child: TextWidget(
                                          text: 'SIGN_UP'.tr,
                                          color: AppColor.primaryColor,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 16.h),
                                  Center(
                                    child: TextWidget(
                                      text: 'OR'.tr,
                                      color: AppColor.black80,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                  SizedBox(height: 12.h),
                                  SecondaryButton(
                                    onPressed: () {
                                      Get.to(() => GuestLoginScreen());
                                    },
                                    text: 'LOGIN_AS_GUEST'.tr,
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
            ),
          ),
          authController.signInLoader.value == true
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
