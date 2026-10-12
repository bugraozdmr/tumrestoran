import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:tumrestoran/app/features/bottom_navbar/controller/navbar_controller.dart';
import 'package:tumrestoran/app/features/profile/controller/profile_controller.dart';
import 'package:tumrestoran/data/model/login_model.dart';
import 'package:tumrestoran/data/repository/auth_repo.dart';
import 'package:tumrestoran/utils/api_list.dart';
import 'package:tumrestoran/widgets/custom_snackbar.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../config/theme/app_color.dart';
import '../../../../data/server/server.dart';
import '../../bottom_navbar/views/bottom_navigation.dart';
import '../view/create_password_screen.dart';
import '../view/forgot_verify_screen.dart';
import '../view/guest_verify_screen.dart';
import '../view/registration_screen.dart';
import '../view/verify_screen.dart';

class AuthController extends GetxController {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final forgotEmailTextController = TextEditingController();
  final guestOTPTextController = TextEditingController();
  final guestphoneTextController = TextEditingController();
  final regPhoneTextController = TextEditingController();
  final regOTPTextController = TextEditingController();

  final box = GetStorage();
  final signInLoader = false.obs;
  final logoutLoader = false.obs;
  final signUpLoader = false.obs;
  final signupPhoneLoader = false.obs;
  final verifyOTPLoader = false.obs;
  final signupOTPLoader = false.obs;
  final forgotLoader = false.obs;
  final resetPasswordLoader = false.obs;
  AuthRepo authRepo = AuthRepo();
  final userData = LoginModel().obs;
  final profileController = Get.put(ProfileController());

  Future<LoginModel> userLogin({
    required String email,
    required String password,
    bool fromReset = false,
  }) async {
    try {
      signInLoader.value = true;
      final response = await authRepo.login(email: email, password: password);
      signInLoader.value = false;
      if (response.statusCode == 200 || response.statusCode == 201) {
        signInLoader.value = false;
        final data = response.data;

        userData.value = LoginModel.fromJson(data);
        box.write("token", "Bearer ${userData.value.token.toString()}");
        box.write("isLoggedIn", true);

        if (!fromReset) {
          customSnackbar(
            "SUCCESS".tr,
            data['message'].toString(),
            AppColor.positiveDark,
          );
        }
        profileController.getProfile();
        final navController = Get.put(NavbarController());
        navController.changePage(0);
        Get.off(() => const BottomNavigationScreen());
        return userData.value;
      } else if (response.statusCode == 429) {
        customSnackbar(
          "ERROR".tr,
          response.data['message'].toString(),
          AppColor.negativeDark,
        );
        return userData.value;
      } else {
        String message = response.data['errors']['validation'];
        signInLoader.value = false;
        customSnackbar("ERROR".tr, message, AppColor.negativeDark);
        return userData.value;
      }
    } catch (e) {
      signInLoader.value = false;
      return userData.value;
    }
  }

  Future phoneVerify(phoneNumber) async {
    signUpLoader.value = true;
    update();
    try {
      Server()
          .postRequest(
            endpoint: ApiList.sendOtp,
            body: {
              'phone': phoneNumber,
              'code': profileController.callingCode.toString(),
            },
          )
          .then((response) {
            if (response != null && response.statusCode == 200) {
              final jsonResponse = response.data;
              customSnackbar(
                "SUCCESS".tr,
                jsonResponse["message"].toString(),
                AppColor.positiveDark,
              );

              signUpLoader.value = false;
              update();
            } else if (response.statusCode == 422) {
              final jsonResponse = response.data;
              customSnackbar(
                "ERROR".tr,
                jsonResponse["message"].toString(),
                AppColor.negativeDark,
              );
              signUpLoader.value = false;
              update();
            } else if (response.statusCode == 429) {
              customSnackbar(
                "ERROR".tr,
                response.data['message'].toString(),
                AppColor.negativeDark,
              );
              signUpLoader.value = false;
              update();
            } else {
              final jsonResponse = json.decode(response.data);
              customSnackbar(
                "ERROR".tr,
                jsonResponse["message"].toString(),
                AppColor.negativeDark,
              );
              signUpLoader.value = false;
              update();
            }
          });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future guestPhoneVerify(phoneNumber) async {
    signUpLoader.value = true;
    update();
    try {
      Server()
          .postRequest(
            endpoint: ApiList.sendGuestOtp,
            body: {
              'phone': phoneNumber,
              'code': profileController.callingCode.toString(),
            },
          )
          .then((response) {
            if (response != null && response.statusCode == 200) {
              final jsonResponse = response.data;

              if (profileController.settingModel.data!.sitePhoneVerification
                      .toString() ==
                  '5') {
                customSnackbar(
                  "SUCCESS".tr,
                  jsonResponse["message"].toString(),
                  AppColor.positiveDark,
                );
                Get.to(
                  () => GuestVerifyScreen(
                    callingCode: profileController.callingCode.value,
                    phoneNumber: phoneNumber,
                  ),
                );
              } else if (profileController
                      .settingModel
                      .data!
                      .sitePhoneVerification
                      .toString() ==
                  '10') {
                guestVerifyOTP(phoneNumber, '0000');
              }
              signUpLoader.value = false;
              update();
            } else if (response.statusCode == 422) {
              final jsonResponse = response.data;
              customSnackbar(
                "ERROR".tr,
                jsonResponse["message"].toString(),
                AppColor.negativeDark,
              );
              signUpLoader.value = false;
              update();
            } else if (response.statusCode == 429) {
              final jsonResponse = response.data;
              customSnackbar(
                "ERROR".tr,
                jsonResponse["message"].toString(),
                AppColor.negativeDark,
              );
              signUpLoader.value = false;
              update();
            } else {
              final jsonResponse = response.data;
              customSnackbar(
                "ERROR".tr,
                jsonResponse["message"].toString(),
                AppColor.negativeDark,
              );
              signUpLoader.value = false;
              update();
            }
          });
    } catch (e) {
      signUpLoader.value = false;

      debugPrint(e.toString());
    }
  }

  Future<void> resendOTP(phoneNumber) async {
    verifyOTPLoader.value = true;
    update();
    try {
      Server()
          .postRequest(
            endpoint: ApiList.signupWithPhone,
            body: {
              'phone': phoneNumber,
              'code': profileController.callingCode.toString(),
            },
          )
          .then((response) {
            if (response != null && response.statusCode == 200) {
              verifyOTPLoader.value = false;
              final jsonResponse = response.data;
              customSnackbar(
                "SUCCESS".tr,
                jsonResponse["message"].toString(),
                AppColor.positiveDark,
              );
              verifyOTPLoader.value = false;

              update();
            } else if (response.statusCode == 422) {
              final jsonResponse = response.data;
              customSnackbar(
                "ERROR".tr,
                jsonResponse["message"].toString(),
                AppColor.negativeDark,
              );
              verifyOTPLoader.value = false;
              update();
            } else if (response.statusCode == 429) {
              final jsonResponse = response.data;
              customSnackbar(
                "ERROR".tr,
                jsonResponse["message"].toString(),
                AppColor.negativeDark,
              );
              verifyOTPLoader.value = false;
              update();
            } else {
              final jsonResponse = json.decode(response.data);
              customSnackbar(
                "ERROR".tr,
                jsonResponse["message"].toString(),
                AppColor.negativeDark,
              );
              verifyOTPLoader.value = false;
              update();
            }
          });
    } catch (e) {
      verifyOTPLoader.value = false;

      debugPrint(e.toString());
    }
  }

  Future verifyOTP(phoneNumber, token) async {
    signupOTPLoader.value = true;
    try {
      Server()
          .postRequest(
            endpoint: ApiList.verifyOtp,
            body: {
              'phone': phoneNumber,
              'code': profileController.callingCode.toString(),
              'token': token,
            },
          )
          .then((response) {
            if (response.statusCode == 200 || response.statusCode == 201) {
              final jsonResponse = response.data;
              customSnackbar(
                "SUCCESS".tr,
                jsonResponse["message"].toString(),
                AppColor.positiveDark,
              );
              signupOTPLoader.value = false;
              Get.to(() => const RegistrationScreen());
            } else if (response.statusCode == 429) {
              final jsonResponse = response.data;
              customSnackbar(
                "ERROR".tr,
                jsonResponse["message"].toString(),
                AppColor.negativeDark,
              );
              signupOTPLoader.value = false;
              update();
            } else {
              final jsonResponse = response.data;
              customSnackbar(
                "ERROR".tr,
                jsonResponse["message"].toString(),
                AppColor.negativeDark,
              );
              signupOTPLoader.value = false;
              update();
            }
          });
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      signupOTPLoader.value = false;
    }
  }

  Future guestVerifyOTP(phoneNumber, token) async {
    verifyOTPLoader.value = true;
    update();
    try {
      Server()
          .postRequest(
            endpoint: ApiList.verifyGuestOtp,
            body: {
              'phone': phoneNumber,
              'code': profileController.callingCode.toString(),
              'token': token,
            },
          )
          .then((response) {
            if (response != null && response.statusCode == 201) {
              verifyOTPLoader.value = false;
              final jsonResponse = response.data;
              customSnackbar(
                "SUCCESS".tr,
                jsonResponse["message"].toString(),
                AppColor.positiveDark,
              );
              box.write("token", "Bearer ${jsonResponse["token"].toString()}");
              box.write("isLoggedIn", true);
              guestOTPTextController.clear();
              guestphoneTextController.clear();
              final navController = Get.put(NavbarController());
              navController.changePage(0);
              Get.offAll(() => const BottomNavigationScreen());
              final profileController = Get.put(ProfileController());
              profileController.getProfile();
              update();
            } else if (response.statusCode == 422) {
              final jsonResponse = response.data;
              customSnackbar(
                "ERROR".tr,
                jsonResponse["message"].toString(),
                AppColor.negativeDark,
              );
              verifyOTPLoader.value = false;
              update();
            } else if (response.statusCode == 429) {
              final jsonResponse = response.data;
              customSnackbar(
                "ERROR".tr,
                jsonResponse["message"].toString(),
                AppColor.negativeDark,
              );
              verifyOTPLoader.value = false;
              update();
            } else {
              final jsonResponse = json.decode(response.data);
              customSnackbar(
                "ERROR".tr,
                jsonResponse["message"].toString(),
                AppColor.negativeDark,
              );
              verifyOTPLoader.value = false;
              update();
            }
          });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<bool> singupPhone({required String phone}) async {
    signupPhoneLoader(true);
    final response = await Server().postRequest(
      endpoint: ApiList.signupWithPhone,
      body: {'phone': phone, 'code': profileController.callingCode.toString()},
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      signupPhoneLoader(false);
      if (profileController.settingModel.data?.sitePhoneVerification
              .toString() ==
          '5') {
        String message = response.data['message'];
        customSnackbar("SUCCESS".tr, message, AppColor.green);
        Get.to(
          () => VerifyScreen(
            callingCode: Get.find<ProfileController>().callingCode.value,
            phoneNumber: regPhoneTextController.text,
          ),
        );
      } else {
        Get.to(() => RegistrationScreen());
      }

      return true;
    } else if (response.statusCode == 429) {
      String message = response.data['message'];
      customSnackbar("ERROR".tr, message, AppColor.negativeDark);
      signupPhoneLoader(false);

      return false;
    } else {
      String message = response.data['message'];
      customSnackbar("ERROR".tr, message, AppColor.negativeDark);
      signupPhoneLoader(false);

      return false;
    }
  }

  Future signupWithPhone({
    firstName,
    lastName,
    email,
    password,
    phoneNumber,
    termsAndCondition,
  }) async {
    signUpLoader.value = true;
    update();
    try {
      Server()
          .postRequest(
            endpoint: ApiList.signup,
            body: {
              'first_name': firstName,
              'last_name': lastName,
              'email': email,
              'phone': phoneNumber,
              'password': password,
              'country_code': profileController.callingCode.toString(),
              'token': regOTPTextController.text,
              "terms_and_conditions": termsAndCondition,
            },
          )
          .then((response) async {
            if (response != null && response.statusCode == 201) {
              signUpLoader.value = false;
              final jsonResponse = response.data;
              otpController.clear;
              customSnackbar(
                "SUCCESS".tr,
                jsonResponse["message"].toString(),
                AppColor.positiveDark,
              );

              String email = emailController.text;
              String password = passwordController.text;

              await userLogin(email: email, password: password);
              firstNameController.clear();
              lastNameController.clear();
              emailController.clear();
              phoneController.clear();
              passwordController.clear();
              guestOTPTextController.clear();
              guestphoneTextController.clear();
              regOTPTextController.clear();
              regPhoneTextController.clear();

              final navController = Get.put(NavbarController());
              navController.changePage(0);
              Get.offAll(() => const BottomNavigationScreen());
              update();
            } else if (response.statusCode == 422) {
              final jsonResponse = response.data;
              customSnackbar(
                "ERROR".tr,
                jsonResponse["message"].toString(),
                AppColor.negativeDark,
              );
              signUpLoader.value = false;
              update();
            } else if (response.statusCode == 429) {
              final jsonResponse = response.data;
              customSnackbar(
                "ERROR".tr,
                jsonResponse["message"].toString(),
                AppColor.negativeDark,
              );
              signUpLoader.value = false;
              update();
            } else {
              final jsonResponse = json.decode(response.data);
              customSnackbar(
                "ERROR".tr,
                jsonResponse["message"].toString(),
                AppColor.negativeDark,
              );
              signUpLoader.value = false;
              update();
            }
          });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  forgotPassword({required String email}) async {
    forgotLoader(true);
    try {
      final response = await Server().postRequest(
        endpoint: ApiList.forgotPassword,
        body: {"email": email},
      );

      if (response.statusCode == 200) {
        forgotLoader(false);

        if (profileController.settingModel.data!.siteEmailVerification
                .toString() ==
            '5') {
          customSnackbar(
            "SUCCESS".tr,
            response.data["message"].toString().tr,
            AppColor.positiveDark,
          );
          Get.to(() => ForgotVerifyScreen(email: email));
        } else {
          Get.to(() => CreateNewPasswordScreen(email: email));
        }
      } else if (response.statusCode == 429) {
        forgotLoader(false);
        customSnackbar(
          "ERROR".tr,
          response.data["message"].toString().tr,
          AppColor.negativeDark,
        );
      } else {
        forgotLoader(false);
        customSnackbar(
          "ERROR".tr,
          response.data["errors"]['email'][0].toString().tr,
          AppColor.negativeDark,
        );
      }
    } catch (e) {
      forgotLoader(false);
      customSnackbar("ERROR".tr, e.toString(), AppColor.negativeDark);
    }
  }

  resendOTPforgotPassword({required String email}) async {
    forgotLoader(true);
    try {
      final response = await Server().postRequest(
        endpoint: ApiList.forgotPassword,
        body: {"email": email},
      );

      if (response.statusCode == 200) {
        forgotLoader(false);
        customSnackbar(
          "SUCCESS".tr,
          response.data["message"].toString().tr,
          AppColor.positiveDark,
        );
      } else if (response.statusCode == 429) {
        forgotLoader(false);
        customSnackbar(
          "ERROR".tr,
          response.data["message"].toString().tr,
          AppColor.negativeDark,
        );
      } else {
        forgotLoader(false);
        customSnackbar(
          "ERROR".tr,
          response.data["errors"]['email'][0].toString().tr,
          AppColor.negativeDark,
        );
      }
    } catch (e) {
      forgotLoader(false);
      customSnackbar("ERROR".tr, e.toString(), AppColor.negativeDark);
    }
  }

  Future verifyForgotPasswordOTP({email, code}) async {
    forgotLoader.value = true;
    update();
    try {
      Server()
          .postRequest(
            endpoint: ApiList.verifyForgotPasswordOTP,
            body: {'email': email, 'code': code},
          )
          .then((response) {
            if (response != null && response.statusCode == 200) {
              forgotLoader.value = false;
              final jsonResponse = response.data;

              customSnackbar(
                "SUCCESS".tr,
                jsonResponse["message"].toString(),
                AppColor.positiveDark,
              );
              Get.to(() => CreateNewPasswordScreen(email: email));
              update();
            } else if (response.statusCode == 422) {
              customSnackbar(
                "ERROR".tr,
                response.data["errors"]['code'][0].toString().tr,
                AppColor.negativeDark,
              );
              forgotLoader.value = false;
              update();
            } else if (response.statusCode == 429) {
              customSnackbar(
                "ERROR".tr,
                response.data["message"].toString().tr,
                AppColor.negativeDark,
              );
              forgotLoader.value = false;
              update();
            } else {
              customSnackbar(
                "ERROR".tr,
                response.data["errors"]['code'][0].toString().tr,
                AppColor.negativeDark,
              );
              forgotLoader.value = false;
              update();
            }
          });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future resetPassword({email, password, confirmPassword, token}) async {
    resetPasswordLoader.value = true;
    update();
    try {
      final jsonBody = {
        'email': email,
        'password': password,
        'confirm_password': confirmPassword,
        'token': token,
      };

      Server()
          .postRequest(endpoint: ApiList.resetPassword, body: jsonBody)
          .then((response) {
            if (response != null && response.statusCode == 200) {
              resetPasswordLoader.value = false;
              final jsonResponse = response.data;
              customSnackbar(
                "SUCCESS".tr,
                jsonResponse["message"].toString(),
                AppColor.positiveDark,
              );

              userLogin(email: email, password: password, fromReset: true);
              emailController.clear();
              passwordController.clear();
              otpController.clear();
              box.write("token", "Bearer ${jsonResponse["token"].toString()}");
              box.write("isLoggedIn", true);
              otpController.clear();
              phoneController.clear();
              final navController = Get.put(NavbarController());
              navController.changePage(0);
              Get.offAll(() => const BottomNavigationScreen());
              update();
            } else if (response.statusCode == 422) {
              customSnackbar(
                "ERROR".tr,
                response.data["errors"]['confirm_password'][0].toString().tr,
                AppColor.negativeDark,
              );
              resetPasswordLoader.value = false;
              update();
            } else if (response.statusCode == 429) {
              customSnackbar(
                "ERROR".tr,
                response.data["message"].toString().tr,
                AppColor.negativeDark,
              );
              resetPasswordLoader.value = false;
              update();
            } else {
              customSnackbar(
                "ERROR".tr,
                response.data["errors"]['confirm_password'][0].toString().tr,
                AppColor.negativeDark,
              );
              resetPasswordLoader.value = false;
              update();
            }
          });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  logout() async {
    logoutLoader(true);
    var response = await authRepo.logout();
    if (response.statusCode == 200) {
      logoutLoader(false);
      box.remove("token");
      box.write("isLoggedIn", false);
      customSnackbar(
        "SUCCESS".tr,
        "Logout is successful.",
        AppColor.positiveDark,
      );
    } else {
      logoutLoader(false);
    }
  }

  Future postDeviceToken(token) async {
    update();
    Map<String, dynamic> body = {'token': token};
    try {
      Server()
          .postRequestWithToken(endpoint: ApiList.postDeviceToken, body: body)
          .then((response) {
            if (response != null && response.statusCode == 200) {
              update();
            } else {
              update();
            }
          });
    } catch (e) {
      debugPrint(e.toString());
      update();
    }
    update();
  }

  @override
  void onInit() {
    if (box.read("isLoggedIn") == null) {
      box.write("isLoggedIn", false);
    }
    super.onInit();
  }
}
