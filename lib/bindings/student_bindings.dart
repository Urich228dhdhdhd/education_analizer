import 'package:education_analizer/controlles/auth_controller.dart';
import 'package:education_analizer/controlles/student_dialog_page_controller.dart';
import 'package:education_analizer/controlles/student_page_controller.dart';
import 'package:education_analizer/repository/group_repository.dart';
import 'package:education_analizer/repository/student_repository.dart';
import 'package:get/get.dart';

class StudentBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
    Get.lazyPut<StudentRepository>(() => StudentRepository());
    Get.lazyPut<GroupRepository>(() => GroupRepository());

    Get.lazyPut<StudentPageController>(() => StudentPageController(
          authController: Get.find<AuthController>(),
          groupRepository: Get.find<GroupRepository>(),
          studentRepository: Get.find<StudentRepository>(),
        ));

    Get.lazyPut<StudentDialogController>(() => StudentDialogController(
          studentPageController: Get.find<StudentPageController>(),
        ));
  }
}
