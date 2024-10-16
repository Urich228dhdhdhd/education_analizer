import 'package:education_analizer/controlles/auth_controller.dart';
import 'package:education_analizer/controlles/user_page_controller.dart';
import 'package:get/get.dart';

class UserBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
        () => UserPageController(authController: Get.find<AuthController>()));
  }
}
