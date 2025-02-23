import 'dart:developer';
import 'dart:io';

import 'package:easy_stepper/easy_stepper.dart';
import 'package:education_analizer/controlles/report_page_controller.dart';
import 'package:education_analizer/design/dialog/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../design/widgets/colors.dart';
import '../../design/widgets/dimentions.dart';
import '../../model/group.dart';
import '../../model/subject.dart';

class PerformanceReport extends StatelessWidget {
  final ReportPageController controller;

  const PerformanceReport({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    ReportPageController controller = Get.find();

    return Column(
      mainAxisSize: MainAxisSize.min,
      // mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: 120, child: StepperWidgets()),
        const SizedBox(
          height: padding6,
        ),
        Expanded(
            child: Obx(() => _getStepWidget(controller.performanceStep.value)))
      ],
    );
  }
}

Widget _getStepWidget(int step) {
  switch (step) {
    case 0:
      return GroupSelected();
    //  _groupSelected();
    case 1:
      return const SemesterSelected();
    //  _dateSelected();
    case 2:
      return const SubjectSelected();
    // _absTypeSelected();
    default:
      return Container();
  }
}

class SubjectSelected extends StatelessWidget {
  const SubjectSelected({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ReportPageController controller = Get.find();
    return Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Expanded(child: Obx(() {
        if (controller.isLoadingSubject.value) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12.0,
              mainAxisSpacing: 12.0,
              childAspectRatio: 2 / 1,
            ),
            itemCount: controller.subjects.length,
            itemBuilder: (context, index) {
              Subject subject = controller.subjects[index];
              return Obx(() {
                return GestureDetector(
                  onTap: () {
                    controller.toggleSubjectSelection(subject);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: controller.selectedSubjects.contains(subject)
                            ? Colors.green[700]!
                            : primaryColor,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  subject.subjectNameShort!,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  subject.subjectNameLong!,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 10),
                                ),
                              ],
                            ),
                          ),
                          Obx(() {
                            return Checkbox(
                              side: WidgetStateBorderSide.resolveWith((states) {
                                if (states.contains(WidgetState.selected)) {
                                  return BorderSide(
                                    color: Colors.green[700]!,
                                    width: 2,
                                  );
                                } else {
                                  return BorderSide(
                                    color: Colors.green[700]!,
                                    width: 1.5,
                                  );
                                }
                              }),
                              shape: const CircleBorder(),
                              activeColor: Colors.green[100],
                              checkColor: Colors.green,
                              value:
                                  controller.selectedSubjects.contains(subject),
                              onChanged: (value) {
                                controller.toggleSubjectSelection(subject);
                              },
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                );
              });
            },
          ),
        );
      })),
      Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton(
              heroTag: null,
              onPressed: () {
                if (controller.performanceStep.value > 0) {
                  controller.performanceStep.value--;
                  controller.selectedSubjects.clear();
                }
              },
              backgroundColor: primary9Color,
              child: const Icon(Icons.arrow_back, color: Colors.white),
            ),
            const SizedBox(width: 10),
            FloatingActionButton(
              heroTag: null,
              onPressed: () async {
                if (controller.selectedSubjects.isNotEmpty) {
                  await _openPreviewWindow(controller);
                } else {
                  showSnackBar(
                      title: "Ошибка выбора",
                      message: "Выберите предметы для отчета");
                }
              },
              backgroundColor: primary9Color,
              child: const Icon(Icons.create, color: Colors.white),
            ),
          ],
        ),
      ),
    ]);
  }
}

class SemesterSelected extends StatelessWidget {
  const SemesterSelected({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ReportPageController controller = Get.find();

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(padding14),
              child: Obx(() {
                if (controller.isLoadingSubject.value) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                }
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: padding14,
                    mainAxisSpacing: padding14,
                    childAspectRatio: 2 / 1,
                  ),
                  itemCount: controller.groupSemesters.length,
                  itemBuilder: (context, index) {
                    final semester = controller.groupSemesters[index];

                    return GestureDetector(onTap: () {
                      controller.toggleSelectionSemester(semester);
                    }, child: Obx(() {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            width: 2,
                            color: controller.startSemester.value == semester ||
                                    controller.endSemester.value == semester
                                ? Colors.green
                                : Colors.transparent,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                                flex: 3,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: controller.startSemester
                                                            .value ==
                                                        semester ||
                                                    controller.endSemester
                                                            .value ==
                                                        semester
                                                ? Colors.grey[400]
                                                : controller
                                                        .semesterRange
                                                        .contains(semester)
                                                    ? greyColor[350]
                                                    : primary8Color,
                                            borderRadius: const BorderRadius
                                                .only(
                                                topLeft:
                                                    Radius.circular(radius12),
                                                bottomLeft:
                                                    Radius.circular(radius12))),
                                        child: Center(
                                          child: Text(
                                            "${semester.semesterNumber}",
                                            style: primaryStyle.copyWith(
                                              fontSize: 36,
                                              fontWeight: FontWeight.bold,
                                              color: controller.startSemester
                                                              .value ==
                                                          semester ||
                                                      controller.endSemester
                                                              .value ==
                                                          semester
                                                  ? whiteColor
                                                  : controller.semesterRange
                                                          .contains(semester)
                                                      ? greyColor[600]
                                                      : primary6Color,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                            Expanded(
                              flex: 5,
                              child: Container(
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(radius12),
                                      bottomRight: Radius.circular(radius12)),
                                  color: primary6Color,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  "${semester.semesterYear}",
                                  style: preferTextStyle.copyWith(
                                      color: whiteColor,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    }));
                  },
                );
              }),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FloatingActionButton(
                heroTag: null,
                onPressed: () {
                  if (controller.performanceStep.value > 0) {
                    controller.performanceStep.value--;
                  }
                },
                backgroundColor: primary9Color,
                child: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              const SizedBox(width: 10),
              FloatingActionButton(
                heroTag: null,
                onPressed: () async {
                  if (controller.semesterRange.isEmpty) {
                    showSnackBar(
                        title: "Ошибка выбора",
                        message: "Выберите семестры для отчета");
                  } else {
                    controller.subjects.clear();
                    if (controller.performanceStep.value < 2) {
                      controller.performanceStep.value++;
                    }
                    await controller.getSubjectsBySemesterRangeAndGroupId(
                        group: controller.performanceSelectedGroup.value!,
                        semesters: controller.semesterRange);
                  }
                },
                backgroundColor: primary9Color,
                child: const Icon(Icons.arrow_forward, color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class GroupSelected extends StatelessWidget {
  final ReportPageController controller = Get.find();

  GroupSelected({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(radius12),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: padding6),
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                  itemCount: controller.groups.length,
                  itemBuilder: (context, index) {
                    Group group = controller.groups[index];
                    return Obx(() {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        child: Container(
                          decoration: BoxDecoration(
                            color:
                                controller.performanceSelectedGroup.value?.id ==
                                        group.id
                                    ? primaryColor
                                    : Colors.white,
                            borderRadius: BorderRadius.circular(radius8),
                            border: Border.all(color: greyColor),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                spreadRadius: 1,
                                offset: const Offset(3, 3),
                              ),
                            ],
                          ),
                          child: CheckboxListTile(
                              side: WidgetStateBorderSide.resolveWith((states) {
                                if (states.contains(WidgetState.selected)) {
                                  return BorderSide(
                                    color: Colors.green[700]!,
                                    width: 2,
                                  );
                                } else {
                                  return const BorderSide(
                                    style: BorderStyle.solid,
                                    color: greyColor,
                                    width: 1.5,
                                  );
                                }
                              }),
                              checkboxShape: const CircleBorder(),
                              activeColor: Colors.green[100],
                              checkColor: Colors.green,
                              value: controller
                                      .performanceSelectedGroup.value?.id ==
                                  group.id,
                              onChanged: (value) async {
                                if (value == true) {
                                  controller.performanceSelectedGroup.value =
                                      group;
                                } else {
                                  controller.performanceSelectedGroup.value =
                                      null;
                                }
                              },
                              title: Text(group.groupName!,
                                  style: preferTextStyle.copyWith(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600))),
                        ),
                      );
                    });
                  },
                );
              }),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(width: 10),
              FloatingActionButton(
                heroTag: null,
                onPressed: () async {
                  if (controller.performanceSelectedGroup.value == null) {
                    showSnackBar(
                        title: "Ошибка выбора",
                        message: "Выберите группы для отчета");
                  } else {
                    if (controller.performanceStep.value < 2) {
                      controller.startSemester.value = null;
                      controller.endSemester.value = null;
                      controller.semesterRange.clear();
                      controller.performanceStep.value++;
                      await controller.getSemestersForGroup(
                          controller.performanceSelectedGroup.value!);
                    }
                  }
                },
                backgroundColor: primary9Color,
                child: const Icon(Icons.arrow_forward, color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class StepperWidgets extends StatelessWidget {
  final ReportPageController controller = Get.find();

  StepperWidgets({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return EasyStepper(
        padding: EdgeInsets.zero,
        alignment: Alignment.center,
        defaultStepBorderType: BorderType.normal,
        borderThickness: 6,

        activeStep: controller.performanceStep.value,
        // onStepReached: (index) {
        //   controller.performanceStep.value = index;
        // },
        lineStyle: LineStyle(
          lineLength: 60,
          lineThickness: 4,
          progress: 0.5,
          lineType: LineType.normal,
          defaultLineColor: greyColor,
          progressColor: primary6Color,
          finishedLineColor: Colors.green[700],
        ),
        finishedStepBackgroundColor: Colors.green[700],
        finishedStepBorderColor: Colors.green[700],
        finishedStepIconColor: whiteColor,
        activeStepBorderColor: primary10Color,
        activeStepIconColor: primary10Color,
        internalPadding: 12,
        showLoadingAnimation: false,
        // loadingAnimation: "lib/images/loading_circle.json",
        steps: [
          EasyStep(
            icon: const Icon(
              Icons.groups,
            ),
            finishIcon: const Icon(
              Icons.task_alt_sharp,
            ),
            customTitle: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Шаг 1",
                  style: TextStyle(color: greyColor, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "Группа",
                  style: controller.performanceStep.value >= 0
                      ? const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold)
                      : const TextStyle(
                          color: greyColor, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          EasyStep(
            icon: const Icon(Icons.calendar_today),
            finishIcon: const Icon(Icons.task_alt_sharp),
            customTitle: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Шаг 2",
                  style: TextStyle(color: greyColor, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "Семестры",
                  style: controller.performanceStep.value >= 1
                      ? const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold)
                      : const TextStyle(
                          color: greyColor, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          EasyStep(
            icon: const Icon(Icons.book),
            customTitle: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Шаг 3",
                  style: TextStyle(color: greyColor, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "Предметы",
                  style: controller.performanceStep.value >= 2
                      ? const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold)
                      : const TextStyle(
                          color: greyColor, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            finishIcon: const Icon(Icons.task_alt_sharp),
          ),
        ],
      );
    });
  }
}

Future<void> _openPreviewWindow(
  ReportPageController controller,
) async {
  try {
    final fontData =
        await rootBundle.load('lib/assets/fonts/Roboto-Regular.ttf');
    final ttf = pw.Font.ttf(fontData);

    final ByteData bytes =
        await rootBundle.load('lib/images/college_image.png');
    final Uint8List imageBytes = bytes.buffer.asUint8List();
    controller.performanceReport.value = null;
    controller.performanceReport.refresh();

    controller.performanceReport.value = await controller.reportRepository
        .getPerformanceReport(
            group: controller.performanceSelectedGroup.value!,
            semesters: controller.semesterRange,
            subjects: controller.selectedSubjects);
    log("logging!!! ${controller.performanceReport.toString()}");

    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        orientation: pw.PageOrientation.portrait,
        pageFormat: PdfPageFormat.a4.copyWith(
            marginBottom: 5, marginLeft: 5, marginRight: 5, marginTop: 10),
        build: (pw.Context context) {
          return [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Align(
                  alignment: pw.Alignment.centerRight,
                  child: pw.Image(
                    pw.MemoryImage(imageBytes),
                    width: 75,
                    height: 75,
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Expanded(
                      child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Row(
                              mainAxisAlignment:
                                  pw.MainAxisAlignment.spaceBetween,
                              children: [
                                pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.Padding(
                                      padding: const pw.EdgeInsets.only(
                                          top: 8, bottom: 8, right: 8),
                                      child: pw.Text(
                                        'Группа: ${controller.performanceSelectedGroup.value!.groupName}',
                                        style: pw.TextStyle(
                                            fontSize: 12, font: ttf),
                                      ),
                                    ),
                                    pw.Text(
                                      'Период: ${controller.startSemester.value!.semesterNumber.toString()}-${controller.endSemester.value!.semesterNumber.toString()} семестр(ы)',
                                      style:
                                          pw.TextStyle(fontSize: 12, font: ttf),
                                    ),
                                  ],
                                ),
                                pw.Table(
                                  border: pw.TableBorder.all(
                                      color: PdfColors.black, width: 1),
                                  children: [
                                    pw.TableRow(children: [
                                      pw.Padding(
                                        padding: const pw.EdgeInsets.all(8.0),
                                        child: pw.Text(
                                          'СОУ',
                                          style: pw.TextStyle(
                                            fontWeight: pw.FontWeight.bold,
                                            font: ttf,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      pw.Padding(
                                        padding: const pw.EdgeInsets.all(8.0),
                                        child: pw.Text(
                                          'КЗ',
                                          style: pw.TextStyle(
                                            fontWeight: pw.FontWeight.bold,
                                            font: ttf,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      pw.Padding(
                                        padding: const pw.EdgeInsets.all(8.0),
                                        child: pw.Text(
                                          'АУ',
                                          style: pw.TextStyle(
                                            fontWeight: pw.FontWeight.bold,
                                            font: ttf,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ]),
                                    pw.TableRow(children: [
                                      pw.Padding(
                                        padding: const pw.EdgeInsets.all(4.0),
                                        child: pw.Text(
                                          textAlign: pw.TextAlign.center,
                                          controller.performanceReport.value!
                                                      .studentsLearningPercent !=
                                                  "NaN"
                                              ? "${controller.performanceReport.value!.studentsLearningPercent!.split('.').first}%"
                                              : "—",
                                          style: pw.TextStyle(
                                            fontWeight: pw.FontWeight.bold,
                                            font: ttf,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      pw.Padding(
                                        padding: const pw.EdgeInsets.all(4.0),
                                        child: pw.Text(
                                          textAlign: pw.TextAlign.center,
                                          controller.performanceReport.value!
                                                      .qualityOfKnowledgePercent !=
                                                  "NaN"
                                              ? "${controller.performanceReport.value!.qualityOfKnowledgePercent!.split('.').first}%"
                                              : "—",
                                          style: pw.TextStyle(
                                            fontWeight: pw.FontWeight.bold,
                                            font: ttf,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      pw.Padding(
                                        padding: const pw.EdgeInsets.all(4.0),
                                        child: pw.Text(
                                          textAlign: pw.TextAlign.center,
                                          controller.performanceReport.value!
                                                      .performancePercent !=
                                                  "NaN"
                                              ? "${controller.performanceReport.value!.performancePercent!.split('.').first}%"
                                              : "—",
                                          style: pw.TextStyle(
                                            fontWeight: pw.FontWeight.bold,
                                            font: ttf,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ])
                                  ],
                                ),
                              ],
                            ),
                            // pw.Padding(
                            //   padding: const pw.EdgeInsets.only(
                            //       top: 8, bottom: 8, right: 8),
                            //   child: pw.Text(
                            //     'Предметы: ${controller.selectedSubjects.map((sub) => sub.subjectNameLong).join(', ')}',
                            //     style: pw.TextStyle(fontSize: 12, font: ttf),
                            //   ),
                            // ),
                            pw.Text(
                              'Результаты отчета:',
                              style: pw.TextStyle(
                                fontSize: 12,
                                fontWeight: pw.FontWeight.bold,
                                font: ttf,
                              ),
                            ),
                            pw.TableHelper.fromTextArray(
                              border: pw.TableBorder.all(
                                  color: PdfColors.black, width: 1),
                              headerPadding: const pw.EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 2),
                              headerStyle: pw.TextStyle(
                                // fontWeight: pw.FontWeight.normal,
                                font: ttf,
                                fontSize: 8,
                              ),
                              cellAlignment: pw.Alignment.center,
                              cellPadding: const pw.EdgeInsets.symmetric(
                                  horizontal: 2, vertical: 2),
                              cellStyle: pw.TextStyle(
                                font: ttf,
                                fontSize: 6,
                              ),
                              headerDecoration: const pw.BoxDecoration(
                                color: PdfColors.grey300,
                              ),
                              data: [
                                [
                                  'Учащиеся',
                                  ...controller.selectedSubjects
                                      .map((sub) => sub.subjectNameShort!)
                                ],
                                ...controller
                                    .performanceReport.value!.marksData!
                                    .map((studentData) {
                                  return [
                                    studentData.studentName!,
                                    ...controller.selectedSubjects
                                        .map((subject) {
                                      final subjectMark =
                                          studentData.markData?.firstWhere(
                                        (markData) =>
                                            markData.subjectName ==
                                            subject.subjectNameShort,
                                      );
                                      return subjectMark!.mark != "null"
                                          ? (subjectMark.isExam == true
                                              ? pw.Align(
                                                  alignment:
                                                      pw.Alignment.center,
                                                  child: pw.Text(
                                                    subjectMark.mark!,
                                                    style: pw.TextStyle(
                                                      font: ttf,
                                                      fontSize: 8,
                                                      fontWeight:
                                                          pw.FontWeight.bold,
                                                      color: PdfColors.green,
                                                    ),
                                                  ),
                                                )
                                              : pw.Text(
                                                  subjectMark.mark!,
                                                  style: pw.TextStyle(
                                                      font: ttf, fontSize: 8),
                                                ))
                                          : "—";
                                    }),
                                  ];
                                }),
                              ],
                            ),
                          ]),
                    ),
                  ],
                ),
              ],
            ),
          ];

          // pw.SizedBox(height: 10),
          // Используем TableHelper для таблицы с данными
        },
      ),
    );

    final pdfBytes = await pdf.save();

    final tempDir = await getTemporaryDirectory();
    final tempFilePath =
        '${tempDir.path}/Отчет_успеваемость_${controller.startSemester.value!.toString()}-${controller.endSemester.value!.toString()}.pdf';
    // log(tempFilePath);

    final file = File(tempFilePath);
    await file.writeAsBytes(pdfBytes);

    Get.dialog(
      AlertDialog(
        contentPadding: EdgeInsets.zero,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Предпросмотр отчета',
              style: TextStyle(fontSize: 14),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.data_saver_on_sharp),
                  onPressed: () async {
                    try {
                      await controller.reportRepository.savePerformanseReport(
                          userId: controller.authController.id.value,
                          reportData: controller.performanceReport,
                          selectedGroup:
                              controller.performanceSelectedGroup.value!,
                          period:
                              "${controller.startSemester.value!.semesterNumber.toString()}-${controller.endSemester.value!.semesterNumber.toString()}",
                          selectedSubjects: controller.selectedSubjects);
                      Get.back();
                      showSnackBar(
                          title: "Успех",
                          message: "Отчет успешно сохранен",
                          backgroundColor: Colors.green[300]!);
                    } catch (e) {
                      showSnackBar(title: "Ошибка", message: e.toString());
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: () async {
                    try {
                      if (await file.exists()) {
                        await Share.shareXFiles(
                          [XFile(file.path)],
                        );
                      } else {
                        log('Файл не найден по пути: $tempFilePath');
                        Get.snackbar('Ошибка', 'Файл не найден.');
                      }
                    } catch (e) {
                      log(e.toString());
                      Get.snackbar(
                          'Ошибка', 'Не удалось поделиться файлом: $e');
                    }
                  },
                ),
              ],
            )
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          height: double.maxFinite,
          child: SfPdfViewer.memory(pdfBytes),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  } catch (e) {
    Get.back();
    log(e.toString());
    Get.snackbar('Ошибка', 'Не удалось загрузить данные отчета: $e');
  }
}
