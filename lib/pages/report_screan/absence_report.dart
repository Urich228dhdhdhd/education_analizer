import 'dart:developer';
import 'dart:io';

import 'package:education_analizer/controlles/report_page_controller.dart';
import 'package:education_analizer/design/widgets/colors.dart';
import 'package:education_analizer/design/widgets/dimentions.dart';
import 'package:education_analizer/model/group.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../design/dialog/styles.dart';

class AbsenceReport extends StatelessWidget {
  final ReportPageController controller;

  const AbsenceReport({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 120,
          child: Obx(() {
            return EasyStepper(
              padding: EdgeInsets.zero,
              alignment: Alignment.center,
              borderThickness: 6,
              defaultStepBorderType: BorderType.normal,

              activeStep: controller.absenceStep.value,
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
                        style: controller.absenceStep.value >= 0
                            ? const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold)
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
                        "Дата",
                        style: controller.absenceStep.value >= 1
                            ? const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold)
                            : const TextStyle(
                                color: greyColor, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                EasyStep(
                  icon: const Icon(Icons.type_specimen_rounded),
                  customTitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Шаг 3",
                        style: TextStyle(color: greyColor, fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "Тип пропусков",
                        style: controller.absenceStep.value >= 2
                            ? const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold)
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
          }),
        ),
        const SizedBox(
          height: padding6,
        ),
        Expanded(
          child: Obx(
              () => _getStepWidget(controller, controller.absenceStep.value)),
        ),
      ],
    );
  }
}

Widget _getStepWidget(ReportPageController controller, int step) {
  switch (step) {
    case 0:
      return _groupSelected(controller);
    case 1:
      return _dateSelected(controller);
    case 2:
      return _absTypeSelected(controller);
    default:
      return Container();
  }
}

Widget _groupSelected(ReportPageController controller) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Expanded(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(radius12),
          ),
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: padding6),
              child: ListView.builder(
                itemCount: controller.groups.length,
                itemBuilder: (context, index) {
                  final group = controller.groups[index];

                  return Obx(() {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 6.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: controller.absenceSelectedGroups
                                  .contains(group.id)
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
                            activeColor: primary10Color,
                            side: WidgetStateBorderSide.resolveWith((states) {
                              if (states.contains(WidgetState.selected)) {
                                return const BorderSide(
                                  color: greyColor,
                                  width: 1,
                                );
                              } else {
                                return const BorderSide(
                                  style: BorderStyle.solid,
                                  color: greyColor,
                                  width: 1,
                                );
                              }
                            }),
                            // checkboxShape: const RoundedRectangleBorder(),
                            value: controller.absenceSelectedGroups
                                .contains(group),
                            onChanged: (value) {
                              controller.toggleGroupSelection(group);
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
              ),
            );
          }),
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
              onPressed: () {
                if (controller.absenceSelectedGroups.isEmpty) {
                  showSnackBar(
                      title: "Ошибка выбора",
                      message: "Выберите группы для отчета");
                } else {
                  if (controller.absenceStep.value < 2) {
                    controller.absenceStep.value++;
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

Widget _dateSelected(ReportPageController controller) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Expanded(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(radius12),
          ),
          padding: const EdgeInsets.all(padding14),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(radius10),
            child: SfDateRangePicker(
              headerHeight: 60,
              showNavigationArrow: true,

              selectionShape: DateRangePickerSelectionShape.rectangle,
              view: DateRangePickerView.year,
              selectionMode: DateRangePickerSelectionMode.single, // Один месяц
              allowViewNavigation: false,
              monthFormat: 'MMMM',
              headerStyle: DateRangePickerHeaderStyle(
                  textAlign: TextAlign.center,
                  backgroundColor: primary10Color,
                  textStyle: preferTextStyle.copyWith(
                      fontSize: 24,
                      color: whiteColor,
                      fontWeight: FontWeight.bold)),
              selectionRadius: 40,

              selectionColor: primary9Color.withOpacity(0.9),
              selectionTextStyle: const TextStyle(
                fontSize: 15,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              // Оформление ячеек года
              yearCellStyle: DateRangePickerYearCellStyle(
                  textStyle: const TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  todayTextStyle: const TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  // todayCellDecoration: BoxDecoration(
                  //   color: Colors.blue.withOpacity(0.2),
                  //   borderRadius: BorderRadius.circular(
                  //       8), // Скругление углов для ячеек с сегодняшней датой
                  // ),
                  cellDecoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey
                          .withOpacity(0.5), // Цвет сетки между месяцами
                      width: 0.5, // Толщина сетки
                    ),
                    // borderRadius: BorderRadius.circular(8),
                  )),

              backgroundColor:
                  primaryColor, // Устанавливаем цвет фона для календаря

              monthCellStyle: DateRangePickerMonthCellStyle(
                todayTextStyle: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
                todayCellDecoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),

              onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                if (args.value is DateTime) {
                  final selectedMonth = args.value as DateTime;
                  controller.selectedDate.value = selectedMonth;
                }
              },
            ),
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
                if (controller.absenceStep.value > 0) {
                  controller.absenceStep.value--;
                }
              },
              backgroundColor: primary9Color,
              child: const Icon(Icons.arrow_back, color: Colors.white),
            ),
            const SizedBox(width: 10),
            FloatingActionButton(
              heroTag: null,
              onPressed: () {
                if (controller.selectedDate.value == null) {
                  showSnackBar(
                      title: "Ошибка выбора",
                      message: "Выберите дату для отчета");
                } else {
                  if (controller.absenceStep.value < 2) {
                    controller.absenceStep.value++;
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

Widget _absTypeSelected(ReportPageController controller) {
  final absenceTypes = [
    {'key': 'absenceIllness', 'label': 'Болезнь'},
    {'key': 'absenceOrder', 'label': 'По приказу'},
    {'key': 'absenceResp', 'label': 'Уважительные'},
    {'key': 'absenceDisresp', 'label': 'Неуважительные'},
  ];

  return Column(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius12),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: padding6),
          child: Obx(() {
            return ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: absenceTypes.map((type) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 6.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color:
                          controller.selectedAbsenceTypes.contains(type['key'])
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
                          return const BorderSide(
                            color: greyColor,
                            width: 1,
                          );
                        } else {
                          return const BorderSide(
                            style: BorderStyle.solid,
                            color: greyColor,
                            width: 1,
                          );
                        }
                      }),
                      // tileColor: const Color.fromARGB(255, 16, 16, 16),
                      title: Text(type['label']!,
                          style: preferTextStyle.copyWith(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w600)),
                      value:
                          controller.selectedAbsenceTypes.contains(type['key']),
                      onChanged: (isChecked) {
                        if (isChecked == true) {
                          controller.selectedAbsenceTypes.add(type['key']!);
                        } else {
                          controller.selectedAbsenceTypes.remove(type['key']!);
                        }
                      },
                      activeColor: primary10Color,
                      checkColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          }),
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
                if (controller.absenceStep.value > 0) {
                  controller.absenceStep.value--;
                }
              },
              backgroundColor: primary9Color,
              child: const Icon(Icons.arrow_back, color: Colors.white),
            ),
            const SizedBox(width: 10),
            FloatingActionButton(
              heroTag: null,
              onPressed: () async {
                if (controller.selectedAbsenceTypes.isNotEmpty) {
                  _openPreviewWindow(controller, absenceTypes);
                } else {
                  showSnackBar(
                      title: "Ошибка выбора",
                      message: "Выберите типы пропусков для отчета");
                }
              },
              backgroundColor: primary9Color,
              child: const Icon(Icons.create, color: Colors.white),
            ),
          ],
        ),
      ),
    ],
  );
}

Future<void> _openPreviewWindow(ReportPageController controller,
    List<Map<String, String>> absenceTypes) async {
  try {
    final fontData =
        await rootBundle.load('lib/assets/fonts/Roboto-Regular.ttf');
    final ttf = pw.Font.ttf(fontData);

    final ByteData bytes =
        await rootBundle.load('lib/images/college_image.png');
    final Uint8List imageBytes = bytes.buffer.asUint8List();

    controller.reportAbsenceData.value =
        await controller.absenceRepository.getAbsenceReport(
      group: controller.absenceSelectedGroups,
      year: controller.selectedDate.value!.year,
      month: controller.selectedDate.value!.month,
      absenceTypes: controller.selectedAbsenceTypes,
    );
    // List<Group> = controller.reportAbsenceData.map((group)=> group.groupId)

    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Image(
                  pw.MemoryImage(imageBytes),
                  width: 100,
                  height: 100,
                ),
              ),
              pw.SizedBox(height: 50),
              pw.Align(
                alignment: pw.Alignment.center,
                child: pw.Text(
                  'Отчет о пропусках',
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                    font: ttf,
                  ),
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          // 'Группы: ${controller.groups.where((group) => controller.absenceSelectedGroups.contains(group.id)).map((group) => group.groupName).join(", ")}',
                          'Группы: ${controller.absenceSelectedGroups.map((group) => group.groupName).join(", ")}',
                          style: pw.TextStyle(fontSize: 12, font: ttf),
                        ),
                        pw.Text(
                          'Дата: ${controller.selectedDate.value!.year.toString()}-${controller.selectedDate.value!.month.toString()}',
                          style: pw.TextStyle(fontSize: 12, font: ttf),
                        ),
                        pw.Text(
                          'Типы пропусков: ${absenceTypes.where((type) => controller.selectedAbsenceTypes.contains(type['key'])).map((type) => type['label']).join(', ')}',
                          style: pw.TextStyle(fontSize: 12, font: ttf),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                'Результаты отчета:',
                style: pw.TextStyle(
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                  font: ttf,
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Align(
                alignment: pw.Alignment.center,
                // child: pw.Table(
                //   border: pw.TableBorder.all(color: PdfColors.black, width: 1),
                //   children: [
                //     pw.TableRow(
                //       children: [
                //         pw.Padding(
                //           padding: const pw.EdgeInsets.all(8.0),
                //           child: pw.Text(
                //             'Группа',
                //             style: pw.TextStyle(
                //               fontWeight: pw.FontWeight.bold,
                //               font: ttf,
                //               fontSize: 12,
                //             ),
                //           ),
                //         ),
                //         if (controller.selectedAbsenceTypes
                //             .contains('absenceIllness'))
                //           pw.Padding(
                //             padding: const pw.EdgeInsets.all(8.0),
                //             child: pw.Text(
                //               'Болезнь',
                //               style: pw.TextStyle(
                //                 fontWeight: pw.FontWeight.bold,
                //                 font: ttf,
                //                 fontSize: 12,
                //               ),
                //             ),
                //           ),
                //         if (controller.selectedAbsenceTypes
                //             .contains('absenceOrder'))
                //           pw.Padding(
                //             padding: const pw.EdgeInsets.all(8.0),
                //             child: pw.Text(
                //               'По приказу',
                //               style: pw.TextStyle(
                //                 fontWeight: pw.FontWeight.bold,
                //                 font: ttf,
                //                 fontSize: 12,
                //               ),
                //             ),
                //           ),
                //         if (controller.selectedAbsenceTypes
                //             .contains('absenceResp'))
                //           pw.Padding(
                //             padding: const pw.EdgeInsets.all(8.0),
                //             child: pw.Text(
                //               'Уважительные',
                //               style: pw.TextStyle(
                //                 fontWeight: pw.FontWeight.bold,
                //                 font: ttf,
                //                 fontSize: 12,
                //               ),
                //             ),
                //           ),
                //         if (controller.selectedAbsenceTypes
                //             .contains('absenceDisresp'))
                //           pw.Padding(
                //             padding: const pw.EdgeInsets.all(8.0),
                //             child: pw.Text(
                //               'Неуважительные',
                //               style: pw.TextStyle(
                //                 fontWeight: pw.FontWeight.bold,
                //                 font: ttf,
                //                 fontSize: 12,
                //               ),
                //             ),
                //           ),
                //       ],
                //     ),
                //     ...controller.reportAbsenceData.map((data) {
                //       final absenceReport = data.absenceReport;
                //       final group = controller.groups.firstWhere(
                //         (group) => group.id == data.groupId,
                //         orElse: () =>
                //             Group(id: data.groupId, groupName: 'Неизвестно'),
                //       );
                //       final groupName = group.groupName ?? 'Неизвестно';

                //       return pw.TableRow(
                //         children: [
                //           pw.Padding(
                //             padding: const pw.EdgeInsets.all(8.0),
                //             child: pw.Text(
                //               groupName,
                //               style: pw.TextStyle(font: ttf, fontSize: 12),
                //             ),
                //           ),
                //           if (controller.selectedAbsenceTypes
                //               .contains('absenceIllness'))
                //             pw.Padding(
                //               padding: const pw.EdgeInsets.all(8.0),
                //               child: pw.Text(
                //                 '${absenceReport?.illness ?? 0}',
                //                 style: pw.TextStyle(font: ttf, fontSize: 12),
                //               ),
                //             ),
                //           if (controller.selectedAbsenceTypes
                //               .contains('absenceOrder'))
                //             pw.Padding(
                //               padding: const pw.EdgeInsets.all(8.0),
                //               child: pw.Text(
                //                 '${absenceReport?.order ?? 0}',
                //                 style: pw.TextStyle(font: ttf, fontSize: 12),
                //               ),
                //             ),
                //           if (controller.selectedAbsenceTypes
                //               .contains('absenceResp'))
                //             pw.Padding(
                //               padding: const pw.EdgeInsets.all(8.0),
                //               child: pw.Text(
                //                 '${absenceReport?.resp ?? 0}',
                //                 style: pw.TextStyle(font: ttf, fontSize: 12),
                //               ),
                //             ),
                //           if (controller.selectedAbsenceTypes
                //               .contains('absenceDisresp'))
                //             pw.Padding(
                //               padding: const pw.EdgeInsets.all(8.0),
                //               child: pw.Text(
                //                 '${absenceReport?.disresp ?? 0}',
                //                 style: pw.TextStyle(font: ttf, fontSize: 12),
                //               ),
                //             ),
                //         ],
                //       );
                //     }),
                //   ],
                // ),
                child: pw.TableHelper.fromTextArray(
                  border: pw.TableBorder.all(color: PdfColors.black, width: 1),
                  headerPadding:
                      const pw.EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                  headerStyle: pw.TextStyle(
                    font: ttf,
                    fontSize: 14,
                  ),
                  cellAlignment: pw.Alignment.center,
                  cellPadding:
                      const pw.EdgeInsets.symmetric(horizontal: 2, vertical: 3),
                  cellStyle: pw.TextStyle(
                    font: ttf,
                    fontSize: 12,
                  ),
                  headerDecoration: const pw.BoxDecoration(
                    color: PdfColors.grey300,
                  ),
                  data: [
                    // Заголовки таблицы
                    [
                      'Группа',
                      if (controller.selectedAbsenceTypes
                          .contains('absenceIllness'))
                        'Болезнь',
                      if (controller.selectedAbsenceTypes
                          .contains('absenceOrder'))
                        'По приказу',
                      if (controller.selectedAbsenceTypes
                          .contains('absenceResp'))
                        'Уважительные',
                      if (controller.selectedAbsenceTypes
                          .contains('absenceDisresp'))
                        'Неуважительные',
                    ],
                    // Данные таблицы
                    ...controller.reportAbsenceData.map((data) {
                      final absenceReport = data.absenceReport;
                      final group = controller.groups.firstWhere(
                        (group) => group.id == data.groupId,
                        orElse: () =>
                            Group(id: data.groupId, groupName: 'Неизвестно'),
                      );
                      final groupName = group.groupName ?? 'Неизвестно';

                      return [
                        groupName,
                        if (controller.selectedAbsenceTypes
                            .contains('absenceIllness'))
                          '${absenceReport?.illness ?? 0}',
                        if (controller.selectedAbsenceTypes
                            .contains('absenceOrder'))
                          '${absenceReport?.order ?? 0}',
                        if (controller.selectedAbsenceTypes
                            .contains('absenceResp'))
                          '${absenceReport?.resp ?? 0}',
                        if (controller.selectedAbsenceTypes
                            .contains('absenceDisresp'))
                          '${absenceReport?.disresp ?? 0}',
                      ];
                    }),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );

    final pdfBytes = await pdf.save();

    final tempDir = await getTemporaryDirectory();
    final tempFilePath =
        '${tempDir.path}/Отчет_пропусков_${controller.selectedDate.value!.year.toString()}-${controller.selectedDate.value!.month.toString()}.pdf';
    log(tempFilePath);

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
                      await controller.reportRepository.saveAbsenceReport(
                          userId: controller.authController.id.value,
                          reportData: controller.reportAbsenceData,
                          selectedGroups:
                              controller.absenceSelectedGroups.toList(),
                          date: controller.selectedDate.value!,
                          typesOfAbsence: controller.selectedAbsenceTypes);
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
                          // text: 'Отчет о пропусках ${controller.selectedDate.value!.year.toString()}-${controller.selectedDate.value!.month.toString()}',
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
            ),
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
