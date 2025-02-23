import 'dart:developer';
import 'package:education_analizer/design/widgets/colors.dart';
import 'package:education_analizer/model/group_info.dart';
import 'package:education_analizer/repository/report_repository.dart';
import 'package:education_analizer/repository/user_repository.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:education_analizer/repository/group_repository.dart';
import 'package:education_analizer/controlles/auth_controller.dart';

import '../model/group.dart';
import '../model/user.dart';

class MainPageController extends GetxController {
  final GroupRepository groupRepository;
  final UserRepository userRepository;
  final AuthController authController;
  final ReportRepository reportRepository;

  var groups = <Map<int, GroupInfo>>[].obs;
  var selectedGroupInfo = Rxn<GroupInfo>(null);
  var currentCarouselIndex = 0.obs;

  var isGroupLoading = false.obs;
  var curatorData = Rxn<User>(null);
  var performancePercent = ''.obs;
  var diogramPercent = 0.0.obs;
  Map<String, int> absences = {
    "Болезнь": 0,
    "Приказ": 0,
    "Уваж.": 0,
    "Неуваж.": 0,
  }.obs;
  MainPageController(
      {required this.reportRepository,
      required this.groupRepository,
      required this.userRepository,
      required this.authController});

  Future<void> findGroupsByRole() async {
    try {
      groups.clear();
      isGroupLoading.value = true;
      // await Future.delayed(const Duration(seconds: 5));
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
        groups.add({groupId: groupInfo});

        currentCarouselIndex.value = 0;
        selectedGroupInfo.value =
            groups[currentCarouselIndex.value].values.first;
        setSelectedGroup(groupInfo: selectedGroupInfo.value!);
      }
      isGroupLoading.value = false;
    } catch (e) {
      log('Ошибка при получении групп: $e');
    }
  }

  Future<void> setSelectedGroup({required GroupInfo groupInfo}) async {
    selectedGroupInfo.value = groupInfo;
    if (groupInfo.group!.curatorId != null) {
      curatorData.value =
          await userRepository.getUserbyId(groupInfo.group!.curatorId!);
    } else {
      curatorData.value = null;
    }
    final response = await reportRepository.getPerformancePercent(
        groupId: groupInfo.group!.id!);
    if (response["performancePercent"] == "NaN") {
      performancePercent.value = "-";
      diogramPercent.value = 0;
    } else {
      performancePercent.value = response["performancePercent"];
      diogramPercent.value = double.parse(performancePercent.value);
    }
    await getSummaryGroupAbsence(groupId: selectedGroupInfo.value!.group!.id!);
    // log(performancePercent.toString());
  }

  Future<void> getSummaryGroupAbsence({required int groupId}) async {
    final result =
        await reportRepository.getSummaryGroupAbsenceById(groupId: groupId);
    absences.assignAll({
      "Болезнь": result["absence_illness"],
      "Приказ": result["absence_order"],
      "Уваж.": result["absence_resp"],
      "Неуваж.": result["absence_disresp"],
    });
    log(absences.toString());
  }

  List<BarChartGroupData> generateBarGroups() {
    return absences.entries.map((entry) {
      int index = absences.keys.toList().indexOf(entry.key);
      return BarChartGroupData(x: index, barRods: [
        BarChartRodData(
            toY: entry.value.toDouble(),
            gradient: gradColor,
            // color: barColors[index],
            // borderSide: const BorderSide(color: Colors.black),
            width: 12,
            borderRadius: BorderRadius.circular(8)),
      ], showingTooltipIndicators: [
        0
      ]);
    }).toList();
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    List<String> labels = absences.keys.toList();
    String text = labels[value.toInt()];
    return Text(text,
        style: const TextStyle(
            fontSize: 14, fontWeight: FontWeight.w500, color: primary10Color));
  }

  LinearGradient get gradColor => LinearGradient(
        colors: [
          // primary9Color,
          Colors.blue[200]!,

          primary6Color,
          // dialogButtonColor,
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
}
