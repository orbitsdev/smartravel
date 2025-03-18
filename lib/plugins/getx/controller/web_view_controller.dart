// lib/controllers/webview_controller.dart

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

class WebViewController extends GetxController {
  InAppWebViewController? webViewController;
  RxString currentUrl = ''.obs;
  bool isDisposed = false;

  void setCurrentUrl(String url) {
    if (isDisposed) return;
    currentUrl.value = url;
    update();
  }

  Future<bool> confirmExit(BuildContext context) async {
    if (isDisposed) return false;
    bool canGoBack = await webViewController?.canGoBack() ?? false;
    
    if (canGoBack) {
      webViewController?.goBack();
      return Future.value(false); // Stay on the page
    }

    bool shouldExit = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Exit'),
        content: const Text('Are you sure you want to exit this page?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );
    return shouldExit;
  }

  void closeWebView() {
    if (isDisposed) return;
    currentUrl.value = '';
    update();
    Get.back();
  }

  @override
  void onClose() {
    isDisposed = true;
    super.onClose();
  }
}