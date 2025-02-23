import 'dart:developer';

import 'package:education_analizer/controlles/auth_controller.dart';
import 'package:education_analizer/model/group.dart';
import 'package:education_analizer/model/list_of_subject.dart';
import 'package:education_analizer/model/mark.dart';
import 'package:education_analizer/model/semester.dart';
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
  var selectedGroup = Rxn<Group>(null);
  var subjects = <Subject>[].obs;
  var selectedSubjectId = Rxn<int>(null);
  var isLoading = false.obs;
  var isLoadingSemester = false.obs;
  var listOfSubjectsList = <ListOfSubject>[].obs;
  var semesterList = <Semester>[].obs;
  var selectedSemester = Rxn<Semester>(null);
  var students = <Student>[].obs;
  var marks = <Mark>[].obs;
  var isSemesterExist = true.obs;
  var isExam = false.obs;
  List<String> ratingOptions = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    'Зачет',
    'Незачет'
  ].obs;

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
      // log(students.toString());
    } catch (e) {
      log(
        'Ошибка при загрузке студентов для группы $groupId: $e',
      );
    }
  }

  Future<void> loadListOfSubject() async {
    if (selectedGroup.value != null) {
      try {
        isLoading(true);
        List<Subject> loadedSubjects = await listofsubjectRepository
            .getSubjectsByGroupId(selectedGroup.value!.id!);
        subjects.assignAll(loadedSubjects); // Обновляем список предметов
        isLoading(false);
      } catch (e) {
        log("Ошибка загрузки предметов: $e");
      }
    }
  }

  Future<void> loadSemesters() async {
    if (selectedSubjectId.value != null) {
      isLoadingSemester.value = true;
      List<ListOfSubject> loadedSemesters =
          await listofsubjectRepository.getListOfSubjectsBySubjectGroupId(
              selectedGroup.value!.id!, selectedSubjectId.value!);
      listOfSubjectsList.assignAll(loadedSemesters);
      var loadedSemestersList = await Future.wait(
        listOfSubjectsList.map((listofSub) async {
          return await semesterRepository
              .getSemesterById(listofSub.semesterId!);
        }),
      );
      semesterList.assignAll(loadedSemestersList);
      isLoadingSemester.value = false;
    }
  }

  Future<void> loadMarks() async {
    isLoadingSemester.value = true;
    List<Mark> loadedMarks =
        await markRepository.getMarksByGroupIdSemesterNumberSubjectId(
            groupId: selectedGroup.value!.id!,
            subjectId: selectedSubjectId.value!,
            semesterNumber: selectedSemester.value!.semesterNumber!,
            semesterYear: selectedSemester.value!.semesterYear!);
    marks.assignAll(loadedMarks);
    await checkIsExamMarksStatus();

    isLoadingSemester.value = false;
  }

  Future<void> setSelectedGroup(Group group) async {
    selectedGroup.value = group;
    selectedSubjectId.value = null;
    selectedSemester.value = null;
    listOfSubjectsList.clear();
    semesterList.clear();
    await loadStudents(groupId: group.id!);
    await loadListOfSubject(); // Загружаем предметы после выбора группы
  }

  Future<void> setSelectedSubject(int subjectId) async {
    selectedSubjectId.value = subjectId;
    selectedSemester.value = null;
    semesterList.clear();

    await loadSemesters();
  }

  Future<void> setSelectedSemester(Semester semester) async {
    isLoadingSemester.value = true;
    selectedSemester.value = semester;
    await loadMarks();
    isLoadingSemester.value = false;
  }

  Future<void> updateMarksIsExamStatus(bool isExam) async {
    // await checkAllMarksToIsExistStatus(listOfSubjectsList);
    for (var mark in marks) {
      await markRepository.updateMark(mark: Mark(id: mark.id, isExam: isExam));
    }
    await loadMarks();
  }

  Future<void> checkIsExamMarksStatus() async {
    isExam.value = marks.any((mark) => mark.isExam == true);
  }

  Future<Semester?> hasExamMarks(List<ListOfSubject> listOfSubjects) async {
    List<ListOfSubject> filteredSubjects = List.from(listOfSubjects);

    filteredSubjects
        .removeWhere((item) => item.semesterId == selectedSemester.value!.id);

    for (var listOfSub in filteredSubjects) {
      Semester? semester = semesterList.firstWhere(
        (item) => item.id == listOfSub.semesterId,
      );

      var marks = await markRepository.getMarksByGroupIdSemesterNumberSubjectId(
        groupId: selectedGroup.value!.id!,
        subjectId: selectedSubjectId.value!,
        semesterNumber: semester.semesterNumber!,
        semesterYear: semester.semesterYear!,
      );

      bool hasExamMark = marks.any((mark) => mark.isExam == true);
      if (hasExamMark) {
        return semester;
      }
    }
    return null;
  }
}
