import 'dart:developer';

import 'package:education_analizer/controlles/auth_controller.dart';
import 'package:education_analizer/model/group.dart';
import 'package:education_analizer/model/list_of_subject.dart';
import 'package:education_analizer/model/mark.dart';
import 'package:education_analizer/model/student.dart';
import 'package:education_analizer/model/subject.dart';
import 'package:education_analizer/repository/group_repository.dart';
import 'package:education_analizer/repository/listofsubject_repository.dart';
import 'package:education_analizer/repository/mark_repisitory.dart';
import 'package:education_analizer/repository/semester_repository.dart';
import 'package:education_analizer/repository/student_repository.dart';
import 'package:get/get.dart';

class PerformancePageController extends GetxController {
  final AuthController authController;
  final GroupRepository groupRepository;
  final ListofsubjectRepository listofsubjectRepository;
  final StudentRepository studentRepository;
  final MarkRepository markRepository;
  final SemesterRepository semesterRepository;

  var groups = <Group>[].obs;
  var selectedGroupId = Rxn<int>(null);
  var subjects = <Subject>[].obs;
  var selectedSubjectId = Rxn<int>(null);
  var isLoading = false.obs;
  var semesters = <ListOfSubject>[].obs;
  var selectedSemesterId = Rxn<int>(null);
  var year = Rxn<DateTime?>();
  var students = <Student>[].obs;
  var marks = <Mark>[].obs;
  var isSemesterExist = true.obs;

  PerformancePageController({
    required this.semesterRepository,
    required this.markRepository,
    required this.studentRepository,
    required this.listofsubjectRepository,
    required this.groupRepository,
    required this.authController,
  });

  @override
  void onInit() async {
    await loadGroups();
    super.onInit();
  }

  Future<void> loadGroups() async {
    try {
      isLoading(true);
      List<Map<String, dynamic>> loadedGroupMaps =
          await groupRepository.getGroupByRole(
              id: authController.id.value, role: authController.role.value);
      List<Group> loadedGroups =
          loadedGroupMaps.map((groupMap) => Group.fromJson(groupMap)).toList();
      groups.assignAll(loadedGroups);
      isLoading(false);
    } catch (e) {
      log("Ошибка загрузки групп: $e");
    }
  }

  Future<void> loadStudents({required int groupId}) async {
    try {
      List<Student> loadedStudents =
          await studentRepository.getStudentsByGroupId(groupId);
      students.assignAll(loadedStudents);
      log(students.toString());
    } catch (e) {
      log(
        'Ошибка при загрузке студентов для группы $groupId: $e',
      );
    }
  }

  Future<void> loadListOfSubject() async {
    if (selectedGroupId.value != null) {
      try {
        isLoading(true);
        List<Subject> loadedSubjects = await listofsubjectRepository
            .getSubjectsByGroupId(selectedGroupId.value!);
        subjects.assignAll(loadedSubjects); // Обновляем список предметов
        isLoading(false);
      } catch (e) {
        log("Ошибка загрузки предметов: $e");
      }
    }
  }

  Future<void> loadSemesters() async {
    if (selectedSubjectId.value != null) {
      isLoading(true);
      List<ListOfSubject> loadedSemesters =
          await listofsubjectRepository.getListOfSubjectsBySubjectGroupId(
              selectedGroupId.value!, selectedSubjectId.value!);
      semesters.assignAll(loadedSemesters);
      isLoading(false);
    }
  }

  Future<void> loadMarks() async {
    if (year.value != null) {
      isLoading(true);
      if (await semesterRepository.isSemesterExist(
          semesterNumber: semesters
              .firstWhere(
                  (semester) => semester.id! == selectedSemesterId.value)
              .semesterNumber!,
          semesterYear: year.value!.year)) {
        isSemesterExist(true);
        List<Mark> loadedMarks =
            await markRepository.getMarksByGroupIdSemesterNumberSubjectId(
                groupId: selectedGroupId.value!,
                subjectId: selectedSubjectId.value!,
                semesterNumber: semesters
                    .firstWhere(
                        (semester) => semester.id! == selectedSemesterId.value)
                    .semesterNumber!,
                semesterYear: year.value!.year);
        marks.assignAll(loadedMarks);
        log(marks.toString());

        isLoading(false);
      } else {
        isSemesterExist(false);
        isLoading(false);
      }
    }
  }

  void setSelectedGroup(int groupId) async {
    selectedGroupId.value = groupId;
    selectedSubjectId.value = null;
    selectedSemesterId.value = null;
    year.value = null;
    semesters.clear();
    await loadStudents(groupId: groupId);
    await loadListOfSubject(); // Загружаем предметы после выбора группы
  }

  void setSelectedSubject(int subjectId) async {
    selectedSubjectId.value = subjectId;
    selectedSemesterId.value = null;
    await loadSemesters();
  }

  void setSelectedSemester(int semesterId) async {
    selectedSemesterId.value = semesterId;
    year.value = null;
  }

  void setSelecetedDate(DateTime selecetdDate) async {
    year.value = selecetdDate;
    await loadMarks();
  }
}
