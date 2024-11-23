import 'package:education_analizer/controlles/report_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PerformanceReport extends StatelessWidget {
  final ReportPageController controller;

  const PerformanceReport({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    ReportPageController controller = Get.find();

    return const Column(
      children: [
        Text(
          'Отчет по успеваемости',
          style: TextStyle(color: Colors.white),
        ),
        // Логика и элементы отчета по успеваемости
      ],
    );
  }
}
