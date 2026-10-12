import 'package:flutter/material.dart';
import 'package:foodnanny/data/server/server.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../utils/api_list.dart';
import '../model/language_model.dart';

class LanguageController extends GetxController {
  final box = GetStorage();
  final selectLanguage = RxInt(-1);

  final languageList = <LanguageData>[].obs;

  @override
  void onInit() {
    getLanguage();
    if (box.read('selectedLanguageValue') == null) {
      box.write('langCode', 'tr');
      box.write('langName', 'TR');
      box.write('selectedLanguageValue', 'Türkçe');
      update();
    }
    super.onInit();
  }

  changeLanguage(String languageCode, String languageName) {
    box.write('langCode', languageCode);
    box.write('langName', languageName);
    Get.updateLocale(Locale(languageCode, languageName));
  }

  Future<List<LanguageData>> getLanguage() async {
    try {
      await Server().getRequestWithToken(endPoint: ApiList.language).then((
        response,
      ) {
        if (response != null && response.statusCode == 200) {
          final data = response.data['data'] as List<dynamic>;

          final langList = data
              .map((lang) => LanguageData.fromJson(lang))
              .toList();

          languageList.value = langList
              .where((lan) => lan.status.toString() == "5")
              .toList();
          return languageList;
        }
      });
      return languageList;
    } catch (e) {
      debugPrint(e.toString());
    }
    return languageList;
  }
}
