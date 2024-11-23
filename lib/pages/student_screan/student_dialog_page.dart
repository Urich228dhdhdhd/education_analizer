import 'dart:developer';

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
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                          controller.middleName, 'Фамилия', TextInputType.text),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildTextField(
                          controller.firstName, 'Имя', TextInputType.text),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildTextField(
                          controller.lastName, 'Отчество', TextInputType.text),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                _buildTextField(
                    controller.telNumber, 'Телефон', TextInputType.phone),
                const SizedBox(height: 5),
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
                      if (await _validateFields()) {
                        try {
                          await controller.saveStudent();

                          Get.back(result: true);
                        } catch (e) {
                          Get.snackbar(
                            "Ошибка",
                            "Произошла ошибка при сохранении данных.",
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor:
                                const Color.fromRGBO(244, 67, 54, 70),
                            colorText: Colors.white,
                          );
                        }
                      } else {
                        Get.snackbar(
                          "Ошибка",
                          "Пожалуйста, заполните все обязательные поля.",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor:
                              const Color.fromRGBO(244, 67, 54, 70),
                          colorText: Colors.white,
                        );
                      }
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

  Widget _buildTextField(
      RxString textObservable, String label, TextInputType inputType) {
    return Obx(() {
      return TextField(
        keyboardType: inputType,
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

  // Метод для проверки обязательных полей
  Future<bool> _validateFields() async {
    if (controller.middleName.value.isEmpty) {
      return false; // Фамилия не заполнена
    }
    if (controller.firstName.value.isEmpty) {
      return false; // Имя не заполнено
    }
    if (controller.lastName.value.isEmpty) {
      return false; // Отчество не заполнено
    }
    if (controller.telNumber.value.isEmpty) {
      return false; // Телефон не заполнен
    }
    if (controller.groupId.value == null) {
      return false; // Группа не выбрана
    }
    return true; // Все поля заполнены
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
              locale: const Locale("ru", "RU"),
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
