import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smarttravel/plugins/getx/controller/device_controller.dart';
import 'package:smarttravel/plugins/sharepreference/shared_preferences_manager.dart';

class NotRegisteredDeviceMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
     final deviceController = Get.find<DeviceController>();

    if (!deviceController.isRegistered.value) {
       return const RouteSettings(name: '/register');
    }


    return null;
  }
}

