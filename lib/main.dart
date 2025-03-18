import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smarttravel/pages/location_page.dart';
import 'package:smarttravel/pages/render_page.dart';
import 'package:smarttravel/plugins/getx/app_binding.dart';

Future<void> main() async {
    AppBinding().dependencies();
    runApp(const SmartTravelApp());
}



class SmartTravelApp extends StatefulWidget {
  const SmartTravelApp({ Key? key }) : super(key: key);

  @override
  _SmartTravelAppState createState() => _SmartTravelAppState();
}

class _SmartTravelAppState extends State<SmartTravelApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
       debugShowCheckedModeBanner: false,
        theme: ThemeData(
           useMaterial3: true,
           colorSchemeSeed: Color(0xfffa1b1b),
        ),
        getPages: [
                   GetPage(name: '/', page: () => RenderPage()),
                   GetPage(name: '/location', page: () => LocationPage()),
        ],
    );
  }
}