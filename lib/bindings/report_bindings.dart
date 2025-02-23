import 'package:education_analizer/controlles/auth_controller.dart';
import 'package:education_analizer/controlles/report_page_controller.dart';
import 'package:education_analizer/repository/absence_repository.dart';
import 'package:education_analizer/repository/group_repository.dart';
import 'package:education_analizer/repository/listofsubject_repository.dart';
import 'package:education_analizer/repository/report_repository.dart';
import 'package:education_analizer/repository/semester_repository.dart';
import 'package:education_analizer/repository/subject_repository.dart';
import 'package:get/get.dart';

class ReportBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
    Get.lazyPut<GroupRepository>(() => GroupRepository());
    Get.lazyPut<SemesterRepository>(() => SemesterRepository());
    Get.lazyPut<AbsenceRepository>(() => AbsenceRepository());
    Get.lazyPut<ListofsubjectRepository>(() => ListofsubjectRepository());
    Get.lazyPut<SubjectRepository>(() => SubjectRepository());
    Get.lazyPut<ReportRepository>(() => ReportRepository());
    Get.lazyPut<ReportPageController>(() => ReportPageController(
        reportRepository: Get.find<ReportRepository>(),
        subjectRepository: Get.find<SubjectRepository>(),
        listofsubjectRepository: Get.find<ListofsubjectRepository>(),
        semesterRepository: Get.find<SemesterRepository>(),
        authController: Get.find<AuthController>(),
        groupRepository: Get.find<GroupRepository>(),
        absenceRepository: Get.find<AbsenceRepository>()));
  }
}
