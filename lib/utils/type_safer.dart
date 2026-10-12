import 'package:flutter/cupertino.dart';

T? safeParse<T>(
  Map<String, dynamic> json,
  T Function(Map<String, dynamic>) fromJson,
) {
  try {
    return fromJson(json);
  } catch (e, s) {
    debugPrint("❌ JSON parse failed: $e");
    debugPrint("Stacktrace:\n$s");
    return null;
  }
}
