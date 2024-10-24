import 'package:education_analizer/controlles/student_dialog_page_controller.dart';
import 'package:education_analizer/design/dialog/styles.dart';
import 'package:education_analizer/design/widgets/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class StudentDialog extends StatelessWidget {
  final StudentDialogController controller;

  const StudentDialog({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minWidth: 300,
              maxWidth: 400,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  controller.studentId.value == null
                      ? 'Создать студента'
                      : 'Редактировать студента',
                  style: semestDialogMainTextStyle,
                ),
                const SizedBox(height: 10),

                // Объединение полей ФИО в одну строку
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(controller.middleName, 'Фамилия'),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildTextField(controller.firstName, 'Имя'),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildTextField(controller.lastName, 'Отчество'),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                _buildTextField(controller.telNumber, 'Телефон'),
                const SizedBox(height: 5),

                // Поля для выбора даты и группы на одной линии
                Row(
                  children: [
                    Expanded(
                      child: Obx(() {
                        final formattedDate = DateFormat('yyyy-MM-dd')
                            .format(controller.dateBirthday.value);
                        return _buildDateField(formattedDate, context);
                      }),
                    ),
                    const SizedBox(width: 8), // Отступ между полями
                    Expanded(
                      child: _buildDropdownField(),
                    ),
                  ],
                ),
                const SizedBox(height: 5),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(
                        const Color(0xFF1D427A),
                      ),
                    ),
                    onPressed: () async {
                      // Сохраняем студента
                      await controller.saveStudent();
                      Get.back(result: true);
                    },
                    child: const Text(
                      'Сохранить',
                      style: dropdownButtonTextStyle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(RxString textObservable, String label) {
    return Obx(() {
      return TextField(
        style: inputDialogSemesters,
        onChanged: (value) => textObservable.value = value,
        decoration: InputDecoration(
          labelStyle: styleDrawer,
          labelText: label,
          filled: true,
          fillColor: primary8Color,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          hintText: textObservable.value.isEmpty ? '' : null,
        ),
        controller: TextEditingController(text: textObservable.value)
          ..selection = TextSelection.fromPosition(
              TextPosition(offset: textObservable.value.length)),
      );
    });
  }

  Widget _buildDateField(String formattedDate, BuildContext context) {
    return TextField(
      readOnly: true,
      style: inputDialogSemesters,
      decoration: InputDecoration(
        labelStyle: styleDrawer,
        labelText: 'Дата рождения',
        filled: true,
        fillColor: primary8Color,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        suffixIcon: IconButton(
          icon: const Icon(
            Icons.calendar_today,
            color: primary3Color,
          ),
          onPressed: () async {
            DateTime? selectedDate = await showDatePicker(
              context: context,
              initialDate: controller.dateBirthday.value,
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
            );

            if (selectedDate != null) {
              controller.dateBirthday.value =
                  selectedDate; // Обновляем состояние
            }
          },
        ),
      ),
      controller: TextEditingController(text: formattedDate)
        ..selection = TextSelection.fromPosition(
            TextPosition(offset: formattedDate.length)),
    );
  }

  Widget _buildDropdownField() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: primary3Color, // Цвет границы
          width: 1.0, // Ширина границы
        ),
        borderRadius: BorderRadius.circular(12), // Скругление углов

        color: primary8Color, // Цвет фона
      ),
      padding: const EdgeInsets.symmetric(
          horizontal: 12), // Отступы внутри контейнера
      child: Obx(() {
        return DropdownButton<int>(
          value: controller.groupId.value,
          hint: const Text(
            'Выберите группу',
            style: inputDialogSemesters,
          ),
          isExpanded: true,
          underline: const SizedBox(),
          dropdownColor: primary8Color, // Цвет выпадающего списка
          items: controller.studentPageController.groups.entries
              .map((entry) => DropdownMenuItem<int>(
                    value: entry.key,
                    child: Text(
                      entry.value,
                      style: inputDialogSemesters,
                    ),
                  ))
              .toList(),
          onChanged: (value) {
            controller.groupId.value = value; // Обновляем состояние группы
          },
        );
      }),
    );
  }
}
