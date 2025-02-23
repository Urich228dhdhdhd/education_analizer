import 'package:education_analizer/controlles/student_dialog_page_controller.dart';
import 'package:education_analizer/controlles/student_page_controller.dart';
import 'package:education_analizer/design/dialog/app_bar.dart';
import 'package:education_analizer/design/dialog/confirmation_dialog.dart';
import 'package:education_analizer/design/dialog/drawer.dart';
import 'package:education_analizer/design/dialog/styles.dart';
import 'package:education_analizer/design/widgets/colors.dart';
import 'package:education_analizer/design/widgets/dimentions.dart';
import 'package:education_analizer/model/student.dart';
import 'package:education_analizer/pages/student_screan/student_dialog_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class StudentPage extends StatelessWidget {
  const StudentPage({super.key});

  @override
  Widget build(BuildContext context) {
    StudentPageController studentPageController = Get.find();
    final FocusNode focusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await studentPageController.fetchGroups();
      await studentPageController.fetchStudent();
    });
    studentPageController.searchText.addListener(() {
      studentPageController
          .searchStudents(studentPageController.searchText.text);
    });

    return WillPopScope(
      onWillPop: () async {
        homeRoute();
        return false;
      },
      child: Scaffold(
        backgroundColor: primaryColor,
        resizeToAvoidBottomInset: false,
        appBar:
            CustomAppBar(role: studentPageController.authController.role.value),
        drawer:
            CustomDrawer(role: studentPageController.authController.role.value),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(padding14),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Список учащихся',
                      style: semestDialogMainTextStyle,
                    ),
                    FloatingActionButton(
                      heroTag: null,
                      backgroundColor: secColor,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(radius8),
                      ),
                      onPressed: () async {
                        final dialogController = StudentDialogController(
                            studentPageController: studentPageController);
                        dialogController.setStudent(null);
                        bool? result = await Get.dialog(
                            StudentDialog(controller: dialogController));
                        if (result == true) {
                          studentPageController.fetchStudent();
                        }
                      },
                      child: const Icon(
                        Icons.add,
                        color: whiteColor,
                        size: 36,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 14,
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(padding14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(radius12),
                    ),
                    child: Column(
                      children: [
                        TextField(
                          controller: studentPageController.searchText,
                          // onChanged: (value) {
                          //   studentPageController.searchText.value = value;
                          // },
                          style: labelTextField.copyWith(fontSize: 14),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: primary8Color,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(radius8),
                              borderSide: const BorderSide(
                                color: greyColor,
                                width: 1.0,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(radius8),
                                borderSide: const BorderSide(
                                  color: greyColor,
                                  width: 1.0,
                                )),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(radius8),
                              borderSide: BorderSide(
                                color: greyColor[600]!,
                                width: 2,
                              ),
                            ),
                            hintText: "Поиск учащихся",
                            hintStyle: textFieldtext.copyWith(fontSize: 14),
                            suffixIcon: const Icon(
                              Icons.search,
                              color: greyColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: padding14),
                        Expanded(
                          child: Obx(() {
                            if (studentPageController.isLoading.value) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            return ListView.builder(
                              itemCount:
                                  studentPageController.filteredStudents.length,
                              itemBuilder: (context, index) {
                                final student = studentPageController
                                    .filteredStudents[index];
                                final groupName = studentPageController
                                    .getGroupNameById(student.groupId!);

                                return StudentItem(
                                    student: student,
                                    groupName: groupName,
                                    focusNode: focusNode,
                                    studentPageController:
                                        studentPageController);
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
      ),
    );
  }
}

class StudentItem extends StatelessWidget {
  const StudentItem({
    super.key,
    required this.student,
    required this.groupName,
    required this.focusNode,
    required this.studentPageController,
  });

  final Student student;
  final String? groupName;
  final FocusNode focusNode;
  final StudentPageController studentPageController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: padding12),
      child: Container(
          decoration: BoxDecoration(
              color: primary8Color,
              borderRadius: BorderRadius.circular(radius8)),
          child: Padding(
            padding: const EdgeInsets.all(padding6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${student.middleName ?? ''} ${student.firstName?[0] ?? ''}. ${student.lastName?[0] ?? ''}.",
                      style: primaryStyle.copyWith(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        Text("Телефон: ",
                            style: primaryStyle.copyWith(
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                                color: greyColor[600])),
                        Text("${student.telNumber}",
                            style: primaryStyle.copyWith(
                                fontSize: 10, fontWeight: FontWeight.w400))
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Text("Группа: ",
                            style: primaryStyle.copyWith(
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                                color: greyColor[600])),
                        Text("$groupName",
                            style: primaryStyle.copyWith(
                                fontSize: 10, fontWeight: FontWeight.w400))
                      ],
                    )
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        try {
                          focusNode.unfocus();
                          final dialogController = StudentDialogController(
                              studentPageController: studentPageController);
                          dialogController.setStudent(student);
                          bool? result = await Get.dialog(
                              StudentDialog(controller: dialogController));

                          if (result == true) {
                            studentPageController.fetchStudent();
                          }
                        } catch (e) {
                          showSnackBar(title: "Ошибка", message: e.toString());
                        }
                      },
                      child: SvgPicture.asset(
                        "lib/images/edit.svg",
                        width: 26,
                        height: 26,
                        color: greyColor[600],
                      ),
                    ),
                    const SizedBox(
                      width: 28,
                    ),
                    GestureDetector(
                      onTap: () async {
                        focusNode.unfocus();

                        showDialog(
                          context: context,
                          builder: (context) {
                            return ConfirmationDialog(
                              title: "Удаление студента",
                              message:
                                  "При удалении учащегося все связанные с ним данные будут удалены!",
                              onConfirm: () async {
                                try {
                                  await studentPageController.studentRepository
                                      .deleteStudent(student.id!);
                                  showSnackBar(
                                      title: "Успех",
                                      message: "Учащийся успешно удален",
                                      backgroundColor: orangeColor[300]!);
                                  await studentPageController.fetchStudent();
                                } catch (e) {
                                  showSnackBar(
                                      title: "Ошибка", message: e.toString());
                                }
                              },
                            );
                          },
                        );
                      },
                      child: SvgPicture.asset(
                        "lib/images/delete.svg",
                        width: 26,
                        height: 26,
                        color: greyColor[600],
                      ),
                    ),
                    const SizedBox(
                      width: 7,
                    )
                  ],
                ),
              ],
            ),
          )),
    );
    // Ca
  }
}
