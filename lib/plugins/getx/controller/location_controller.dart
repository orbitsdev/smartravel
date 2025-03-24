// 🔄 Updated: location_controller.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:smarttravel/components/modal.dart';
import 'package:smarttravel/plugins/dio/api_service.dart';
import 'package:smarttravel/plugins/getx/controller/device_controller.dart';

class LocationController extends GetxController {
  Rx<LatLng?> currentPosition = Rx<LatLng?>(null);
  GoogleMapController? mapController;
  RxBool isPermissionGranted = false.obs;
  RxBool isLocationDenied = false.obs;
  StreamSubscription<Position>? _locationSubscription;

  Future<void> checkAndRequestPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      isPermissionGranted.value = true;
      isLocationDenied.value = false;
      _getCurrentLocation();
      _listenToLocationUpdates();
    } else {
      isLocationDenied.value = true;
      Get.snackbar(
        "Permission Required",
        "Please allow location access to use this feature.",
      );
    }
  }

  Future<void> _getCurrentLocation() async {
    Modal.showLoading();

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar("Location Error", "Please enable location services.");
      Modal.hideLoading();
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );

    currentPosition.value = LatLng(position.latitude, position.longitude);

    mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(currentPosition.value!, 17.0),
    );

    await Future.delayed(const Duration(milliseconds: 500));
    Modal.hideLoading();
  }

  void _listenToLocationUpdates() {
    _locationSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 5,
      ),
    ).listen((Position position) async {
      currentPosition.value = LatLng(position.latitude, position.longitude);

      if (mapController != null) {
        mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(currentPosition.value!, 17.0),
        );
      }

      // 🔄 Send to API
      final deviceController = Get.find<DeviceController>();
      final deviceData = deviceController.deviceData;
      final deviceId = deviceData['androidId'] ?? deviceData['id'];

      if (deviceId != null) {
        final payload = {
          "latitude": position.latitude,
          "longitude": position.longitude,
          "device_mac": deviceId,
        };

        final result = await ApiService.post("location/update.php", payload);
        result.fold(
          (failure) => debugPrint("Location update failed: \${failure.message}"),
          (response) => debugPrint("Location updated!"),
        );
      }

      update();
    });
  }

  void stopListeningToLocationUpdates() {
    _locationSubscription?.cancel();
    _locationSubscription = null;
  }
}
