import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:smarttravel/plugins/getx/controller/location_controller.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({Key? key}) : super(key: key);

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  final LocationController locationController = Get.find<LocationController>();

  @override
  void initState() {
    super.initState();
    locationController.checkAndRequestPermission(); // ✅ Ask for location permission when page opens
  }

  @override
  void dispose() {
    locationController.stopListeningToLocationUpdates(); // ✅ Stops listening when leaving
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        backgroundColor: const Color(0xfffa1b1b),
        title: const Text("Real-Time Location", style: TextStyle(color: Colors.white)),
      ),
      body: Obx(() {
        // **1️⃣ Show warning if permission is denied**
        if (locationController.isLocationDenied.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.location_off, color: Colors.red, size: 50),
                const SizedBox(height: 10),
                const Text(
                  "Location access is required to show the map.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () {
                    locationController.checkAndRequestPermission(); // ✅ Retry permission
                  },
                  child: const Text("Allow Location Access"),
                ),
              ],
            ),
          );
        }


        if (locationController.currentPosition.value == null) {
          return const Center(child: CircularProgressIndicator());
        }


        return GoogleMap(
          initialCameraPosition: CameraPosition(
            target: locationController.currentPosition.value!,
            zoom: 17.0,
          ),
          onMapCreated: (controller) {
            locationController.mapController = controller;
          },
          markers: {
            Marker(
              markerId: const MarkerId("currentLocation"),
              position: locationController.currentPosition.value!,
              icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueRed, // 🔴 Red marker
              ),
            ),
          },
          myLocationEnabled: true,
        );
      }),
    );
  }
}
