// lib/pages/webview_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:smarttravel/plugins/getx/controller/web_view_controller.dart';


class WebViewWidget extends StatefulWidget {
  final String url;
  final String title;

  const WebViewWidget({
    Key? key,
    required this.url,
    required this.title,
  }) : super(key: key);

  @override
  State<WebViewWidget> createState() => _WebViewWidgetState();
}

class _WebViewWidgetState extends State<WebViewWidget> {
  final WebViewController webViewController = Get.put(WebViewController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool exit = await webViewController.confirmExit(context);
        return exit;
      },
      child: Scaffold(
       
        body: InAppWebView(
          initialUrlRequest: URLRequest(url: WebUri.uri(Uri.parse(widget.url))),
          onWebViewCreated: (controller) {
            webViewController.webViewController = controller;
          },
          onLoadStop: (controller, url) {
            webViewController.setCurrentUrl(url.toString());
          },
        ),
      ),
    );
  }
}
