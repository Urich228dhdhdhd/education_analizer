import 'package:education_analizer/controlles/auth_controller.dart';
import 'package:education_analizer/controlles/group_dialog_page_controller.dart';
import 'package:education_analizer/controlles/group_page_controller.dart';
import 'package:education_analizer/repository/group_repository.dart';
import 'package:education_analizer/repository/semester_repository.dart';
import 'package:get/get.dart';

class GroupBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
    Get.lazyPut<GroupRepository>(() => GroupRepository());
    Get.lazyPut<SemesterRepository>(() => SemesterRepository());

    Get.lazyPut<GroupPageController>(
      () => GroupPageController(
        Get.find<GroupRepository>(),
        authController: Get.find<AuthController>(),
      ),
    );

    Get.lazyPut<GroupDialogPageController>(() => GroupDialogPageController(
        Get.find<GroupPageController>(),
        groupRepository: Get.find<GroupRepository>(),
        semesterRepository: Get.find<SemesterRepository>()));
  }
}
