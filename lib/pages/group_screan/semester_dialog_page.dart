import 'package:education_analizer/controlles/semester_selection_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SemesterDialogPage extends StatelessWidget {
  final List<int> initialSelectedSemesters; // Изначально выбранные семестры
  final int groupId; // ID группы
  final int subjectId; // ID предмета

  const SemesterDialogPage({
    super.key,
    required this.initialSelectedSemesters,
    required this.groupId,
    required this.subjectId,
  });

  @override
  Widget build(BuildContext context) {
    // Инициализация контроллера и начальных данных
    final SemesterSelectionController controller =
        Get.put(SemesterSelectionController());
    controller.initializeSelectedSemesters(initialSelectedSemesters);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: 300, // Минимальная ширина
          minHeight: 200, // Минимальная высота
          maxWidth: 400, // Максимальная ширина
          maxHeight: 400, // Максимальная высота
        ),
        child: SingleChildScrollView(
          // Оборачиваем в прокручиваемый виджет
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Выберите семестры',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                // Список чекбоксов для 8 семестров
                Obx(() {
                  return Column(
                    children: List.generate(8, (index) {
                      int semesterNumber = index + 1;
                      return CheckboxListTile(
                        title: Text('Семестр $semesterNumber'),
                        value: controller.selectedSemesters
                            .contains(semesterNumber),
                        onChanged: (bool? value) {
                          controller.toggleSemester(semesterNumber);
                        },
                      );
                    }),
                  );
                }),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      child: const Text('Отмена'),
                      onPressed: () {
                        Get.back(result: initialSelectedSemesters);
                      },
                    ),
                    TextButton(
                      child: const Text('ОК'),
                      onPressed: () {
                        Get.back(result: controller.getSelectedSemesters());
                        // Обработайте выбранные семестры здесь, если необходимо
                        print(
                            'Выбранные семестры для группы $groupId и предмета $subjectId: ${controller.getSelectedSemesters()}');
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

  // Статический метод для показа диалога
  static Future<List<int>> show(BuildContext context,
      List<int> selectedSemesters, int groupId, int subjectId) async {
    return await Get.dialog<List<int>>(
          SemesterDialogPage(
            initialSelectedSemesters: selectedSemesters,
            groupId: groupId,
            subjectId: subjectId,
          ),
          barrierDismissible: false,
        ) ??
        selectedSemesters;
  }
}
