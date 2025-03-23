import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:smarttravel/plugins/sharepreference/shared_preferences_manager.dart';

class DeviceCheckMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    // 🔴 TEST MODE: Force redirect for testing
    final bool isRegistered = false;
 
    print('midlware called---------------------');

    if (!isRegistered) {
      return const RouteSettings(name: '/register');
    }

    return null;
  }
}
