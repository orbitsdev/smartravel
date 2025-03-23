import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smarttravel/components/local_lottie_image.dart';
import 'package:smarttravel/components/modal.dart';
import 'package:smarttravel/plugins/getx/controller/device_controller.dart';
import 'package:smarttravel/plugins/dio/failure.dart';

class DeviceRegistrationPage extends StatefulWidget {
  const DeviceRegistrationPage({Key? key}) : super(key: key);

  @override
  State<DeviceRegistrationPage> createState() => _DeviceRegistrationPageState();
}

class _DeviceRegistrationPageState extends State<DeviceRegistrationPage> {

  final TextEditingController nameController = TextEditingController();
  final DeviceController deviceController = Get.find<DeviceController>();

  Future<void> handleSubmit() async {
    final name = nameController.text.trim();

    if (name.isEmpty) {
      Modal.showToast(msg: "Name is required to proceed.");
      return;
    }

    Modal.showLoading(message: "Registering device...");
    final result = await deviceController.submitDeviceRegistration(name: name);
    Modal.hideLoading();

    // result.match(
    //   (Failure failure) => Modal.errorDialogMessage(failure: failure),
    //   (success) {
    //     Modal.showToast(msg: "Welcome, $name!");
    //     Get.offAllNamed('/location');
    //   },
    // );
  }

  @override
  void initState() {
    super.initState();
    deviceController.getDeviceInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffad0707),
      body: SafeArea(
        child: SizedBox.expand(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      LocalLottieImage(
                        width: 200,
                        height: 200,
                        path: 'assets/images/identification.json',
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Welcome to SmartTravel",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Please enter your name. This helps us personalize your travel experience and track your journey across tourist spots.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 30),
                      TextField(
                        controller: nameController,
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: "Your Name",
                          labelStyle: const TextStyle(color: Colors.black),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),
                      Obx(() {
                        return SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: deviceController.isSubmitting.value
                                ? null
                                : handleSubmit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xfffa1b1b),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              deviceController.isSubmitting.value
                                  ? "Submitting..."
                                  : "Get Started",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
              // 👇 Logo pinned to the bottom
              // Padding(
              //   padding: const EdgeInsets.only(bottom: 16),
              //   child: Image.asset(
              //     'assets/images/logo.png',
              //     width: 80,
              //     height: 80,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
