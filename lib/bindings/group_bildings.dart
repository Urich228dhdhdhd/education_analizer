import 'package:education_analizer/controlles/auth_controller.dart';
import 'package:education_analizer/controlles/group_page_controller.dart';
import 'package:get/get.dart';

class GroupBildings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
        () => GroupPageController(authController: Get.find<AuthController>()));
  }
}
