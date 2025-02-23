import 'package:education_analizer/controlles/subject_dialog_controller.dart';
import 'package:education_analizer/controlles/subject_page_controller.dart';
import 'package:education_analizer/design/dialog/app_bar.dart';
import 'package:education_analizer/design/dialog/confirmation_dialog.dart';
import 'package:education_analizer/design/dialog/drawer.dart';
import 'package:education_analizer/design/dialog/styles.dart';
import 'package:education_analizer/design/widgets/colors.dart';
import 'package:education_analizer/design/widgets/dimentions.dart';
import 'package:education_analizer/pages/subject_screan/subject_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../model/subject.dart';

class SubjectPage extends StatelessWidget {
  const SubjectPage({super.key});

  @override
  Widget build(BuildContext context) {
    SubjectPageController subjectPageController = Get.find();
    FocusNode focusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await subjectPageController.fetchSubjects();
    });
    subjectPageController.searchText.addListener(() {
      subjectPageController
          .searchSubjects(subjectPageController.searchText.text);
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
            CustomAppBar(role: subjectPageController.authController.role.value),
        drawer:
            CustomDrawer(role: subjectPageController.authController.role.value),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(padding14),
            child: Column(
              // mainAxisSize: MainAxisSize.min,
              children: [
                CreateButtonColumn(
                    focusNode: focusNode,
                    subjectPageController: subjectPageController),
                const SizedBox(
                  height: padding14,
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(radius12),
                        color: whiteColor),
                    child: Padding(
                      padding: const EdgeInsets.all(padding12),
                      child: Column(
                        children: [
                          TextField(
                            controller: subjectPageController.searchText,
                            // onChanged: (value) {
                            //   subjectPageController.searchText.value = value;
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
                              hintText: "Поиск предметов",
                              hintStyle: textFieldtext.copyWith(fontSize: 14),
                              suffixIcon: const Icon(
                                Icons.search,
                                color: greyColor,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 14,
                          ),
                          Obx(() {
                            if (subjectPageController.subjects.isEmpty) {
                              return Expanded(
                                  child: Center(
                                      child: Text('Нет предметов',
                                          style: textFieldtext.copyWith(
                                              fontSize: 14))));
                            }
                            return Expanded(
                              child: ListView.builder(
                                itemCount: subjectPageController
                                    .filteredSubjects.length,
                                itemBuilder: (context, index) {
                                  Subject subject = subjectPageController
                                      .filteredSubjects[index];
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: padding12),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(radius8),
                                        color: primaryColor,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    "${subject.subjectNameShort}",
                                                    style:
                                                        primaryStyle.copyWith(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600)),
                                                Container(
                                                  constraints:
                                                      const BoxConstraints(
                                                          maxWidth: 230),
                                                  child: Text(
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    "${subject.subjectNameLong}",
                                                    style:
                                                        primaryStyle.copyWith(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                GestureDetector(
                                                  onTap: () async {
                                                    try {
                                                      focusNode.unfocus();
                                                      final dialogController =
                                                          SubjectDialogController(
                                                              subjectPageController:
                                                                  subjectPageController);
                                                      dialogController.setSubject(
                                                          subject.id!,
                                                          shortName: subject
                                                              .subjectNameShort,
                                                          longName: subject
                                                              .subjectNameLong);
                                                      Get.dialog(SubjectDialog(
                                                              controller:
                                                                  dialogController))
                                                          .then((result) async {
                                                        if (result == true) {
                                                          await subjectPageController
                                                              .fetchSubjects();
                                                        }
                                                      });
                                                    } catch (e) {
                                                      showSnackBar(
                                                          title: "Ошибка",
                                                          message:
                                                              e.toString());
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
                                                    try {
                                                      focusNode.unfocus();

                                                      showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return ConfirmationDialog(
                                                            title:
                                                                "Удаление предмета",
                                                            message:
                                                                "При удалении предмета все данные (оценки, семестры преподавания) связанные с ним будут удалены!",
                                                            onConfirm:
                                                                () async {
                                                              await subjectPageController
                                                                  .subjectRepository
                                                                  .deleteSubject(
                                                                      subject
                                                                          .id!);
                                                              await subjectPageController
                                                                  .fetchSubjects();
                                                              showSnackBar(
                                                                  title:
                                                                      "Успех",
                                                                  message:
                                                                      "Предмет успешно удален",
                                                                  backgroundColor:
                                                                      orangeColor[
                                                                          300]!);
                                                            },
                                                          );
                                                        },
                                                      );
                                                    } catch (e) {
                                                      showSnackBar(
                                                          title: "Ошибка",
                                                          message:
                                                              e.toString());
                                                    }
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
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          })
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CreateButtonColumn extends StatelessWidget {
  const CreateButtonColumn({
    super.key,
    required this.focusNode,
    required this.subjectPageController,
  });

  final FocusNode focusNode;
  final SubjectPageController subjectPageController;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Список предметов',
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
            focusNode.unfocus();
            final dialogController = SubjectDialogController(
                subjectPageController: subjectPageController);
            Get.dialog(SubjectDialog(controller: dialogController))
                .then((result) {
              if (result == true) {
                subjectPageController.fetchSubjects();
              }
            });
          },
          child: const Icon(
            Icons.add,
            color: whiteColor,
            size: 36,
          ),
        ),
      ],
    );
  }
}
