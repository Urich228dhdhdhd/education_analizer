import 'dart:developer';

import 'package:education_analizer/controlles/auth_controller.dart';
import 'package:education_analizer/model/student.dart';
import 'package:education_analizer/repository/group_repository.dart';
import 'package:education_analizer/repository/student_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class StudentPageController extends GetxController {
  final AuthController authController;
  final StudentRepository studentRepository;
  final GroupRepository groupRepository;

  var students = <Student>[].obs;
  var filteredStudents = <Student>[].obs;
  var groups = {}.obs;
  TextEditingController searchText = TextEditingController();
  var isLoading = false.obs;

  // @override
  // void onInit() async {
  //   await fetchGroups();
  //   await fetchStudent(); // Загрузка студентов
  //   super.onInit();
  // }

  StudentPageController(
      {required this.groupRepository,
      required this.studentRepository,
      required this.authController});

  // List<dynamic> get filteredStudents {
  //   if (searchText.text.isEmpty) {
  //     return students;
  //   } else {
  //     return students.where((student) {
  //       final firstName = student.firstName.toString().toLowerCase();
  //       final middleName = student.middleName.toString().toLowerCase();
  //       final lastName = student.lastName.toString().toLowerCase();
  //       final groupName =
  //           getGroupNameById(student.groupId)?.toLowerCase() ?? '';

  //       final query = searchText.text.toLowerCase();
  //       return firstName.contains(query) ||
  //           middleName.contains(query) ||
  //           lastName.contains(query) ||
  //           groupName.contains(query);
  //     }).toList();
  //   }
  // }

  void searchStudents(String query) {
    if (query.isEmpty || query == "") {
      filteredStudents
          .assignAll([...students]); // Показать все, если запрос пустой
    } else {
      filteredStudents.assignAll(
        [...students].where((student) {
          final groupName =
              getGroupNameById(student.groupId!)?.toLowerCase() ?? '';
          return (student.firstName
                      ?.toLowerCase()
                      .contains(query.toLowerCase()) ??
                  false) ||
              (student.middleName
                      ?.toLowerCase()
                      .contains(query.toLowerCase()) ??
                  false) ||
              (student.lastName?.toLowerCase().contains(query.toLowerCase()) ??
                  false) ||
              groupName.contains(
                  query.toLowerCase()); // Добавлен поиск по названию группы
        }).toList(),
      );
    }
  }

  Future<void> fetchStudent() async {
    try {
      students.clear();
      isLoading(true);
      students.value = await studentRepository.getStudentsByRole(
        userId: authController.id.value,
        userRole: authController.role.value,
      );
      filteredStudents.assignAll(students);
      if (searchText.text.isNotEmpty) {
        searchStudents(searchText.text);
      }
    } catch (error) {
      log("Ошибка при получении студентов: $error");
    } finally {
      isLoading(false);
    }
  }

  // Метод для загрузки всех групп
  Future<void> fetchGroups() async {
    try {
      groups.clear();
      isLoading(true);
      var allGroups = await groupRepository.getGroupByRole2(
          id: authController.id.value,
          role: authController.role.value); // Получаем все группы
      for (var group in allGroups) {
        if (group.statusGroup == "ARCHIVE") {
          continue;
        }
        groups[group.id] = group.groupName; // Кэшируем название группы по её ID
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
