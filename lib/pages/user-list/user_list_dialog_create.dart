import 'dart:developer';

import 'package:education_analizer/design/widgets/images.dart';
import 'package:education_analizer/model/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../controlles/user_list_controller.dart';
import '../../design/dialog/styles.dart';
import '../../design/widgets/colors.dart';
import '../../design/widgets/dimentions.dart';
import '../../model/group.dart';

class CreateUserListDialog extends StatelessWidget {
  const CreateUserListDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final UserListController controller = Get.find();
    TextEditingController surnameController = TextEditingController(text: "");
    TextEditingController nameController = TextEditingController(text: "");
    TextEditingController lastNameController = TextEditingController(text: "");
    TextEditingController loginController = TextEditingController(text: "");
    TextEditingController passwordController = TextEditingController(text: "");
    String role = "CURATOR";

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
                "Создание пользователя",
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
                "Пароль",
                style: labelTextField.copyWith(fontSize: 12),
              ),
              const SizedBox(
                height: 2,
              ),
              Obx(() {
                return TextField(
                  controller: passwordController,
                  keyboardType: TextInputType.text,
                  obscureText: !controller
                      .isPasswordVisible.value, // Переключение видимости
                  style: labelTextField.copyWith(fontSize: 14),
                  decoration: InputDecoration(
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
                    hintText: "Введите пароль",
                    hintStyle: textFieldtext,
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.isPasswordVisible.value
                            ? Icons.sentiment_satisfied_alt_outlined
                            : Icons.sentiment_very_dissatisfied,
                        color: greyColor,
                      ),
                      onPressed: () {
                        controller.isPasswordVisible
                            .toggle(); // Переключаем видимость
                      },
                    ),
                  ),
                );
              }),
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
                width: double.infinity,
                initialSelection: role,
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
                textStyle: labelTextField.copyWith(fontSize: 12),
                menuStyle: const MenuStyle(
                    fixedSize: WidgetStatePropertyAll(Size(60, 120)),
                    backgroundColor: WidgetStatePropertyAll(primaryColor)),
                onSelected: (value) {
                  role = value!;
                },
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
                        text: controller.connectedCreateGroup
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
                              await controller.getGroupsToConnect(null);
                              // log(userGroup.groups.toString());
                              await Get.dialog(
                                  const GroupConnectCreateDialog());
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
                            var createdUser = await controller.userRepository
                                .createUser(User(
                                    firstName: nameController.text,
                                    middleName: surnameController.text,
                                    lastName: lastNameController.text,
                                    username: loginController.text,
                                    password: passwordController.text,
                                    role: role));

                            for (var groupItem
                                in controller.connectedCreateGroup) {
                              await controller.groupRepository.updateGroup(
                                  group: Group(
                                      id: groupItem.id,
                                      curatorId: createdUser.id!));
                            }
                            Get.back();
                            showSnackBar(
                                backgroundColor: Colors.green[300]!,
                                title: "Успех",
                                message:
                                    "Пользователь ${createdUser.firstName} ${createdUser.middleName} успешно создан");
                            await controller.fetchUsersWithGroups();
                            controller.connectedCreateGroup.clear();
                            controller.searchGroupsCreateController.clear();
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

class GroupConnectCreateDialog extends StatelessWidget {
  const GroupConnectCreateDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final UserListController controller = Get.find();
    controller.searchGroupsCreateController.addListener(() {
      controller.filterGroups(controller.searchGroupsCreateController.text,
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
              controller: controller.searchGroupsCreateController,
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
                          controller.connectedCreateGroup.contains(group);
                      return GestureDetector(
                        onTap: () {
                          if (isChecked) {
                            controller.connectedCreateGroup.remove(group);
                          } else {
                            if (controller.connectedCreateGroup.length == 3) {
                              showSnackBar(
                                duration: const Duration(seconds: 1),
                                title: "Ошибка",
                                message: "Нельзя привязать более 3-х групп",
                              );
                              return;
                            }
                            controller.connectedCreateGroup.add(group);
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
                                      controller.connectedCreateGroup
                                          .remove(group);
                                    } else {
                                      if (controller
                                              .connectedCreateGroup.length ==
                                          3) {
                                        showSnackBar(
                                          duration: const Duration(seconds: 1),
                                          title: "Ошибка",
                                          message:
                                              "Нельзя привязать более 3-х групп",
                                        );
                                        return;
                                      }
                                      controller.connectedCreateGroup
                                          .add(group);
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
