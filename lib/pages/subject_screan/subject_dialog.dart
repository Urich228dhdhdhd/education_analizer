import 'package:education_analizer/controlles/subject_dialog_controller.dart';
import 'package:education_analizer/design/dialog/styles.dart';
import 'package:education_analizer/design/widgets/colors.dart';
import 'package:education_analizer/design/widgets/dimentions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubjectDialog extends StatelessWidget {
  final SubjectDialogController controller;

  const SubjectDialog({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final shortNameController =
        TextEditingController(text: controller.subjectNameShort.value);
    final longNameController =
        TextEditingController(text: controller.subjectNameLong.value);

    return Dialog(
      backgroundColor: primaryColor,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius6)),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: padding14, vertical: padding20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              controller.subjectId == null
                  ? 'Создать предмет'
                  : 'Редактировать предмет',
              style: primaryStyle.copyWith(fontSize: 16),
            ),
            const SizedBox(height: 4),
            Visibility(
              visible: controller.subjectId == null,
              child: Text(
                  "При корректном создании предмета он сразу же станет доступным для выбора. ",
                  style: textFieldtext.copyWith(
                      color: greyColor[600], fontSize: 10)),
            ),
            const SizedBox(height: padding12),
            Text(
              "Аббревиатура",
              style: labelTextField,
            ),
            const SizedBox(
              height: 2,
            ),
            TextField(
              style: labelTextField.copyWith(fontSize: 14),
              keyboardType: TextInputType.text,
              controller: shortNameController,
              decoration: textFieldStyle(hintText: "Введите аббревиатуру"),
            ),
            const SizedBox(height: padding12),
            Text(
              "Полное название",
              style: labelTextField,
            ),
            const SizedBox(
              height: 2,
            ),
            TextField(
              style: labelTextField.copyWith(fontSize: 14),
              keyboardType: TextInputType.text,
              controller: longNameController,
              decoration: textFieldStyle(hintText: "Введите полное название"),
            ),
            const SizedBox(height: padding12),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                      style: ButtonStyle(
                          shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8))),
                          backgroundColor:
                              const WidgetStatePropertyAll(dialogButtonColor)),
                      onPressed: () async {
                        try {
                          controller.subjectNameShort.value =
                              shortNameController.text;
                          controller.subjectNameLong.value =
                              longNameController.text;

                          await controller.saveSubject();

                          Get.back(result: true);
                          if (controller.subjectId == null) {
                            showSnackBar(
                                title: "Успех",
                                message: "Предмет успешно создан",
                                backgroundColor: greenColor[300]!);
                          }
                        } catch (e) {
                          showSnackBar(title: "Ошибка", message: e.toString());
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
    );
  }
}

InputDecoration textFieldStyle({
  required String hintText,
}) {
  return InputDecoration(
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
    hintText: hintText,
    hintStyle: textFieldtext,
  );
}
