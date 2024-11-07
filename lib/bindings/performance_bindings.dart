import 'package:education_analizer/controlles/auth_controller.dart';
import 'package:education_analizer/controlles/performance_page_controller.dart';
import 'package:education_analizer/repository/group_repository.dart';
import 'package:education_analizer/repository/listofsubject_repository.dart';
import 'package:education_analizer/repository/mark_repisitory.dart';
import 'package:education_analizer/repository/semester_repository.dart';
import 'package:education_analizer/repository/student_repository.dart';
import 'package:education_analizer/repository/subject_repository.dart';
import 'package:get/get.dart';

class PerformanceBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GroupRepository>(() => GroupRepository());
    Get.lazyPut<SubjectRepository>(() => SubjectRepository());
    Get.lazyPut<ListofsubjectRepository>(() => ListofsubjectRepository());
    Get.lazyPut<StudentRepository>(() => StudentRepository());
    Get.lazyPut<MarkRepository>(() => MarkRepository());
    Get.lazyPut<SemesterRepository>(() => SemesterRepository());

    Get.lazyPut(() => PerformancePageController(
        semesterRepository: Get.find<SemesterRepository>(),
        markRepository: Get.find<MarkRepository>(),
        studentRepository: Get.find<StudentRepository>(),
        authController: Get.find<AuthController>(),
        listofsubjectRepository: Get.find<ListofsubjectRepository>(),
        groupRepository: Get.find<GroupRepository>()));
  }
}
