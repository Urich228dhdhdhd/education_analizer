import 'package:education_analizer/controlles/subject_dialog_controller.dart';
import 'package:education_analizer/design/dialog/styles.dart';
import 'package:education_analizer/design/widgets/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubjectDialog extends StatelessWidget {
  final SubjectDialogController controller;

  const SubjectDialog({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    // Контроллеры для полей ввода
    final shortNameController =
        TextEditingController(text: controller.subjectNameShort.value);
    final longNameController =
        TextEditingController(text: controller.subjectNameLong.value);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: 300, // Задайте минимальную ширину
          maxWidth: 400, // Максимальная ширина (опционально)
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                controller.subjectId == null
                    ? 'Создать предмет'
                    : 'Редактировать предмет',
                style: semestDialogMainTextStyle,
              ),
              const SizedBox(height: 15),
              TextField(
                style: inputDialogSemesters,
                controller: shortNameController, // Установка контроллера
                decoration: InputDecoration(
                  labelStyle: styleDrawer,
                  labelText: 'Абревиатура',
                  filled: true,
                  fillColor: primary8Color,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                style: inputDialogSemesters,
                controller: longNameController, // Установка контроллера
                decoration: InputDecoration(
                    labelText: 'Полное название',
                    labelStyle: styleDrawer,
                    filled: true,
                    fillColor: primary8Color,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    )),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(
                        const Color(0xFF1D427A),
                      ),
                    ),
                    onPressed: () async {
                      controller.subjectNameShort.value =
                          shortNameController.text;
                      controller.subjectNameLong.value =
                          longNameController.text;

                      await controller.saveSubject();
                      Get.back(
                          result: true); // Закрыть диалог и вернуть результат
                    },
                    child: const Text(
                      'Сохранить',
                      style: dropdownButtonTextStyle,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
