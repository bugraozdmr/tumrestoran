import 'package:tumrestoran/app/localization/english.dart';
import 'package:get/get_navigation/src/root/internacionalization.dart';

import 'arabic.dart';
import 'bangla.dart';
import 'turkish.dart';

class Languages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': english,
        'en': english,
        'tr_TR': turkish,
        'tr': turkish,
        'ar_AR': arabic,
        'bn': bangla,
      };
}
