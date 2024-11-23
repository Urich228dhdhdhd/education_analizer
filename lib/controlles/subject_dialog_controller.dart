import 'dart:developer';

import 'package:education_analizer/controlles/subject_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubjectDialogController extends GetxController {
  final SubjectPageController subjectPageController;
  int? subjectId;
  var subjectNameShort = ''.obs;
  var subjectNameLong = ''.obs;

  SubjectDialogController({required this.subjectPageController});

  void setSubject(int id, {String? shortName, String? longName}) {
    subjectId = id;
    subjectNameShort.value = shortName ?? '';
    subjectNameLong.value = longName ?? '';
  }

  Future<void> saveSubject() async {
    try {
      if (subjectNameLong.value == "" || subjectNameShort.value == "") {
        await snak(text: "Зополните все поля ввода");
      } else {
        if (subjectId == null) {
          // Создаем новый предмет
          await subjectPageController.subjectRepository
              .createSubject(subjectNameShort.value, subjectNameLong.value);
        } else {
          // Обновляем существующий предмет
          await subjectPageController.subjectRepository.updateSubject(
              subjectId!, subjectNameShort.value, subjectNameLong.value);
        }
      }
    } catch (e) {
      await snak(text: e.toString());
    }
  }
}

Future<void> snak({required String text}) async {
  Get.snackbar(
    "Ошибка",
    duration: const Duration(milliseconds: 1200),
    text,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: const Color.fromRGBO(244, 67, 54, 70),
    colorText: Colors.white,
  );
  await Future.delayed(const Duration(
      milliseconds: 1300)); // Даем время снэкбару, чтобы он закрылся
}
