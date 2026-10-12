import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:foodnanny/data/model/country_flag_model.dart';
import 'package:foodnanny/data/model/profile_model.dart';
import 'package:foodnanny/data/model/setting_model.dart';
import 'package:foodnanny/data/repository/profile_repo.dart';
import 'package:foodnanny/data/server/server.dart';
import 'package:foodnanny/main.dart';
import 'package:foodnanny/utils/api_list.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../config/theme/app_color.dart';
import '../../../../data/model/pages_model.dart';
import '../../../../widgets/custom_snackbar.dart';
import '../../bottom_navbar/views/bottom_navigation.dart';
import '../widgets/image_size_checker.dart';

class ProfileController extends GetxController {
  final ProfileRepo _profileRepo = ProfileRepo();
  final profileModel = ProfileModel().obs;

  PageModel pageModelData = PageModel();
  PageData pageData = PageData();
  List<PageData> pageDataList = <PageData>[];

  CountryFlagModel countryFlagModel = CountryFlagModel();
  SettingModel settingModel = SettingModel();

  final fakeInt = RxInt(-1);
  final passChangingLoader = false.obs;
  final updateProfileLoader = false.obs;
  final imageLoader = false.obs;

  final fNameController = TextEditingController();
  final lNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final countryCodeController = TextEditingController();

  final oldPassController = TextEditingController();
  final newPassController = TextEditingController();
  final confirmPassController = TextEditingController();

  final countryCode = 'BDG'.obs;
  final callingCode = '+880'.obs;
  final countryFlag = ''.obs;
  final phoneVerification = '5'.obs;

  final currency = '\$'.obs;
  final currencyPosition = '5'.obs;
  final emailVerification = '5'.obs;

  Future<void> getProfile() async {
    final data = await _profileRepo.getProfile();
    data.fold((error) => null, (data) {
      profileModel.value = data;
      fNameController.text = profileModel.value.data!.firstName.toString();
      lNameController.text = profileModel.value.data!.lastName.toString();
      emailController.text = profileModel.value.data?.email ?? "";
      phoneController.text = profileModel.value.data!.phone.toString();
      countryCodeController.text = profileModel.value.data!.countryCode
          .toString();
      return profileModel.value;
    });
  }

  Future<void> updateProfile({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String countryCode,
  }) async {
    updateProfileLoader(true);
    final data = await _profileRepo.updateProfile(
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
      countryCode: countryCode,
    );
    updateProfileLoader(false);
    data.fold((error) => null, (data) {
      profileModel.value = data;
      return profileModel.value;
    });
  }

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      passChangingLoader(true);
      final response = await Server().putRequestWithToken(
        endPoint: ApiList.changePassword,
        queryParameters: {
          "old_password": oldPassword,
          "password": newPassword,
          "confirm_password": confirmPassword,
        },
      );

      passChangingLoader(false);
      if (response.statusCode == 200) {
        passChangingLoader(false);
        Get.back();
        customSnackbar(
          "SUCCESS".tr,
          'PASSWORD_CHANGED_SUCCESSFULLY!'.tr,
          AppColor.positiveDark,
        );
        oldPassController.clear();
        newPassController.clear();
        confirmPassController.clear();
      } else if (response.statusCode == 422) {
        passChangingLoader(false);
        customSnackbar(
          "ERROR".tr,
          response.data['message'].toString(),
          AppColor.negativeDark,
        );
      } else {
        passChangingLoader(false);
        customSnackbar(
          "ERROR".tr,
          response.data['message'].toString(),
          AppColor.negativeDark,
        );
      }
    } catch (e) {
      passChangingLoader(false);
      customSnackbar(
        "ERROR".tr,
        "SOMETHING_WENT_WRONG!".tr,
        AppColor.negativeDark,
      );
    }
  }

  RxString imagePath = "".obs;
  Future<void> pickImageFromGallery() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      double imageSize = await ImageSize.getImageSize(pickedFile);
      imagePath.value = pickedFile.path;
      if (imageSize > 2) {
        customSnackbar(
          "ERROR".tr,
          "IMAGE_SHOULD_BE_LESS_THAN_2MB".tr,
          AppColor.negativeDark,
        );
      } else {
        updateProfileImage(imagePath.value);
      }
    } else {
      customSnackbar("ERROR".tr, "NO_IMAGE_SELECTED".tr, AppColor.negativeDark);
    }
  }

  updateProfileImage(file) async {
    imageLoader(true);
    update();
    await Server().multipartRequest(ApiList.changeImage, file).then((
      response,
    ) async {
      final responseData = await response.stream.bytesToString();
      if (response != null && response.statusCode == 200) {
        imageLoader(false);
        update();
        getProfile();
        customSnackbar(
          "SUCCESS".tr,
          "PROFILE_IMAGE_SAVED_SUCCESSFULLY".tr,
          AppColor.positiveDark,
        );
        update();
      } else {
        final errorMessage = jsonDecode(responseData)['message'];
        imageLoader(false);
        update();
        customSnackbar(
          "ERROR".tr,
          errorMessage.toString(),
          AppColor.negativeDark,
        );
      }
    });
  }

  Future<PageModel> getPages() async {
    try {
      await Server().getRequest(endPoint: ApiList.pages).then((response) {
        if (response != null && response.statusCode == 200) {
          pageModelData = PageModel.fromJson(response.data);
          return pageModelData;
        }
      });
      return pageModelData;
    } catch (e) {
      debugPrint(e.toString());
    }
    return pageModelData;
  }

  getPageData() async {
    var responsePageData = await getPages();
    if (responsePageData.data != null) {
      pageDataList = responsePageData.data!
          .where((page) => page.status == 5)
          .toList();
      update();
    }
  }

  Future<SettingModel> getSettings() async {
    try {
      await Server().getRequest(endPoint: ApiList.setting).then((response) {
        if (response != null && response.statusCode == 200) {
          settingModel = SettingModel.fromJson(response.data);
          countryCode.value = settingModel.data!.companyCountryCode.toString();
          phoneVerification.value = settingModel.data!.sitePhoneVerification
              .toString();
          emailVerification.value = settingModel.data!.siteEmailVerification
              .toString();
          currency.value = settingModel.data!.siteDefaultCurrencySymbol
              .toString();
          currencyPosition.value = settingModel.data!.siteCurrencyPosition
              .toString();
          box.write(
            "primaryColor",
            settingModel.data!.themePrimaryColor?.replaceAll('#', ''),
          );
          getCountryFlag(countryCode: countryCode.value);
          update();
          return settingModel;
        }
      });
      return settingModel;
    } catch (e) {
      debugPrint(e.toString());
    }
    return settingModel;
  }

  Future<CountryFlagModel> getCountryFlag({required String countryCode}) async {
    try {
      await Server()
          .getRequest(endPoint: '${ApiList.countryFlag}$countryCode')
          .then((response) {
            if (response != null && response.statusCode == 200) {
              countryFlagModel = CountryFlagModel.fromJson(response.data);
              countryFlag.value = countryFlagModel.data!.flagSvg.toString();
              callingCode.value = countryFlagModel.data!.callingCode.toString();
              update();
              return countryFlagModel;
            }
          });
      return countryFlagModel;
    } catch (e) {
      debugPrint(e.toString());
    }
    return countryFlagModel;
  }

  deleteAccount() async {
    updateProfileLoader.value = true;
    Server().postRequestWithToken(endpoint: ApiList.deleteAccount).then((
      response,
    ) {
      if (response != null && response.statusCode == 200) {
        updateProfileLoader.value = false;
        update();

        box.write('isLoggedIn', false);
        box.remove('email');
        box.remove('password');
        box.remove('remember');

        Get.offAll(const BottomNavigationScreen());
        customSnackbar(
          "ACCOUNT".tr,
          "ACCOUNT_DELETED_SUCCESSFULLY".tr,
          AppColor.green,
        );
      } else if (response != null && response.statusCode == 422) {
        final jsonResponse = response.data;
        updateProfileLoader.value = false;
        update();
        String errorMessage = jsonResponse['message'].toString();
        customSnackbar("ERROR".tr, errorMessage, AppColor.rejectedTextColor);
        update();
      }
      updateProfileLoader.value = false;
      update();
    });
    return null;
  }

  @override
  void onInit() {
    if (box.read('isLoggedIn') == true) {
      getProfile();
    }
    getPageData();
    getSettings();
    super.onInit();
  }
}
