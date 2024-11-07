import 'dart:developer';
import 'package:education_analizer/controlles/performance_page_controller.dart';
import 'package:education_analizer/design/dialog/app_bar.dart';
import 'package:education_analizer/design/dialog/confirmation_dialog.dart';
import 'package:education_analizer/design/dialog/drawer.dart';
import 'package:education_analizer/design/dialog/styles.dart';
import 'package:education_analizer/design/widgets/colors.dart';
import 'package:education_analizer/design/widgets/dimentions.dart';
import 'package:education_analizer/model/mark.dart';
import 'package:education_analizer/model/semester.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PerformancePage extends StatelessWidget {
  const PerformancePage({super.key});

  @override
  Widget build(BuildContext context) {
    PerformancePageController controller = Get.find();
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: CustomAppBar(role: controller.authController.role.value),
      drawer: CustomDrawer(role: controller.authController.role.value),
      body: Center(
        child: Column(
          children: [
            _firstPlace(controller),
            _secondPlace(controller),
          ],
        ),
      ),
    );
  }

  ConstrainedBox _firstPlace(PerformancePageController controller) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: 300,
        maxWidth: 400,
      ),
      child: Container(
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius32),
          boxShadow: const [
            BoxShadow(
              color: Color(0xFFc2d0e3),
              blurRadius: 8,
              spreadRadius: 5,
              offset: Offset(3, 0),
            )
          ],
        ),
        child: Column(
          children: [
            _groupSelector(controller),
            const SizedBox(height: 5),
            _subjectSelector(controller),
            const SizedBox(height: 5),
            _semesterSelector(controller),
          ],
        ),
      ),
    );
  }
}

Widget _groupSelector(PerformancePageController controller) {
  return Obx(() {
    var groupList = controller.groups;
    int? selectedGroupId = controller.selectedGroupId.value;
    String displayText = selectedGroupId != null
        ? groupList
                .firstWhere((group) => group.id == selectedGroupId)
                .groupName ??
            "Неизвестная группа"
        : "Выберите группу";

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildArrowButton(
          icon: Icons.keyboard_arrow_left,
          onPressed: () {
            int currentIndex =
                groupList.indexWhere((group) => group.id == selectedGroupId);
            if (currentIndex > 0) {
              controller.setSelectedGroup(groupList[currentIndex - 1].id!);
            }
          },
        ),
        const SizedBox(width: 8),
        Expanded(
          child: GestureDetector(
            onTap: () {
              showSelectionDialog(
                controller: controller,
                itemsList: groupList,
                dialogTitle: "Выберите группу",
                displayValue: (item) => item.groupName,
                onSelectItem: (item) {
                  controller.setSelectedGroup(item.id);
                },
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              decoration: BoxDecoration(
                color: primaryColor,
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                displayText,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 1, 1, 1),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        _buildArrowButton(
          icon: Icons.keyboard_arrow_right,
          onPressed: () {
            int currentIndex =
                groupList.indexWhere((group) => group.id == selectedGroupId);
            if (currentIndex < groupList.length - 1) {
              controller.setSelectedGroup(groupList[currentIndex + 1].id!);
            }
          },
        ),
      ],
    );
  });
}

Widget _subjectSelector(PerformancePageController controller) {
  return Obx(
    () {
      var subjectList = controller.subjects;
      int? selectedSubjectId = controller.selectedSubjectId.value;
      // Проверка на пустоту subjectList
      if (subjectList.isEmpty && controller.selectedGroupId.value != null) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          decoration: BoxDecoration(
            color: primaryColor,
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            "Нет предметов",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 1, 1, 1),
            ),
          ),
        );
      }

      String displayText;
      if (selectedSubjectId != null &&
          subjectList.any((subject) => subject.id == selectedSubjectId)) {
        displayText = subjectList
                .firstWhere((subject) => subject.id == selectedSubjectId)
                .subjectNameShort ??
            "Неизвестный предмет";
      } else {
        displayText = "Выберите предмет";
      }

      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildArrowButton(
            icon: Icons.keyboard_arrow_left,
            onPressed: () {
              if (selectedSubjectId != null) {
                int currentIndex = subjectList
                    .indexWhere((subject) => subject.id == selectedSubjectId);
                if (currentIndex > 0) {
                  controller
                      .setSelectedSubject(subjectList[currentIndex - 1].id!);
                }
              }
            },
          ),
          const SizedBox(width: 8),
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (subjectList.isNotEmpty) {
                  showSelectionDialog(
                    controller: controller,
                    itemsList: subjectList,
                    dialogTitle: "Выберите предмет",
                    displayValue: (item) => item.subjectNameShort,
                    onSelectItem: (item) {
                      controller.setSelectedSubject(item.id);
                    },
                  );
                }
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                decoration: BoxDecoration(
                  color: primaryColor,
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  displayText,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 1, 1, 1),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          _buildArrowButton(
            icon: Icons.keyboard_arrow_right,
            onPressed: () {
              // Логика выбора следующего предмета
              if (selectedSubjectId != null) {
                int currentIndex = subjectList
                    .indexWhere((subject) => subject.id == selectedSubjectId);
                if (currentIndex < subjectList.length - 1) {
                  controller
                      .setSelectedSubject(subjectList[currentIndex + 1].id!);
                }
              } else if (subjectList.isNotEmpty) {
                // Если ничего не выбрано, выбираем первый предмет
                controller.selectedSubjectId.value = subjectList.first.id!;
              }
            },
          ),
        ],
      );
    },
  );
}

Widget _semesterSelector(PerformancePageController controller) {
  return Obx(
    () {
      var semesterList = controller.semesters;
      int? selectedSemesterId = controller.selectedSemesterId.value;

      // Получаем текст для отображения
      String displayText = selectedSemesterId != null
          ? semesterList
              .firstWhere(
                (semester) => semester.id == selectedSemesterId,
              )
              .semesterNumber
              .toString()
          : "Выберите семестр";

      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // // Левая кнопка-стрелка для выбора предыдущего семестра
          // _buildArrowButton(
          //   icon: Icons.keyboard_arrow_left,
          //   onPressed: () {
          //     int currentIndex = semesterList
          //         .indexWhere((semester) => semester.id == selectedSemesterId);
          //     if (currentIndex > 0) {
          //       // Выбираем предыдущий семестр
          //       controller
          //           .setSelectedSemester(semesterList[currentIndex - 1].id!);
          //     }
          //   },
          // ),
          // const SizedBox(width: 8),

          // Центральная область для отображения выбранного семестра
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (semesterList.isNotEmpty) {
                  showSelectionDialog(
                    controller: controller,
                    itemsList: semesterList,
                    dialogTitle: "Выберите семестр",
                    displayValue: (item) => item.semesterNumber.toString(),
                    onSelectItem: (item) {
                      controller.setSelectedSemester(item.id);
                    },
                  );
                }
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                decoration: BoxDecoration(
                  color: primaryColor,
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  displayText,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 1, 1, 1),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),

          // // Правая кнопка-стрелка для выбора следующего семестра
          // _buildArrowButton(
          //   icon: Icons.keyboard_arrow_right,
          //   onPressed: () {
          //     int currentIndex = semesterList
          //         .indexWhere((semester) => semester.id == selectedSemesterId);
          //     if (currentIndex < semesterList.length - 1) {
          //       // Выбираем следующий семестр
          //       controller
          //           .setSelectedSemester(semesterList[currentIndex + 1].id!);
          //     }
          //   },
          // ),
          Expanded(
            child: _buildDatePicker(controller, Get.context!),
          ),
        ],
      );
    },
  );
}

// Функция для стрелок выбора группы
Widget _buildArrowButton(
    {required IconData icon, required VoidCallback onPressed}) {
  return Container(
    decoration: BoxDecoration(
      border: Border.all(color: Colors.black),
      color: primary8Color,
      shape: BoxShape.circle,
    ),
    child: IconButton(
      icon: Icon(icon, color: Colors.black),
      onPressed: onPressed,
    ),
  );
}

void showSelectionDialog({
  required PerformancePageController controller,
  required List itemsList,
  required String dialogTitle,
  required String Function(dynamic) displayValue,
  required void Function(dynamic) onSelectItem,
}) {
  Get.dialog(
    AlertDialog(
      title: Text(dialogTitle),
      content: SizedBox(
        height: 200,
        width: double.minPositive,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: itemsList.map((item) {
              return ListTile(
                title: Text(displayValue(item)),
                onTap: () {
                  onSelectItem(item);
                  Get.back(); // закрывает диалог
                },
              );
            }).toList(),
          ),
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Закрыть'),
          onPressed: () {
            Get.back();
          },
        ),
      ],
    ),
  );
}

Widget _secondPlace(PerformancePageController controller) {
  return Expanded(
    child: ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: 400,
        maxWidth: 700,
      ),
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius32),
          boxShadow: const [
            BoxShadow(
              color: Color(0xFFc2d0e3),
              spreadRadius: 5,
              blurRadius: 10,
              offset: Offset(3, 3),
            ),
          ],
        ),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (controller.selectedGroupId.value == null ||
              controller.selectedSemesterId.value == null ||
              controller.selectedSubjectId.value == null ||
              controller.year.value == null) {
            return const Center(
              child: Text(
                'Группа не выбрана или данные отсутствуют.',
                textAlign: TextAlign.center,
                style: semestDialogMainTextStyle,
              ),
            );
          }

          final selectedGroup = controller.groups.firstWhere(
            (group) => group.id == controller.selectedGroupId.value,
          );

          return Column(
            children: [
              Text(
                'Список учащихся группы: ${selectedGroup.groupName}',
                textAlign: TextAlign.center,
                style: semestDialogMainTextStyle,
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: controller.students.length,
                  itemBuilder: (context, index) {
                    final student = controller.students[index];
                    final mark = controller.marks.firstWhere(
                        (mark) => mark.studentId == student.id,
                        orElse: () => Mark(mark: ""));

                    return Card(
                      color: primary8Color,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${student.middleName ?? ''} ${student.firstName ?? ''} ${student.lastName ?? ''}",
                              style: subjectMainTextDialogSemesters,
                            ),
                            const Text(
                              "Средний балл, хз для чего",
                              style: shortSubName,
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 100,
                              child: GestureDetector(
                                onTap: () {
                                  List<String> ratingOptions = [
                                    '1',
                                    '2',
                                    '3',
                                    '4',
                                    '5',
                                    '6',
                                    '7',
                                    '8',
                                    '9',
                                    '10',
                                    'Зачет',
                                    'Незачет'
                                  ];

                                  showSelectionDialog(
                                    controller: controller,
                                    itemsList: ratingOptions,
                                    dialogTitle: "Выберите оценку",
                                    displayValue: (item) => item,
                                    onSelectItem: (item) async {
                                      if (mark.mark != "") {
                                        controller.markRepository.updateMark(
                                            markId: mark.id!,
                                            studentId: null,
                                            semesterId: null,
                                            subjectId: null,
                                            mark: item);
                                        controller.loadMarks();
                                      } else {
                                        Semester semester = await controller
                                            .semesterRepository
                                            .getSemesterBySemesterYear(
                                                semesterNumber: controller
                                                    .semesters
                                                    .firstWhere((semester) =>
                                                        semester.id! ==
                                                        controller
                                                            .selectedSemesterId
                                                            .value)
                                                    .semesterNumber!,
                                                year: controller
                                                    .year.value!.year);
                                        controller.markRepository.createMark(
                                            studentId: student.id!,
                                            semesterId: semester.id!,
                                            subjectId: controller
                                                .selectedSubjectId.value!,
                                            mark: item);
                                        controller.loadMarks();
                                      }
                                    },
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: primaryColor,
                                    border: Border.all(color: Colors.black),
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  child: Text(
                                    mark.mark!,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 1, 1, 1),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () async {
                                if (mark.mark! != "") {
                                  return showDialog(
                                      context: context,
                                      builder: (context) {
                                        return ConfirmationDialog(
                                            title: "Удаление оценки",
                                            message:
                                                "Вы действительно хотите удалить: ${mark.mark}",
                                            onConfirm: () {
                                              controller.markRepository
                                                  .deleteMark(markId: mark.id!);
                                              controller.loadMarks();
                                            });
                                      });
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }),
      ),
    ),
  );
}

// Функция для построения виджета выбора даты
Widget _buildDatePicker(
    PerformancePageController controller, BuildContext context) {
  return Obx(() {
    // Создаем TextEditingController вне виджета Obx, чтобы избежать повторной инициализации
    final TextEditingController textEditingController = TextEditingController(
      text: controller.year.value?.year.toString() ?? "",
    );

    return TextField(
      readOnly: true, // Поле только для чтения
      decoration: InputDecoration(
        filled: true,
        fillColor: primaryColor,
        labelText: 'Выберите год', // Текст метки
        suffixIcon: IconButton(
            icon: const Icon(Icons.calendar_today), // Иконка выбора даты
            onPressed: () {
              if (controller.selectedSemesterId.value != null) {
                _selectDate(controller, context);
              }
            }),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      controller: textEditingController, // Привязываем контроллер текста
    );
  });
}

// Функция для показа диалога выбора даты
Future<void> _selectDate(
    PerformancePageController controller, BuildContext context) async {
  DateTime? selectedDate = DateTime.now(); // Начальная дата - текущая

  // Показать диалог выбора года
  DateTime? result = await showDialog<DateTime>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Выберите год"),
        content: SizedBox(
          width: 250,
          height: 250,
          child: YearPicker(
            firstDate: DateTime(DateTime.now().year - 5),
            lastDate: DateTime(DateTime.now().year + 5),
            selectedDate: selectedDate,
            onChanged: (DateTime dateTime) {
              // Сохраняем выбранный год и закрываем диалог
              selectedDate = dateTime;
              Navigator.pop(context, dateTime); // Возвращаем выбранный год
            },
          ),
        ),
      );
    },
  );

  // Устанавливаем выбранную дату в контроллер
  if (result != null) {
    controller.setSelecetedDate(result); // Обновляем дату в контроллере
  }
}
