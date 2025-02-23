import 'dart:developer';

import 'package:education_analizer/controlles/auth_controller.dart';
import 'package:education_analizer/model/group.dart';
import 'package:education_analizer/model/user.dart';
import 'package:education_analizer/repository/group_repository.dart';
import 'package:education_analizer/repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/user_group.dart';

class UserListController extends GetxController {
  final AuthController authController;
  final UserRepository userRepository;
  final GroupRepository groupRepository;

  var users = <User>[].obs;
  var groups = <Group>[].obs;
  var userGroups = <UserGroup>[].obs; // Новый список
  var filteredUserGroups = <UserGroup>[].obs;
  var searchController = TextEditingController();

  var selectedRole = "".obs;
  var connectedGroup = <Group>[].obs;
  var groupsToConnect = <Group>[].obs;
  var filteredGroupsToConnect = <Group>[].obs;
  var searchGroupsController = TextEditingController();

  var selectedGroups = <Group>[].obs;

  // ---------------

  final isPasswordVisible = false.obs;
  var connectedCreateGroup = <Group>[].obs;
  var searchGroupsCreateController = TextEditingController();

  List<String> roleList = <String>["CURATOR", "ADMINISTRATOR"];

  var isLoading = false.obs;

  UserListController(
      {required this.authController,
      required this.groupRepository,
      required this.userRepository});

  void filter(String query, List finalyFilterList, List filteredList) {
    if (query.isEmpty) {
      finalyFilterList.assignAll(filteredList);
    } else {
      isLoading.value = true;
      finalyFilterList.assignAll(
        filteredList.where((userGroup) =>
            userGroup.user!.firstName!
                .toLowerCase()
                .contains(query.toLowerCase()) ||
            userGroup.user!.lastName!
                .toLowerCase()
                .contains(query.toLowerCase()) ||
            userGroup.user!.middleName!
                .toLowerCase()
                .contains(query.toLowerCase())),
      );
      isLoading.value = false;
    }
  }

  void filterGroups(
      String query, List<Group> finalyFilterList, List<Group> filteredList) {
    if (query.isEmpty) {
      finalyFilterList.assignAll(filteredList);
    } else {
      finalyFilterList.assignAll(
        filteredList.where((group) =>
            group.groupName!.toLowerCase().contains(query.toLowerCase())),
      );
    }
  }

  Future<void> fetchUsersWithGroups() async {
    isLoading(true);
    var usersResult = await userRepository.getAllUsers();
    usersResult.removeWhere((user) => user.id == authController.id.value);
    usersResult.sort((a, b) {
      return a.middleName!.compareTo(b.middleName!);
    });

    users.value = usersResult;
    var groupsResult = await groupRepository.getGroups();
    groups.value = groupsResult;

    userGroups.value = users.map((user) {
      List<Group> curatedGroups =
          groups.where((group) => group.curatorId == user.id).toList();
      return UserGroup(user: user, groups: curatedGroups);
    }).toList();

    filteredUserGroups.assignAll(userGroups);
    if (searchController.text.isNotEmpty) {
      filter(searchController.text, filteredUserGroups, userGroups);
    }

    isLoading(false);
  }

  Future<void> getGroupsToConnect(int? userId) async {
    isLoading.value = true;
    final responce = await groupRepository.getGroups();
    var filteredGroups = responce
        .where((group) => group.curatorId == userId || group.curatorId == null);
    groupsToConnect.assignAll(filteredGroups);
    filteredGroupsToConnect.assignAll(filteredGroups);
    isLoading.value = false;
  }
}
