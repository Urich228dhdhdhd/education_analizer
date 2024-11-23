import 'dart:developer';
// import 'dart:ffi';

import 'package:education_analizer/controlles/auth_controller.dart';
import 'package:education_analizer/model/group.dart';
import 'package:education_analizer/repository/absence_repository.dart';
import 'package:education_analizer/repository/group_repository.dart';
import 'package:get/get.dart';

class ReportPageController extends GetxService {
  final AuthController authController;
  final GroupRepository groupRepository;
  final AbsenceRepository absenceRepository;

  var selectedReportIndex = 0.obs;
  var currentStep = 0.obs;
  var isLoading = false.obs;
  var groups = <Group>[].obs;
  var selectedGroups = <int>{}.obs;
  var selectedDate = Rx<DateTime?>(null);
  var selectedAbsenceTypes = <String>[].obs;

  ReportPageController(
      {required this.groupRepository,
      required this.authController,
      required this.absenceRepository});

  @override
  void onInit() async {
    findGroupsByRole();
    super.onInit();
  }

  void toggleGroupSelection(int groupId) {
    if (selectedGroups.contains(groupId)) {
      selectedGroups.remove(groupId);
    } else {
      selectedGroups.add(groupId);
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

      groups.value = result;
      isLoading(false);
      // log(groups.value.toString());
    } catch (e) {
      log('Ошибка при получении групп: $e');
    }
  }
}
