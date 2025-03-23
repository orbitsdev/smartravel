import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smarttravel/pages/device_registration_page.dart';
import 'package:smarttravel/pages/location_page.dart';
import 'package:smarttravel/pages/render_page.dart';
import 'package:smarttravel/plugins/getx/app_binding.dart';
import 'package:smarttravel/plugins/getx/controller/device_controller.dart';
import 'package:smarttravel/plugins/getx/middleware/device_middleware.dart';
import 'package:smarttravel/plugins/sharepreference/shared_preferences_manager.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  AppBinding().dependencies();

  runApp(const SmartTravelApp());
}

class SmartTravelApp extends StatefulWidget {
  const SmartTravelApp({Key? key}) : super(key: key);

  @override
  _SmartTravelAppState createState() => _SmartTravelAppState();
}

class _SmartTravelAppState extends State<SmartTravelApp> {
  @override
  void initState() {
      initialzie();
    super.initState();
  }

  Future<void> initialzie () async {
     await SharedPreferencesManager.init(); // ✅ This makes prefs ready
    final deviceController = Get.find<DeviceController>();
  await deviceController.checkDeviceFromApi(); // ✅ stores 'is_registered'
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textSelectionTheme: TextSelectionThemeData(
      selectionHandleColor: Color(0xfffa1b1b),
      cursorColor: Color(0xfffa1b1b),
    ),
     buttonTheme: ButtonThemeData(
      buttonColor:Color(0xfffa1b1b),
      
    ),
     textTheme:  GoogleFonts.robotoTextTheme().copyWith(
      titleLarge:  GoogleFonts.robotoTextTheme().titleLarge!.copyWith(
        
      ),
      titleMedium:  GoogleFonts.robotoTextTheme().titleMedium!.copyWith(
        
      
      ),
      titleSmall:  GoogleFonts.robotoTextTheme().titleSmall!.copyWith(
        
      ),
      bodyLarge:  GoogleFonts.robotoTextTheme().bodyLarge!.copyWith(      
        
      ),
      bodyMedium:  GoogleFonts.robotoTextTheme().bodyMedium!.copyWith(
        
        
      ),
      bodySmall:  GoogleFonts.robotoTextTheme().bodySmall!.copyWith(
        
      
      ),
    ),
        useMaterial3: true, colorSchemeSeed: Color(0xfffa1b1b)),
      getPages: [
        GetPage(name: '/', page: () => DeviceRegistrationPage()),
        // GetPage(name: '/', page: () => RenderPage()),
      
        GetPage(
          name: '/location',
          page: () => const LocationPage(),
          middlewares: [DeviceCheckMiddleware()],
        ),
        GetPage(name: '/register', page: () => const DeviceRegistrationPage()),
      ],
    );
  }
}
