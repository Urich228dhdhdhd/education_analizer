import 'dart:developer';

import 'package:education_analizer/controlles/group_dialog_page_controller.dart';
import 'package:education_analizer/design/dialog/styles.dart';
import 'package:education_analizer/design/widgets/colors.dart';
import 'package:education_analizer/model/list_of_subject.dart';
import 'package:education_analizer/pages/group_screan/semester_dialog_page.dart';
import 'package:education_analizer/repository/listofsubject_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GroupDialog extends StatelessWidget {
  final int? groupId;
  final String? initialGroupName;

  const GroupDialog({
    super.key,
    this.groupId,
    this.initialGroupName,
  });

  @override
  Widget build(BuildContext context) {
    final GroupDialogPageController dialogController = Get.find();
    final ListofsubjectRepository listofsubjectRepository = Get.find();

    final TextEditingController groupNameController =
        TextEditingController(text: initialGroupName ?? "");
    final TextEditingController searchController = TextEditingController();
    dialogController.groupId.value = groupId;

    // Загружаем данные после первого кадра
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Начинаем загрузку
      dialogController.isLoading.value = true;

      await Future.delayed(const Duration(milliseconds: 100));

      // Загружаем данные
      await dialogController.fetchAllSubjects();
      if (dialogController.groupId.value != null) {
        await dialogController
            .fetchAllListOfSubjectByGroupId(dialogController.groupId.value!);
      }

      dialogController.isLoading.value = false; // Завершаем загрузку
    });

    // Слушаем изменения в поле поиска
    searchController.addListener(() {
      dialogController.filterSubjects(searchController.text);
    });

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: primary2Color,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 400,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDialogTitle(dialogController),
                const SizedBox(height: 10),
                _buildGroupNameField(groupNameController),
                Obx(() {
                  return Visibility(
                    visible: dialogController.groupId.value != null,
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        _buildSearchField(searchController),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 20),
                _buildSubjectList(dialogController, listofsubjectRepository),
                const SizedBox(height: 20),
                _buildSaveButton(dialogController, groupNameController),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Метод для построения заголовка диалогового окна
  Widget _buildDialogTitle(GroupDialogPageController dialogController) {
    return Text(
      dialogController.groupId.value == null
          ? 'Создать новую группу'
          : 'Редактировать группу',
      style: dialogMainTextStyle,
    );
  }

  // Метод для построения поля ввода имени группы
  Widget _buildGroupNameField(TextEditingController controller) {
    return TextField(
      decoration: _inputField("Название группы"),
      controller: controller,
      style: inputDialogSemesters,
    );
  }

  // Метод для построения поля поиска предметов
  Widget _buildSearchField(TextEditingController controller) {
    return TextField(
      decoration: _inputFieldWithIcon("Поиск предмета", Icons.search),
      controller: controller,
      style: inputDialogSemesters,
    );
  }

  // Метод для построения списка предметов
  // Метод для построения списка предметов
  Widget _buildSubjectList(GroupDialogPageController dialogController,
      ListofsubjectRepository listOfSubjectRepository) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Obx(() {
        // Проверка состояния загрузки
        if (dialogController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (dialogController.groupId.value == null) {
          // Если groupId равен null, показываем сообщение
          return const Center(
            child: Text(
              'Необходимо создать группу для редактирования предметов',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        } else {
          return ListView.builder(
            itemCount: dialogController.filteredSubjects.length,
            itemBuilder: (context, index) {
              return _buildSubjectItem(
                  dialogController, listOfSubjectRepository, index, context);
            },
          );
        }
      }),
    );
  }

// Метод для построения элемента списка предметов
  // Метод для построения элемента списка предметов
  Widget _buildSubjectItem(
      GroupDialogPageController dialogController,
      ListofsubjectRepository listOfSubjectRepository,
      int index,
      BuildContext context) {
    final subject = dialogController.filteredSubjects[index];
    String semesterNumbers = '';

    if (dialogController.groupId.value != null) {
      // Ищем все объекты ListOfSubject с соответствующим subjectId
      final matchingSubjects = dialogController.listOfSubjects
          .where((listSubj) => listSubj.subjectId == subject.id)
          .toList();

      // Формируем строку с номерами семестров
      List<int> semestersForSubject = matchingSubjects
          .map((listSubj) => listSubj.semesterNumber)
          .where((semester) => semester != null)
          .map((semester) => semester!)
          .toList();

      semesterNumbers = semestersForSubject.join(', ');
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.only(left: 5, right: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                height: 47, // Высота для контейнера
                decoration: BoxDecoration(
                  color: primary8Color,
                  borderRadius: BorderRadius.circular(15), // Закругленные углы
                ),
                alignment: Alignment.centerLeft,
                child: Text(
                  subject.subjectNameShort ?? '',
                  textAlign: TextAlign.left, // Текст выровнен по левому краю
                  style: subjectDialogSemesters,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  List<ListOfSubject> listOfSubjects =
                      await listOfSubjectRepository
                          .getListOfSubjectsBySubjectGroupId(
                              dialogController.groupId.value!, subject.id!);

                  // Вызываем диалоговое окно с полученным списком предметов
                  List<int> selectedSemesters = await SemesterDialogPage.show(
                    context,
                    listOfSubjects, // Передаем полученный список предметов
                    dialogController.groupId.value!,
                    subject.id!,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: primary8Color, // Цвет фона
                    borderRadius:
                        BorderRadius.circular(15), // Закругленные углы
                  ),
                  child: TextField(
                    style: semestersDialogSemesters,

                    controller: TextEditingController(
                      text: semesterNumbers.isNotEmpty ? semesterNumbers : '',
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                    readOnly: true, // Поле только для чтения
                    onTap: () async {
                      List<ListOfSubject> listOfSubjects =
                          await listOfSubjectRepository
                              .getListOfSubjectsBySubjectGroupId(
                                  dialogController.groupId.value!, subject.id!);

                      // Вызываем диалоговое окно с полученным списком предметов
                      List<int> selectedSemesters =
                          await SemesterDialogPage.show(
                        context,
                        listOfSubjects, // Передаем полученный список предметов
                        dialogController.groupId.value!,
                        subject.id!,
                      );
                      await dialogController.fetchAllListOfSubjectByGroupId(
                          dialogController.groupId.value!);
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Метод для построения кнопки сохранения
  Widget _buildSaveButton(GroupDialogPageController dialogController,
      TextEditingController groupNameController) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: _elevationButtonStyle(),
        onPressed: () {
          if (dialogController.groupId.value == null) {
            dialogController.createNewGroup(
              groupName: groupNameController.text.trim(),
            );
          } else {
            dialogController.editGroup(
              id: dialogController.groupId.value!,
              groupName: groupNameController.text.trim(),
            );
          }
          Get.back(); // Закрыть диалог после сохранения
        },
        child: const Text(
          'Сохранить',
          style: dropdownButtonTextStyle,
        ),
      ),
    );
  }

  // Стиль для кнопки
  ButtonStyle _elevationButtonStyle() {
    return ButtonStyle(
      backgroundColor: WidgetStateProperty.all<Color>(
        const Color(0xFF1D427A),
      ),
      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }

  // Поле ввода без иконки
  InputDecoration _inputField(String labelText) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: styleDrawer,
      filled: true,
      fillColor: primary8Color,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }

  // Поле ввода с иконкой
  InputDecoration _inputFieldWithIcon(String labelText, IconData icon) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: styleDrawer,
      filled: true,
      fillColor: primary8Color,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      suffixIcon: Icon(icon, color: Colors.grey),
    );
  }
}
