import 'dart:developer';
import 'package:education_analizer/design/dialog/styles.dart';
import 'package:education_analizer/design/widgets/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:education_analizer/controlles/absence_dialog_controller.dart';
import 'package:education_analizer/repository/absence_repository.dart';

class AbsenceDialog extends StatelessWidget {
  final AbsenceDialogController absenceDialogController;
  final AbsenceRepository absenceRepository;

  const AbsenceDialog({
    super.key,
    required this.absenceDialogController,
    required this.absenceRepository,
  });

  // Функция для создания текстового поля
  Widget _buildTextField({
    required String label,
    required String hint,
    required Function(String) onChanged,
    required TextEditingController controller,
  }) {
    return TextField(
      onChanged: onChanged,
      style: inputDialogSemesters,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          labelText: label,
          labelStyle: styleDrawer,
          hintText: hint,
          filled: true,
          fillColor: primary8Color,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          )),
      controller: controller,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Obx(() {
        final studentName =
            "${absenceDialogController.student.value?.middleName ?? ''} ${absenceDialogController.student.value?.firstName ?? ''}";
        return Column(
          children: [
            Text(style: semestDialogMainTextStyle, 'Учащийся: $studentName'),
            Text(
                style: semestDialogMainTextStyle,
                '${absenceDialogController.year.value}.${absenceDialogController.month.value}'),
          ],
        );
      }),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Поле для ввода пропусков по болезни
            Obx(() {
              return _buildTextField(
                label: 'Пропуски по болезни',
                hint: absenceDialogController.absence.value?.absenceIllness
                        ?.toString() ??
                    '',
                onChanged: (value) {
                  absenceDialogController.absence.value?.absenceIllness =
                      int.tryParse(value);
                },
                controller: TextEditingController(
                    text: absenceDialogController.absence.value?.absenceIllness
                            ?.toString() ??
                        ''),
              );
            }),
            const SizedBox(height: 10),

            // Поле для ввода пропусков по приказу
            Obx(() {
              return _buildTextField(
                label: 'Пропуски по приказу',
                hint: absenceDialogController.absence.value?.absenceOrder
                        ?.toString() ??
                    '',
                onChanged: (value) {
                  absenceDialogController.absence.value?.absenceOrder =
                      int.tryParse(value);
                },
                controller: TextEditingController(
                    text: absenceDialogController.absence.value?.absenceOrder
                            ?.toString() ??
                        ''),
              );
            }),
            const SizedBox(height: 10),

            // Поле для ввода пропусков по уважительной причине
            Obx(() {
              return _buildTextField(
                label: 'Пропуски по уважительной причине',
                hint: absenceDialogController.absence.value?.absenceResp
                        ?.toString() ??
                    '',
                onChanged: (value) {
                  absenceDialogController.absence.value?.absenceResp =
                      int.tryParse(value);
                },
                controller: TextEditingController(
                    text: absenceDialogController.absence.value?.absenceResp
                            ?.toString() ??
                        ''),
              );
            }),
            const SizedBox(height: 10),

            // Поле для ввода пропусков по неуважительной причине
            Obx(() {
              return _buildTextField(
                label: 'Пропуски по неуважительной причине',
                hint: absenceDialogController.absence.value?.absenceDisresp
                        ?.toString() ??
                    '',
                onChanged: (value) {
                  absenceDialogController.absence.value?.absenceDisresp =
                      int.tryParse(value);
                },
                controller: TextEditingController(
                    text: absenceDialogController.absence.value?.absenceDisresp
                            ?.toString() ??
                        ''),
              );
            }),
          ],
        ),
      ),
      actionsPadding: const EdgeInsets.symmetric(
          horizontal: 8, vertical: 4), // Уменьшаем отступы вокруг кнопок
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(
                horizontal: 10, vertical: 4), // Компактный внутренний отступ
            minimumSize:
                const Size(0, 32), // Устанавливаем минимальную высоту кнопки
            textStyle: const TextStyle(fontSize: 14), // Меньший размер шрифта
          ),
          child: const Text('Закрыть'),
        ),
        Obx(() {
          return TextButton(
            onPressed: () async {
              if (absenceDialogController.isEditMode.value) {
                await absenceRepository.updateAbsence(
                  absenceDialogController.absence.value!.id!,
                  absenceDialogController.absence.value!,
                );
              } else {
                await absenceRepository.createAbsence(
                  studentId: absenceDialogController.student.value!.id!,
                  year: absenceDialogController.year.value!,
                  month: absenceDialogController.month.value!,
                  absenceIllness:
                      absenceDialogController.absence.value?.absenceIllness ??
                          0,
                  absenceOrder:
                      absenceDialogController.absence.value?.absenceOrder ?? 0,
                  absenceResp:
                      absenceDialogController.absence.value?.absenceResp ?? 0,
                  absenceDisresp:
                      absenceDialogController.absence.value?.absenceDisresp ??
                          0,
                );
              }
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              minimumSize: const Size(0, 32),
              textStyle: const TextStyle(fontSize: 14),
            ),
            child: Text(absenceDialogController.isEditMode.value
                ? 'Обновить'
                : 'Создать'),
          );
        }),
      ],
    );
  }
}
