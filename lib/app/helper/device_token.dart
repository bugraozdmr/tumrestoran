import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../features/auth/controller/auth_controller.dart';

class DeviceToken {
  AuthController controller = Get.put(AuthController());
  Future<String?> getDeviceToken() async {
    String? deviceToken = '@';
    try {
      deviceToken = await FirebaseMessaging.instance.getToken();
    } catch (e) {
      debugPrint(e.toString());
    }
    if (deviceToken != null) {
      controller.postDeviceToken(deviceToken);
    }
    return deviceToken;
  }
}
