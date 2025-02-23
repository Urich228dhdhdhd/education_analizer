import 'dart:developer';
import 'package:education_analizer/controlles/performance_page_controller.dart';
import 'package:education_analizer/design/dialog/app_bar.dart';
import 'package:education_analizer/design/dialog/confirmation_dialog.dart';
import 'package:education_analizer/design/dialog/drawer.dart';
import 'package:education_analizer/design/dialog/styles.dart';
import 'package:education_analizer/design/widgets/colors.dart';
import 'package:education_analizer/design/widgets/dimentions.dart';
import 'package:education_analizer/model/mark.dart';
import 'package:education_analizer/model/semester.dart';
import 'package:education_analizer/model/student.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../model/group.dart';

class PerformancePage extends StatelessWidget {
  const PerformancePage({super.key});

  @override
  Widget build(BuildContext context) {
    PerformancePageController controller = Get.find();
    return WillPopScope(
      onWillPop: () async {
        homeRoute();
        return false;
      },
      child: Scaffold(
        backgroundColor: primaryColor,
        appBar: CustomAppBar(role: controller.authController.role.value),
        drawer: CustomDrawer(role: controller.authController.role.value),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(padding14),
            child: Column(
              children: [
                _firstPlace(controller),
                const SizedBox(
                  height: padding12,
                ),
                _secondPlace(controller),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _firstPlace(PerformancePageController controller) {
    return Container(
      padding: const EdgeInsets.all(padding20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius12),
      ),
      child: Column(
        children: [
          _groupSelector(controller),
          const SizedBox(height: padding6),
          _subjectSelector(controller),
          const SizedBox(height: padding6),
          _semesterSelector(controller),
        ],
      ),
    );
  }
}

Widget _groupSelector(PerformancePageController controller) {
  return Obx(() {
    var groupList = controller.groups;
    Group? selectedGroup = controller.selectedGroup.value;
    String displayText =
        selectedGroup != null ? selectedGroup.groupName! : "Выберите группу";

    return Container(
      decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(radius6),
          border: Border.all(color: greyColor[400]!)),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: IconButton(
                  alignment: Alignment.center,
                  onPressed: () async {
                    int currentIndex = groupList
                        .indexWhere((group) => group.id == selectedGroup?.id);
                    if (currentIndex > 0) {
                      await controller
                          .setSelectedGroup(groupList[currentIndex - 1]);
                    }
                  },
                  icon: const Icon(Icons.arrow_back_rounded)),
            ),
            const VerticalDivider(
              width: 1,
            ),
            Expanded(
                flex: 4,
                child: GestureDetector(
                  onTap: () {
                    showSelectionDialog(
                      controller: controller,
                      itemsList: groupList,
                      dialogTitle: "Выберите группу",
                      displayValue: (item) => item.groupName,
                      onSelectItem: (item) async {
                        await controller.setSelectedGroup(item);
                      },
                    );
                  },
                  child: Text(
                    displayText,
                    style: primaryStyle.copyWith(
                        fontSize: 18, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                )),
            const VerticalDivider(
              width: 1,
            ),
            Expanded(
              child: IconButton(
                onPressed: () async {
                  int currentIndex = groupList
                      .indexWhere((group) => group.id == selectedGroup?.id);
                  if (currentIndex < groupList.length - 1) {
                    await controller
                        .setSelectedGroup(groupList[currentIndex + 1]);
                  }
                },
                icon: Transform.rotate(
                  angle: 3.14, // Угол в радианах (180 градусов = π радиан)
                  child: const Icon(Icons.arrow_back_rounded),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  });
}

Widget _subjectSelector(PerformancePageController controller) {
  return Obx(
    () {
      var subjectList = controller.subjects;
      int? selectedSubjectId = controller.selectedSubjectId.value;

      if (subjectList.isEmpty && controller.selectedGroup.value != null) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          decoration: BoxDecoration(
            color: primaryColor,
            border: Border.all(color: greyColor),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            "Нет предметов",
            textAlign: TextAlign.center,
            style: preferTextStyle,
          ),
        );
      }

      String displayText;
      if (selectedSubjectId != null &&
          subjectList.any((subject) => subject.id == selectedSubjectId)) {
        displayText = subjectList
                .firstWhere((subject) => subject.id == selectedSubjectId)
                .subjectNameShort ??
            "Неизвестный предмет";
      } else {
        displayText = "Выберите предмет";
      }

      return Container(
        decoration: BoxDecoration(
            border: Border.all(color: greyColor[400]!),
            color: primaryColor,
            borderRadius: BorderRadius.circular(radius6)),
        child: IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: IconButton(
                    alignment: Alignment.center,
                    onPressed: () async {
                      if (selectedSubjectId != null) {
                        int currentIndex = subjectList.indexWhere(
                            (subject) => subject.id == selectedSubjectId);
                        if (currentIndex > 0) {
                          await controller.setSelectedSubject(
                              subjectList[currentIndex - 1].id!);
                        }
                      }
                    },
                    icon: const Icon(Icons.arrow_back_rounded)),
              ),
              const VerticalDivider(
                width: 1,
              ),
              Expanded(
                  flex: 4,
                  child: GestureDetector(
                    onTap: () {
                      if (subjectList.isNotEmpty) {
                        showSelectionDialog(
                          controller: controller,
                          itemsList: subjectList,
                          dialogTitle: "Выберите группу",
                          displayValue: (item) => item.subjectNameShort,
                          onSelectItem: (item) async {
                            await controller.setSelectedSubject(item.id);
                          },
                        );
                      }
                    },
                    // onTap: () {
                    //   if (semesterList.isNotEmpty) {
                    //     showSelectionDialog(
                    //       controller: controller,
                    //       itemsList: semesterList,
                    //       dialogTitle: "Выберите семестр",
                    //       displayValue: (item) =>
                    //           item.semesterNumber.toString(),
                    //       onSelectItem: (item) async {
                    //         await controller.setSelectedSemester(item);
                    //       },
                    //     );
                    //   }
                    // },
                    child: Text(
                      displayText,
                      style: primaryStyle.copyWith(
                          fontSize: 18, fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                  )),
              const VerticalDivider(
                width: 1,
              ),
              Expanded(
                child: IconButton(
                  onPressed: () async {
                    if (selectedSubjectId != null) {
                      int currentIndex = subjectList.indexWhere(
                          (subject) => subject.id == selectedSubjectId);
                      if (currentIndex < subjectList.length - 1) {
                        await controller.setSelectedSubject(
                            subjectList[currentIndex + 1].id!);
                      }
                    } else if (subjectList.isNotEmpty) {
                      controller.selectedSubjectId.value =
                          subjectList.first.id!;
                    }
                  },
                  icon: Transform.rotate(
                    angle: 3.14, // Угол в радианах (180 градусов = π радиан)
                    child: const Icon(Icons.arrow_back_rounded),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Widget _semesterSelector(PerformancePageController controller) {
  return Obx(
    () {
      if (controller.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator.adaptive(),
        );
      }
      var semesterList = controller.semesterList;

      String displayText =
          controller.selectedSemester.value?.semesterNumber != null
              ? semesterList
                  .firstWhere(
                    (semester) =>
                        semester.id == controller.selectedSemester.value!.id,
                  )
                  .semesterNumber
                  .toString()
              : "Выберите семестр";

      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (semesterList.isNotEmpty) {
                  showSelectionDialog(
                    controller: controller,
                    itemsList: semesterList,
                    dialogTitle: "Выберите семестр",
                    displayValue: (item) => item.semesterNumber.toString(),
                    onSelectItem: (item) async {
                      await controller.setSelectedSemester(item);
                    },
                  );
                }
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                decoration: BoxDecoration(
                    border: Border.all(color: greyColor[400]!),
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(radius6)),
                child: Text(
                  displayText,
                  textAlign: TextAlign.center,
                  style: primaryStyle.copyWith(
                      fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}

Widget _secondPlace(PerformancePageController controller) {
  return Expanded(
    child: Container(
      padding: const EdgeInsets.all(padding14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius12),
      ),
      child: Obx(() {
        if (controller.isLoadingSemester.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (controller.selectedGroup.value == null ||
            controller.selectedSemester.value == null ||
            controller.selectedSubjectId.value == null) {
          return const Center(
            child: Text(
              'Группа не выбрана или данные отсутствуют.',
              textAlign: TextAlign.center,
              style: semestDialogMainTextStyle,
            ),
          );
        }
        if (!controller.isSemesterExist.value) {
          return const Center(
            child: Text(
              'Выбранного семестра не существует',
              textAlign: TextAlign.center,
              style: semestDialogMainTextStyle,
            ),
          );
        }

        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "Выберите тип оценки",
                  style: primaryStyle.copyWith(
                    fontSize: 12,
                    // decoration: TextDecoration.underline,
                    // decorationColor: greyColor,
                    // decorationThickness: 2
                  ),
                ),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 5,
                  children: [
                    Obx(() {
                      return FilterChip(
                        showCheckmark: false,
                        avatar: !controller.isExam.value
                            ? const Icon(
                                Icons.check,
                                color: whiteColor,
                              )
                            : null,
                        backgroundColor: greyColor,
                        selectedColor: primary9Color,
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                        label: const Text(
                          "Семестровая",
                          style: TextStyle(fontSize: 11, color: whiteColor),
                        ),
                        selected: !controller.isExam.value,
                        onSelected: (value) async {
                          if (controller.marks.isEmpty) {
                            showSnackBar(
                              title: "Уведомление",
                              backgroundColor: Colors.amber[700]!,
                              message:
                                  "Для смены статуса для начала выставите отметки",
                            );
                          } else {
                            // Смена статуса на "Семестровая"
                            controller.isExam.value = false;
                            controller.updateMarksIsExamStatus(
                                controller.isExam.value);
                          }
                        },
                      );
                    }),
                    Obx(() {
                      return FilterChip(
                        showCheckmark: false,
                        avatar: controller.isExam.value
                            ? const Icon(
                                Icons.check,
                                color: Colors.white,
                              )
                            : null,
                        backgroundColor: greyColor,
                        selectedColor: primary9Color,
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                        label: const Text(
                          "Итоговая",
                          style: TextStyle(fontSize: 11, color: whiteColor),
                        ),
                        selected: controller.isExam.value, // Если итоговая
                        onSelected: (value) async {
                          if (controller.marks.isEmpty) {
                            showSnackBar(
                              title: "Уведомление",
                              backgroundColor: Colors.amber[700]!,
                              message:
                                  "Для смены статуса для начала выставите отметки",
                            );
                          } else {
                            if (value == true) {
                              // Проверяем, есть ли конфликт с другим семестром
                              Semester? existingSemester = await controller
                                  .hasExamMarks(controller.listOfSubjectsList);
                              if (existingSemester == null) {
                                controller.isExam.value = true;
                                await controller.updateMarksIsExamStatus(
                                    controller.isExam.value);
                              } else {
                                showSnackBar(
                                  title: "Ошибка",
                                  message:
                                      "Статус итоговых оценок уже установлен для семестра номер ${existingSemester.semesterNumber} в ${existingSemester.semesterYear} году.",
                                );
                              }
                            } else {
                              // Снятие статуса "Итоговая"
                              controller.isExam.value = false;
                              controller.updateMarksIsExamStatus(
                                  controller.isExam.value);
                            }
                          }
                        },
                      );
                    })
                  ],
                )
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: controller.students.length,
                itemBuilder: (context, index) {
                  final student = controller.students[index];
                  final mark = controller.marks.firstWhere(
                      (mark) => mark.studentId == student.id,
                      orElse: () => Mark(mark: ""));

                  return ListItem(student: student, mark: mark);
                },
              ),
            ),
          ],
        );
      }),
    ),
  );
}

class ListItem extends StatelessWidget {
  const ListItem({
    super.key,
    required this.student,
    required this.mark,
  });

  final Student student;
  final Mark mark;

  @override
  Widget build(BuildContext context) {
    PerformancePageController controller = Get.find();

    return Padding(
      padding: const EdgeInsets.only(bottom: padding12),
      child: Container(
        decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.circular(radius6),
            border: Border.all(color: greyColor)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: padding10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                textAlign: TextAlign.start,
                "${student.middleName ?? ''} ${student.firstName.toString()[0] ?? ''}. ${student.lastName.toString()[0] ?? ''}.",
                style: subjectMainTextDialogSemesters,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        try {
                          showSelectionDialog(
                            controller: controller,
                            itemsList: controller.ratingOptions,
                            dialogTitle: "Выберите оценку",
                            displayValue: (item) => item,
                            onSelectItem: (item) async {
                              if (mark.mark != "") {
                                await controller.markRepository.updateMark(
                                    mark: Mark(
                                        id: mark.id,
                                        mark: item,
                                        isExam: controller.isExam.value));
                                await controller.loadMarks();
                              } else {
                                await controller.markRepository.createMark(
                                    mark: Mark(
                                        studentId: student.id,
                                        semesterId: controller
                                            .selectedSemester.value!.id,
                                        subjectId:
                                            controller.selectedSubjectId.value,
                                        mark: item,
                                        isExam: controller.isExam.value));
                                await controller.loadMarks();
                              }
                            },
                          );
                        } catch (e) {
                          showSnackBar(title: "Ошибка", message: e.toString());
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: greyColor)),
                        height: 50,
                        width: 80,
                        child: Center(
                            child: Text(
                          "${mark.mark}",
                          style: primaryStyle.copyWith(
                              fontSize: 14, fontWeight: FontWeight.w600),
                        )),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    GestureDetector(
                      child: SvgPicture.asset(
                        "lib/images/delete.svg",
                      ),
                      onTap: () async {
                        try {
                          if (mark.mark! != "") {
                            return showDialog(
                                context: context,
                                builder: (context) {
                                  return ConfirmationDialog(
                                      title: "Удаление оценки",
                                      message:
                                          "Вы действительно хотите удалить: ${mark.mark}",
                                      onConfirm: () async {
                                        await controller.markRepository
                                            .deleteMark(markId: mark.id!);
                                        await controller.loadMarks();
                                      });
                                });
                          }
                        } catch (e) {
                          showSnackBar(title: "Ошибка", message: e.toString());
                        }
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void showSelectionDialog({
  required PerformancePageController controller,
  required List itemsList,
  required String dialogTitle,
  required String Function(dynamic) displayValue,
  required void Function(dynamic) onSelectItem,
}) {
  Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius8),
      ),
      backgroundColor: primaryColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: padding14, vertical: padding10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              dialogTitle,
              style: primaryStyle.copyWith(fontSize: 18),
            ),
            const SizedBox(height: padding14),

            SizedBox(
              height: 300,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: itemsList.length,
                itemBuilder: (context, index) {
                  final item = itemsList[index];
                  return GestureDetector(
                    onTap: () {
                      try {
                        onSelectItem(item);
                        Get.back();
                      } catch (e) {
                        showSnackBar(title: "Ошибка", message: e.toString());
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: whiteColor,
                        border: Border.all(color: greyColor),
                        borderRadius: BorderRadius.circular(radius6),
                      ),
                      child: Text(
                        displayValue(item),
                        style: textFieldtext.copyWith(
                            fontSize: 16,
                            color: greyColor[600],
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Кнопка "Закрыть"
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Get.back(),
                child: const Text(
                  'Закрыть',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
