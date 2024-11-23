import 'package:education_analizer/controlles/group_page_controller.dart';
import 'package:education_analizer/controlles/semester_selection_controller.dart';
import 'package:education_analizer/model/list_of_subject.dart';
import 'package:education_analizer/model/subject.dart';
import 'package:education_analizer/repository/group_repository.dart';
import 'package:education_analizer/repository/listofsubject_repository.dart';
import 'package:education_analizer/repository/semester_repository.dart';
import 'package:education_analizer/repository/subject_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GroupDialogPageController extends GetxController {
  final GroupRepository groupRepository;
  final SemesterRepository semesterRepository;

  final GroupPageController groupPageController;
  final SubjectRepository subjectRepository;
  final ListofsubjectRepository listofsubjectRepository;
  final SemesterSelectionController semesterSelectionController;

  var subjects = <Subject>[].obs;
  var filteredSubjects = <Subject>[].obs;
  var listOfSubjects = <ListOfSubject>[].obs;
  var isLoading = false.obs;
  var subjectsByGroupAndSubject = <ListOfSubject>[].obs;
  var groupId = Rx<int?>(null);
  var startYear = Rx<int?>(null);
  var endYear = Rx<int?>(null);

  bool isEditing = false;

  GroupDialogPageController(
    this.groupPageController, {
    required this.semesterRepository,
    required this.semesterSelectionController,
    required this.listofsubjectRepository,
    required this.subjectRepository,
    required this.groupRepository,
  });

  @override
  void onInit() {
    super.onInit();
    fetchAllSubjects();
  }

  Future<void> createNewGroup({
    required String groupName,
    int? curatorId,
  }) async {
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

      resetEditingParameters();
    } catch (e) {
      Get.snackbar(
        "Ошибка",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color.fromRGBO(244, 67, 54, 70),
        colorText: Colors.white,
      );
    }
  }

  Future<void> editGroup({
    required int id,
    required String groupName,
    int? curatorId,
  }) async {
    try {
      final updatedGroup = await groupRepository.updateGroup(
        id: id,
        groupName: groupName,
        curatorId: curatorId,
      );

      groupPageController.findGroupsByRole();

      Get.snackbar(
        'Успех',
        'Группа успешно обновлена: ${updatedGroup['group_name']}',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );

      resetEditingParameters(); // Сброс параметров редактирования
    } catch (e) {
      // Уведомление об ошибке
      Get.snackbar(
        'Ошибка',
        'Не удалось обновить группу: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }
  }

  // Метод для сохранения группы (новой или редактируемой)
  Future<void> saveGroup({
    required String groupName,
    int? id,
    int? curatorId,
  }) async {
    if (isEditing && id != null) {
      await editGroup(id: id, groupName: groupName, curatorId: curatorId);
    } else {
      await createNewGroup(groupName: groupName, curatorId: curatorId);
    }
  }

  void setEditingParameters(int id,
      {required String groupName, int? curatorId}) {
    groupId.value = id;
    isEditing = true;
  }

  void resetEditingParameters() {
    groupId.value = null;
    isEditing = false;
  }

  Future<void> fetchAllSubjects() async {
    try {
      isLoading(true);
      final response = await subjectRepository.getSubjects();

      List<Subject> fetchedSubjects = response
          .map<Subject>((subject) => Subject.fromJson(subject))
          .toList();

      subjects.assignAll(fetchedSubjects);
      // log(subjects.toString());
      filteredSubjects.assignAll(fetchedSubjects);
    } catch (e) {
      Get.snackbar(
        'Ошибка',
        'Не удалось получить предметы: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } finally {
      isLoading(false);
    }
  }

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

  // Получение списка  по ID группы
  Future<List<ListOfSubject>> fetchAllListOfSubjectByGroupId(
      int groupId) async {
    listOfSubjects.clear();
    isLoading.value = true;
    try {
      final response =
          await listofsubjectRepository.getListOfSubjectsByGroupId(groupId);

      List<ListOfSubject> fetchedListOfSubject = response
          .map<ListOfSubject>(
              (listofsubj) => ListOfSubject.fromJson(listofsubj))
          .toList();
      // log(fetchedListOfSubject.toString());
      listOfSubjects.assignAll(fetchedListOfSubject);
      isLoading.value = false;
      return fetchedListOfSubject;
    } catch (e) {
      return [];
    }
  }

  // Новый метод для получения списка предметов по ID группы и предмета
  Future<void> fetchListOfSubjectsByGroupAndSubjectId(
      int groupId, int subjectId) async {
    subjectsByGroupAndSubject.clear(); // Очистка предыдущих данных

    try {
      final response = await listofsubjectRepository
          .getListOfSubjectsBySubjectGroupId(groupId, subjectId);

      subjectsByGroupAndSubject
          .assignAll(response); // Сохраняем в новую переменную
      // log('Полученные предметы по группе $groupId и предмету $subjectId: $subjectsByGroupAndSubject');
    } catch (e) {
      // log(e.toString());
      Get.snackbar(
        'Ошибка',
        'Не удалось получить предметы: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }
  }
}
