import 'package:phone_form_field/phone_form_field.dart';

IsoCode getIsoCodeFromString(String code) {
  return IsoCode.values.firstWhere(
    (element) => element.name.toUpperCase() == code.toUpperCase(),
    orElse: () => IsoCode.BD, // fallback
  );
}
