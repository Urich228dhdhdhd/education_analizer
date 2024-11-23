import 'package:education_analizer/controlles/report_page_controller.dart';
import 'package:education_analizer/design/dialog/app_bar.dart';
import 'package:education_analizer/design/dialog/drawer.dart';
import 'package:education_analizer/design/widgets/colors.dart';
import 'package:education_analizer/pages/report_screan/absence_report.dart';
import 'package:education_analizer/pages/report_screan/list_of_reports.dart';
import 'package:education_analizer/pages/report_screan/performance_report.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    ReportPageController controller = Get.find();

    return WillPopScope(
      onWillPop: () async {
        Get.offAllNamed("/home");
        return false;
      },
      child: Scaffold(
        backgroundColor: primaryColor,
        resizeToAvoidBottomInset: false,
        appBar: CustomAppBar(role: controller.authController.role.value),
        drawer: CustomDrawer(role: controller.authController.role.value),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Поле выбора между отчетом по успеваемости, пропускам и списком
              Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: primary9Color, width: 2),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          controller.selectReportType(0);
                        },
                        child: Obx(() {
                          return Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(25),
                                bottomLeft: Radius.circular(25),
                              ),
                              color: controller.selectedReportIndex.value == 0
                                  ? primary9Color
                                  : Colors.transparent,
                            ),
                            child: Text(
                              'Успеваемость',
                              style: TextStyle(
                                color: controller.selectedReportIndex.value == 0
                                    ? Colors.white
                                    : primary9Color,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    Container(
                      width: 3,
                      color: primary9Color,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          controller.selectReportType(1);
                        },
                        child: Obx(() {
                          return Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: controller.selectedReportIndex.value == 1
                                  ? primary9Color
                                  : Colors.transparent,
                            ),
                            child: Text(
                              'Пропуски',
                              style: TextStyle(
                                color: controller.selectedReportIndex.value == 1
                                    ? Colors.white
                                    : primary9Color,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    Container(
                      width: 3,
                      color: primary9Color,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          controller.selectReportType(2);
                        },
                        child: Obx(() {
                          return Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(25),
                                bottomRight: Radius.circular(25),
                              ),
                              color: controller.selectedReportIndex.value == 2
                                  ? primary9Color
                                  : Colors.transparent,
                            ),
                            child: Text(
                              'Список отчетов',
                              style: TextStyle(
                                color: controller.selectedReportIndex.value == 2
                                    ? Colors.white
                                    : primary9Color,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              // Дальше можно добавить элементы, зависящие от выбранного отчета
              Expanded(
                child: Obx(() {
                  switch (controller.selectedReportIndex.value) {
                    case 0:
                      return PerformanceReport(
                        controller: controller,
                      );
                    case 1:
                      return AbsenceReport(controller: controller);
                    case 2:
                      return ListOfReports(controller: controller);
                    default:
                      return const SizedBox();
                  }
                }),
              ),
              // Можно добавить сюда другие виджеты, которые будут зависеть от выбранного отчета
            ],
          ),
        ),
      ),
    );
  }
}
