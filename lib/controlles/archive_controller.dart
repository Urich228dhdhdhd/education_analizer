import 'dart:developer';

import 'package:education_analizer/model/group.dart';
import 'package:get/get.dart';

import '../repository/group_repository.dart';
import 'auth_controller.dart';

class ArchiveController extends GetxController {
  final AuthController authController;
  final GroupRepository groupRepository;
  ArchiveController({
    required this.authController,
    required this.groupRepository,
  });
  @override
  void onInit() async {
    super.onInit();
    await fetchGroup();
  }

  var allGroup = <Group>[].obs;
  var archivedGroup = <Group>[].obs;
  var filteredArchivedGroup = <Group>[].obs;
  var dialogArchivedGroup = <Group>[].obs;
  var dialogFilteredArchivedGroup = <Group>[].obs;
  var isLoading = false.obs;

  Future<void> fetchGroup() async {
    isLoading.value = true;
    var response = await groupRepository.getGroups();
    allGroup.value = response;
    archivedGroup.value =
        response.where((group) => group.statusGroup == "ARCHIVE").toList();
    dialogFilteredArchivedGroup.value = allGroup;
    dialogArchivedGroup.assignAll(archivedGroup);
    filteredArchivedGroup.assignAll(archivedGroup);
    isLoading.value = false;
  }

  void filterGroupsMainScrean(
      String query, List<Group> finalyFilterList, List<Group> filteredList) {
    if (query.isEmpty || query == "") {
      finalyFilterList.assignAll([...filteredList]);
    } else {
      finalyFilterList.assignAll(
        [...filteredList].where((group) =>
            group.groupName!.toLowerCase().contains(query.toLowerCase())),
      );
    }

    // log("Фильтрованный список:${finalyFilterList.toString()}");
    // log("Полный список:${filteredList.toString()}");
  }
}
