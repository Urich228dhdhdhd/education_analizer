import 'package:education_analizer/controlles/auth_controller.dart';
import 'package:education_analizer/controlles/subject_page_controller.dart';
import 'package:education_analizer/repository/subject_repository.dart';
import 'package:get/get.dart';

class SubjectBildings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SubjectRepository>(() => SubjectRepository());
    Get.lazyPut<SubjectPageController>(() => SubjectPageController(
        authController: Get.find<AuthController>(),
        subjectRepository: Get.find<SubjectRepository>()));
  }
}
