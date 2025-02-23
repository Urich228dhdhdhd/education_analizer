import 'package:education_analizer/controlles/absence_dialog_controller.dart';
import 'package:education_analizer/controlles/absence_page_controller.dart';
import 'package:education_analizer/design/dialog/app_bar.dart';
import 'package:education_analizer/design/dialog/drawer.dart';
import 'package:education_analizer/design/dialog/styles.dart';
import 'package:education_analizer/design/widgets/colors.dart';
import 'package:education_analizer/design/widgets/dimentions.dart';
import 'package:education_analizer/model/group.dart';
import 'package:education_analizer/pages/absence_screan/absence_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart' as dp;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class AbsencePage extends StatelessWidget {
  const AbsencePage({super.key});

  @override
  Widget build(BuildContext context) {
    AbsencePageController absencePageController = Get.find();

    return WillPopScope(
      onWillPop: () async {
        homeRoute();
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: primaryColor,
        appBar: CustomAppBar(
          role: absencePageController.authController.role.value,
        ),
        drawer: CustomDrawer(
          role: absencePageController.authController.role.value,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(padding14),
            child: Center(
              child: Column(
                children: [
                  _buildGroupAndDateSelection(absencePageController, context),
                  const SizedBox(
                    height: padding12,
                  ),
                  _buildContentField(absencePageController),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGroupAndDateSelection(
      AbsencePageController controller, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildGroupSelector(controller, context),
          const SizedBox(height: padding12),
          Text(
            "Выберите месяц",
            style: labelTextField,
          ),
          _buildDatePicker(controller, context),
        ],
      ),
    );
  }

  Widget _buildGroupSelector(
      AbsencePageController controller, BuildContext context) {
    return Obx(() {
      var groupList = controller.groups;
      int? selectedGroupId = controller.selectedGroupId.value;

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
                    onPressed: () => _selectPreviousGroup(
                        controller, groupList, selectedGroupId),
                    icon: const Icon(Icons.arrow_back_rounded)),
              ),
              const VerticalDivider(
                width: 1,
              ),
              Expanded(
                  flex: 4,
                  child: GestureDetector(
                    onTap: () => _showGroupSelectionDialog(
                        controller, groupList, context),
                    child: Text(
                      textAlign: TextAlign.center,
                      selectedGroupId == null
                          ? 'Выберите группу'
                          : groupList
                              .firstWhere(
                                  (group) => group.id == selectedGroupId)
                              .groupName
                              .toString(),
                      style: preferTextStyle,
                    ),
                  )),
              const VerticalDivider(
                width: 1,
              ),
              Expanded(
                child: IconButton(
                  onPressed: () =>
                      _selectNextGroup(controller, groupList, selectedGroupId),
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

// Функция для отображения группы
  Widget _buildGroupSelectionField(AbsencePageController controller,
      List groupList, int? selectedGroupId, BuildContext context) {
    return GestureDetector(
      onTap: () => _showGroupSelectionDialog(controller, groupList, context),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        decoration: BoxDecoration(
          color: primary8Color,
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          textAlign: TextAlign.center,
          selectedGroupId == null
              ? 'Выберите группу' // Показывает "Выберите группу", если selectedGroupId == null
              : groupList
                  .firstWhere((group) => group.id == selectedGroupId)
                  .groupName
                  .toString(),
          style: preferTextStyle,
        ),
      ),
    );
  }

  // Функция для показа диалога выбора группы
  void _showGroupSelectionDialog(
      AbsencePageController controller, List groupList, BuildContext context) {
    // showDialog(
    //   context: context,
    //   builder: (BuildContext context) {
    //     return AlertDialog(
    //       title: const Text('Выберите группу'),
    //       content: SizedBox(
    //         height: 200,
    //         width: double.minPositive,
    //         child: SingleChildScrollView(
    //           child: Column(
    //             mainAxisSize: MainAxisSize.min,
    //             children: groupList.map((group) {
    //               return ListTile(
    //                 title: Text(group.groupName.toString()),
    //                 onTap: () {
    //                   controller.setSelectedGroup(group.id!);
    //                   // log("Выбрана группа ${group.groupName} с id:${group.id}");
    //                   Navigator.pop(context);
    //                 },
    //               );
    //             }).toList(),
    //           ),
    //         ),
    //       ),
    //       actions: [
    //         TextButton(
    //           child: const Text('Закрыть'),
    //           onPressed: () {
    //             Navigator.of(context).pop();
    //           },
    //         ),
    //       ],
    //     );
    //   },
    // );
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
                'Выберите группу',
                style: primaryStyle.copyWith(fontSize: 18),
              ),
              const SizedBox(height: padding14),

              SizedBox(
                height: 300,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: groupList.length,
                  itemBuilder: (context, index) {
                    Group group = groupList[index];
                    return GestureDetector(
                      onTap: () {
                        try {
                          controller.setSelectedGroup(group.id!);
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
                          group.groupName!,
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

  // Функция для выбора даты
  Widget _buildDatePicker(
      AbsencePageController controller, BuildContext context) {
    return Obx(() {
      return TextField(
        style: primaryStyle.copyWith(fontSize: 16, fontWeight: FontWeight.w600),
        enabled: controller.selectedGroupId.value != null,
        readOnly: true,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius8),
            borderSide: BorderSide(
              color: greyColor[600]!,
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
              color: greyColor[400]!,
              width: 2,
            ),
          ),

          filled: true,
          fillColor: primaryColor,
          // labelText: 'Выберите месяц',
          // labelStyle: preferTextStyle,
          suffixIcon: IconButton(
            color: greyColor[600],
            icon: const Icon(Icons.calendar_today),
            onPressed: () => _selectDate(controller, context),
          ),
        ),
        controller: TextEditingController(
          text:
              '${controller.dateTime.value.month}/${controller.dateTime.value.year}',
        ),
      );
    });
  }

  Future<void> _selectDate(
      AbsencePageController controller, BuildContext context) async {
    DateTime? result = await showDialog<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // Закругленные углы
          ),
          backgroundColor: Colors.white, // Цвет фона диалога
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: dp.MonthPicker.single(
                  selectedDate: controller.dateTime.value,
                  onChanged: (DateTime dateTime) {
                    Navigator.pop(context, dateTime);
                  },
                  firstDate: DateTime(DateTime.now().year - 5),
                  lastDate: DateTime(DateTime.now().year + 5),
                  datePickerStyles: dp.DatePickerRangeStyles(
                    selectedDateStyle: const TextStyle(
                      color: primary6Color,
                      fontWeight: FontWeight.bold,
                    ),
                    selectedSingleDateDecoration: const BoxDecoration(
                      color: primaryColor,
                      shape: BoxShape.circle,
                    ),
                    defaultDateTextStyle: const TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                    ),
                    disabledDateStyle: const TextStyle(
                      color: Colors.grey, // Стиль для неактивных дат
                    ),
                    currentDateStyle: const TextStyle(
                      color: primaryColor, // Цвет для текущей даты
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
            // padding: const EdgeInsets.all(padding10),
          ),
        );
      },
    );

    if (result != null) {
      controller.setDate(result);
    }
  }

  Widget _buildContentField(AbsencePageController controller) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(padding12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius12),
        ),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (controller.students.isEmpty) {
            return Center(
              child: Text(
                'Данные о учащихся не найдены',
                textAlign: TextAlign.center,
                style: semestDialogMainTextStyle.copyWith(
                    color: greyColor[400]!, fontWeight: FontWeight.w400),
              ),
            );
          }

          return ListView.builder(
            itemCount: controller.students.length,
            itemBuilder: (context, index) {
              final student = controller.students[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Container(
                  decoration: BoxDecoration(
                    color: primary8Color,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ListTile(
                    title: Text(
                      "${student.middleName!} ${student.firstName.toString()[0]}. ${student.lastName.toString()[0]}.",
                      style: subjectMainTextDialogSemesters,
                    ),
                    subtitle: Obx(() {
                      final absenceEntry = controller.absences.firstWhere(
                        (absenceMap) => absenceMap[student.id!] != null,
                        orElse: () => {student.id!: null},
                      );
                      final absence = absenceEntry[student.id!];

                      if (absence != null) {
                        return Text(
                          "Бол:${absence.absenceIllness} Пр:${absence.absenceOrder} Уваж:${absence.absenceResp} Неуваж:${absence.absenceDisresp}",
                          style: absenceSubTitle,
                        );
                      } else {
                        return const Text('Пропуски не отмечены');
                      }
                    }),
                    trailing: IconButton(
                      icon: SvgPicture.asset(
                        "lib/images/edit.svg",
                        height: 24,
                        width: 24,
                        color: greyColor[600],
                      ),
                      onPressed: () async {
                        try {
                          final absence =
                              await controller.absenceRepository.checkAbsence(
                            student.id!,
                            controller.dateTime.value.year,
                            controller.dateTime.value.month,
                          );
                          AbsenceDialogController absenceDialogController =
                              Get.find();
                          absenceDialogController.setAbsence(absence, student);
                          absenceDialogController.isEditMode.value =
                              absence != null;
                          absenceDialogController.selectedDate.value =
                              controller.dateTime.value;

                          Get.dialog(
                            AbsenceDialog(
                              absenceDialogController: absenceDialogController,
                              absenceRepository: controller.absenceRepository,
                            ),
                          ).then((_) async {
                            await controller.loadAbsences();
                          });
                        } catch (e) {
                          showSnackBar(title: "Ошибка", message: e.toString());
                        }
                      },
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }

  void _selectPreviousGroup(
      AbsencePageController controller, List groupList, int? selectedGroupId) {
    int currentIndex =
        groupList.indexWhere((group) => group.id == selectedGroupId);
    if (currentIndex > 0) {
      controller.setSelectedGroup(groupList[currentIndex - 1].id!);
    }
  }

  void _selectNextGroup(
      AbsencePageController controller, List groupList, int? selectedGroupId) {
    int currentIndex =
        groupList.indexWhere((group) => group.id == selectedGroupId);
    if (currentIndex < groupList.length - 1) {
      controller.setSelectedGroup(groupList[currentIndex + 1].id!);
    }
  }
}
