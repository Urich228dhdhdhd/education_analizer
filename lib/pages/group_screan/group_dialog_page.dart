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
    final FocusNode focusNode = FocusNode();
    final GroupDialogPageController dialogController = Get.find();
    final ListofsubjectRepository listofsubjectRepository = Get.find();

    final TextEditingController groupNameController =
        TextEditingController(text: initialGroupName ?? "");
    final TextEditingController searchController = TextEditingController();
    dialogController.groupId.value = groupId;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      dialogController.isLoading.value = true;

      await Future.delayed(const Duration(milliseconds: 100));

      await dialogController.fetchAllSubjects();
      if (dialogController.groupId.value != null) {
        await dialogController
            .fetchAllListOfSubjectByGroupId(dialogController.groupId.value!);
      }

      dialogController.isLoading.value = false;
    });

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
                const SizedBox(height: 10),
                Obx(() {
                  return Visibility(
                    visible: dialogController.groupId.value == null,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            style: inputDialogSemesters,
                            decoration: InputDecoration(
                              labelStyle: styleDrawer,
                              filled: true,
                              fillColor: primary8Color,
                              labelText: 'Год начала обучения',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              dialogController.startYear.value =
                                  int.tryParse(value);
                            },
                          ),
                        ),
                        const SizedBox(width: 5), // Отступ между полями
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              labelStyle: styleDrawer,
                              filled: true,
                              fillColor: primary8Color,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              labelText: 'Год окончания обучения',
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              // Сохраняем введенное значение в контроллере
                              dialogController.endYear.value =
                                  int.tryParse(value);
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                Obx(() {
                  return Visibility(
                    visible: dialogController.groupId.value != null,
                    child: Column(
                      children: [
                        // const SizedBox(height: 20),
                        _buildSearchField(searchController, focusNode),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 20),
                _buildSubjectList(
                    dialogController, listofsubjectRepository, focusNode),
                const SizedBox(height: 20),
                _buildSaveButton(dialogController, groupNameController),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDialogTitle(GroupDialogPageController dialogController) {
    return Text(
      dialogController.groupId.value == null
          ? 'Создать новую группу'
          : 'Редактировать группу',
      style: dialogMainTextStyle,
    );
  }

  Widget _buildGroupNameField(TextEditingController controller) {
    return TextField(
      decoration: _inputField("Название группы"),
      controller: controller,
      style: inputDialogSemesters,
    );
  }

  Widget _buildSearchField(
      TextEditingController controller, FocusNode focusNode) {
    return TextField(
      focusNode: focusNode,
      decoration: _inputFieldWithIcon("Поиск предмета", Icons.search),
      controller: controller,
      style: inputDialogSemesters,
    );
  }

  Widget _buildSubjectList(GroupDialogPageController dialogController,
      ListofsubjectRepository listOfSubjectRepository, FocusNode focusNode) {
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
              return _buildSubjectItem(dialogController,
                  listOfSubjectRepository, index, context, focusNode);
            },
          );
        }
      }),
    );
  }

  Widget _buildSubjectItem(
      GroupDialogPageController dialogController,
      ListofsubjectRepository listOfSubjectRepository,
      int index,
      BuildContext context,
      FocusNode focusNode) {
    final subject = dialogController.filteredSubjects[index];
    String semesterNumbers = '';

    if (dialogController.groupId.value != null) {
      final matchingSubjects = dialogController.listOfSubjects
          .where((listSubj) => listSubj.subjectId == subject.id)
          .toList();

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
                    color: primary8Color,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: TextField(
                    style: semestersDialogSemesters,
                    controller: TextEditingController(
                      text: semesterNumbers.isNotEmpty ? semesterNumbers : '',
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                    readOnly: true,
                    onTap: () async {
                      focusNode.unfocus();
                      List<ListOfSubject> listOfSubjects =
                          await listOfSubjectRepository
                              .getListOfSubjectsBySubjectGroupId(
                                  dialogController.groupId.value!, subject.id!);

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

  Widget _buildSaveButton(GroupDialogPageController dialogController,
      TextEditingController groupNameController) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: _elevationButtonStyle(),
        onPressed: () async {
          try {
            if (groupNameController.text.isEmpty) {
              Get.snackbar(
                "Ошибка",
                "Пожалуйста, введите название группы",
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: const Color.fromRGBO(244, 67, 54, 70),
                colorText: Colors.white,
              );
              return;
            }
            if (dialogController.groupId.value == null) {
              if (dialogController.startYear.value == null ||
                  dialogController.endYear.value == null) {
                Get.snackbar(
                  "Ошибка",
                  "Пожалуйста, введите года начала и окончания",
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: const Color.fromRGBO(244, 67, 54, 70),
                  colorText: Colors.white,
                );
                return;
              } else {
                // log(groupNameController.text.toString());

                await dialogController.createNewGroup(
                  groupName: groupNameController.text.trim(),
                );
                await checkSemesters(dialogController);
                dialogController.startYear.value = null;
                dialogController.endYear.value = null;
              }
            } else {
              await dialogController.editGroup(
                id: dialogController.groupId.value!,
                groupName: groupNameController.text.trim(),
              );
            }
            Get.close(1);
          } catch (e) {
            log(e.toString());
            throw Error();
          }
        },
        child: const Text(
          'Сохранить',
          style: dropdownButtonTextStyle,
        ),
      ),
    );
  }

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

  Future<void> checkSemesters(
      GroupDialogPageController dialogController) async {
    for (int year = dialogController.startYear.value!;
        year <= dialogController.endYear.value!;
        year++) {
      for (int semesterPart = 1; semesterPart <= 2; semesterPart++) {
        int semesterNumber =
            (year - dialogController.startYear.value!) * 2 + semesterPart;

        bool exists = await dialogController.semesterRepository.isSemesterExist(
          semesterNumber: semesterNumber,
          semesterYear: year,
        );
        if (!exists) {
          dialogController.semesterRepository.createSemester(
              semesterNumber: semesterNumber,
              semesterYear: year,
              semesterPart: semesterPart);
        }
      }
    }
  }
}
