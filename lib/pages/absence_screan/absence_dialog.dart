import 'dart:developer';

import 'package:education_analizer/design/dialog/styles.dart';
import 'package:education_analizer/design/widgets/colors.dart';
import 'package:education_analizer/design/widgets/dimentions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  Widget buildTextField({
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
          labelStyle: preferTextStyle,
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
    AbsenceDialogController absenceDialogController = Get.find();
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
              "Пропуски учащегося",
              style: preferTextStyle.copyWith(fontSize: 16),
            ),
            Row(
              children: [
                Text(
                  "Учащийся: ",
                  style: preferTextStyle.copyWith(
                      fontSize: 14, fontWeight: FontWeight.w400),
                ),
                Text(
                    "${absenceDialogController.student.value!.middleName}.${absenceDialogController.student.value!.firstName![0]}.${absenceDialogController.student.value!.lastName![0]}",
                    style: preferTextStyle.copyWith(
                        color: greyColor[600],
                        fontSize: 14,
                        fontWeight: FontWeight.w400))
              ],
            ),
            Row(
              children: [
                Text(
                  "Дата : ",
                  style: preferTextStyle.copyWith(
                      fontSize: 14, fontWeight: FontWeight.w400),
                ),
                Text(
                    "${absenceDialogController.selectedDate.value.month}.${absenceDialogController.selectedDate.value.year}",
                    style: preferTextStyle.copyWith(
                        color: greyColor[600],
                        fontSize: 14,
                        fontWeight: FontWeight.w400))
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "По болезни",
                        style: labelTextField.copyWith(fontSize: 9),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      TextField(
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^[0-9]*$')), // Разрешаем только цифры
                        ],
                        style: textFieldtext.copyWith(
                            fontSize: 14,
                            color: greyColor[600],
                            fontWeight: FontWeight.bold),
                        controller:
                            absenceDialogController.absenceIllnessController,
                        decoration: textFieldStyle(
                            hintText: "", pathToImage: "lib/images/illnes.svg"),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "По уважительной причине",
                        style: labelTextField.copyWith(fontSize: 9),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      TextField(
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^[0-9]*$')), // Разрешаем только цифры
                        ],
                        style: textFieldtext.copyWith(
                            fontSize: 14,
                            color: greyColor[600],
                            fontWeight: FontWeight.bold),
                        controller:
                            absenceDialogController.absenceRespController,
                        decoration: textFieldStyle(
                            hintText: "",
                            pathToImage: "lib/images/respect.svg"),
                      )
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "По приказу",
                        style: labelTextField.copyWith(fontSize: 9),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      TextField(
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^[0-9]*$')), // Разрешаем только цифры
                        ],
                        style: textFieldtext.copyWith(
                            fontSize: 14,
                            color: greyColor[600],
                            fontWeight: FontWeight.bold),
                        controller:
                            absenceDialogController.absenceOrderController,
                        decoration: textFieldStyle(
                            hintText: "", pathToImage: "lib/images/order.svg"),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "По неуважительной причине",
                        style: labelTextField.copyWith(fontSize: 9),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      TextField(
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^[0-9]*$')),
                        ],
                        style: textFieldtext.copyWith(
                            fontSize: 14,
                            color: greyColor[600],
                            fontWeight: FontWeight.bold),
                        controller:
                            absenceDialogController.absenceDisrespController,
                        decoration: textFieldStyle(
                            hintText: "",
                            pathToImage: "lib/images/unrespect.svg"),
                      )
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: padding12,
            ),
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
                          await absenceDialogController.updateAbsence();
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

InputDecoration textFieldStyle(
    {required String hintText, required String pathToImage}) {
  return InputDecoration(
    prefixIconConstraints: const BoxConstraints(minHeight: 24, minWidth: 24),
    prefixIcon: Padding(
      padding: const EdgeInsets.all(8.0),
      child: SvgPicture.asset(
        color: greyColor,
        pathToImage,
      ),
    ),
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
