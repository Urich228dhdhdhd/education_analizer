import 'package:education_analizer/controlles/subject_dialog_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubjectDialog extends StatelessWidget {
  final SubjectDialogController controller;

  const SubjectDialog({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    // Контроллеры для полей ввода
    final shortNameController =
        TextEditingController(text: controller.subjectNameShort);
    final longNameController =
        TextEditingController(text: controller.subjectNameLong);

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
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: shortNameController, // Установка контроллера
                decoration:
                    const InputDecoration(labelText: 'Короткое название'),
              ),
              TextField(
                controller: longNameController, // Установка контроллера
                decoration:
                    const InputDecoration(labelText: 'Длинное название'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  controller.subjectNameShort = shortNameController.text;
                  controller.subjectNameLong = longNameController.text;

                  await controller.saveSubject();
                  Get.back(result: true); // Закрыть диалог и вернуть результат
                },
                child: const Text('Сохранить'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
