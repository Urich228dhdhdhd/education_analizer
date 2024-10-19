import 'dart:developer';

import 'package:education_analizer/controlles/group_page_controller.dart';
import 'package:education_analizer/model/list_of_subject.dart';
import 'package:education_analizer/model/subject.dart';
import 'package:education_analizer/repository/group_repository.dart';
import 'package:education_analizer/repository/listofsubject_repository.dart';
import 'package:education_analizer/repository/subject_repository.dart';
import 'package:get/get.dart';

class GroupDialogPageController extends GetxController {
  final GroupRepository groupRepository;
  final GroupPageController groupPageController;
  final SubjectRepository subjectRepository;
  final ListofsubjectRepository listofsubjectRepository;

  bool isEditing = false; // Флаг редактирования
  int? groupId; // ID группы, если редактируем
  RxList<Subject> subjects = <Subject>[].obs;
  var filteredSubjects = <Subject>[].obs; // Отфильтрованный список предметов
  var listOfSubjects = <ListOfSubject>[].obs; // Список семестров
  // Метод для фильтрации предметов по имени
  void filterSubjects(String query) {
    filteredSubjects.assignAll(
      subjects.where((subject) {
        return subject.subjectNameShort
                ?.toLowerCase()
                .contains(query.toLowerCase()) ??
            false;
      }).toList(),
    );
  }

  GroupDialogPageController(
    this.groupPageController, {
    required this.listofsubjectRepository,
    required this.subjectRepository,
    required this.groupRepository,
  });

  Future<void> createNewGroup(
      {required String groupName, int? curatorId}) async {
    try {
      final newGroup = await groupRepository.createGroup(
        groupName: groupName,
        curatorId: curatorId,
      );

      groupPageController.findGroupsByRole();

      Get.snackbar(
        'Успех',
        'Группа успешно создана: ${newGroup['group_name']}',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );

      resetEditingParameters(); // Сбрасываем параметры редактирования
    } catch (e) {
      Get.snackbar(
        'Ошибка',
        'Не удалось создать группу: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }
  }

  Future<void> editGroup(
      {required int id, required String groupName, int? curatorId}) async {
    try {
      final updatedGroup = await groupRepository.updateGroup(
        id: id, // Используем параметр id напрямую
        groupName: groupName,
        curatorId: curatorId, // Если нужно, раскомментируйте эту строку
      );

      // Обновляем список групп
      groupPageController.findGroupsByRole();

      Get.snackbar(
        'Успех',
        'Группа успешно обновлена: ${updatedGroup['group_name']}',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );

      resetEditingParameters(); // Сбрасываем параметры редактирования
    } catch (e) {
      // Обработка ошибок
      Get.snackbar(
        'Ошибка',
        'Не удалось обновить группу: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }
  }

  Future<void> saveGroup(
      {required String groupName, int? id, int? curatorId}) async {
    if (isEditing && id != null) {
      // Проверяем, что id не null
      await editGroup(id: id, groupName: groupName, curatorId: curatorId);
    } else {
      await createNewGroup(groupName: groupName, curatorId: curatorId);
    }
  }

  void setEditingParameters(int id,
      {required String groupName, int? curatorId}) {
    groupId = id; // Устанавливаем ID группы
    isEditing = true; // Устанавливаем флаг редактирования
    // Здесь можно сохранить название группы и ID куратора, если необходимо
  }

  void resetEditingParameters() {
    groupId = null;
    isEditing = false;
  }

  Future<void> fetchAllSubjects() async {
    try {
      final response = await subjectRepository.getSubjects();

      List<Subject> fetchedSubjects = response
          .map<Subject>((subject) => Subject.fromJson(subject))
          .toList();

      // Обновляем список предметов в контроллере
      subjects.assignAll(fetchedSubjects);
    } catch (e) {
      Get.snackbar(
        'Ошибка',
        'Не удалось получить предметы: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }
  }

  Future<List<ListOfSubject>> fetchAllListOfSubjectByGroupId(
      int groupId) async {
    try {
      final response =
          await listofsubjectRepository.getListOfSubjectsByGroupId(groupId);
      List<ListOfSubject> fetchedListOfSubject = response
          .map<ListOfSubject>(
              (listofsubj) => ListOfSubject.fromJson(listofsubj))
          .toList();
      log(fetchedListOfSubject.toString());
      return fetchedListOfSubject;
    } catch (e) {
      // Get.snackbar(
      //   'Ошибка',
      //   'Не удалось получить список предметов для группы: ${e.toString()}',
      //   snackPosition: SnackPosition.BOTTOM,
      //   duration: const Duration(seconds: 2),
      // );
      return [];
    }
  }
}
