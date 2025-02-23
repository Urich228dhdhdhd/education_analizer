import 'package:education_analizer/controlles/main_page_controller.dart';
import 'package:education_analizer/design/dialog/styles.dart';
import 'package:flutter/material.dart';
import 'package:education_analizer/design/widgets/colors.dart';
import 'package:education_analizer/design/widgets/images.dart';
import 'package:get/get.dart';

class CustomDrawer extends StatelessWidget {
  final String role;

  const CustomDrawer({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: primary7Color,
            ),
            child: Image.asset(
              "lib/images/college_image.png",
            ),
          ),
          ListTile(
            tileColor: Get.currentRoute == "/home" ? greyColor[300] : null,
            leading: SizedBox(
              height: 25,
              width: 25,
              child: homeImage,
            ),
            title: const Text(
              'Главное меню',
              style: styleDrawer,
            ),
            onTap: () async {
              Get.toNamed("/home");
            },
          ),
          ListTile(
            tileColor: Get.currentRoute == "/group" ? greyColor[300] : null,
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
            tileColor: Get.currentRoute == "/student" ? greyColor[300] : null,
            leading: SizedBox(
              height: 25,
              width: 25,
              child: studentImage,
            ),
            title: const Text(
              'Учащиеся',
              style: styleDrawer,
            ),
            onTap: () {
              Get.toNamed("/student");
            },
          ),
          if (role == 'ADMINISTRATOR') ...[
            ListTile(
              tileColor: Get.currentRoute == "/subject" ? greyColor[300] : null,
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
          ],
          ListTile(
            tileColor:
                Get.currentRoute == "/performance" ? greyColor[300] : null,
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
              Get.toNamed("/performance");
            },
          ),
          ListTile(
            tileColor: Get.currentRoute == "/absence" ? greyColor[300] : null,
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
              Get.toNamed("/absence");
            },
          ),
          ListTile(
            tileColor: Get.currentRoute == "/report" ? greyColor[300] : null,
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
              Get.toNamed("/report");
            },
          ),
          if (role == 'ADMINISTRATOR') ...[
            ListTile(
              tileColor:
                  Get.currentRoute == "/user-list" ? greyColor[300] : null,
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
                Get.toNamed("/user-list");
              },
            ),
            ListTile(
              tileColor: Get.currentRoute == "/archive" ? greyColor[300] : null,
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
                Get.toNamed("/archive");
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
              Get.toNamed("/login");
              Get.deleteAll();
            },
          ),
        ],
      ),
    );
  }
}
