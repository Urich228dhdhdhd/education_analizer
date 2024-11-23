import 'dart:developer';

import 'package:get/get.dart';
import 'package:education_analizer/repository/group_repository.dart';
import 'package:education_analizer/controlles/auth_controller.dart';

class MainPageController extends GetxController {
  final GroupRepository groupRepository;
  final AuthController authController;

  var groups = <Map<String, dynamic>>[].obs;

  MainPageController(this.groupRepository, {required this.authController});

  void findGroupsByRole() async {
    try {
      int id = authController.id.value;
      String role = authController.role.value;
      var result = await groupRepository.getGroupByRole(id: id, role: role);

      groups.value = result;
    } catch (e) {
      log('Ошибка при получении групп: $e');
    }
  }

  @override
  void onInit() {
    super.onInit();
    findGroupsByRole();
  }
}
