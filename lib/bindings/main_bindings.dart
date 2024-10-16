import 'package:education_analizer/controlles/auth_controller.dart';
import 'package:education_analizer/controlles/main_page_controller.dart';
import 'package:get/get.dart';

class MainBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
        () => MainPageController(authController: Get.find<AuthController>()));
  }
}
