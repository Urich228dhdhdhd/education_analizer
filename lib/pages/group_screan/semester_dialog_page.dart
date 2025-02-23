import 'dart:developer';

import 'package:education_analizer/controlles/semester_selection_controller.dart';
import 'package:education_analizer/design/dialog/styles.dart';
import 'package:education_analizer/design/widgets/colors.dart';
import 'package:education_analizer/design/widgets/dimentions.dart';
import 'package:education_analizer/model/list_of_subject.dart';
import 'package:education_analizer/model/semester.dart';
import 'package:education_analizer/repository/listofsubject_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SemesterDialogPage extends StatelessWidget {
  final int groupId;
  final int subjectId;
  final List<ListOfSubject> listOfSubjects; // Список предметов с семестрами
  final List<Semester> semesterList; // Список всех семестров

  const SemesterDialogPage({
    super.key,
    required this.groupId,
    required this.subjectId,
    required this.listOfSubjects,
    required this.semesterList,
  });

  @override
  Widget build(BuildContext context) {
    final SemesterSelectionController controller =
        Get.find<SemesterSelectionController>();

    controller.initializeSelectedSemesters(listOfSubjects);
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      backgroundColor: primaryColor,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(padding14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Выберите семестры',
                  style:
                      primaryStyle.copyWith(fontSize: 16, color: Colors.black)),
              Container(
                // color: greyColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(semesterList.length, (index) {
                    var semester = semesterList[index];

                    return Obx(() {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: CheckboxListTile(
                          tileColor: whiteColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(
                              color: Colors.grey,
                              width: 1,
                            ),
                          ),
                          title: Text(
                            'Семестр ${semester.semesterNumber} - ${semester.semesterYear}',
                            style: const TextStyle(
                                fontSize: 16,
                                fontFamily: "Inter",
                                fontWeight: FontWeight.w500),
                          ),
                          value: controller.selectedSemesters
                              .contains(semester.id),
                          activeColor: const Color(0xFF1D427A),
                          onChanged: (bool? value) {
                            if (value != null) {
                              controller.toggleSemester(semester.id!);
                            }
                          },
                        ),
                      );
                    });
                  }),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1D427A), // Button color
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(15), // Rounded corners
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                    ),
                    child: const Text(
                      'ОК',
                      style: TextStyle(color: Colors.white), // Text color
                    ),
                    onPressed: () async {
                      try {
                        await controller.applyChanges(groupId, subjectId);
                        Get.back(result: [groupId, subjectId]);
                      } catch (e) {
                        showSnackBar(title: "Ошибка", message: e.toString());
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Future<List<int>> show(
      BuildContext context,
      List<ListOfSubject> listOfSubjects,
      int groupId,
      int subjectId,
      List<Semester> semesterList) async {
    // Здесь нужно убедиться, что вы создаете экземпляр контроллера с репозиторием
    Get.put(SemesterSelectionController(
        listOfSubjectRepository: Get.find<ListofsubjectRepository>()));

    final result = await Get.dialog<List<int>>(
      SemesterDialogPage(
        groupId: groupId,
        subjectId: subjectId,
        listOfSubjects: listOfSubjects,
        semesterList: semesterList,
      ),
      barrierDismissible: true, // С возможностью закрытия при клике вне диалога
    );

    return result ?? [];
  }
}
