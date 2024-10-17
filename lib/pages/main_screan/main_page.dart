import 'package:education_analizer/controlles/main_page_controller.dart';
import 'package:education_analizer/design/dialog/app_bar.dart';
import 'package:education_analizer/design/dialog/drawer.dart';
import 'package:education_analizer/design/dialog/styles.dart';
import 'package:education_analizer/design/widgets/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Инициализация контроллера
    MainPageController mainPageController = Get.find();

    return Scaffold(
      backgroundColor: primaryColor,
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(role: mainPageController.authController.role.value),
      drawer: CustomDrawer(role: mainPageController.authController.role.value),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Отступы вокруг списка
          child: SizedBox(
            height: 200,
            child: Obx(() {
              // Используем Obx для обновления UI, когда изменяется список групп
              return ListView.builder(
                scrollDirection: Axis.horizontal, // Горизонтальный список
                itemCount: mainPageController.groups.length, // Количество групп
                itemBuilder: (context, index) {
                  // Получаем данные о группе
                  Map<String, dynamic> group = mainPageController.groups[index];
                  String groupName = group['group_name'];
                  int studentCount = group['student_count'];

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: GroupCard(
                      groupName: groupName,
                      studentCount: studentCount,
                    ),
                  );
                },
              );
            }),
          ),
        ),
      ),
    );
  }
}

class GroupCard extends StatelessWidget {
  final String groupName;
  final int studentCount;

  const GroupCard({
    super.key,
    required this.groupName,
    required this.studentCount,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 4,
      child: SizedBox(
        width: 300,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment:
                CrossAxisAlignment.center, // Центрирование по горизонтали
            children: [
              Text(
                groupName,
                style: cardMainTextStyle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 10),
              Text(
                "Количество учащихся: $studentCount",
                style: styleDrawer,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
