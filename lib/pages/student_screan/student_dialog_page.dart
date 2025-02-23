import 'dart:developer';

import 'package:education_analizer/controlles/student_dialog_page_controller.dart';
import 'package:education_analizer/design/dialog/styles.dart';
import 'package:education_analizer/design/widgets/colors.dart';
import 'package:education_analizer/design/widgets/dimentions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class StudentDialog extends StatelessWidget {
  final StudentDialogController controller;

  const StudentDialog({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: primaryColor,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius12)),
      child: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: padding14, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                controller.studentId.value == null
                    ? 'Создание учащегося'
                    : 'Редактирование учащегося',
                style: primaryStyle.copyWith(fontSize: 16),
              ),
              const SizedBox(height: 4),
              Visibility(
                  visible: controller.studentId.value == null,
                  child: Text(
                    "При грамотном заполнении всех полей учащийся успешно создастся",
                    style: textFieldtext.copyWith(
                        color: greyColor[600], fontSize: 10),
                  )),
              const SizedBox(height: padding12),
              Text(
                "Фамилия",
                style: labelTextField,
              ),
              const SizedBox(
                height: 2,
              ),
              TextField(
                style: labelTextField.copyWith(fontSize: 14),
                keyboardType: TextInputType.text,
                controller: controller.middleName,
                decoration: textFieldStyle(hintText: "Введите фамилию"),
              ),
              const SizedBox(
                height: padding12,
              ),
              Text(
                "Имя",
                style: labelTextField,
              ),
              const SizedBox(
                height: 2,
              ),
              TextField(
                style: labelTextField.copyWith(fontSize: 14),
                controller: controller.firstName,
                decoration: textFieldStyle(hintText: "Введите имя"),
              ),
              const SizedBox(
                height: padding12,
              ),
              Text(
                "Отчество",
                style: labelTextField,
              ),
              const SizedBox(
                height: 2,
              ),
              TextField(
                style: labelTextField.copyWith(fontSize: 14),
                controller: controller.lastName,
                decoration: textFieldStyle(hintText: "Введите отчество"),
              ),
              const SizedBox(
                height: padding12,
              ),
              Text(
                "Телефон",
                style: labelTextField,
              ),
              const SizedBox(
                height: 2,
              ),
              TextField(
                style: labelTextField.copyWith(fontSize: 14),
                controller: controller.telNumber,
                decoration: textFieldStyle(hintText: "+375 (xx) xxx-xx-xx"),
              ),
              const SizedBox(
                height: padding12,
              ),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Дата рождения",
                          style: labelTextField,
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Obx(() {
                          final formattedDate = DateFormat('yyyy-MM-dd')
                              .format(controller.dateBirthday.value);
                          return _buildDateField(formattedDate, context);
                        }),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Группа",
                          style: labelTextField,
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Obx(() {
                          return DropdownMenu(
                            menuStyle: MenuStyle(
                                backgroundColor:
                                    const WidgetStatePropertyAll(whiteColor),
                                padding: const WidgetStatePropertyAll(
                                    EdgeInsets.zero),
                                shape: WidgetStatePropertyAll(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(radius12)))),
                            textStyle: labelTextField.copyWith(fontSize: 14),
                            inputDecorationTheme: InputDecorationTheme(
                              filled: true,
                              fillColor: primary8Color,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(radius8),
                                borderSide: BorderSide(
                                  color: greyColor[400]!,
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
                              hintStyle: textFieldtext,
                            ),
                            initialSelection: controller.groupId.value,
                            dropdownMenuEntries:
                                controller.studentPageController.groups.entries
                                    .map((entry) => DropdownMenuEntry(
                                          value: entry.key,
                                          label: entry.value,
                                        ))
                                    .toList(),
                            onSelected: (value) {
                              controller.groupId.value = value;
                            },
                          );
                        })
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: padding12),
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
                        onPressed: controller.isButtonDisabled.value
                            ? null
                            : () async {
                                try {
                                  try {
                                    await controller.saveStudent();
                                    Get.back(result: true);
                                    if (controller.studentId.value == null) {
                                      showSnackBar(
                                          title: "Успех",
                                          message: "Учащийся успешно создан",
                                          backgroundColor: greenColor[300]!);
                                    }
                                  } catch (e) {
                                    showSnackBar(
                                      title: "Ошибка",
                                      message: e.toString(),
                                      duration:
                                          const Duration(milliseconds: 1200),
                                      snackPosition: SnackPosition.BOTTOM,
                                      backgroundColor:
                                          const Color.fromRGBO(244, 67, 54, 70),
                                    );
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

  Widget _buildDateField(String formattedDate, BuildContext context) {
    return TextField(
      style: labelTextField.copyWith(fontSize: 14),

      readOnly: true,
      // style: inputDialogSemesters,
      decoration: InputDecoration(
        filled: true, // Включение фона
        fillColor: primary8Color, // Цвет фона
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius8), // Закругленные углы
          borderSide: BorderSide(
            color: greyColor[400]!, // Цвет границы
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
        hintText: "Дата рождения",
        hintStyle: textFieldtext,
        suffixIcon: IconButton(
          icon: Icon(
            Icons.calendar_today,
            color: greyColor[600]!,
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

  InputDecoration textFieldStyle({
    required String hintText,
  }) {
    return InputDecoration(
      filled: true, // Включение фона
      fillColor: primary8Color, // Цвет фона
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius8), // Закругленные углы
        borderSide: BorderSide(
          color: greyColor[400]!, // Цвет границы
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
    );
  }
}
