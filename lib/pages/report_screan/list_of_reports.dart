import 'dart:developer';
import 'dart:io';

import 'package:education_analizer/controlles/report_page_controller.dart';
import 'package:education_analizer/design/dialog/confirmation_dialog.dart';
import 'package:education_analizer/model/group.dart';
import 'package:education_analizer/model/group_absence_report.dart';
import 'package:education_analizer/model/subject.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xls;

import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../design/dialog/styles.dart';
import '../../design/widgets/colors.dart';
import '../../design/widgets/dimentions.dart';
import '../../model/performanse_report.dart';

class ListOfReports extends StatelessWidget {
  final ReportPageController controller;

  const ListOfReports({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    ReportPageController controller = Get.find();

    controller.searchController.addListener(() {
      controller.searchReport(controller.searchController.text);
    });

    return Column(
      children: [
        const SizedBox(
          height: padding10,
        ),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller.searchController,
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
                  hintText: "Поиск отчета",
                  hintStyle: textFieldtext.copyWith(fontSize: 14),
                  suffixIcon: const Icon(
                    Icons.search,
                    color: greyColor,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            FloatingActionButton(
                heroTag: null,
                backgroundColor: primary8Color,
                onPressed: () {
                  subjectBottomSheet(context, controller);
                },
                elevation: 0,
                shape: const RoundedRectangleBorder(
                  side: BorderSide(color: greyColor),
                  borderRadius: BorderRadius.all(Radius.circular(radius12)),
                ),
                child: SvgPicture.asset(
                  "lib/images/filter.svg",
                  color: greyColor,
                  width: 25,
                  height: 25,
                )),
          ],
        ),
        const SizedBox(
          height: 16,
        ),
        Expanded(
            child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius12), color: whiteColor),
          child: Padding(
              padding: const EdgeInsets.all(padding14),
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                }
                if (controller.reports.isEmpty) {
                  return Center(
                      child: Text(
                    "Отчеты не обнаружены",
                    style: textFieldtext.copyWith(fontSize: 14),
                  ));
                }
                return ListView.builder(
                  itemCount: controller.filteredSearchReports.length,
                  itemBuilder: (context, index) {
                    final report = controller.filteredSearchReports[index];
                    String formattedDate = DateFormat('yyyy-MM-dd | HH:mm:ss')
                        .format(report.createdAt.toLocal());

                    return Padding(
                      padding: const EdgeInsets.only(bottom: padding12),
                      child: InkWell(
                        onTap: () async {
                          final reportData = await controller.reportRepository
                              .getReportDateByReportId(reportId: report.id);

                          if (reportData["type"] == "Absence") {
                            Get.dialog(DialogSelectItem(
                              reportData: reportData,
                              onShowPDF: (Map<String, dynamic> reportData) {
                                openAbsencePreviewWindowPDF(reportData);
                              },
                              onShowExcel: (Map<String, dynamic> reportData) {
                                openAbsencePreviewWindowExcel(reportData);
                              },
                            ));
                          } else if (reportData["type"] == "Performance") {
                            Get.dialog(DialogSelectItem(
                              reportData: reportData,
                              onShowPDF: (reportData) async {
                                openPerformancePreviewWindowPDF(reportData);
                              },
                              onShowExcel: (reportData) async {
                                openPreviewPerformanceWindowExcel(reportData);
                              },
                            ));
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(radius8),
                            color: primaryColor,
                          ),
                          padding: const EdgeInsets.all(padding10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    report.reportName.split(".").first,
                                    style: primaryStyle.copyWith(fontSize: 14),
                                  ),
                                  Text(
                                    formattedDate,
                                    style: textFieldtext,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  IconButton(
                                      visualDensity: VisualDensity.comfortable,
                                      padding: EdgeInsets.zero,
                                      onPressed: () async {
                                        Get.dialog(ConfirmationDialog(
                                          title: "Удаление отчета",
                                          message: "",
                                          onConfirm: () async {
                                            await controller.reportRepository
                                                .deleteReport(
                                                    report_id: report.id);
                                            await controller.getReports();
                                          },
                                        ));
                                      },
                                      icon: SvgPicture.asset(
                                          "lib/images/delete.svg"))
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              })),
        ))
      ],
    );
  }
}

class DialogSelectItem<T> extends StatelessWidget {
  final T reportData;
  final void Function(T reportData) onShowPDF;
  final void Function(T reportData) onShowExcel;
  const DialogSelectItem({
    super.key,
    required this.reportData,
    required this.onShowPDF,
    required this.onShowExcel,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: primaryColor,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius6)),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            vertical: padding20, horizontal: padding14),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Cпособ открытия файла",
              style: preferTextStyle.copyWith(fontSize: 14),
            ),
            const SizedBox(
              height: padding12,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () => onShowPDF(reportData),
                  child: Container(
                    decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(radius10)),
                    child: const Padding(
                        padding: EdgeInsets.all(16),
                        child: Icon(
                          Icons.picture_as_pdf,
                          color: Colors.red,
                        )),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Icon(
                  Icons.compare_arrows_rounded,
                  size: 30,
                  color: greyColor[600],
                ),
                const SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () => onShowExcel(reportData),
                  child: Container(
                    decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(radius10)),
                    child: const Padding(
                        padding: EdgeInsets.all(16),
                        child: Icon(
                          Icons.explicit_outlined,
                          color: Colors.green,
                        )),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void openPerformancePreviewWindowPDF(Map<String, dynamic> reportDate) async {
  try {
    Group selectedGroup = Group.fromJson(reportDate["selected_group"]);
    String period = reportDate["period"];
    PerformanseReport report =
        PerformanseReport.fromJson(reportDate["report_data"]);
    List<Subject> selectedSubjects = reportDate["selected_subjects"]
        .map<Subject>((json) => Subject.fromJson(json))
        .toList();

    final fontData = await rootBundle.load('lib/assets/fonts/Roboto-Black.ttf');
    final ttf = pw.Font.ttf(fontData);
    final ByteData bytes =
        await rootBundle.load('lib/images/college_image.png');
    final Uint8List imageBytes = bytes.buffer.asUint8List();

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
                // pw.Align(
                //   alignment: pw.Alignment.center,
                //   child: pw.Text(
                //     'Отчет о успеваемости',
                //     style: pw.TextStyle(
                //       fontSize: 18,
                //       fontWeight: pw.FontWeight.bold,
                //       font: ttf,
                //     ),
                //   ),
                // ),
                // pw.SizedBox(height: 10),
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
                                        'Группа: ${selectedGroup.groupName}',
                                        style: pw.TextStyle(
                                            fontSize: 12, font: ttf),
                                      ),
                                    ),
                                    pw.Text(
                                      'Период: $period семестр(ы)',
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
                                          // controller.performanceReport.value!
                                          report.studentsLearningPercent !=
                                                  "NaN"
                                              ? "${report.studentsLearningPercent!.split('.').first}%"
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
                                          report.qualityOfKnowledgePercent !=
                                                  "NaN"
                                              ? "${report.qualityOfKnowledgePercent!.split('.').first}%"
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
                                          report.performancePercent != "NaN"
                                              ? "${report.performancePercent!.split('.').first}%"
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
                                  ...selectedSubjects
                                      .map((sub) => sub.subjectNameShort!)
                                ],
                                ...report.marksData!.map((studentData) {
                                  return [
                                    studentData.studentName!,
                                    ...selectedSubjects.map((subject) {
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
        // '${tempDir.path}/Отчет_успеваемость_${controller.startSemester.value!.toString()}-${controller.endSemester.value!.toString()}.pdf';
        '${tempDir.path}/Отчет_успеваемость_${DateTime.now().toIso8601String()}.pdf';
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

void openPreviewPerformanceWindowExcel(Map<String, dynamic> reportData) async {
  try {
    final List<int> excelBytes =
        await compute(generatePerformanceExcelFile, reportData);

    final tempDir = await getTemporaryDirectory();
    final tempFilePath =
        '${tempDir.path}/Отчет_успеваемости_${DateTime.now()..toIso8601String()}.xlsx';
    final file = File(tempFilePath);
    await file.writeAsBytes(excelBytes);

    // Открываем диалог сохранения или сразу делимся файлом
    if (await file.exists()) {
      await Share.shareXFiles([XFile(file.path)]);
    } else {
      log('Ошибка: Файл не найден.');
    }
  } catch (e) {
    log('Ошибка при создании отчёта: $e');
  }
}

List<int> generatePerformanceExcelFile(Map<String, dynamic> reportData) {
  Group selectedGroup = Group.fromJson(reportData["selected_group"]);
  String period = reportData["period"];
  PerformanseReport report =
      PerformanseReport.fromJson(reportData["report_data"]);
  List<Subject> selectedSubjects = reportData["selected_subjects"]
      .map<Subject>((json) => Subject.fromJson(json))
      .toList();

  final workbook = xls.Workbook();
  final sheet = workbook.worksheets[0];

  sheet.getRangeByIndex(1, 1).setText('Группа: ${selectedGroup.groupName}');
  sheet.getRangeByIndex(2, 1).setText('Период: $period семестр(ы)');
  var rowSubIndex = 2;
  sheet.getRangeByIndex(3, 1).setText('Предметы:');
  for (var sub in selectedSubjects) {
    sheet.getRangeByIndex(3, rowSubIndex).setText(sub.subjectNameLong);
    rowSubIndex++;
  }

  sheet.getRangeByIndex(5, 1).setText('Учащиеся');
  int colIndex = 2;
  for (var subject in selectedSubjects) {
    sheet.getRangeByIndex(5, colIndex).setText(subject.subjectNameShort!);
    // sheet.getRangeByIndex(5, 1, 5, colIndex - 1).autoFitRows();
    sheet.getRangeByIndex(5, 1, 5, colIndex - 1).autoFit();

    colIndex++;
  }

  int rowIndex = 6;
  for (var studentData in report.marksData!) {
    sheet.getRangeByIndex(rowIndex, 1).setText(studentData.studentName!);
    colIndex = 2;
    for (var subject in selectedSubjects) {
      final subjectMark = studentData.markData?.firstWhere(
        (markData) => markData.subjectName == subject.subjectNameShort,
      );
      var cell = sheet.getRangeByIndex(rowIndex, colIndex);
      cell.setText(subjectMark!.mark != "null" ? subjectMark.mark! : "—");
      if (subjectMark.isExam == true) {
        cell.cellStyle.bold = true;
        // cell.cellStyle.fontColor = xls.Style().fontColor;
      }
      cell.cellStyle.hAlign = xls.HAlignType.center;
      cell.cellStyle.vAlign = xls.VAlignType.center;
      cell.cellStyle.borders.all.lineStyle = xls.LineStyle.thin;
      colIndex++;
    }
    rowIndex++;
  }

  for (int i = 1; i < colIndex; i++) {
    sheet.getRangeByIndex(5, i).cellStyle.bold = true;
    sheet.getRangeByIndex(5, i).cellStyle.hAlign = xls.HAlignType.center;
    sheet.getRangeByIndex(5, i).cellStyle.vAlign = xls.VAlignType.center;
    sheet.getRangeByIndex(5, i).cellStyle.borders.all.lineStyle =
        xls.LineStyle.thin;
  }

  // sheet.getRangeByIndex(4, 1, rowIndex, colIndex).autoFitColumns();
  // sheet.getRangeByIndex(4, 1, rowIndex - 1, colIndex - 1).autoFitColumns();

  final List<int> bytes = workbook.saveAsStream();
  workbook.dispose();
  return bytes;
}

void openAbsencePreviewWindowPDF(Map<String, dynamic> reportDate) async {
  final absenceTypes = [
    {'key': 'absenceIllness', 'label': 'Болезнь'},
    {'key': 'absenceOrder', 'label': 'По приказу'},
    {'key': 'absenceResp', 'label': 'Уважительные'},
    {'key': 'absenceDisresp', 'label': 'Неуважительные'},
  ];

  try {
    final fontData =
        await rootBundle.load('lib/assets/fonts/Roboto-Regular.ttf');
    final ttf = pw.Font.ttf(fontData);

    final ByteData bytes =
        await rootBundle.load('lib/images/college_image.png');
    final Uint8List imageBytes = bytes.buffer.asUint8List();

    List<GroupAbsenceReport> reports = (reportDate["report_data"]
            as List<dynamic>)
        .map(
            (json) => GroupAbsenceReport.fromJson(json as Map<String, dynamic>))
        .toList();
    List<Group> selectedGroups =
        (reportDate["selected_groups"] as List<dynamic>)
            .map((group) => Group.fromJson(group as Map<String, dynamic>))
            .toList();

    DateTime date = DateTime.parse(reportDate["date"]);

    List<String> typesOfAbsence =
        List<String>.from(reportDate["types_of_absence"]);
    final selectedLabels = typesOfAbsence.map((type) {
      return absenceTypes.firstWhere(
        (element) => element['key'] == type,
        orElse: () => {'label': type},
      )['label'];
    }).toList();

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
                          'Группы: ${selectedGroups.map((group) => group.groupName).join(", ")}',
                          style: pw.TextStyle(fontSize: 12, font: ttf),
                        ),
                        pw.Text(
                          'Дата: ${date.day}-${date.month}-${date.year}',
                          style: pw.TextStyle(fontSize: 12, font: ttf),
                        ),
                        pw.Text(
                          'Типы пропусков: ${selectedLabels.join(", ")}',
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
                //         if (typesOfAbsence.contains('absenceIllness'))
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
                //         if (typesOfAbsence.contains('absenceOrder'))
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
                //         if (typesOfAbsence.contains('absenceResp'))
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
                //         if (typesOfAbsence.contains('absenceDisresp'))
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
                //     ...reports.map((data) {
                //       final absenceReport = data.absenceReport;
                //       final group = selectedGroups.firstWhere(
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
                //           if (typesOfAbsence.contains('absenceIllness'))
                //             pw.Padding(
                //               padding: const pw.EdgeInsets.all(8.0),
                //               child: pw.Text(
                //                 '${absenceReport?.illness ?? 0}',
                //                 style: pw.TextStyle(font: ttf, fontSize: 12),
                //               ),
                //             ),
                //           if (typesOfAbsence.contains('absenceOrder'))
                //             pw.Padding(
                //               padding: const pw.EdgeInsets.all(8.0),
                //               child: pw.Text(
                //                 '${absenceReport?.order ?? 0}',
                //                 style: pw.TextStyle(font: ttf, fontSize: 12),
                //               ),
                //             ),
                //           if (typesOfAbsence.contains('absenceResp'))
                //             pw.Padding(
                //               padding: const pw.EdgeInsets.all(8.0),
                //               child: pw.Text(
                //                 '${absenceReport?.resp ?? 0}',
                //                 style: pw.TextStyle(font: ttf, fontSize: 12),
                //               ),
                //             ),
                //           if (typesOfAbsence.contains('absenceDisresp'))
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
                      if (typesOfAbsence.contains('absenceIllness')) 'Болезнь',
                      if (typesOfAbsence.contains('absenceOrder')) 'По приказу',
                      if (typesOfAbsence.contains('absenceResp'))
                        'Уважительные',
                      if (typesOfAbsence.contains('absenceDisresp'))
                        'Неуважительные',
                    ],
                    // Данные таблицы
                    ...reports.map((data) {
                      final absenceReport = data.absenceReport;
                      final group = selectedGroups.firstWhere(
                        (group) => group.id == data.groupId,
                        orElse: () =>
                            Group(id: data.groupId, groupName: 'Неизвестно'),
                      );
                      final groupName = group.groupName ?? 'Неизвестно';

                      return [
                        groupName,
                        if (typesOfAbsence.contains('absenceIllness'))
                          '${absenceReport?.illness ?? 0}',
                        if (typesOfAbsence.contains('absenceOrder'))
                          '${absenceReport?.order ?? 0}',
                        if (typesOfAbsence.contains('absenceResp'))
                          '${absenceReport?.resp ?? 0}',
                        if (typesOfAbsence.contains('absenceDisresp'))
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
        '${tempDir.path}/Отчет_пропусков_${DateTime.now().toIso8601String()}.pdf';
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

void openAbsencePreviewWindowExcel(Map<String, dynamic> reportData) async {
  try {
    final List<int> excelBytes = await compute(generateExcelFile, reportData);

    final tempDir = await getTemporaryDirectory();
    final tempFilePath =
        '${tempDir.path}/Отчет_пропуски_${DateTime.now().toIso8601String()}.xlsx';
    final file = File(tempFilePath);
    await file.writeAsBytes(excelBytes);

    // Открываем диалог сохранения или сразу делимся файлом
    if (await file.exists()) {
      await Share.shareXFiles([XFile(file.path)]);
    } else {
      log('Ошибка: Файл не найден.');
    }
  } catch (e) {
    log('Ошибка при создании отчёта: $e');
  }
}

List<int> generateExcelFile(Map<String, dynamic> reportData) {
  final absenceTypes = [
    {'key': 'absenceIllness', 'label': 'Болезнь'},
    {'key': 'absenceOrder', 'label': 'По приказу'},
    {'key': 'absenceResp', 'label': 'Уважительные'},
    {'key': 'absenceDisresp', 'label': 'Неуважительные'},
  ];

  List<Group> selectedGroups = (reportData["selected_groups"] as List<dynamic>)
      .map((group) => Group.fromJson(group as Map<String, dynamic>))
      .toList();

  List<GroupAbsenceReport> groupsReport =
      (reportData["report_data"] as List<dynamic>)
          .map((json) => GroupAbsenceReport.fromJson(json))
          .toList();

  DateTime date = DateTime.parse(reportData["date"]);
  List<String> typesOfAbsence = List.from(reportData["types_of_absence"]);
  final labelType = typesOfAbsence
      .map((type) =>
          absenceTypes.firstWhere((element) => element["key"] == type)["label"])
      .toList();

  final workbook = xls.Workbook();
  final sheet = workbook.worksheets[0];

  sheet.getRangeByIndex(1, 1).setText('Группы:');
  sheet.getRangeByIndex(2, 1).setText('Дата:');
  sheet.getRangeByIndex(2, 2).setText("${date.day}-${date.month}-${date.year}");
  sheet.getRangeByIndex(3, 1).setText('Типы пропусков:');

  int rowGroupIndex = 2;
  for (var group in selectedGroups) {
    sheet
        .getRangeByIndex(1, rowGroupIndex)
        .setText(group.groupName ?? 'Неизвестно');
    rowGroupIndex++;
  }

  int rowAbsenceTypeIndex = 2;
  for (var type in labelType) {
    sheet.getRangeByIndex(3, rowAbsenceTypeIndex).setText(type);
    rowAbsenceTypeIndex++;
  }

  sheet.getRangeByIndex(4, 1).setText('Группа');
  int colIndex = 2;
  for (var type in absenceTypes) {
    if (typesOfAbsence.contains(type['key'])) {
      sheet.getRangeByIndex(4, colIndex).setText(type['label']);
      colIndex++;
    }
  }

  int rowIndex = 5;
  for (var data in groupsReport) {
    final group = selectedGroups.firstWhere(
      (group) => group.id == data.groupId,
      orElse: () => Group(id: data.groupId, groupName: 'Неизвестно'),
    );

    sheet.getRangeByIndex(rowIndex, 1).setText(group.groupName ?? 'Неизвестно');

    colIndex = 2;
    for (var type in absenceTypes) {
      if (typesOfAbsence.contains(type['key'])) {
        int value = 0;
        switch (type['key']) {
          case 'absenceIllness':
            value = data.absenceReport?.illness ?? 0;
            break;
          case 'absenceOrder':
            value = data.absenceReport?.order ?? 0;
            break;
          case 'absenceResp':
            value = data.absenceReport?.resp ?? 0;
            break;
          case 'absenceDisresp':
            value = data.absenceReport?.disresp ?? 0;
            break;
        }
        var cell = sheet.getRangeByIndex(rowIndex, colIndex);
        cell.setText(value.toString());
        cell.cellStyle.hAlign = xls.HAlignType.center;
        cell.cellStyle.vAlign = xls.VAlignType.center;
        cell.cellStyle.borders.all.lineStyle = xls.LineStyle.thin;
        cell.autoFitColumns();
        colIndex++;
      }
    }
    rowIndex++;
  }

  for (int i = 1; i <= colIndex; i++) {
    var headerCell = sheet.getRangeByIndex(4, i);
    headerCell.cellStyle.bold = true;
    headerCell.cellStyle.hAlign = xls.HAlignType.center;
    headerCell.cellStyle.vAlign = xls.VAlignType.center;
    headerCell.cellStyle.borders.all.lineStyle = xls.LineStyle.thin;
    sheet.getRangeByIndex(4, i).autoFitColumns();
  }

  sheet.getRangeByIndex(1, 1, rowIndex, colIndex).autoFitColumns();

  final List<int> bytes = workbook.saveAsStream();
  workbook.dispose();

  return bytes;
}

Future<void> subjectBottomSheet(
    BuildContext context, ReportPageController controller) {
  return showModalBottomSheet<void>(
    context: context,
    builder: (BuildContext context) {
      return Container(
        decoration: const BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(
                        "lib/images/filter.svg",
                        color: greyColor,
                      ),
                      const SizedBox(
                        width: padding12,
                      ),
                      const Text(
                        "FILTER",
                        style: preferTextStyle,
                      )
                    ],
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.close,
                      color: greyColor,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 25),
              const Text(
                "Параметры фильтрования",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: controller.reportOptions.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          controller.selectedReportFilter.value = index;
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 25,
                              width: 25,
                              child: Obx(() {
                                return Radio(
                                  fillColor:
                                      WidgetStateProperty.resolveWith<Color>(
                                          (Set<WidgetState> states) {
                                    return (controller
                                                .selectedReportFilter.value ==
                                            index)
                                        ? dialogButtonColor
                                        : greyColor;
                                  }),
                                  toggleable: true,
                                  value: index,
                                  groupValue:
                                      controller.selectedReportFilter.value,
                                  onChanged: (value) {
                                    if (value == null) {
                                      controller.selectedReportFilter.value =
                                          -1;
                                    } else {
                                      controller.selectedReportFilter.value =
                                          value;
                                    }
                                  },
                                );
                              }),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              controller.reportOptions[index],
                              style: const TextStyle(
                                  fontFamily: "Inter",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: TextButton(
                          style: ButtonStyle(
                              shape: WidgetStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(radius8),
                                ),
                              ),
                              backgroundColor:
                                  const WidgetStatePropertyAll(primary9Color)),
                          onPressed: () {
                            controller.filterReport();
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Применить",
                            style: labelTextField.copyWith(
                                fontSize: 16, color: whiteColor),
                          )),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    },
  );
}
