import 'package:education_analizer/controlles/archive_controller.dart';
import 'package:education_analizer/controlles/auth_controller.dart';
import 'package:education_analizer/repository/group_repository.dart';
import 'package:get/get.dart';

class ArchiveBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
    Get.lazyPut<GroupRepository>(() => GroupRepository());
    Get.lazyPut<ArchiveController>(() => ArchiveController(
        authController: Get.find<AuthController>(),
        groupRepository: Get.find<GroupRepository>()));
  }
}
