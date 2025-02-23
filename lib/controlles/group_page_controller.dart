import 'dart:developer';

import 'package:education_analizer/controlles/auth_controller.dart';
import 'package:education_analizer/model/semester.dart';
import 'package:education_analizer/model/subject.dart';
import 'package:education_analizer/model/subject_info.dart';
import 'package:education_analizer/pages/report_screan/performance_report.dart';
import 'package:education_analizer/repository/group_repository.dart';
import 'package:education_analizer/repository/listofsubject_repository.dart';
import 'package:education_analizer/repository/semester_repository.dart';
import 'package:education_analizer/repository/subject_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../design/widgets/dimentions.dart';
import '../model/group.dart';
import '../model/group_info.dart';
import '../model/list_of_subject.dart';

class GroupPageController extends GetxController {
  final AuthController authController;
  final GroupRepository groupRepository;
  final SubjectRepository subjectRepository;
  final ListofsubjectRepository listofsubjectRepository;
  final SemesterRepository semesterRepository;
  GroupPageController(
      {required this.semesterRepository,
      required this.listofsubjectRepository,
      required this.groupRepository,
      required this.subjectRepository,
      required this.authController});

  var filteredgroups = <GroupInfo>[].obs;

  var isLoaded = false.obs;
  var searchController = TextEditingController();
  var groupNameController = TextEditingController();
  var startYearController = TextEditingController();
  var startYear = ''.obs;
  var endYearController = TextEditingController();
  var selectedGroup = Rxn<Group>(null);
  var isLoading = false.obs;
  var subjects = <Subject>[].obs;
  var listOfSubjects = <ListOfSubject>[].obs;
  var groupSemesters = <Semester>[].obs;

  var selectedGroupFilter = Rx(-1);
  var groups = <GroupInfo>[].obs;

  var selectedSubjectFilter = Rx(-1);
  var subjectsInfo = <SubjectInfo>[].obs;
  var filteredSubjectInfo = <SubjectInfo>[].obs;
  var searchededSubjectInfo = <SubjectInfo>[].obs;

  var groupOptions = [
    "По возрастанию",
    "По убыванию",
    "Заканчивают обучение в этом году",
  ].obs;
  var subjectOptions = [
    "От А до Я",
    "От Я до А",
    "Только предметы с семестрами",
    "Телько предметы без семестров",
  ].obs;

  Future<void> findGroupsByRole() async {
    groups.clear();
    filteredgroups.clear();
    try {
      isLoaded.value = true;

      int id = authController.id.value;
      String role = authController.role.value;
      var result = await groupRepository.getGroupByRole(id: id, role: role);
      for (var groupData in result) {
        int groupId = groupData['id'];
        int studentCount = groupData['student_count'];
        Group group = await groupRepository.getGroupById(groupId);
        if (group.statusGroup == "ARCHIVE") {
          continue;
        }
        GroupInfo groupInfo =
            GroupInfo(group: group, studentCount: studentCount);
        groups.add(groupInfo);
        filteredgroups.add(groupInfo);
      }
      if (selectedGroupFilter.value != -1) {
        filterGroups();
      }
      isLoaded.value = false;
    } catch (e) {
      log('Ошибка при получении групп: $e');
    }
  }

  int extractNumber(String groupName) {
    RegExp regExp = RegExp(r'\d+');
    var match = regExp.firstMatch(groupName);
    return match != null ? int.parse(match.group(0)!) : 999;
  }

  void filterGroups() {
    if (selectedGroupFilter.value == -1) {
      filteredgroups
        ..clear()
        ..addAll(groups);
    } else {
      switch (selectedGroupFilter.value) {
        case 0:
          filteredgroups.assignAll(
            [...groups]..sort((a, b) => extractNumber(a.group!.groupName!)
                .compareTo(extractNumber(b.group!.groupName!))),
          );
          break;
        case 1:
          filteredgroups.assignAll(
            [...groups]..sort((a, b) => extractNumber(b.group!.groupName!)
                .compareTo(extractNumber(a.group!.groupName!))),
          );
          break;
        case 2:
          var currentYear = DateTime.now().year;
          filteredgroups.assignAll(
            groups
                .where((groupInfo) => groupInfo.group!.endYear == currentYear)
                .toList(),
          );
          break;
        default:
      }
    }
    log(groups.toString());
  }

  void filterSubjects() {
    if (selectedSubjectFilter.value == -1) {
      filteredSubjectInfo
        ..clear()
        ..addAll(subjectsInfo);
    } else {
      switch (selectedSubjectFilter.value) {
        case 0:
          filteredSubjectInfo.assignAll(
            [...subjectsInfo] // Создаем копию списка
              ..sort((a, b) => a.subject.subjectNameLong!
                  .compareTo(b.subject.subjectNameLong!)),
          );
          break;
        case 1:
          filteredSubjectInfo.assignAll(
            [...subjectsInfo] // Создаем копию списка
              ..sort((a, b) => b.subject.subjectNameLong!
                  .compareTo(a.subject.subjectNameLong!)),
          );
          break;
        case 2:
          filteredSubjectInfo.assignAll(
            subjectsInfo
                .where((subjectInf) => subjectInf.semesters.isNotEmpty)
                .toList(),
          );
          break;

        case 3:
          filteredSubjectInfo.assignAll(
            subjectsInfo
                .where((subjectInf) => subjectInf.semesters.isEmpty)
                .toList(),
          );
          break;

        default:
      }
    }
    searchededSubjectInfo.assignAll(filteredSubjectInfo);

    // log(groups.toString());
  }

  void clearGroupDialogDate() {
    groupNameController.clear();
    startYearController.clear();
    endYearController.clear();
    startYear.value = "";
  }

  void clearGroupUpdateDialogDate() {
    searchController.clear();
    subjects.clear();
    listOfSubjects.clear();
    groupSemesters.clear();
  }

  Future<bool> validateGroupDate() async {
    if (groupNameController.text.isEmpty ||
        startYearController.text.isEmpty ||
        endYearController.text.isEmpty) {
      showSnackBar(title: "Ошибка", message: "Все поля должны быть заполнены");
      return false;
    }

    int? startYear = int.tryParse(startYearController.text);
    int? endYear = int.tryParse(endYearController.text);

    if (startYear == null ||
        endYear == null ||
        startYearController.text.length != 4 ||
        endYearController.text.length != 4) {
      showSnackBar(
          title: 'Ошибка', message: 'Введите корректные годы (4 цифры)');
      return false;
    }

    if (endYear < startYear) {
      showSnackBar(
          title: 'Ошибка',
          message: 'Год окончания не может быть меньше года начала');
      return false;
    }
    await createGroup();
    return true;
  }

  Future<void> createGroup() async {
    await groupRepository.createGroup(
        group: Group(
            groupName: groupNameController.text,
            startYear: int.tryParse(startYearController.text),
            endYear: int.tryParse(endYearController.text)));
  }

  Future<void> getAllSubjects() async {
    isLoading.value = true;

    subjects.value = await subjectRepository.getSubjects();
    isLoading.value = false;
  }

  Future<void> getListOfSubjects(int groupId) async {
    isLoading.value = true;
    try {
      List<ListOfSubject> fetchedListOfSubject =
          await listofsubjectRepository.getListOfSubjectsByGroupId(groupId);

      listOfSubjects.assignAll(fetchedListOfSubject);
      isLoading.value = false;
    } catch (e) {
      log(e.toString());
    }
  }

  Future<List<Semester>> getSemestersForSubject(
      List<ListOfSubject> listOfSubjects) async {
    List<Semester> semesterNumberList = [];
    for (var listOfSub in listOfSubjects) {
      var semester =
          await semesterRepository.getSemesterById(listOfSub.semesterId!);
      semesterNumberList.add(semester);
    }
    semesterNumberList
        .sort((a, b) => a.semesterNumber!.compareTo(b.semesterNumber!));
    // log(semesterNumberList.toString());
    return semesterNumberList;
  }

  Future<void> getSemestersForGroup(Group group) async {
    // groupSemesters.clear();
    isLoading.value = true;

    for (var year = group.startYear; year! <= group.endYear!; year++) {
      for (int semesterPart = 1; semesterPart <= 2; semesterPart++) {
        if (year == group.startYear) {
          semesterPart = 2;
        }
        int semesterNumber = (year - group.startYear!) * 2 + semesterPart - 1;
        bool exists = await semesterRepository.isSemesterExist(
          semesterNumber: semesterNumber,
          semesterYear: year,
        );
        if (!exists) {
          await semesterRepository.createSemester(
              semesterNumber: semesterNumber,
              semesterYear: year,
              semesterPart: semesterPart);
        }
        var semester = await semesterRepository.getSemesterBySemesterYear(
            semesterNumber: semesterNumber, year: year);
        groupSemesters.add(semester);
        isLoading.value = false;
      }
    }
  }

  void searchSubjects(String query) {
    if (query.isEmpty || query == "") {
      searchededSubjectInfo.assignAll(
          [...filteredSubjectInfo]); // Показать все, если запрос пустой
    } else {
      searchededSubjectInfo.assignAll(
        [...filteredSubjectInfo]
            .where(
              (info) =>
                  info.subject.subjectNameShort != null &&
                  info.subject.subjectNameShort!
                      .toLowerCase()
                      .contains(query.toLowerCase()),
            )
            .toList(),
      );
    }

    // log("Filtered list: ${filteredSubjectInfo.map((e) => e.subject.subjectNameShort).toList()}");
  }

  Future<void> updateSelectedGroup(Group group) async {
    int index =
        groups.indexWhere((groupInfo) => groupInfo.group?.id == group.id);
    int indexFiltert = filteredgroups
        .indexWhere((groupInfo) => groupInfo.group?.id == group.id);

    if (index != -1) {
      groups[index] =
          GroupInfo(group: group, studentCount: groups[index].studentCount);
      filteredgroups[indexFiltert] = GroupInfo(
          group: group,
          studentCount: filteredgroups[indexFiltert].studentCount);
    } else {
      log('Group not found');
    }
  }

  Future<void> updateGroupInfoByGroup(int groupId, int subjectId) async {
    isLoading.value = true;
    await getListOfSubjects(groupId);

    final listToCurrentSubject = listOfSubjects
        .where((listOfSyb) => listOfSyb.subjectId == subjectId)
        .toList();

    final semesters = await getSemestersForSubject(listToCurrentSubject);

    int indexSubjectsInfo = subjectsInfo
        .indexWhere((subjectInfo) => subjectInfo.subject.id == subjectId);

    int indexFilteredSubjectInfo = filteredSubjectInfo
        .indexWhere((subjectInfo) => subjectInfo.subject.id == subjectId);

    int indexSearchededSubjectInfo = searchededSubjectInfo
        .indexWhere((subjectInfo) => subjectInfo.subject.id == subjectId);

    if (indexSubjectsInfo != -1) {
      subjectsInfo[indexSubjectsInfo] = SubjectInfo(
          subject: subjectsInfo[indexSubjectsInfo].subject,
          semesters: semesters);
    }

    if (indexFilteredSubjectInfo != -1) {
      filteredSubjectInfo[indexFilteredSubjectInfo] = SubjectInfo(
          subject: filteredSubjectInfo[indexFilteredSubjectInfo].subject,
          semesters: semesters);
    }

    if (indexSearchededSubjectInfo != -1) {
      searchededSubjectInfo[indexSearchededSubjectInfo] = SubjectInfo(
          subject: searchededSubjectInfo[indexSearchededSubjectInfo].subject,
          semesters: semesters);
    }
    isLoading.value = false;
  }

  Future<void> loadSubjectsAndSemesters(Group group) async {
    // clearGroupUpdateDialogDate();
    isLoading.value = true;

    await getAllSubjects();
    await getListOfSubjects(group.id!);

    final subjectInfoTempList = <SubjectInfo>[];
    for (var subject in subjects) {
      final listToCurrentSubject = listOfSubjects
          .where((listOfSyb) => listOfSyb.subjectId == subject.id)
          .toList();

      final semesters = await getSemestersForSubject(listToCurrentSubject);

      subjectInfoTempList
          .add(SubjectInfo(semesters: semesters, subject: subject));
    }
    subjectsInfo.assignAll(subjectInfoTempList);
    filteredSubjectInfo.assignAll(subjectInfoTempList);
    searchededSubjectInfo.assignAll(subjectInfoTempList);

    isLoading.value = false;

    // log("subjectsInfo:${subjectsInfo.toString()}");
    // log("filteredSubjectInfo:${filteredSubjectInfo.toString()}");
  }

  void refreshGroups() {
    findGroupsByRole();
  }

  // @override
  // void onInit() {
  //   super.onInit();
  //   findGroupsByRole();
  // }
}
