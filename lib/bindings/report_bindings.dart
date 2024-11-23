import 'package:education_analizer/controlles/auth_controller.dart';
import 'package:education_analizer/controlles/report_page_controller.dart';
import 'package:education_analizer/repository/absence_repository.dart';
import 'package:education_analizer/repository/group_repository.dart';
import 'package:get/get.dart';

class ReportBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
    Get.lazyPut<GroupRepository>(() => GroupRepository());
    Get.lazyPut<AbsenceRepository>(() => AbsenceRepository());
    Get.lazyPut<ReportPageController>(() => ReportPageController(
        authController: Get.find<AuthController>(),
        groupRepository: Get.find<GroupRepository>(),
        absenceRepository: Get.find<AbsenceRepository>()));
  }
}
