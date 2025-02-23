import 'dart:developer';

import 'package:education_analizer/design/dialog/app_bar.dart';
import 'package:education_analizer/design/dialog/drawer.dart';
import 'package:education_analizer/design/dialog/styles.dart';
import 'package:education_analizer/design/widgets/colors.dart';
import 'package:education_analizer/design/widgets/dimentions.dart';
import 'package:education_analizer/model/group.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../controlles/archive_controller.dart';

class ArchivePage extends StatelessWidget {
  const ArchivePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ArchiveController controller = Get.find();
    TextEditingController searchController = TextEditingController();
    searchController.addListener(
      () {
        controller.filterGroupsMainScrean(searchController.text,
            controller.filteredArchivedGroup, controller.archivedGroup);
      },
    );

    return WillPopScope(
        onWillPop: () async {
          homeRoute();
          return false;
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: primaryColor,
          appBar: CustomAppBar(
            role: controller.authController.role.value,
          ),
          drawer: CustomDrawer(role: controller.authController.role.value),
          body: SafeArea(
              child: Padding(
            padding: const EdgeInsets.all(padding14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Список архивированных групп",
                  style: semestDialogMainTextStyle,
                ),
                const SizedBox(height: padding14),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: searchController,
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
                          hintText: "Поиск групп",
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
                          Get.dialog(ArchiveDialog(
                            archivedGroup: controller.archivedGroup,
                          ));
                        },
                        child: SvgPicture.asset(
                          "lib/images/edit.svg",
                          color: whiteColor,
                          width: 24,
                          height: 24,
                        )
                        // const Icon(
                        //   Icons.add,
                        //   color: whiteColor,
                        //   size: 36,
                        // ),
                        ),
                  ],
                ),
                const SizedBox(height: padding20),
                Expanded(
                    child: Container(
                        decoration: BoxDecoration(
                            color: whiteColor,
                            borderRadius: BorderRadius.circular(radius12)),
                        child: Padding(
                          padding: const EdgeInsets.all(padding12),
                          child: Obx(() {
                            if (controller.isLoading.value) {
                              return const Center(
                                child: CircularProgressIndicator.adaptive(),
                              );
                            }
                            if (controller.archivedGroup.isEmpty) {
                              return Center(
                                child: Text(
                                  "Архивированных групп не обнаруженно",
                                  style: textFieldtext.copyWith(fontSize: 16),
                                ),
                              );
                            }
                            return GridView.builder(
                              itemCount:
                                  controller.filteredArchivedGroup.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      mainAxisSpacing: 4,
                                      crossAxisSpacing: 4,
                                      crossAxisCount: 2),
                              itemBuilder: (context, index) {
                                var group =
                                    controller.filteredArchivedGroup[index];
                                return Padding(
                                  padding: const EdgeInsets.all(padding10),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                        color: primaryColor,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(radius8))),
                                    child: Padding(
                                      padding: const EdgeInsets.all(padding6),
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              group.groupName!,
                                              style: const TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Text(
                                              "Года обучения ${group.startYear} - ${group.endYear}",
                                              style:
                                                  const TextStyle(fontSize: 10),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          }),
                        )))
              ],
            ),
          )),
        ));
  }
}

class ArchiveDialog extends StatelessWidget {
  final List<Group> archivedGroup;
  const ArchiveDialog({super.key, required this.archivedGroup});

  @override
  Widget build(BuildContext context) {
    final ArchiveController controller = Get.find();
    // controller.dialogArchivedGroup.value = [...archivedGroup];

    return Dialog(
      backgroundColor: primaryColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(radius12)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: padding14, vertical: padding20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 240,
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                }
                return ListView.builder(
                  itemCount: controller.dialogFilteredArchivedGroup.length,
                  itemBuilder: (context, index) {
                    var group = controller.dialogFilteredArchivedGroup[index];

                    return Obx(() {
                      bool isChecked =
                          controller.dialogArchivedGroup.contains(group);
                      return GestureDetector(
                        onTap: () {
                          if (isChecked) {
                            controller.dialogArchivedGroup.remove(group);
                          } else {
                            controller.dialogArchivedGroup.add(group);
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
                                      controller.dialogArchivedGroup
                                          .remove(group);
                                    } else {
                                      controller.dialogArchivedGroup.add(group);
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
            ),
            const SizedBox(
              height: padding14,
            ),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                      style: ButtonStyle(
                          shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8))),
                          backgroundColor:
                              const WidgetStatePropertyAll(dialogButtonColor)),
                      onPressed: () async {
                        try {
                          var newArchivedGroups = controller.dialogArchivedGroup
                              .toSet()
                              .difference(archivedGroup.toSet())
                              .toList();

                          var activeGroups = archivedGroup
                              .toSet()
                              .difference(
                                  controller.dialogArchivedGroup.toSet())
                              .toList();
                          if (newArchivedGroups.isNotEmpty ||
                              activeGroups.isNotEmpty) {
                            if (newArchivedGroups.isNotEmpty) {
                              for (var group in newArchivedGroups) {
                                await controller.groupRepository.updateGroup(
                                    group: Group(
                                        id: group.id, statusGroup: "ARCHIVE"));
                              }
                            }
                            if (archivedGroup.isNotEmpty) {
                              for (var group in activeGroups) {
                                await controller.groupRepository.updateGroup(
                                    group: Group(
                                        id: group.id, statusGroup: "ACTIVE"));
                              }
                            }

                            await controller.fetchGroup();
                            Get.back();
                            showSnackBar(
                                title: "Успех",
                                duration: const Duration(seconds: 1),
                                backgroundColor: Colors.green[300]!,
                                message: "Группы успешно обнавлены");
                          } else {
                            Get.back();
                          }
                        } catch (e) {
                          showSnackBar(title: "Ошибка", message: e.toString());
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
    );
  }
}
