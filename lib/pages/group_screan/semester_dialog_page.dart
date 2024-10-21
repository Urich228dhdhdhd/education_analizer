import 'package:education_analizer/controlles/semester_selection_controller.dart';
import 'package:education_analizer/design/dialog/styles.dart';
import 'package:education_analizer/design/widgets/colors.dart';
import 'package:education_analizer/model/list_of_subject.dart';
import 'package:education_analizer/repository/listofsubject_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SemesterDialogPage extends StatelessWidget {
  final int groupId;
  final int subjectId;
  final List<ListOfSubject> listOfSubjects;

  const SemesterDialogPage({
    super.key,
    required this.groupId,
    required this.subjectId,
    required this.listOfSubjects,
  });

  @override
  Widget build(BuildContext context) {
    // Инициализация контроллера
    final SemesterSelectionController controller =
        Get.find<SemesterSelectionController>();

    // Инициализируем выбранные семестры на основе переданных предметов
    controller.initializeSelectedSemesters(listOfSubjects);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: primary2Color, // Background color for the dialog
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: 300,
          minHeight: 200,
          maxWidth: 400,
          maxHeight: 400,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Выберите семестры',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1D427A), // Updated color
                  ),
                ),
                const SizedBox(height: 10),
                // Список чекбоксов для 8 семестров
                Column(
                  children: List.generate(8, (index) {
                    int semesterNumber = index + 1;
                    return Obx(() {
                      return CheckboxListTile(
                        title: Text(
                          'Семестр $semesterNumber',
                          style: dialogSemestrTextStyle, // Updated font size
                        ),
                        value: controller.selectedSemesters
                            .contains(semesterNumber),
                        activeColor:
                            const Color(0xFF1D427A), // Checkbox active color
                        onChanged: (bool? value) {
                          if (value != null) {
                            controller.toggleSemester(semesterNumber);
                          }
                        },
                      );
                    });
                  }),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xFF1D427A), // Button color
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
                        // Применение изменений и закрытие диалога
                        await controller.applyChanges(groupId, subjectId);
                        Get.back(result: controller.getSelectedSemesters());
                        print(
                            'Выбранные семестры: ${controller.getSelectedSemesters()}');
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Future<List<int>> show(BuildContext context,
      List<ListOfSubject> listOfSubjects, int groupId, int subjectId) async {
    // Здесь нужно убедиться, что вы создаете экземпляр контроллера с репозиторием
    Get.put(SemesterSelectionController(
        listOfSubjectRepository: Get.find<ListofsubjectRepository>()));

    final result = await Get.dialog<List<int>>(
      SemesterDialogPage(
        groupId: groupId,
        subjectId: subjectId,
        listOfSubjects: listOfSubjects,
      ),
      barrierDismissible: false,
    );

    return result ?? [];
  }
}
