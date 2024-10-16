import 'package:education_analizer/controlles/auth_controller.dart';
import 'package:education_analizer/controlles/performance_page_controller.dart';
import 'package:get/get.dart';

class PerformanceBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() =>
        PerformancePageController(authController: Get.find<AuthController>()));
  }
}
