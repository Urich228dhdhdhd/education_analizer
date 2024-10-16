import 'package:education_analizer/controlles/auth_controller.dart';
import 'package:education_analizer/controlles/login_page_controller.dart';
import 'package:education_analizer/repository/user_repository.dart';
import 'package:get/get.dart';

class LoginBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserRepository>(() => UserRepository());
    Get.lazyPut<AuthController>(() => AuthController());

    Get.lazyPut<LoginPageController>(
      () => LoginPageController(
        Get.find<UserRepository>(),
        authController: Get.find<AuthController>(),
      ),
    );
  }
}
