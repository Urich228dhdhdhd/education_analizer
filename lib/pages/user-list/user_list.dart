import 'package:education_analizer/controlles/user_list_controller.dart';
import 'package:education_analizer/design/dialog/app_bar.dart';
import 'package:education_analizer/design/dialog/confirmation_dialog.dart';
import 'package:education_analizer/design/dialog/drawer.dart';
import 'package:education_analizer/design/widgets/colors.dart';
import 'package:education_analizer/design/widgets/dimentions.dart';
import 'package:education_analizer/model/user_group.dart';
import 'package:education_analizer/pages/user-list/user_list_dialog_update.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../design/dialog/styles.dart';
import 'user_list_dialog_create.dart';

class UserListPage extends StatelessWidget {
  const UserListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final UserListController controller = Get.find();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await controller.fetchUsersWithGroups();
    });

    controller.searchController.addListener(() {
      controller.filter(controller.searchController.text,
          controller.filteredUserGroups, controller.userGroups);
    });

    return Scaffold(
      backgroundColor: primaryColor,
      appBar: CustomAppBar(role: controller.authController.role.value),
      drawer: CustomDrawer(role: controller.authController.role.value),
      body: SafeArea(
          child: Padding(
              padding: const EdgeInsets.all(padding14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Список пользователей',
                    style: semestDialogMainTextStyle,
                  ),
                  const SizedBox(
                    height: padding14,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controller.searchController,
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
                            hintText: "Поиск пользователей",
                            hintStyle: textFieldtext.copyWith(fontSize: 14),
                            suffixIcon: const Icon(
                              Icons.search,
                              color: greyColor,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      FloatingActionButton(
                        heroTag: null,
                        backgroundColor: secColor,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(radius8),
                        ),
                        onPressed: () async {
                          await Get.dialog(const CreateUserListDialog());
                        },
                        child: const Icon(
                          Icons.add,
                          color: whiteColor,
                          size: 36,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(
                        child: CircularProgressIndicator.adaptive(),
                      );
                    }
                    return Expanded(
                      child: ListView.builder(
                        itemCount: controller.filteredUserGroups.length,
                        itemBuilder: (context, index) {
                          UserGroup userGroup =
                              controller.filteredUserGroups[index];

                          return UserItem(userGroup: userGroup);
                        },
                      ),
                    );
                  })
                ],
              ))),
    );
  }
}

class UserItem extends StatelessWidget {
  const UserItem({
    super.key,
    required this.userGroup,
  });

  final UserGroup userGroup;

  @override
  Widget build(BuildContext context) {
    final UserListController controller = Get.find();

    return Padding(
      padding: const EdgeInsets.only(bottom: padding12),
      child: Container(
        decoration: BoxDecoration(
            color: whiteColor, borderRadius: BorderRadius.circular(10)),
        child: Padding(
            padding: const EdgeInsets.all(padding10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 240,
                      child: Text(
                          "${userGroup.user!.middleName} ${userGroup.user!.firstName} ${userGroup.user!.lastName}",
                          style: preferTextStyle.copyWith(fontSize: 15),
                          overflow: TextOverflow
                              .ellipsis, // Многоточие, если текст не помещается
                          maxLines: 1),
                    ),
                    const SizedBox(
                        height: 1,
                        width: 100,
                        child: Divider(
                          thickness: 2,
                          height: 1,
                        )),
                    const SizedBox(
                      height: padding10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Группы: ",
                          style: preferTextStyle.copyWith(
                              fontSize: 14, color: primary6Color),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(4)),
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Row(
                              children: userGroup.groups!.isNotEmpty
                                  ? userGroup.groups!
                                      .asMap()
                                      .entries
                                      .map<Widget>((entry) {
                                      final isLast = entry.key ==
                                          userGroup.groups!.length - 1;
                                      return Row(
                                        children: [
                                          Text(
                                            entry.value.groupName ??
                                                "Без названия",
                                            style: preferTextStyle.copyWith(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          if (!isLast)
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 4),
                                              child: Container(
                                                height: 16,
                                                width: 2,
                                                decoration: BoxDecoration(
                                                    color: primary10Color,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            1)),
                                              ),
                                            ),
                                        ],
                                      );
                                    }).toList()
                                  : [
                                      Text(
                                        "Нет групп",
                                        style: preferTextStyle.copyWith(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500),
                                      )
                                    ],
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          UserGroup copiedUserGroup = UserGroup(
                            user: userGroup.user,
                            groups: List.from(userGroup.groups ?? []),
                          );

                          Get.dialog(UpdateUserListDialog(
                            userGroup: copiedUserGroup,
                          ));
                        },
                        icon: SvgPicture.asset("lib/images/edit.svg")),
                    IconButton(
                        onPressed: () async {
                          Get.dialog(ConfirmationDialog(
                              title: "Удаление пользователя",
                              message:
                                  "При удалении пользователя все связанные с ним данные будут удалены, а связанные группы отвязаны!",
                              onConfirm: () async {
                                try {
                                  await controller.userRepository
                                      .deleteUser(userGroup.user!.id!);
                                  await controller.fetchUsersWithGroups();
                                } catch (e) {
                                  showSnackBar(
                                      title: "Ошибка", message: e.toString());
                                }
                              }));
                        },
                        icon: SvgPicture.asset("lib/images/delete.svg")),
                  ],
                )
              ],
            )),
      ),
    );
  }
}
