import 'dart:developer';

import 'package:education_analizer/controlles/auth_controller.dart';
import 'package:education_analizer/model/student.dart';
import 'package:education_analizer/repository/group_repository.dart';
import 'package:education_analizer/repository/student_repository.dart';
import 'package:get/get.dart';

class StudentPageController extends GetxController {
  final AuthController authController;
  final StudentRepository studentRepository;
  final GroupRepository groupRepository;

  var students = <dynamic>[].obs;
  var groups = {}.obs;
  var isLoading = false.obs;

  @override
  void onInit() async {
    await fetchGroups();
    await fetchStudent(); // Загрузка студентов
    super.onInit();
  }

  StudentPageController(
      {required this.groupRepository,
      required this.studentRepository,
      required this.authController});

  Future<void> fetchStudent() async {
    try {
      isLoading(true);
      List<dynamic> fetchedStudents = await studentRepository.getStudentsByRole(
        userId: authController.id.value,
        userRole: authController.role.value,
      );
      students.assignAll(fetchedStudents
          .map((studentJson) => Student.fromJson(studentJson))
          .toList());
      log(students.toString());
    } catch (error) {
      log("Ошибка при получении студентов: $error");
    } finally {
      isLoading(false);
    }
  }

  // Метод для загрузки всех групп
  Future<void> fetchGroups() async {
    try {
      isLoading(true);
      var allGroups = await groupRepository.getGroupByRole(
          id: authController.id.value,
          role: authController.role.value); // Получаем все группы
      for (var group in allGroups) {
        groups[group['id']] =
            group['group_name']; // Кэшируем название группы по её ID
      }
      isLoading(false);
    } catch (e) {
      // Обработка ошибок
    }
  }

  // Получение названия группы по ID
  String? getGroupNameById(int groupId) {
    return groups[groupId] ?? 'Группа не найдена';
  }
}
