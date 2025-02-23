import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:education_analizer/controlles/student_page_controller.dart';
import 'package:education_analizer/design/widgets/dimentions.dart';
import 'package:education_analizer/model/student.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class StudentDialogController extends GetxController {
  final StudentPageController studentPageController;

  var studentId = Rxn<int>(); //
  TextEditingController firstName = TextEditingController();
  TextEditingController middleName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController telNumber = TextEditingController();

  var dateBirthday = DateTime.now().obs;
  var groupId = Rxn<int>();
  var isButtonDisabled = false.obs;

  StudentDialogController({required this.studentPageController});

  void setStudent(Student? student) {
    if (student != null) {
      studentId.value = student.id;
      firstName = TextEditingController(text: student.firstName ?? "");
      middleName = TextEditingController(text: student.middleName ?? "");
      lastName = TextEditingController(text: student.lastName ?? "");
      telNumber = TextEditingController(text: student.telNumber ?? "");

      dateBirthday.value = DateTime.parse(student.dateBirthday!);
      groupId.value = student.groupId;
    } else {
      studentId.value = null;
      firstName = TextEditingController(text: "");
      middleName = TextEditingController(text: "");
      lastName = TextEditingController(text: "");
      telNumber = TextEditingController(text: "");
      dateBirthday.value = DateTime.now();
      groupId.value = null;
    }
  }

  // Метод для сохранения студента (создание или обновление)
  Future<void> saveStudent() async {
    if (isButtonDisabled.value) return;
    isButtonDisabled.value = true;
    try {
      if (studentId.value == null) {
        await studentPageController.studentRepository.createStudent({
          'first_name': firstName.text,
          'middle_name': middleName.text,
          'last_name': lastName.text,
          'tel_number': telNumber.text,
          'date_birthday':
              "${dateBirthday.value.toIso8601String().split('T')[0]}T00:00:00.000Z",
          'group_id': groupId.value
        });
      } else {
        await studentPageController.studentRepository
            .updateStudent(studentId.value!, {
          'first_name': firstName.text,
          'middle_name': middleName.text,
          'last_name': lastName.text,
          'tel_number': telNumber.text,
          'date_birthday':
              "${dateBirthday.value.toIso8601String().split('T')[0]}T00:00:00.000Z",
          'group_id': groupId.value
        });
      }
    } on DioException catch (e) {
      log(e.toString());
      isButtonDisabled.value = true;
      Future.delayed(const Duration(seconds: 2), () {
        isButtonDisabled.value = false;
      });
      throw handleDioError(e);
    } finally {
      isButtonDisabled.value = false;
    }
  }
}
