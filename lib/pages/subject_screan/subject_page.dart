import 'dart:developer';
import 'package:education_analizer/controlles/subject_dialog_controller.dart';
import 'package:education_analizer/controlles/subject_page_controller.dart';
import 'package:education_analizer/design/dialog/app_bar.dart';
import 'package:education_analizer/design/dialog/drawer.dart';
import 'package:education_analizer/design/dialog/styles.dart';
import 'package:education_analizer/design/widgets/colors.dart';
import 'package:education_analizer/design/widgets/dimentions.dart';
import 'package:education_analizer/pages/subject_screan/subject_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubjectPage extends StatelessWidget {
  const SubjectPage({super.key});

  @override
  Widget build(BuildContext context) {
    SubjectPageController subjectPageController = Get.find();

    return Scaffold(
      backgroundColor: primaryColor,
      appBar:
          CustomAppBar(role: subjectPageController.authController.role.value),
      drawer:
          CustomDrawer(role: subjectPageController.authController.role.value),
      body: SingleChildScrollView(
        // Используем SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Измените это значение
            children: [
              // Кнопка "+" для добавления нового предмета
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.topRight,
                  child: FloatingActionButton(
                    onPressed: () {
                      final dialogController = SubjectDialogController(
                          subjectPageController: subjectPageController);
                      Get.dialog(SubjectDialog(controller: dialogController))
                          .then((result) {
                        if (result == true) {
                          // Обновить состояние, если предмет был изменен
                          subjectPageController
                              .fetchSubjects(); // Обновляем список предметов
                        }
                      });
                    },
                    child: const Icon(Icons.add),
                  ),
                ),
              ),
              // Ограничиваем ширину контейнера
              ConstrainedBox(
                constraints: const BoxConstraints(
                  minWidth: 400,
                  maxWidth: 700,
                ), // Максимальная ширина контейнера
                child: Container(
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(radius32),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x42000000),
                        spreadRadius: 10,
                        blurRadius: 10,
                        offset: Offset(3, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Список предметов',
                        textAlign: TextAlign.center,
                        style: semestDialogMainTextStyle,
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        decoration: InputDecoration(
                          labelText: "Поиск предмета",
                          labelStyle: styleDrawer,
                          filled: true,
                          fillColor: primary8Color,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          suffixIcon:
                              const Icon(Icons.search, color: Colors.grey),
                        ),
                        onChanged: (value) {
                          subjectPageController.searchText.value = value;
                        },
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 400,
                        child: Obx(() {
                          if (subjectPageController.isLoading.value) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (subjectPageController.subjects.isEmpty) {
                            return const Center(child: Text('Нет предметов'));
                          }

                          return ListView.builder(
                            itemCount:
                                subjectPageController.filteredSubject.length,
                            itemBuilder: (context, index) {
                              final subject =
                                  subjectPageController.filteredSubject[index];
                              return Card(
                                color: primary8Color,
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                child: ListTile(
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        subject.subjectNameShort.toString(),
                                        style: subjectMainTextDialogSemesters,
                                      ),
                                      Text(subject.subjectNameLong.toString(),
                                          style: shortSubName),
                                    ],
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit),
                                        onPressed: () {
                                          final dialogController =
                                              SubjectDialogController(
                                                  subjectPageController:
                                                      subjectPageController);
                                          dialogController.setSubject(
                                              subject.id,
                                              shortName:
                                                  subject.subjectNameShort,
                                              longName:
                                                  subject.subjectNameLong);
                                          Get.dialog(SubjectDialog(
                                                  controller: dialogController))
                                              .then((result) {
                                            if (result == true) {
                                              subjectPageController
                                                  .fetchSubjects();
                                            }
                                          });
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed: () async {
                                          await subjectPageController
                                              .subjectRepository
                                              .deleteSubject(subject.id);
                                          subjectPageController.fetchSubjects();
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
