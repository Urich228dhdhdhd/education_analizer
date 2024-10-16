import 'package:education_analizer/controlles/auth_controller.dart';
import 'package:education_analizer/controlles/login_page_controller.dart';
import 'package:get/get.dart';

class LoginBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
        () => LoginPageController(authController: Get.find<AuthController>()));
  }
}
