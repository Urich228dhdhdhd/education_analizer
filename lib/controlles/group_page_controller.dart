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
      int id = authController.id.value; // Получаем id пользователя
      String role = authController.role.value; // Получаем роль пользователя
      var result = await groupRepository.getGroupByRole(id: id, role: role);

      groups.value = result; // Обновляем список групп
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
