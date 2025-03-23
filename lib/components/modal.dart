import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:smarttravel/plugins/dio/failure.dart';

class Modal {
  static void showLoading({String message = "Preparing map view..."}) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(color: Colors.red), // 🔴 Red loading indicator
              const SizedBox(height: 16),
              Text(message, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ),
      barrierDismissible: true, 
    );
  }

  static void hideLoading() {
    if (Get.isDialogOpen!) {
      Get.back();
    }
  }

   static showToast(
      {String? msg = "Toast Message",
      Color? color,
      Toast? toastLength,
      Color? textColor,
      ToastGravity? gravity}) {
    Fluttertoast.showToast(
        msg: msg as String,
        toastLength: toastLength ?? Toast.LENGTH_SHORT,
        gravity: gravity ?? ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: color ?? Colors.black,
        textColor: textColor ?? Colors.white,
        fontSize: 16.0);
  }

  static void errorDialogMessage({
  String? message = "Something went wrong",
  Failure? failure,
  VoidCallback? onDismiss,
  String buttonText = "OK",
  bool barrierDismissible = false,
}) {
  Get.dialog(
    AlertDialog(
      title: const Text("Error"),
      content: Text(
        failure?.message ?? message!,
        style: const TextStyle(fontSize: 16),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Get.back(); // Close the dialog
            if (onDismiss != null) onDismiss(); // Optional callback
          },
          child: Text(buttonText),
        ),
      ],
    ),
    barrierDismissible: barrierDismissible,
  );
}

}
