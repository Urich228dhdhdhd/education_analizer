import 'dart:developer';

import 'package:education_analizer/controlles/student_page_controller.dart';
import 'package:education_analizer/model/student.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StudentDialogController extends GetxController {
  final StudentPageController studentPageController;

  var studentId = Rxn<int>(); //
  var firstName = ''.obs;
  var middleName = ''.obs;
  var lastName = ''.obs;
  var telNumber = ''.obs;
  var dateBirthday = DateTime.now().obs;
  var groupId = Rxn<int>();

  StudentDialogController({required this.studentPageController});

  void setStudent(Student? student) {
    if (student != null) {
      studentId.value = student.id;
      firstName.value = student.firstName ?? "";
      middleName.value = student.middleName ?? "";
      lastName.value = student.lastName ?? "";
      telNumber.value = student.telNumber ?? "";
      dateBirthday.value = DateTime.parse(student.dateBirthday!);
      groupId.value = student.groupId;
    } else {
      studentId.value = null;
      firstName.value = '';
      middleName.value = '';
      lastName.value = '';
      telNumber.value = '';
      dateBirthday.value = DateTime.now();
      groupId.value = null;
    }
  }

  // Метод для сохранения студента (создание или обновление)
  Future<void> saveStudent() async {
    try {
      log("cread");
      if (studentId.value == null) {
        await studentPageController.studentRepository.createStudent({
          'first_name': firstName.value.trim(),
          'middle_name': middleName.value.trim(),
          'last_name': lastName.value.trim(),
          'tel_number': telNumber.value.trim(),
          'date_birthday':
              "${dateBirthday.value.toIso8601String().split('T')[0]}T00:00:00.000Z",
          'group_id': groupId.value
        });
      } else {
        log("red");
        await studentPageController.studentRepository
            .updateStudent(studentId.value!, {
          'first_name': firstName.value.trim(),
          'middle_name': middleName.value.trim(),
          'last_name': lastName.value.trim(),
          'tel_number': telNumber.value.trim(),
          'date_birthday':
              "${dateBirthday.value.toIso8601String().split('T')[0]}T00:00:00.000Z",
          'group_id': groupId.value
        });
      }
    } catch (e) {}
  }
}
