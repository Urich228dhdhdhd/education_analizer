import 'package:education_analizer/controlles/auth_controller.dart';
import 'package:education_analizer/controlles/group_dialog_page_controller.dart';
import 'package:education_analizer/controlles/group_page_controller.dart';
import 'package:education_analizer/controlles/semester_selection_controller.dart';
import 'package:education_analizer/repository/group_repository.dart';
import 'package:education_analizer/repository/listofsubject_repository.dart';
import 'package:education_analizer/repository/subject_repository.dart';
import 'package:get/get.dart';

class GroupBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
    Get.lazyPut<GroupRepository>(() => GroupRepository());
    Get.lazyPut<SubjectRepository>(() => SubjectRepository());
    Get.lazyPut<ListofsubjectRepository>(() => ListofsubjectRepository());
    Get.lazyPut<GroupPageController>(
      () => GroupPageController(
        Get.find<GroupRepository>(),
        authController: Get.find<AuthController>(),
      ),
    );

    Get.lazyPut<GroupDialogPageController>(() => GroupDialogPageController(
        Get.find<GroupPageController>(),
        semesterSelectionController: Get.find<SemesterSelectionController>(),
        listofsubjectRepository: Get.find<ListofsubjectRepository>(),
        subjectRepository: Get.find<SubjectRepository>(),
        groupRepository: Get.find<GroupRepository>()));
    Get.lazyPut<SemesterSelectionController>(() => SemesterSelectionController(
        listOfSubjectRepository: Get.find<ListofsubjectRepository>()));
  }
}
