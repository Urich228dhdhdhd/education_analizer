import 'dart:developer';
import 'package:education_analizer/controlles/absence_dialog_controller.dart';
import 'package:education_analizer/controlles/absence_page_controller.dart';
import 'package:education_analizer/design/dialog/app_bar.dart';
import 'package:education_analizer/design/dialog/drawer.dart';
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

    return Scaffold(
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
    );
  }

  // Функция для выбора группы и даты
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

  // Функция для выбора группы
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
          border: Border.all(color: Colors.black), // Задаёт цвет рамки
          borderRadius: BorderRadius.circular(12), // Скругление углов
        ),
        child: Text(
          textAlign: TextAlign.center,
          selectedGroupId == null
              ? 'Выберите группу' // Показывает "Выберите группу", если selectedGroupId == null
              : groupList
                  .firstWhere((group) => group.id == selectedGroupId)
                  .groupName
                  .toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 1, 1, 1),
          ),
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

  // Функция для показа диалога выбора даты
  Future<void> _selectDate(
      AbsencePageController controller, BuildContext context) async {
    DateTime? result = await showDialog<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: dp.MonthPicker.single(
            selectedDate: controller.dateTime.value,
            onChanged: (DateTime dateTime) {
              Navigator.pop(context, dateTime);
            },
            firstDate: DateTime(DateTime.now().year - 100),
            lastDate: DateTime(DateTime.now().year + 100),
            datePickerStyles: dp.DatePickerRangeStyles(
              selectedDateStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              selectedSingleDateDecoration: const BoxDecoration(
                color: primaryColor,
                shape: BoxShape.circle,
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
                child: CircularProgressIndicator(), // Индикатор загрузки
              );
            }

            if (controller.students.isEmpty) {
              return const Center(
                child: Text(
                  'Студенты не загружены',
                  style: TextStyle(fontSize: 16),
                ),
              );
            }

            // Отображаем список студентов
            return ListView.builder(
              itemCount: controller.students.length,
              itemBuilder: (context, index) {
                final student = controller.students[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 6, horizontal: 4), // Отступы между элементами
                  child: Container(
                    decoration: BoxDecoration(
                      color: primary8Color, // Цвет фона
                      borderRadius:
                          BorderRadius.circular(12), // Скругление углов
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 6,
                          offset: const Offset(0, 3), // Смещение тени
                        ),
                      ],
                    ),
                    child: ListTile(
                      title: Text(
                        "${student.middleName!} ${student.firstName} ${student.lastName}",
                        style:
                            const TextStyle(color: Colors.black), // Цвет текста
                      ),
                      subtitle: Obx(() {
                        final absenceEntry = controller.absences.firstWhere(
                          (absenceMap) => absenceMap[student.id!] != null,
                          orElse: () => {
                            student.id!: null
                          }, // Возвращаем null, если нет пропусков
                        );
                        final absence = absenceEntry[student.id!];

                        if (absence != null) {
                          return Text(
                            "Больничный лист:${absence.absenceIllness} Приказ:${absence.absenceOrder} Уважительная:${absence.absenceResp} Неуважительная:${absence.absenceDisresp}",
                            style: const TextStyle(
                                color:
                                    Colors.black), // Цвет текста для пропусков
                          );
                        } else {
                          return const Text(
                              'Пропуски не отмечены'); // Если данных о пропусках нет
                        }
                      }),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () async {
                          // Проверяем, есть ли уже данные о пропусках для данного студента
                          final absence =
                              await controller.absenceRepository.checkAbsence(
                            student.id!,
                            controller.dateTime.value.year,
                            controller.dateTime.value.month,
                          );
                          AbsenceDialogController absenceDialogController =
                              Get.find();
                          // Устанавливаем данные в контроллер для диалога
                          absenceDialogController.setAbsence(absence, student);
                          absenceDialogController.isEditMode.value =
                              absence != null;
                          absenceDialogController.year.value =
                              controller.dateTime.value.year;
                          absenceDialogController.month.value =
                              controller.dateTime.value.month;

                          // Вызываем диалог
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AbsenceDialog(
                                absenceDialogController:
                                    absenceDialogController,
                                absenceRepository: controller.absenceRepository,
                              );
                            },
                          );
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

  // Функция для выбора предыдущей группы
  void _selectPreviousGroup(
      AbsencePageController controller, List groupList, int? selectedGroupId) {
    int currentIndex =
        groupList.indexWhere((group) => group.id == selectedGroupId);
    if (currentIndex > 0) {
      controller.setSelectedGroup(groupList[currentIndex - 1].id!);
    }
  }

  // Функция для выбора следующей группы
  void _selectNextGroup(
      AbsencePageController controller, List groupList, int? selectedGroupId) {
    int currentIndex =
        groupList.indexWhere((group) => group.id == selectedGroupId);
    if (currentIndex < groupList.length - 1) {
      controller.setSelectedGroup(groupList[currentIndex + 1].id!);
    }
  }
}
