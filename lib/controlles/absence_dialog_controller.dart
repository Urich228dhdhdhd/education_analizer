import 'dart:developer';

import 'package:get/get.dart';
import 'package:education_analizer/model/absence.dart';
import 'package:education_analizer/model/student.dart';

class AbsenceDialogController extends GetxController {
  var absence = Rxn<Absence>();
  var student = Rxn<Student>();
  var year = RxnInt(null);
  var month = RxnInt(null);
  var isEditMode =
      false.obs; // Флаг для отслеживания режима (создание или редактирование)

  void setAbsence(Absence? absenceData, Student? studentData) {
    absence.value = absenceData ?? Absence();
    student.value = studentData;
    isEditMode.value = absenceData != null;
    // Логируем установленные значения
    log("Absence set: ${absence.value}");
    log("Student set: ${student.value?.middleName}");
  }
}
