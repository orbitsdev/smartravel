
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fpdart/fpdart.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:logger/logger.dart';
import 'package:smarttravel/plugins/dio/api_service.dart';
import 'package:smarttravel/plugins/dio/failure.dart';
import 'package:smarttravel/plugins/sharepreference/shared_preferences_manager.dart';

class DeviceController extends GetxController {
  static DeviceController get controller => Get.find();

  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> deviceData = <String, dynamic>{};
  RxBool isSubmitting = false.obs;

    var logger = Logger();



  Future<void> getDeviceInfo() async {
    try {
      if (defaultTargetPlatform == TargetPlatform.android) {
        deviceData = readAndroidBuildData(await deviceInfoPlugin.androidInfo);
      } else {
        deviceData = <String, dynamic>{};
      }
    } on PlatformException {
      deviceData = <String, dynamic>{};
    }
  }

  Future<Map<String, dynamic>> deviceInfo() async {
    return deviceData = readAndroidBuildData(await deviceInfoPlugin.androidInfo);
  }

  Map<String, dynamic> readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'systemFeatures': build.systemFeatures,
      'serialNumber': build.serialNumber,
      'isLowRamDevice': build.isLowRamDevice,
      'androidId': build.id,
    };
  }

  Future<bool> checkDeviceFromApi() async {
    await getDeviceInfo();
    final deviceId = deviceData['androidId'];

    if (deviceId == null) return false;

    final result = await ApiService.get('check-device/$deviceId');

    final isRegistered = result.isRight();
    await SharedPreferencesManager.writeBool('is_registered', isRegistered);

    return isRegistered;
  }

  /// Handles device registration submission
 

Future<void> submitDeviceRegistration({required String name}) async {
  isSubmitting.value = true;

  try {
    final deviceData = await deviceInfo();
    final deviceId = deviceData['androidId'] ?? deviceData['id'] ?? 'unknown';
    final model = deviceData['model'] ?? 'Unknown Model';

    final position = await getCurrentPosition();
    if (position == null) {
      logger.e("Location permission denied or GPS is disabled.");
      return;
    }

    // Optional: resolve human-readable location name
    String locationName = "Unknown";
    final apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'];
    if (apiKey != null) {
      final geoUrl =
          "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$apiKey";

      final geoResult = await ApiService.get(geoUrl);
      geoResult.fold(
        (failure) => logger.w("Failed to resolve location name: ${failure.exception?.message}"),
        (response) {
          if (response.statusCode == 200 &&
              response.data['results'] != null &&
              response.data['results'].isNotEmpty) {
            locationName = response.data['results'][0]['formatted_address'];
          }
        },
      );
    }

    final payload = {
      "name": name,
      "latitude": position.latitude,
      "longitude": position.longitude,
      "location_name": locationName,
      "device_mac": deviceId,
      "device_model": model,
    };

    logger.t("Payload: $payload");

    final result = await ApiService.post("location/create.php", payload);

    result.fold(
      (failure) {
        logger.e("Registration failed", error: failure.exception?.message);
      },
      (response) {
        logger.t("Registration success: ${response.data}");
        SharedPreferencesManager.writeBool('is_registered', true);
      },
    );
  } catch (e, stack) {
    logger.e("Unexpected error during device registration", error: e.toString(), stackTrace: stack);
  } finally {
    isSubmitting.value = false;
  }
}



Future<Position?> getCurrentPosition() async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) return null;

  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
    permission = await Geolocator.requestPermission();
    if (permission != LocationPermission.always && permission != LocationPermission.whileInUse) {
      return null;
    }
  }

  return await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );
}


}
