import 'dart:async'; // Required for StreamSubscription
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:smarttravel/components/modal.dart';

class LocationController extends GetxController {
  Rx<LatLng?> currentPosition = Rx<LatLng?>(null); 
  GoogleMapController? mapController;
  RxBool isPermissionGranted = false.obs; 
  RxBool isLocationDenied = false.obs; 
  StreamSubscription<Position>? _locationSubscription; 
  Future<void> checkAndRequestPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
      isPermissionGranted.value = true;
      isLocationDenied.value = false;
      _getCurrentLocation();
      _listenToLocationUpdates();
    } else {
      isLocationDenied.value = true;
      Get.snackbar("Permission Required", "Please allow location access to use this feature.");
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
    ).listen((Position position) {
      currentPosition.value = LatLng(position.latitude, position.longitude);

      if (mapController != null) {
        mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(currentPosition.value!, 17.0),
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
