import 'dart:developer';
import 'dart:io';

import 'package:education_analizer/controlles/report_page_controller.dart';
import 'package:education_analizer/design/widgets/colors.dart';
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
        Obx(() {
          return EasyStepper(
            activeStep: controller.currentStep.value,
            lineStyle: const LineStyle(
              lineLength: 75,
              lineThickness: 8,
              lineSpace: 1,
              lineType: LineType.normal,
              defaultLineColor: primary9Color,
              progress: 0.2,
              progressColor: primary6Color,
            ),
            finishedStepBackgroundColor: primary7Color,
            finishedStepIconColor: primary6Color,
            finishedStepBorderColor: primary6Color,
            activeStepBorderColor: primary9Color,
            activeStepIconColor: primary9Color,
            borderThickness: 10,
            internalPadding: 5,
            showLoadingAnimation: false,
            // loadingAnimation: "lib/images/loading_circle.json",
            steps: const [
              EasyStep(
                icon: Icon(
                  Icons.groups,
                ),
                finishIcon: Icon(
                  Icons.task_alt_sharp,
                ),
                customTitle: Text(
                  "Группа",
                  textAlign: TextAlign.center,
                ),
                lineText: 'Выбор группы',
              ),
              EasyStep(
                icon: Icon(Icons.calendar_today),
                finishIcon: Icon(Icons.task_alt_sharp),
                customTitle: Text(
                  "Дата",
                  textAlign: TextAlign.center,
                ),
                lineText: 'Выбор даты',
              ),
              EasyStep(
                icon: Icon(Icons.type_specimen_rounded),
                title: 'Тип пропусков',
                finishIcon: Icon(Icons.task_alt_sharp),
              ),
            ],
            onStepReached: (index) {
              // controller.currentStep.value = index;
            },
          );
        }),
        Expanded(
          child: Obx(
              () => _getStepWidget(controller, controller.currentStep.value)),
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
    children: [
      Expanded(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Color(0xFFc2d0e3),
                spreadRadius: 10,
                blurRadius: 10,
                offset: Offset(3, 3),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              return ListView.builder(
                itemCount: controller.groups.length,
                itemBuilder: (context, index) {
                  final group = controller.groups[index];

                  return Obx(() {
                    return Card(
                      color: controller.selectedGroups.contains(group.id)
                          ? primaryColor // Цвет для выбранного элемента
                          : Colors.white, // Цвет для невыбранного элемента
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 12),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Obx(() {
                              return Checkbox(
                                activeColor: primary9Color,
                                value: controller.selectedGroups
                                    .contains(group.id),
                                onChanged: (value) {
                                  controller.toggleGroupSelection(group.id!);
                                },
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                              );
                            }),
                            Expanded(
                              child: Text(
                                group.groupName!,
                                style: const TextStyle(fontSize: 16),
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                              ),
                            ),
                          ],
                        ),
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
              onPressed: () {
                if (controller.selectedGroups.isEmpty) {
                  Get.snackbar(
                    "Ошибка выбора",
                    duration: const Duration(milliseconds: 1200),
                    "Выберите группы для отчета",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: const Color.fromRGBO(244, 67, 54, 70),
                    colorText: Colors.white,
                  );
                } else {
                  if (controller.currentStep.value < 2) {
                    controller.currentStep.value++;
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
    children: [
      Expanded(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: SfDateRangePicker(
            view: DateRangePickerView.year,
            selectionMode: DateRangePickerSelectionMode.single, // Один месяц
            allowViewNavigation: false,
            monthFormat: 'MMMM',
            headerStyle: const DateRangePickerHeaderStyle(
              backgroundColor: primary9Color, // Фон заголовка
              textStyle: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            selectionColor: Colors.blue, // Цвет выделения месяца
            selectionTextStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),

            // Оформление ячеек года
            yearCellStyle: DateRangePickerYearCellStyle(
              textStyle: const TextStyle(
                color: Colors.black87,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              todayTextStyle: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
              todayCellDecoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.2),
                borderRadius: BorderRadius.circular(
                    8), // Скругление углов для ячеек с сегодняшней датой
              ),
            ),

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
      Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton(
              heroTag: null,
              onPressed: () {
                if (controller.currentStep.value > 0) {
                  controller.currentStep.value--;
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
                  Get.snackbar(
                    "Ошибка выбора",
                    duration: const Duration(milliseconds: 1200),
                    "Выберите дату для отчета",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: const Color.fromRGBO(244, 67, 54, 70),
                    colorText: Colors.white,
                  );
                } else {
                  if (controller.currentStep.value < 2) {
                    controller.currentStep.value++;
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
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      Container(
        width: 350,
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Color(0xFFc2d0e3),
              spreadRadius: 10,
              blurRadius: 10,
              offset: Offset(3, 3),
            ),
          ],
        ),
        child: Obx(() {
          return ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: absenceTypes.map((type) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: controller.selectedAbsenceTypes.contains(type['key'])
                        ? primaryColor
                        : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: CheckboxListTile(
                    // tileColor: const Color.fromARGB(255, 16, 16, 16),
                    title: Text(
                      type['label']!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    value:
                        controller.selectedAbsenceTypes.contains(type['key']),
                    onChanged: (isChecked) {
                      if (isChecked == true) {
                        controller.selectedAbsenceTypes.add(type['key']!);
                      } else {
                        controller.selectedAbsenceTypes.remove(type['key']!);
                      }
                    },
                    activeColor: primary9Color,
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
      Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton(
              heroTag: null,
              onPressed: () {
                if (controller.currentStep.value > 0) {
                  controller.currentStep.value--;
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
                  Get.snackbar(
                    "Ошибка выбора",
                    duration: const Duration(milliseconds: 1200),
                    "Выберите типы пропусков для отчета",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: const Color.fromRGBO(244, 67, 54, 70),
                    colorText: Colors.white,
                  );
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
    final fontData = await rootBundle.load('lib/assets/fonts/Roboto-Black.ttf');
    final ttf = pw.Font.ttf(fontData);

    final ByteData bytes =
        await rootBundle.load('lib/images/college_image.png');
    final Uint8List imageBytes = bytes.buffer.asUint8List();

    final reportData = await controller.absenceRepository.getAbsenceReport(
      groupIds: controller.selectedGroups.toList(),
      year: controller.selectedDate.value!.year,
      month: controller.selectedDate.value!.month,
      absenceTypes: controller.selectedAbsenceTypes,
    );

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
                          'Группы: ${controller.groups.where((group) => controller.selectedGroups.contains(group.id)).map((group) => group.groupName).join(", ")}',
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
                child: pw.Table(
                  border: pw.TableBorder.all(color: PdfColors.black, width: 1),
                  children: [
                    pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text(
                            'Группа',
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              font: ttf,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        if (controller.selectedAbsenceTypes
                            .contains('absenceIllness'))
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8.0),
                            child: pw.Text(
                              'Болезнь',
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                font: ttf,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        if (controller.selectedAbsenceTypes
                            .contains('absenceOrder'))
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8.0),
                            child: pw.Text(
                              'По приказу',
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                font: ttf,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        if (controller.selectedAbsenceTypes
                            .contains('absenceResp'))
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8.0),
                            child: pw.Text(
                              'Уважительные',
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                font: ttf,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        if (controller.selectedAbsenceTypes
                            .contains('absenceDisresp'))
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8.0),
                            child: pw.Text(
                              'Неуважительные',
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                font: ttf,
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
                    ),
                    ...reportData.map((data) {
                      final absenceReport = data.absenceReport;
                      final group = controller.groups.firstWhere(
                        (group) => group.id == data.groupId,
                        orElse: () =>
                            Group(id: data.groupId, groupName: 'Неизвестно'),
                      );
                      final groupName = group.groupName ?? 'Неизвестно';

                      return pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8.0),
                            child: pw.Text(
                              groupName,
                              style: pw.TextStyle(font: ttf, fontSize: 12),
                            ),
                          ),
                          if (controller.selectedAbsenceTypes
                              .contains('absenceIllness'))
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(8.0),
                              child: pw.Text(
                                '${absenceReport?.illness ?? 0}',
                                style: pw.TextStyle(font: ttf, fontSize: 12),
                              ),
                            ),
                          if (controller.selectedAbsenceTypes
                              .contains('absenceOrder'))
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(8.0),
                              child: pw.Text(
                                '${absenceReport?.order ?? 0}',
                                style: pw.TextStyle(font: ttf, fontSize: 12),
                              ),
                            ),
                          if (controller.selectedAbsenceTypes
                              .contains('absenceResp'))
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(8.0),
                              child: pw.Text(
                                '${absenceReport?.resp ?? 0}',
                                style: pw.TextStyle(font: ttf, fontSize: 12),
                              ),
                            ),
                          if (controller.selectedAbsenceTypes
                              .contains('absenceDisresp'))
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(8.0),
                              child: pw.Text(
                                '${absenceReport?.disresp ?? 0}',
                                style: pw.TextStyle(font: ttf, fontSize: 12),
                              ),
                            ),
                        ],
                      );
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
            const Text('Предпросмотр отчета'),
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
                  Get.snackbar('Ошибка', 'Не удалось поделиться файлом: $e');
                }
              },
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
