import 'dart:developer';

import 'package:education_analizer/controlles/report_page_controller.dart';
import 'package:education_analizer/design/dialog/app_bar.dart';
import 'package:education_analizer/design/dialog/drawer.dart';
import 'package:education_analizer/design/widgets/colors.dart';
import 'package:education_analizer/design/widgets/dimentions.dart';
import 'package:education_analizer/pages/report_screan/absence_report.dart';
import 'package:education_analizer/pages/report_screan/list_of_reports.dart';
import 'package:education_analizer/pages/report_screan/performance_report.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ReportPageController controller = Get.find();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Код будет выполнен после того, как виджеты были отрисованы
      controller.findGroupsByRole();
    });

    return WillPopScope(
      onWillPop: () async {
        homeRoute();
        return false;
      },
      child: Scaffold(
        backgroundColor: primaryColor,
        resizeToAvoidBottomInset: false,
        appBar: CustomAppBar(role: controller.authController.role.value),
        drawer: CustomDrawer(role: controller.authController.role.value),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              children: [
                // Поле выбора между отчетом по успеваемости, пропускам и списком
                Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: primary10Color, width: 1),
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
                                    ? primary10Color
                                    : Colors.transparent,
                              ),
                              child: Text(
                                'Успеваемость',
                                style: TextStyle(
                                  color:
                                      controller.selectedReportIndex.value == 0
                                          ? Colors.white
                                          : primary10Color,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                      Container(
                        width: 1,
                        color: primary10Color,
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
                                    ? primary10Color
                                    : Colors.transparent,
                              ),
                              child: Text(
                                'Пропуски',
                                style: TextStyle(
                                  color:
                                      controller.selectedReportIndex.value == 1
                                          ? Colors.white
                                          : primary10Color,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                      Container(
                        width: 1,
                        color: primary10Color,
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            try {
                              controller.selectReportType(2);
                              await controller.getReports();
                            } catch (e) {
                              showSnackBar(
                                  title: "Ошибка", message: e.toString());
                            }

                            // log(controller.reports.toString());
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
                                    ? primary10Color
                                    : Colors.transparent,
                              ),
                              child: Text(
                                'Список отчетов',
                                style: TextStyle(
                                  color:
                                      controller.selectedReportIndex.value == 2
                                          ? Colors.white
                                          : primary10Color,
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
                // const SizedBox(height: 5),
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
      ),
    );
  }
}
