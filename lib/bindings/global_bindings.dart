import 'package:education_analizer/controlles/auth_controller.dart';
import 'package:get/get.dart';

class GlobalBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(AuthController());
  }
}
