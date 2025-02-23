import 'dart:developer';
// import 'dart:ffi';

import 'package:education_analizer/controlles/auth_controller.dart';
import 'package:education_analizer/model/group.dart';
import 'package:education_analizer/model/group_absence_report.dart';
import 'package:education_analizer/model/report.dart';
import 'package:education_analizer/model/semester.dart';
import 'package:education_analizer/model/subject.dart';
import 'package:education_analizer/repository/absence_repository.dart';
import 'package:education_analizer/repository/group_repository.dart';
import 'package:education_analizer/repository/listofsubject_repository.dart';
import 'package:education_analizer/repository/report_repository.dart';
import 'package:education_analizer/repository/semester_repository.dart';
import 'package:education_analizer/repository/subject_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../model/performanse_report.dart';

class ReportPageController extends GetxController {
  final AuthController authController;
  final GroupRepository groupRepository;
  final SemesterRepository semesterRepository;
  final AbsenceRepository absenceRepository;
  final ListofsubjectRepository listofsubjectRepository;
  final SubjectRepository subjectRepository;
  final ReportRepository reportRepository;

  var selectedReportIndex = 0.obs;
  var absenceStep = 0.obs;
  var isLoading = false.obs;
  var groups = <Group>[].obs;
  var absenceSelectedGroups = <Group>[].obs;
  var selectedDate = Rx<DateTime?>(null);
  var selectedAbsenceTypes = <String>[].obs;
  var reportAbsenceData = <GroupAbsenceReport>[].obs;
  // --------------------------------------
  var performanceStep = 0.obs;
  var isLoadingSubject = false.obs;
  var performanceSelectedGroup = Rx<Group?>(null);
  var groupSemesters = <Semester>[].obs;
  var startSemester = Rx<Semester?>(null);
  var endSemester = Rx<Semester?>(null);
  var semesterRange = <Semester>[].obs;
  var subjects = <Subject>[].obs;
  var selectedSubjects = <Subject>[].obs;
  var performanceReport = Rxn<PerformanseReport?>(null);

  // ---------------------------------
  var reports = <Report>[].obs;
  var filteredOptionsReports = <Report>[].obs;
  var filteredSearchReports = <Report>[].obs;
  var searchController = TextEditingController();
  var selectedReportFilter = Rx(-1);

  var reportOptions = [
    "Сначала новые",
    "Сначала старые",
  ].obs;

  ReportPageController(
      {required this.reportRepository,
      required this.subjectRepository,
      required this.listofsubjectRepository,
      required this.semesterRepository,
      required this.groupRepository,
      required this.authController,
      required this.absenceRepository});

  // @override
  // void onInit() async {
  //   findGroupsByRole();
  //   super.onInit();
  // }

  void searchReport(String query) {
    if (query.isEmpty || query == "") {
      filteredSearchReports.assignAll([...filteredOptionsReports]);
    } else {
      filteredSearchReports.assignAll(
        [...filteredOptionsReports]
            .where(
              (report) =>
                  report.reportName.toLowerCase().contains(query.toLowerCase()),
            )
            .toList(),
      );
    }

    // log("Filtered list: ${filteredSubjectInfo.map((e) => e.subject.subjectNameShort).toList()}");
  }

  void filterReport() {
    if (selectedReportFilter.value == -1) {
      filteredOptionsReports
        ..clear()
        ..addAll(reports);
    } else {
      switch (selectedReportFilter.value) {
        case 0:
          filteredOptionsReports.assignAll(
            [...reports] // Создаем копию списка
              ..sort((a, b) => b.createdAt.compareTo(a.createdAt)),
          );
          break;
        case 1:
          filteredOptionsReports.assignAll(
            [...reports] // Создаем копию списка
              ..sort((a, b) => a.createdAt.compareTo(b.createdAt)),
          );
          break;

        default:
      }
    }
    filteredSearchReports.assignAll(filteredOptionsReports);
  }

  void toggleGroupSelection(Group group) {
    if (absenceSelectedGroups.contains(group)) {
      absenceSelectedGroups.remove(group);
    } else {
      absenceSelectedGroups.add(group);
    }
  }

  void selectReportType(int index) {
    selectedReportIndex.value = index;
  }

  void findGroupsByRole() async {
    try {
      isLoading(true);
      var result = await groupRepository.getGroupByRole2(
          id: authController.id.value, role: authController.role.value);

      groups.value =
          result.where((group) => group.statusGroup == "ACTIVE").toList();
      isLoading(false);
      // log(groups.value.toString());
    } catch (e) {
      log('Ошибка при получении групп: $e');
    }
  }

  Future<void> getSemestersForGroup(Group group) async {
    isLoadingSubject.value = true;
    groupSemesters.clear();
    for (var year = group.startYear; year! <= group.endYear!; year++) {
      for (int semesterPart = 1; semesterPart <= 2; semesterPart++) {
        if (year == group.startYear) {
          semesterPart = 2;
        }
        int semesterNumber = (year - group.startYear!) * 2 + semesterPart - 1;
        Semester semester = await semesterRepository.getSemesterBySemesterYear(
            semesterNumber: semesterNumber, year: year);
        groupSemesters.add(semester);
      }
    }
    isLoadingSubject.value = false;
    // log(groupSemesters.toString());
  }

  void toggleSelectionSemester(Semester semester) {
    semesterRange.clear();

    if (startSemester.value == null && endSemester.value == null) {
      // Если оба семестра не выбраны, выбираем начальный и конечный
      startSemester.value = semester;
      endSemester.value = semester;
    } else {
      if (startSemester.value == semester && endSemester.value == semester) {
        startSemester.value = null;
        endSemester.value = null;
      } else if (semester == startSemester.value) {
        // Если выбрали начальный семестр, сбрасываем его
        startSemester.value = endSemester.value;
        // endSemester.value = null;  // оставляем конечный
      } else if (semester == endSemester.value) {
        // Если выбрали конечный семестр, сбрасываем его
        endSemester.value = startSemester.value;
      } else {
        final distanceToStart =
            (semester.semesterNumber! - startSemester.value!.semesterNumber!)
                .abs();
        final distanceToEnd =
            (semester.semesterNumber! - endSemester.value!.semesterNumber!)
                .abs();

        if (distanceToStart <= distanceToEnd) {
          startSemester.value = semester;
        } else {
          endSemester.value = semester;
        }
      }
    }

    if (startSemester.value != null && endSemester.value != null) {
      if (startSemester.value!.semesterNumber! >
          endSemester.value!.semesterNumber!) {
        final temp = startSemester.value;
        startSemester.value = endSemester.value;
        endSemester.value = temp;
      }
      semesterRange.clear();
      for (var semester in groupSemesters) {
        if (semester.semesterNumber! >= startSemester.value!.semesterNumber! &&
            semester.semesterNumber! <= endSemester.value!.semesterNumber!) {
          semesterRange.add(semester);
        }
      }
    }
  }

  Future<void> getSubjectsBySemesterRangeAndGroupId(
      {required List<Semester> semesters, required Group group}) async {
    isLoadingSubject.value = true;
    final listOfSubjects =
        await listofsubjectRepository.getListOfSubjectsByGroupId(group.id!);
    final semesterIds = semesters.map((semester) => semester.id).toSet();
    final filteredListOfSubjects = listOfSubjects
        .where((listOfSub) => semesterIds.contains(listOfSub.semesterId))
        .toList();
    final uniqueSubjectIds =
        filteredListOfSubjects.map((listOfSub) => listOfSub.subjectId).toSet();
    for (var element in uniqueSubjectIds) {
      Subject subject = await subjectRepository.getSubjectById(element!);
      subjects.add(subject);
    }
    isLoadingSubject.value = false;
  }

  void toggleSubjectSelection(Subject subject) {
    if (selectedSubjects.contains(subject)) {
      selectedSubjects.remove(subject);
    } else {
      selectedSubjects.add(subject);
    }
    log(selectedSubjects.toString());
  }

  Future<void> getReports() async {
    isLoading.value = true;
    reports.value = await reportRepository.getReportsByUserId(
        userId: authController.id.value);
    filteredOptionsReports.assignAll([...reports]);
    filteredSearchReports.assignAll([...reports]);
    isLoading.value = false;
  }
}
