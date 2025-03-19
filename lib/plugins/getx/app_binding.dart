import 'package:get/get.dart';
import 'package:smarttravel/plugins/getx/controller/location_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    
  Get.put<LocationController>(LocationController(), permanent: true);
    // TODO: implement dependencies 
    
  }

}