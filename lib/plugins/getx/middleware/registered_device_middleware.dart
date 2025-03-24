import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:smarttravel/plugins/getx/controller/device_controller.dart';
import 'package:smarttravel/plugins/sharepreference/shared_preferences_manager.dart';

class RegisteredDeviceMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final deviceController = Get.find<DeviceController>();
    var logger = Logger();
    logger.d(deviceController.isRegistered.value);
    if (deviceController.isRegistered.value) {
      return const RouteSettings(name: '/location');
    }

    return null;
  }
}
