import 'package:education_analizer/controlles/auth_controller.dart';
import 'package:education_analizer/controlles/main_page_controller.dart';
import 'package:education_analizer/repository/group_repository.dart';
import 'package:education_analizer/repository/report_repository.dart';
import 'package:education_analizer/repository/user_repository.dart';
import 'package:get/get.dart';

class MainBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
    Get.lazyPut<GroupRepository>(() => GroupRepository());
    Get.lazyPut<UserRepository>(() => UserRepository());
    Get.lazyPut<ReportRepository>(() => ReportRepository());

    Get.lazyPut<MainPageController>(() => MainPageController(
          reportRepository: Get.find<ReportRepository>(),
          userRepository: Get.find<UserRepository>(),
          groupRepository: Get.find<GroupRepository>(),
          authController: Get.find<AuthController>(),
        ));
  }
}
