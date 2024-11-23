import 'package:education_analizer/controlles/absence_dialog_controller.dart';
import 'package:education_analizer/controlles/absence_page_controller.dart';
import 'package:education_analizer/design/dialog/app_bar.dart';
import 'package:education_analizer/design/dialog/drawer.dart';
import 'package:education_analizer/design/dialog/styles.dart';
import 'package:education_analizer/design/widgets/colors.dart';
import 'package:education_analizer/design/widgets/dimentions.dart';
import 'package:education_analizer/pages/absence_screan/absence_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart' as dp;
import 'package:get/get.dart';

class AbsencePage extends StatelessWidget {
  const AbsencePage({super.key});

  @override
  Widget build(BuildContext context) {
    AbsencePageController absencePageController = Get.find();

    return WillPopScope(
      onWillPop: () async {
        Get.offAllNamed("/home");
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
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Center(
            child: Column(
              children: [
                _buildGroupAndDateSelection(absencePageController, context),
                const SizedBox(height: 16),
                _buildContentField(absencePageController),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGroupAndDateSelection(
      AbsencePageController controller, BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: 300,
        maxWidth: 400,
      ),
      child: Container(
        margin: const EdgeInsets.only(top: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius32),
          boxShadow: const [
            BoxShadow(
              color: Color(0xFFc2d0e3),
              blurRadius: 8,
              spreadRadius: 5,
              offset: Offset(3, 0),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildGroupSelector(controller, context),
            const SizedBox(height: 10),
            _buildDatePicker(controller, context),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupSelector(
      AbsencePageController controller, BuildContext context) {
    return Obx(() {
      var groupList = controller.groups;
      int? selectedGroupId = controller.selectedGroupId.value;

      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildArrowButton(
            icon: Icons.keyboard_arrow_left,
            onPressed: () =>
                _selectPreviousGroup(controller, groupList, selectedGroupId),
          ),
          const SizedBox(width: 8),
          Expanded(
              child: _buildGroupSelectionField(
                  controller, groupList, selectedGroupId, context)),
          const SizedBox(width: 8),
          _buildArrowButton(
            icon: Icons.keyboard_arrow_right,
            onPressed: () =>
                _selectNextGroup(controller, groupList, selectedGroupId),
          ),
        ],
      );
    });
  }

  // Функция для стрелок выбора группы
  Widget _buildArrowButton(
      {required IconData icon, required VoidCallback onPressed}) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        color: primary8Color,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.black),
        onPressed: onPressed,
      ),
    );
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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Выберите группу'),
          content: SizedBox(
            height: 200,
            width: double.minPositive,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: groupList.map((group) {
                  return ListTile(
                    title: Text(group.groupName.toString()),
                    onTap: () {
                      controller.setSelectedGroup(group.id!);
                      // log("Выбрана группа ${group.groupName} с id:${group.id}");
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
              ),
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Закрыть'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Функция для выбора даты
  Widget _buildDatePicker(
      AbsencePageController controller, BuildContext context) {
    return Obx(() {
      return TextField(
        enabled: controller.selectedGroupId.value != null,
        readOnly: true,
        decoration: InputDecoration(
          filled: true,
          fillColor: primary8Color,
          labelText: 'Выберите месяц',
          labelStyle: preferTextStyle,
          suffixIcon: IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () => _selectDate(controller, context),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
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
          child: Container(
            padding: const EdgeInsets.all(16),
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
        );
      },
    );

    if (result != null) {
      controller.setDate(result);
    }
  }

  Widget _buildContentField(AbsencePageController controller) {
    return Expanded(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: 400,
          maxWidth: 700,
        ),
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(radius32),
            boxShadow: const [
              BoxShadow(
                color: Color(0xFFc2d0e3),
                spreadRadius: 5,
                blurRadius: 10,
                offset: Offset(3, 3),
              ),
            ],
          ),
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (controller.students.isEmpty) {
              return const Center(
                child: Text(
                  'Студенты не найдены',
                  style: semestDialogMainTextStyle,
                ),
              );
            }

            return ListView.builder(
              itemCount: controller.students.length,
              itemBuilder: (context, index) {
                final student = controller.students[index];
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
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
                        icon: const Icon(Icons.edit),
                        onPressed: () async {
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
                          absenceDialogController.year.value =
                              controller.dateTime.value.year;
                          absenceDialogController.month.value =
                              controller.dateTime.value.month;

                          Get.dialog(
                            AbsenceDialog(
                              absenceDialogController: absenceDialogController,
                              absenceRepository: controller.absenceRepository,
                            ),
                          ).then((_) {
                            controller.loadAbsences();
                          });
                        },
                      ),
                    ),
                  ),
                );
              },
            );
          }),
        ),
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
