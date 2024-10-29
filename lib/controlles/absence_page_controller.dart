import 'dart:developer';

import 'package:education_analizer/controlles/auth_controller.dart';
import 'package:education_analizer/model/group.dart';
import 'package:education_analizer/model/student.dart';
import 'package:education_analizer/repository/absence_repository.dart';
import 'package:education_analizer/repository/group_repository.dart';
import 'package:education_analizer/repository/student_repository.dart';
import 'package:get/get.dart';

class AbsencePageController extends GetxController {
  final AuthController authController;
  final GroupRepository groupRepository;
  final StudentRepository studentRepository;
  final AbsenceRepository absenceRepository;

  var dateTime = DateTime.now().obs;
  var groups = <Group>[].obs;
  var students = <Student>[].obs;
  var selectedGroupId = Rxn<int>(null);
  var isLoading = false.obs; // Индикатор загрузки
  @override
  void onInit() async {
    await loadGroups();

    super.onInit();
  }

  AbsencePageController(
      {required this.groupRepository,
      required this.studentRepository,
      required this.absenceRepository,
      required this.authController});

  Future<void> loadGroups() async {
    try {
      // Получаем список карт от репозитория
      List<Map<String, dynamic>> loadedGroupMaps =
          await groupRepository.getGroupByRole(
              id: authController.id.value, role: authController.role.value);

      // Преобразуем каждый Map в объект Group
      List<Group> loadedGroups =
          loadedGroupMaps.map((groupMap) => Group.fromJson(groupMap)).toList();

      // Обновляем список групп
      groups.assignAll(loadedGroups);
      log(groups.map((group) => group.toJson()).toList().toString());
    } catch (e) {
      print("Ошибка загрузки групп: $e");
    }
  }

  Future<void> loadStudents() async {
    if (selectedGroupId.value == null) {
      log("Группа не выбрана, студенты не могут быть загружены.");
      return; // Если группа не выбрана, выходим из метода
    }

    try {
      isLoading(true);
      List<Student> loadedStudents =
          await studentRepository.getStudentsByGroupId(selectedGroupId.value!);
      students.assignAll(loadedStudents); // Обновляем список студентов
      isLoading(false);
    } catch (e) {
      print("Ошибка загрузки студентов: $e");
    }
  }

  void setSelectedGroup(int groupId) {
    selectedGroupId.value = groupId;
    loadStudents();
  }
}
