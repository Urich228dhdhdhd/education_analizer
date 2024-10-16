import 'package:education_analizer/controlles/absence_page_controller.dart';
import 'package:education_analizer/controlles/auth_controller.dart';
import 'package:get/get.dart';

class AbsenceBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() =>
        AbsencePageController(authController: Get.find<AuthController>()));
  }
}
