import 'dart:developer';

import 'package:education_analizer/controlles/group_page_controller.dart';
import 'package:education_analizer/design/dialog/app_bar.dart';
import 'package:education_analizer/design/dialog/drawer.dart';
import 'package:education_analizer/design/dialog/styles.dart';
import 'package:education_analizer/design/widgets/colors.dart';
import 'package:education_analizer/design/widgets/dimentions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../design/dialog/confirmation_dialog.dart';
import 'create_dialog.dart';
import 'update_dialog.dart';

class GroupPage extends StatelessWidget {
  const GroupPage({super.key});

  @override
  Widget build(BuildContext context) {
    GroupPageController groupPageController = Get.find();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Код будет выполнен после того, как виджеты были отрисованы
      await groupPageController.findGroupsByRole();
    });

    return WillPopScope(
        onWillPop: () async {
          homeRoute();
          return false;
        },
        child: Scaffold(
          backgroundColor: primaryColor,
          appBar:
              CustomAppBar(role: groupPageController.authController.role.value),
          drawer:
              CustomDrawer(role: groupPageController.authController.role.value),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(padding14),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FloatingActionButton(
                        heroTag: null,
                        backgroundColor: secColor,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(radius8),
                        ),
                        onPressed: () {
                          bottomFilter(context, groupPageController);
                        },
                        child: SvgPicture.asset(
                          "lib/images/filter.svg",
                          width: 30,
                          height: 30,
                        ),
                      ),
                      Visibility(
                        visible:
                            groupPageController.authController.role.value ==
                                "ADMINISTRATOR",
                        child: FloatingActionButton(
                          heroTag: null,
                          backgroundColor: secColor,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(radius8),
                          ),
                          onPressed: () async {
                            await Get.dialog(
                              const CreateDialog(),
                              barrierDismissible: true,
                            ).then((value) {
                              groupPageController.clearGroupDialogDate();
                            });
                          },
                          child: const Icon(
                            Icons.add,
                            color: whiteColor,
                            size: 36,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: padding14,
                  ),
                  Expanded(child: Obx(() {
                    if (groupPageController.isLoaded.value) {
                      return const Center(
                        child: CircularProgressIndicator.adaptive(),
                      );
                    }
                    return ListView.builder(
                      itemCount: groupPageController.filteredgroups.length,
                      itemBuilder: (context, index) {
                        var groupInfo =
                            groupPageController.filteredgroups[index];
                        return Stack(
                          children: [
                            AspectRatio(
                              aspectRatio: 14 / 8,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 9),
                                child: GestureDetector(
                                  onTap: () async {
                                    groupPageController.selectedGroup.value =
                                        groupInfo.group;
                                    await Get.dialog(
                                        UpdateDialog(group: groupInfo.group!
                                            // groupPageController
                                            //     .selectedGroup.value!

                                            ));
                                    groupPageController
                                        .clearGroupUpdateDialogDate();
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        // border: Border.all(color: borderColor),
                                        color: whiteColor,
                                        borderRadius:
                                            BorderRadius.circular(radius12)),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 5,
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.all(padding10),
                                            child: Text(
                                              textAlign: TextAlign.center,
                                              "${groupInfo.group!.groupName}",
                                              style: primaryStyle.copyWith(
                                                  fontSize: 40,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                            flex: 4,
                                            child: Container(
                                                decoration: const BoxDecoration(
                                                    color: secColor,
                                                    //  borderColor,
                                                    borderRadius: BorderRadius
                                                        .only(
                                                            topRight: Radius
                                                                .circular(
                                                                    radius12),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    radius12))),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      padding10),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const Text(
                                                        "Количество учащихся",
                                                        style: TextStyle(
                                                            fontFamily: "Inter",
                                                            color: whiteColor,
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal),
                                                      ),
                                                      Container(
                                                        margin: const EdgeInsets
                                                            .symmetric(
                                                            vertical: 3),
                                                        height: 2,
                                                        width: 130,
                                                        color: Colors.white70,
                                                      ),
                                                      Text(
                                                        "${groupInfo.studentCount}",
                                                        style: const TextStyle(
                                                            fontFamily: "Inter",
                                                            color: whiteColor,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      const Text(
                                                        "Год начала обучения",
                                                        style: TextStyle(
                                                            fontFamily: "Inter",
                                                            color: whiteColor,
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal),
                                                      ),
                                                      Container(
                                                        margin: const EdgeInsets
                                                            .symmetric(
                                                            vertical: 3),
                                                        height: 2,
                                                        width: 122,
                                                        color: Colors.white70,
                                                      ),
                                                      Text(
                                                        "${groupInfo.group!.startYear}",
                                                        style: const TextStyle(
                                                            fontFamily: "Inter",
                                                            color: whiteColor,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      const Text(
                                                        "Год конца обучения",
                                                        style: TextStyle(
                                                            fontFamily: "Inter",
                                                            color: whiteColor,
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal),
                                                      ),
                                                      Container(
                                                        margin: const EdgeInsets
                                                            .symmetric(
                                                            vertical: 3),
                                                        height: 2,
                                                        width: 118,
                                                        color: Colors.white70,
                                                      ),
                                                      Text(
                                                        "${groupInfo.group!.endYear}",
                                                        style: const TextStyle(
                                                            fontFamily: "Inter",
                                                            color: whiteColor,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ],
                                                  ),
                                                )))
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                                top: 5,
                                right: 0,
                                child: Visibility(
                                  visible: groupPageController
                                          .authController.role.value ==
                                      "ADMINISTRATOR",
                                  child: PopupMenuButton(
                                    padding: EdgeInsets.zero,
                                    color: whiteColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(radius8),
                                    ),
                                    icon:
                                        SvgPicture.asset("lib/images/more.svg"),
                                    menuPadding: EdgeInsets.zero,
                                    itemBuilder: (BuildContext context) =>
                                        <PopupMenuEntry>[
                                      PopupMenuItem(
                                        onTap: () async {
                                          try {
                                            Get.dialog(ConfirmationDialog(
                                                title: "Удаление группы",
                                                message:
                                                    "При удалении группы все её учащиеся и связанные с ними данные будут удалены!",
                                                onConfirm: () async {
                                                  await groupPageController
                                                      .groupRepository
                                                      .deleteGroup(
                                                          groupInfo.group!.id!);
                                                  await groupPageController
                                                      .findGroupsByRole();
                                                  showSnackBar(
                                                      title: "Успех",
                                                      backgroundColor:
                                                          Colors.green[300]!,
                                                      message:
                                                          "Группа усепшно удалена");
                                                }));
                                          } catch (e) {
                                            showSnackBar(
                                                title: "Ошибка",
                                                message: e.toString());
                                          }
                                        },
                                        padding: EdgeInsets.zero,
                                        child: Center(
                                          child: Icon(
                                              Icons.delete_forever_outlined,
                                              color: greyColor[600]),
                                        ),
                                      ),
                                    ],
                                  ),
                                )

                                // GestureDetector(
                                //     onTap: () async {
                                //       groupPageController.selectedGroup.value =
                                //           groupInfo.group;
                                //       await Get.dialog(UpdateDialog(
                                //           group: groupPageController
                                //               .selectedGroup.value!));
                                //       groupPageController
                                //           .clearGroupUpdateDialogDate();
                                //     },
                                //     child:
                                //         SvgPicture.asset("lib/images/more.svg")),
                                )
                          ],
                        );
                      },
                    );
                  }))
                ],
              ),
            ),
          ),
        ));
  }

  Future<void> bottomFilter(
      BuildContext context, GroupPageController groupPageController) {
    return showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(24),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(
                          "lib/images/filter.svg",
                          color: greyColor,
                        ),
                        const SizedBox(
                          width: padding12,
                        ),
                        const Text(
                          "FILTER",
                          style: preferTextStyle,
                        )
                      ],
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.close,
                        color: greyColor,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 25),
                const Text(
                  "Параметры фильтрования",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: groupPageController.groupOptions.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            // Меняем значение фильтра на выбранный индекс
                            groupPageController.selectedGroupFilter.value =
                                index;
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 25,
                                width: 25,
                                child: Obx(() {
                                  return Radio(
                                    fillColor:
                                        WidgetStateProperty.resolveWith<Color>(
                                            (Set<WidgetState> states) {
                                      return (groupPageController
                                                  .selectedGroupFilter.value ==
                                              index)
                                          ? dialogButtonColor
                                          : greyColor;
                                    }),
                                    toggleable: true,
                                    value: index,
                                    groupValue: groupPageController
                                        .selectedGroupFilter.value,
                                    onChanged: (value) {
                                      if (value == null) {
                                        groupPageController
                                            .selectedGroupFilter.value = -1;
                                      } else {
                                        groupPageController
                                            .selectedGroupFilter.value = value;
                                      }
                                    },
                                  );
                                }),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                groupPageController.groupOptions[index],
                                style: const TextStyle(
                                    fontFamily: "Inter",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: TextButton(
                            style: ButtonStyle(
                                shape: WidgetStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(radius8),
                                  ),
                                ),
                                backgroundColor: const WidgetStatePropertyAll(
                                    primary9Color)),
                            onPressed: () {
                              groupPageController.filterGroups();
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Применить",
                              style: labelTextField.copyWith(
                                  fontSize: 16, color: whiteColor),
                            )),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
