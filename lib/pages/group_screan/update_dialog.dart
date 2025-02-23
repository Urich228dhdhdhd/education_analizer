import 'dart:developer';

import 'package:education_analizer/controlles/group_page_controller.dart';
import 'package:education_analizer/model/list_of_subject.dart';
import 'package:education_analizer/model/semester.dart';
import 'package:education_analizer/model/subject.dart';
import 'package:education_analizer/model/subject_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../design/dialog/styles.dart';
import '../../design/widgets/colors.dart';
import '../../design/widgets/dimentions.dart';
import '../../model/group.dart';
import '../../model/group_info.dart';
import 'semester_dialog_page.dart';

class UpdateDialog extends StatelessWidget {
  final Group group;
  const UpdateDialog({
    super.key,
    required this.group,
  });

  @override
  Widget build(BuildContext context) {
    GroupPageController groupPageController = Get.find();
    TextEditingController namegroupController =
        TextEditingController(text: group.groupName);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      groupPageController.isLoading.value = true;
      await groupPageController.loadSubjectsAndSemesters(group);
      await groupPageController.getSemestersForGroup(group);

      groupPageController.isLoading.value = false;
      groupPageController.searchController.addListener(() {
        groupPageController
            .searchSubjects(groupPageController.searchController.text);
      });
    });

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
                "Редактирование группы",
                style: primaryStyle.copyWith(fontSize: 16),
              ),
              const SizedBox(
                height: 12,
              ),
              Text(
                "Название группы",
                style: labelTextField.copyWith(fontSize: 12),
              ),
              const SizedBox(
                height: 2,
              ),
              TextField(
                controller: namegroupController,
                keyboardType: TextInputType.text,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(10),
                  FilteringTextInputFormatter.allow(RegExp(
                      '[a-zA-Zа-яА-Я0-9]')), // Разрешает латиницу, кириллицу и цифры
                ],
                style: labelTextField.copyWith(fontSize: 14),
                decoration: textFieldStyle(
                    hintText: "Введите название",
                    icon: const Icon(
                      Icons.person_2_outlined,
                      color: greyColor,
                    )),
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: groupPageController.searchController,
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
                        hintText: "Поиск предметов",
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
                      backgroundColor: primary8Color,
                      onPressed: () {
                        subjectBottomSheet(context, groupPageController);
                      },
                      elevation: 0,
                      shape: const RoundedRectangleBorder(
                        side: BorderSide(color: greyColor),
                        borderRadius:
                            BorderRadius.all(Radius.circular(radius12)),
                      ),
                      child: SvgPicture.asset(
                        "lib/images/filter.svg",
                        color: greyColor,
                        width: 25,
                        height: 25,
                      )),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              AspectRatio(
                aspectRatio: 1 / 1,
                child: Container(
                  decoration: BoxDecoration(
                      color: whiteColor,
                      border: Border.all(color: greyColor

                          // secColor
                          ),
                      borderRadius: BorderRadius.circular(radius8)),
                  child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Obx(() {
                        if (groupPageController.isLoading.value) {
                          return const Center(
                            child: CircularProgressIndicator.adaptive(),
                          );
                        }
                        return ListView.builder(
                          itemCount:
                              groupPageController.searchededSubjectInfo.length,
                          itemBuilder: (context, index) {
                            var subjectInfo = groupPageController
                                .searchededSubjectInfo[index];

                            return SubjectItem(
                              group: group,
                              subjectInfo: subjectInfo,
                            );
                          },
                        );
                      })),
                ),
              ),
              const SizedBox(
                height: 16,
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
                            if (group.groupName != namegroupController.text) {
                              Get.back();
                              final response = await groupPageController
                                  .groupRepository
                                  .updateGroup(
                                      group: Group(
                                          id: group.id,
                                          groupName: namegroupController.text));
                              final updateGroup = Group.fromJson(response);
                              log(updateGroup.toString());
                              int index = groupPageController.groups.indexWhere(
                                (element) =>
                                    element.group?.id == updateGroup.id,
                              );
                              int filteredIndex =
                                  groupPageController.filteredgroups.indexWhere(
                                (element) =>
                                    element.group?.id == updateGroup.id,
                              );

                              groupPageController.groups[index] = GroupInfo(
                                group: updateGroup,
                                studentCount: groupPageController
                                    .groups[index].studentCount,
                              );
                              groupPageController
                                  .filteredgroups[filteredIndex] = GroupInfo(
                                group: updateGroup,
                                studentCount: groupPageController
                                    .filteredgroups[filteredIndex].studentCount,
                              );

                              showSnackBar(
                                  title: "Успех",
                                  message: "Глуппа успешно обнавлена",
                                  backgroundColor: Colors.green[300]!);
                              // groupPageController.findGroupsByRole();
                              // await groupPageController.findGroupsByRole();
                            } else {
                              Get.back();
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

  Future<void> subjectBottomSheet(
      BuildContext context, GroupPageController groupPageController) {
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
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
                    itemCount: groupPageController.subjectOptions.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            groupPageController.selectedSubjectFilter.value =
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
                                                  .selectedSubjectFilter
                                                  .value ==
                                              index)
                                          ? dialogButtonColor
                                          : greyColor;
                                    }),
                                    toggleable: true,
                                    value: index,
                                    groupValue: groupPageController
                                        .selectedSubjectFilter.value,
                                    onChanged: (value) {
                                      if (value == null) {
                                        groupPageController
                                            .selectedSubjectFilter.value = -1;
                                      } else {
                                        groupPageController
                                            .selectedSubjectFilter
                                            .value = value;
                                      }
                                    },
                                  );
                                }),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                groupPageController.subjectOptions[index],
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
                              groupPageController.filterSubjects();
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

  InputDecoration textFieldStyle(
      {required String hintText, required Icon icon}) {
    return InputDecoration(
      filled: true, // Включение фона
      fillColor: primary8Color, // Цвет фона
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius8), // Закругленные углы
        borderSide: const BorderSide(
          color: greyColor, // Цвет границы
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
      prefixIcon: icon,
    );
  }
}

class SubjectItem extends StatelessWidget {
  const SubjectItem({
    super.key,
    required this.subjectInfo,
    required this.group,
  });

  final SubjectInfo subjectInfo;
  final Group group;

  @override
  Widget build(BuildContext context) {
    GroupPageController groupPageController = Get.find();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius8),
          border: Border.all(color: greyColor),
        ),
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${subjectInfo.subject.subjectNameShort}"),
                    Text(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      "${subjectInfo.subject.subjectNameLong}",
                      style: const TextStyle(fontSize: 9),
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: Container(
                child: Text(
                    textAlign: TextAlign.center,
                    subjectInfo.semesters
                        .map((semester) => semester.semesterNumber)
                        .join(" | ")),
              )),
              GestureDetector(
                onTap: () async {
                  List<ListOfSubject> listOfSubjects = await groupPageController
                      .listofsubjectRepository
                      .getListOfSubjectsBySubjectGroupId(
                          group.id!, subjectInfo.subject.id!);
                  log(listOfSubjects.toString());

                  List<int> selectedSemesters = await SemesterDialogPage.show(
                      context,
                      listOfSubjects, // Передаем полученный список предметов
                      group.id!,
                      subjectInfo.subject.id!,
                      groupPageController.groupSemesters);
                  if (selectedSemesters.isNotEmpty) {
                    await groupPageController.updateGroupInfoByGroup(
                        selectedSemesters[0], selectedSemesters[1]);
                  }
                  // await dialogController.fetchAllListOfSubjectByGroupId(
                  //     dialogController.groupId.value!);
                },
                child: Container(
                  child: SvgPicture.asset("lib/images/edit.svg"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
