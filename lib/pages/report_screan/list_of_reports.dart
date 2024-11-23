import 'package:education_analizer/controlles/report_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListOfReports extends StatelessWidget {
  final ReportPageController controller;

  const ListOfReports({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    ReportPageController controller = Get.find();

    return const Column(
      children: [
        Text(
          'Список доступных отчетов',
          style: TextStyle(color: Colors.white),
        ),
        // Логика и элементы списка отчетов
      ],
    );
  }
}
