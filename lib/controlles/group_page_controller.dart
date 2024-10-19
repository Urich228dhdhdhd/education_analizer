import 'dart:developer';

import 'package:education_analizer/controlles/auth_controller.dart';
import 'package:education_analizer/repository/group_repository.dart';
import 'package:get/get.dart';

class GroupPageController extends GetxController {
  final AuthController authController;
  final GroupRepository groupRepository;
  GroupPageController(this.groupRepository, {required this.authController});

  // Реактивный список для групп
  var groups = <Map<String, dynamic>>[].obs;

  // Метод для получения групп
  void findGroupsByRole() async {
    try {
      int id = authController.id.value;
      String role = authController.role.value;
      var result = await groupRepository.getGroupByRole(id: id, role: role);

      groups.value = result;
      // log(groups.value.toString());
    } catch (e) {
      log('Ошибка при получении групп: $e');
    }
  }

  // Метод для обновления списка групп
  void refreshGroups() {
    findGroupsByRole(); // Повторно получить группы
  }

  @override
  void onInit() {
    super.onInit();
    findGroupsByRole();
  }
}
