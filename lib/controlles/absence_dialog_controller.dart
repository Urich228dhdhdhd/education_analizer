import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:education_analizer/model/absence.dart';
import 'package:education_analizer/model/student.dart';

import '../repository/absence_repository.dart';

class AbsenceDialogController extends GetxController {
  final AbsenceRepository absenceRepository;

  var absence = Rxn<Absence>();
  var student = Rxn<Student>();
  // var year = RxnInt(null);
  // var month = RxnInt(null);
  var selectedDate = DateTime.now().obs;
  var isEditMode = false.obs;
  late TextEditingController absenceIllnessController = TextEditingController();
  late TextEditingController absenceOrderController = TextEditingController();
  late TextEditingController absenceRespController = TextEditingController();
  late TextEditingController absenceDisrespController = TextEditingController();
  AbsenceDialogController({
    required this.absenceRepository,
  });

  Future<void> updateAbsence() async {
    bool hasChanges = false;

    int newAbsenceIllness = int.tryParse(absenceIllnessController.text) ?? 0;
    if ((absence.value?.absenceIllness) != newAbsenceIllness) {
      hasChanges = true;
    }

    int newAbsenceOrder = int.tryParse(absenceOrderController.text) ?? 0;
    if ((absence.value?.absenceOrder) != newAbsenceOrder) {
      hasChanges = true;
    }

    int newAbsenceResp = int.tryParse(absenceRespController.text) ?? 0;
    if ((absence.value?.absenceResp) != newAbsenceResp) {
      hasChanges = true;
    }

    int newAbsenceDisresp = int.tryParse(absenceDisrespController.text) ?? 0;
    if ((absence.value?.absenceDisresp) != newAbsenceDisresp) {
      hasChanges = true;
    }

    if (hasChanges) {
      if (isEditMode.value) {
        await absenceRepository.updateAbsence(Absence(
          id: absence.value!.id,
          absenceDisresp: newAbsenceDisresp,
          absenceIllness: newAbsenceIllness,
          absenceOrder: newAbsenceOrder,
          absenceResp: newAbsenceResp,
        ));
      } else {
        await absenceRepository.createAbsence(
          studentId: student.value!.id!,
          year: selectedDate.value.year,
          month: selectedDate.value.month,
          absenceDisresp: newAbsenceDisresp,
          absenceIllness: newAbsenceIllness,
          absenceOrder: newAbsenceOrder,
          absenceResp: newAbsenceResp,
        );
      }
    }
    Get.back();
  }

  void setAbsence(Absence? absenceData, Student? studentData) {
    absence.value = absenceData ?? Absence();
    student.value = studentData;
    isEditMode.value = absenceData != null;

    absenceIllnessController.text =
        absence.value?.absenceIllness?.toString() ?? '';
    absenceOrderController.text = absence.value?.absenceOrder?.toString() ?? '';
    absenceRespController.text = absence.value?.absenceResp?.toString() ?? '';
    absenceDisrespController.text =
        absence.value?.absenceDisresp?.toString() ?? '';
  }
}
