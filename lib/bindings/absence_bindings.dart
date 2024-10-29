import 'package:education_analizer/controlles/absence_dialog_controller.dart';
import 'package:education_analizer/controlles/absence_page_controller.dart';
import 'package:education_analizer/controlles/auth_controller.dart';
import 'package:education_analizer/repository/absence_repository.dart';
import 'package:education_analizer/repository/group_repository.dart';
import 'package:education_analizer/repository/student_repository.dart';
import 'package:get/get.dart';

class AbsenceBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GroupRepository>(() => GroupRepository());
    Get.lazyPut<StudentRepository>(() => StudentRepository());
    Get.lazyPut<AbsenceRepository>(() => AbsenceRepository());
    Get.lazyPut<AbsenceDialogController>(() => AbsenceDialogController());
    Get.lazyPut<AbsencePageController>(() => AbsencePageController(
        authController: Get.find<AuthController>(),
        groupRepository: Get.find<GroupRepository>(),
        studentRepository: Get.find<StudentRepository>(),
        absenceRepository: Get.find<AbsenceRepository>()));
  }
}
