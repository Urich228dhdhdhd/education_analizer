import 'package:education_analizer/design/dialog/styles.dart';
import 'package:flutter/material.dart';
import 'package:education_analizer/design/widgets/colors.dart';
import 'package:education_analizer/design/widgets/images.dart';
import 'package:get/get.dart';

class CustomDrawer extends StatelessWidget {
  final String role; // Параметр для передачи роли

  const CustomDrawer({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: primary7Color, // Цвет фона заголовка
            ),
            child: Image.asset("lib/images/college_image.png"),
          ),
          ListTile(
            leading: SizedBox(
              height: 25, // Высота иконки
              width: 25, // Ширина иконки
              child: homeImage,
            ),
            title: const Text(
              'Главное меню',
              style: styleDrawer,
            ),
            onTap: () {
              Get.toNamed("/home");
            },
          ),
          ListTile(
            leading: SizedBox(
              height: 25,
              width: 25,
              child: groupImage,
            ),
            title: const Text(
              'Группы',
              style: styleDrawer,
            ),
            onTap: () {
              Get.toNamed("/group");
            },
          ),
          ListTile(
            leading: SizedBox(
              height: 25,
              width: 25,
              child: studentImage,
            ),
            title: const Text(
              'Студенты',
              style: styleDrawer,
            ),
            onTap: () {
              Get.toNamed("/student");
            },
          ),
          ListTile(
            leading: SizedBox(
              height: 25,
              width: 25,
              child: subjectImage,
            ),
            title: const Text(
              'Предметы',
              style: styleDrawer,
            ),
            onTap: () {
              Get.toNamed("/subject");
            },
          ),
          ListTile(
            leading: SizedBox(
              height: 25,
              width: 25,
              child: progressImage,
            ),
            title: const Text(
              'Успеваемость',
              style: styleDrawer,
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: SizedBox(
              height: 25,
              width: 25,
              child: absenceImage,
            ),
            title: const Text(
              'Пропуски',
              style: styleDrawer,
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: SizedBox(
              height: 25,
              width: 25,
              child: reportImage,
            ),
            title: const Text(
              'Отчеты',
              style: styleDrawer,
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          // Пункты меню в зависимости от роли
          if (role == 'ADMINISTRATOR') ...[
            ListTile(
              leading: SizedBox(
                height: 25,
                width: 25,
                child: userListImage,
              ),
              title: const Text(
                'Список пользователей',
                style: styleDrawer,
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: SizedBox(
                height: 25,
                width: 25,
                child: archiveImage,
              ),
              title: const Text(
                'Архив',
                style: styleDrawer,
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
          ListTile(
            leading: SizedBox(
              height: 25,
              width: 25,
              child: exitImage,
            ),
            title: const Text(
              'Выход',
              style: styleDrawer,
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
