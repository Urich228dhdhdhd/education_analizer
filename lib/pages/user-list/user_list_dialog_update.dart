import 'dart:developer';

import 'package:education_analizer/model/user.dart';
import 'package:education_analizer/model/user_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../controlles/user_list_controller.dart';
import '../../design/dialog/styles.dart';
import '../../design/widgets/colors.dart';
import '../../design/widgets/dimentions.dart';
import '../../model/group.dart';

class UpdateUserListDialog extends StatelessWidget {
  final UserGroup userGroup; // Поле для хранения переданного объекта

  const UpdateUserListDialog({super.key, required this.userGroup});

  @override
  Widget build(BuildContext context) {
    final UserListController controller = Get.find();

    TextEditingController surnameController =
        TextEditingController(text: userGroup.user!.middleName);
    TextEditingController nameController =
        TextEditingController(text: userGroup.user!.firstName);
    TextEditingController lastNameController =
        TextEditingController(text: userGroup.user!.lastName);
    TextEditingController loginController =
        TextEditingController(text: userGroup.user!.username);
    controller.selectedRole.value = userGroup.user!.role!;
    controller.connectedGroup.value = [...?userGroup.groups];

    return Dialog(
      backgroundColor: primaryColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(radius12)),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: padding14, vertical: padding20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Редактирование пользователя",
                style: primaryStyle.copyWith(fontSize: 16),
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                "Фамилия",
                style: labelTextField.copyWith(fontSize: 12),
              ),
              const SizedBox(
                height: 2,
              ),
              TextField(
                controller: surnameController,
                keyboardType: TextInputType.text,
                style: labelTextField.copyWith(fontSize: 14),
                decoration: textFieldStyle(
                  hintText: "Введите фамилию",
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                "Имя",
                style: labelTextField.copyWith(fontSize: 12),
              ),
              const SizedBox(
                height: 2,
              ),
              TextField(
                controller: nameController,
                keyboardType: TextInputType.text,
                style: labelTextField.copyWith(fontSize: 14),
                decoration: textFieldStyle(
                  hintText: "Введите имя",
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                "Отчество",
                style: labelTextField.copyWith(fontSize: 12),
              ),
              const SizedBox(
                height: 2,
              ),
              TextField(
                controller: lastNameController,
                keyboardType: TextInputType.text,
                style: labelTextField.copyWith(fontSize: 14),
                decoration: textFieldStyle(
                  hintText: "Введите отчесто",
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                "Логин",
                style: labelTextField.copyWith(fontSize: 12),
              ),
              const SizedBox(
                height: 2,
              ),
              TextField(
                controller: loginController,
                keyboardType: TextInputType.text,
                style: labelTextField.copyWith(fontSize: 14),
                decoration: textFieldStyle(
                  hintText: "Введите логин",
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                "Выберите роль",
                style: labelTextField.copyWith(fontSize: 12),
              ),
              const SizedBox(
                height: 2,
              ),
              DropdownMenu(
                onSelected: (value) {
                  controller.selectedRole.value = value.toString();
                  // log(value.toString());
                },
                inputDecorationTheme: InputDecorationTheme(
                  filled: true, // Включение фона
                  fillColor: primary8Color, // Цвет фона
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(radius8), // Закругленные углы
                    borderSide: BorderSide(
                      color: greyColor[400]!, // Цвет границы
                      width: 1.0, // Толщина границы
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(radius8), // Закругленные углы
                      borderSide: const BorderSide(
                        color: greyColor, // Цвет границы в обычном состоянии
                        width: 1.0,
                      )),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                        radius8), // Закругленные углы при фокусе
                    borderSide: BorderSide(
                      color: greyColor[600]!, // Цвет границы при фокусе
                      width: 2,
                    ),
                  ),
                ),
                width: double.infinity,
                initialSelection: userGroup.user!.role,
                textStyle: labelTextField.copyWith(fontSize: 12),
                menuStyle: const MenuStyle(
                    fixedSize: WidgetStatePropertyAll(Size(60, 120)),
                    backgroundColor: WidgetStatePropertyAll(primaryColor)),
                dropdownMenuEntries: controller.roleList
                    .map<DropdownMenuEntry<String>>((String role) {
                  return DropdownMenuEntry(value: role, label: role);
                }).toList(),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                "Выберите группы",
                style: labelTextField.copyWith(fontSize: 12),
              ),
              const SizedBox(
                height: 2,
              ),
              Obx(() {
                return TextField(
                    readOnly: true,
                    controller: TextEditingController(
                        text: controller.connectedGroup
                            .map((group) => group.groupName)
                            .join(" , ")),
                    keyboardType: TextInputType.text,
                    style: labelTextField.copyWith(fontSize: 12),
                    decoration: InputDecoration(
                        filled: true, // Включение фона
                        fillColor: primary8Color, // Цвет фона
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              radius8), // Закругленные углы
                          borderSide: BorderSide(
                            color: greyColor[400]!, // Цвет границы
                            width: 1.0, // Толщина границы
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                radius8), // Закругленные углы
                            borderSide: const BorderSide(
                              color:
                                  greyColor, // Цвет границы в обычном состоянии
                              width: 1.0,
                            )),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              radius8), // Закругленные углы при фокусе
                          borderSide: BorderSide(
                            color: greyColor[600]!, // Цвет границы при фокусе
                            width: 2,
                          ),
                        ),
                        hintText: "Выберите группы",
                        hintStyle: textFieldtext,
                        suffixIcon: IconButton(
                            onPressed: () async {
                              await controller
                                  .getGroupsToConnect(userGroup.user!.id!);
                              // log(userGroup.groups.toString());
                              await Get.dialog(GroupConnectDialog(
                                connectedGroupList: controller.connectedGroup,
                              ));
                              // log("----------");
                              // log(controller.connectedGroup.toString());
                              // log(userGroup.groups.toString());
                            },
                            icon: const Icon(Icons.add))));
              }),
              const SizedBox(
                height: padding20,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                        style: ButtonStyle(
                            shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8))),
                            backgroundColor: const WidgetStatePropertyAll(
                                dialogButtonColor)),
                        onPressed: () async {
                          try {
                            if (surnameController.text.isEmpty ||
                                nameController.text.isEmpty ||
                                lastNameController.text.isEmpty) {
                              showSnackBar(
                                  title: "Ошибка",
                                  message: "Все поля должны быть заполнены");
                            } else {
                              if (userGroup.user!.firstName !=
                                      nameController.text ||
                                  userGroup.user!.middleName !=
                                      surnameController.text ||
                                  userGroup.user!.lastName !=
                                      lastNameController.text ||
                                  userGroup.user!.username !=
                                      loginController.text ||
                                  userGroup.user!.role !=
                                      controller.selectedRole.value ||
                                  (userGroup.groups ?? [])
                                      .toSet()
                                      .difference(
                                          controller.connectedGroup.toSet())
                                      .isNotEmpty ||
                                  (controller.connectedGroup.toSet().difference(
                                          (userGroup.groups ?? []).toSet()))
                                      .isNotEmpty) {
                                log("Зашли в обновление");
                                await controller.userRepository.updateUser(User(
                                  id: userGroup.user!.id,
                                  firstName: nameController.text,
                                  middleName: surnameController.text,
                                  lastName: lastNameController.text,
                                  role: controller.selectedRole.value,
                                  username: loginController.text,
                                ));
                                if (userGroup.groups !=
                                    controller.connectedGroup) {
                                  log("Зашли в обновление групп");

                                  final previousGroups =
                                      userGroup.groups?.toSet() ?? {};
                                  final newGroups =
                                      controller.connectedGroup.toSet() ?? {};
                                  final addedGroup =
                                      newGroups.difference(previousGroups);
                                  final deletedGroup =
                                      previousGroups.difference(newGroups);

                                  if (addedGroup.isNotEmpty) {
                                    for (var group in addedGroup) {
                                      await controller.groupRepository
                                          .updateGroup(
                                              group: Group(
                                                  id: group.id,
                                                  curatorId:
                                                      userGroup.user!.id));
                                    }
                                  }
                                  if (deletedGroup.isNotEmpty) {
                                    for (var group in deletedGroup) {
                                      await controller.groupRepository
                                          .updateGroup(
                                              group: Group(
                                                  id: group.id,
                                                  curatorId: null));
                                    }
                                  }
                                }

                                Get.back();

                                showSnackBar(
                                    backgroundColor: Colors.green[300]!,
                                    title: "Успех",
                                    message:
                                        "Пользователь ${nameController.text} ${surnameController.text} успешно обнавлен");
                                await controller.fetchUsersWithGroups();
                              } else {
                                Get.back();
                              }
                            }
                          } catch (e) {
                            showSnackBar(
                                title: "Ошибка", message: e.toString());
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text("Сохранить",
                              style: primaryStyle.copyWith(
                                  fontSize: 16, color: whiteColor)),
                        )),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class GroupConnectDialog extends StatelessWidget {
  final List<Group> connectedGroupList;
  const GroupConnectDialog({super.key, required this.connectedGroupList});

  @override
  Widget build(BuildContext context) {
    final UserListController controller = Get.find();
    controller.selectedGroups.value = connectedGroupList;
    controller.searchGroupsController.addListener(() {
      controller.filterGroups(controller.searchGroupsController.text,
          controller.filteredGroupsToConnect, controller.groupsToConnect);
    });

    return Dialog(
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius8)),
      backgroundColor: primaryColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: padding14, vertical: padding20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller.searchGroupsController,
              style: labelTextField.copyWith(fontSize: 14),
              decoration: InputDecoration(
                filled: true,
                fillColor: primary8Color,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(radius8),
                  borderSide: const BorderSide(
                    color: greyColor,
                    width: 1.0,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(radius8),
                    borderSide: const BorderSide(
                      color: greyColor,
                      width: 1.0,
                    )),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(radius8),
                  borderSide: BorderSide(
                    color: greyColor[600]!,
                    width: 2,
                  ),
                ),
                hintText: "Поиск группы",
                hintStyle: textFieldtext.copyWith(fontSize: 14),
                suffixIcon: const Icon(
                  Icons.search,
                  color: greyColor,
                ),
              ),
            ),
            const SizedBox(
              height: padding14,
            ),
            SizedBox(
              height: 240,
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                }
                return ListView.builder(
                  itemCount: controller.filteredGroupsToConnect.length,
                  itemBuilder: (context, index) {
                    var group = controller.filteredGroupsToConnect[index];
                    return Obx(() {
                      bool isChecked =
                          controller.connectedGroup.contains(group);
                      return GestureDetector(
                        onTap: () {
                          if (isChecked) {
                            controller.connectedGroup.remove(group);
                          } else {
                            if (controller.connectedGroup.length == 3) {
                              showSnackBar(
                                duration: const Duration(seconds: 1),
                                title: "Ошибка",
                                message: "Нельзя привязать более 3-х групп",
                              );
                              return;
                            }
                            controller.connectedGroup.add(group);
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: padding10),
                          child: Container(
                            padding: const EdgeInsets.all(padding6),
                            decoration: BoxDecoration(
                              color: whiteColor,
                              border: isChecked
                                  ? Border.all(color: primary6Color, width: 2)
                                  : Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(child: Text(group.groupName!)),
                                IconButton(
                                  icon: Icon(
                                    isChecked
                                        ? Icons.remove_circle_outline
                                        : Icons.add_circle_outline,
                                    color:
                                        isChecked ? greyColor : primary6Color,
                                  ),
                                  onPressed: () {
                                    if (isChecked) {
                                      controller.connectedGroup.remove(group);
                                    } else {
                                      if (controller.connectedGroup.length ==
                                          3) {
                                        showSnackBar(
                                          duration: const Duration(seconds: 1),
                                          title: "Ошибка",
                                          message:
                                              "Нельзя привязать более 3-х групп",
                                        );
                                        return;
                                      }
                                      controller.connectedGroup.add(group);
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    });
                  },
                );
              }),
            )
          ],
        ),
      ),
    );
  }
}

InputDecoration textFieldStyle({required String hintText}) {
  return InputDecoration(
    filled: true, // Включение фона
    fillColor: primary8Color, // Цвет фона
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius8), // Закругленные углы
      borderSide: BorderSide(
        color: greyColor[400]!, // Цвет границы
        width: 1.0, // Толщина границы
      ),
    ),
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius8), // Закругленные углы
        borderSide: const BorderSide(
          color: greyColor, // Цвет границы в обычном состоянии
          width: 1.0,
        )),
    focusedBorder: OutlineInputBorder(
      borderRadius:
          BorderRadius.circular(radius8), // Закругленные углы при фокусе
      borderSide: BorderSide(
        color: greyColor[600]!, // Цвет границы при фокусе
        width: 2,
      ),
    ),
    hintText: hintText,
    hintStyle: textFieldtext,
  );
}
