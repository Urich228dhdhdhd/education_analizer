import 'package:education_analizer/controlles/auth_controller.dart';
import 'package:education_analizer/controlles/student_page_controller.dart';
import 'package:get/get.dart';

class StudentBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() =>
        StudentPageController(authController: Get.find<AuthController>()));
  }
}
