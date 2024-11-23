import 'dart:developer';

import 'package:education_analizer/controlles/auth_controller.dart';
import 'package:education_analizer/repository/group_repository.dart';
import 'package:get/get.dart';

class GroupPageController extends GetxController {
  final AuthController authController;
  final GroupRepository groupRepository;
  GroupPageController(this.groupRepository, {required this.authController});

  var groups = <Map<String, dynamic>>[].obs;

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

  void refreshGroups() {
    findGroupsByRole();
  }

  @override
  void onInit() {
    super.onInit();
    findGroupsByRole();
  }
}
