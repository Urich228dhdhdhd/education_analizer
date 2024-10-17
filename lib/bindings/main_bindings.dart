import 'package:education_analizer/controlles/auth_controller.dart';
import 'package:education_analizer/controlles/main_page_controller.dart';
import 'package:education_analizer/repository/group_repository.dart';
import 'package:get/get.dart';

class MainBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
    Get.lazyPut<GroupRepository>(() => GroupRepository());

    Get.lazyPut<MainPageController>(() => MainPageController(
          Get.find<GroupRepository>(),
          authController: Get.find<AuthController>(),
        ));
  }
}
