import 'package:education_analizer/controlles/student_dialog_page_controller.dart';
import 'package:education_analizer/controlles/student_page_controller.dart';
import 'package:education_analizer/design/dialog/app_bar.dart';
import 'package:education_analizer/design/dialog/confirmation_dialog.dart';
import 'package:education_analizer/design/dialog/drawer.dart';
import 'package:education_analizer/design/dialog/styles.dart';
import 'package:education_analizer/design/widgets/colors.dart';
import 'package:education_analizer/design/widgets/dimentions.dart';
import 'package:education_analizer/pages/student_screan/student_dialog_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StudentPage extends StatelessWidget {
  const StudentPage({super.key});

  @override
  Widget build(BuildContext context) {
    StudentPageController studentPageController = Get.find();

    return Scaffold(
      backgroundColor: primaryColor,
      resizeToAvoidBottomInset: false,
      appBar:
          CustomAppBar(role: studentPageController.authController.role.value),
      drawer:
          CustomDrawer(role: studentPageController.authController.role.value),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(
              alignment: Alignment.topRight,
              // Кнопка для добавления студента
              child: FloatingActionButton(
                backgroundColor: const Color(0xFF1D427A),
                child: const Icon(Icons.add, color: Colors.white),
                onPressed: () async {
                  final dialogController = StudentDialogController(
                      studentPageController: studentPageController);
                  dialogController.setStudent(null);
                  bool? result = await Get.dialog(
                      StudentDialog(controller: dialogController));

                  if (result == true) {
                    studentPageController
                        .fetchStudent(); // Обновляем список студентов после добавления
                  }
                },
              ),
            ),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 400, maxWidth: 700),
            child: Container(
              margin: const EdgeInsets.only(top: 8, right: 16, left: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(radius32),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0xFFc2d0e3),
                    spreadRadius: 10,
                    blurRadius: 10,
                    offset: Offset(3, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    'Список учащихся',
                    textAlign: TextAlign.center,
                    style: semestDialogMainTextStyle,
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 400, // Ограничение высоты для ListView
                    child: Obx(() {
                      if (studentPageController.isLoading.value) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return ListView.builder(
                        itemCount: studentPageController.students.length,
                        itemBuilder: (context, index) {
                          final student = studentPageController.students[index];
                          final groupName = studentPageController
                              .getGroupNameById(student.groupId);

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
                                  Text(
                                    " ${groupName ?? 'Не найдена'}",
                                    style: shortSubName,
                                  ),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () async {
                                      final dialogController =
                                          StudentDialogController(
                                              studentPageController:
                                                  studentPageController);
                                      dialogController.setStudent(student);
                                      bool? result = await Get.dialog(
                                          StudentDialog(
                                              controller: dialogController));

                                      if (result == true) {
                                        studentPageController
                                            .fetchStudent(); // Обновляем список студентов после добавления
                                      }
                                    },
                                  ),
                                  IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () async {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return ConfirmationDialog(
                                              title: "Удаление предмета",
                                              message:
                                                  "Вы уверены, что хотете удалить: ${student.middleName ?? ''} ${student.firstName ?? ''} ${student.lastName ?? ''}",
                                              onConfirm: () async {
                                                await studentPageController
                                                    .studentRepository
                                                    .deleteStudent(student.id);
                                                studentPageController
                                                    .fetchStudent();
                                              },
                                            );
                                          },
                                        );
                                      }),
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
    );
  }
}
