import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../controlles/group_page_controller.dart';
import '../../design/dialog/styles.dart';
import '../../design/widgets/colors.dart';
import '../../design/widgets/dimentions.dart';

class CreateDialog extends StatelessWidget {
  const CreateDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    GroupPageController groupPageController = Get.find();

    return Dialog(
      backgroundColor: primaryColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(radius12)),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: padding14, vertical: padding20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Создание группы",
                style: primaryStyle.copyWith(fontSize: 16),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                "При заполнении всех полей и успешном создании группы семестры для нее создаются автоматически",
                style: labelTextField.copyWith(fontSize: 10),
              ),
              const SizedBox(
                height: 12,
              ),
              Text(
                "Название группы",
                style: labelTextField.copyWith(fontSize: 12),
              ),
              const SizedBox(
                height: 2,
              ),
              TextField(
                controller: groupPageController.groupNameController,
                keyboardType: TextInputType.text,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(10),
                  FilteringTextInputFormatter.allow(RegExp(
                      '[a-zA-Zа-яА-Я0-9]')), // Разрешает латиницу, кириллицу и цифры
                ],
                style: labelTextField.copyWith(fontSize: 14),
                decoration: textFieldStyle(
                    hintText: "Введите название",
                    icon: const Icon(
                      Icons.person_2_outlined,
                      color: greyColor,
                    )),
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Год начала обучения",
                          style: labelTextField.copyWith(fontSize: 10),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        TextField(
                          onChanged: (value) {
                            groupPageController.startYear.value = value;
                          },
                          controller: groupPageController.startYearController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(4),
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          style: labelTextField.copyWith(fontSize: 14),
                          decoration: textFieldStyle(
                              hintText: "Год начала",
                              icon: const Icon(
                                Icons.calendar_month_outlined,
                                color: greyColor,
                              )),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10), // Отступ между колонками
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Год окончания обучения",
                          style: labelTextField.copyWith(fontSize: 10),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Obx(() {
                          return TextField(
                            enabled:
                                groupPageController.startYear.value.isNotEmpty,
                            controller: groupPageController.endYearController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(4),
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            style: labelTextField.copyWith(fontSize: 14),
                            decoration: textFieldStyle(
                                hintText: "Год окончания",
                                icon: const Icon(
                                  Icons.calendar_month_outlined,
                                  color: greyColor,
                                )),
                          );
                        })
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              AspectRatio(
                aspectRatio: 2 / 1,
                child: Container(
                  decoration: BoxDecoration(
                      color: whiteColor,
                      border: Border.all(color: greyColor),
                      borderRadius: BorderRadius.circular(radius8)),
                  child: Center(
                      child: Text(
                          style: textFieldtext.copyWith(fontSize: 14),
                          textAlign: TextAlign.center,
                          "Необходимо создать группу для редактирования предметов")),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
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
                        onPressed: () async {
                          try {
                            bool isValid =
                                await groupPageController.validateGroupDate();

                            if (isValid) {
                              Get.back();

                              showSnackBar(
                                  title: 'Успех',
                                  message: 'Группа успешно создана!',
                                  backgroundColor: Colors.green[300]!);
                              await groupPageController.findGroupsByRole();
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

  InputDecoration textFieldStyle(
      {required String hintText, required Icon icon}) {
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
      prefixIcon: icon,
    );
  }
}
