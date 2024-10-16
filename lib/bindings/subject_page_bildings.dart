import 'package:education_analizer/controlles/auth_controller.dart';
import 'package:education_analizer/controlles/subject_page_controller.dart';
import 'package:get/get.dart';

class SubjectPageBildings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() =>
        SubjectPageController(authController: Get.find<AuthController>()));
  }
}
