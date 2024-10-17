import 'package:education_analizer/controlles/group_page_controller.dart';
import 'package:education_analizer/design/dialog/app_bar.dart';
import 'package:education_analizer/design/dialog/drawer.dart';
import 'package:education_analizer/design/dialog/styles.dart';
import 'package:education_analizer/design/widgets/colors.dart';
import 'package:education_analizer/pages/group_screan/group_dialog_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GroupPage extends StatelessWidget {
  const GroupPage({super.key});

  @override
  Widget build(BuildContext context) {
    GroupPageController groupPageController = Get.find();

    String selectedFilter = 'По номеру';

    List<String> filterOptions = [
      'По номеру',
      'По названию',
      'По количеству студентов'
    ];

    return Scaffold(
      backgroundColor: primaryColor,
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(role: groupPageController.authController.role.value),
      drawer: CustomDrawer(role: groupPageController.authController.role.value),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 16.0, top: 16, right: 16, bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  dropContainer(selectedFilter, filterOptions),
                  FloatingActionButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return const GroupDialog();
                          });
                    },
                    backgroundColor: primary6Color,
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SizedBox(
                width: 300,
                child: Obx(() {
                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: groupPageController.groups.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> group =
                          groupPageController.groups[index];
                      String groupName = group['group_name'];
                      int studentCount = group['student_count'];

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10), // Отступы сверху и снизу
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
          ],
        ),
      ),
    );
  }

  Container dropContainer(String selectedFilter, List<String> filterOptions) {
    return Container(
      width: 180, // Устанавливаем фиксированную ширину
      decoration: BoxDecoration(
        color: primary6Color,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: DropdownButton<String>(
        value: selectedFilter,
        isExpanded: true, // Занимает доступное пространство
        icon: const Icon(Icons.arrow_downward, color: Colors.white),
        iconSize: 24,
        elevation: 16,
        style: dropdownButtonTextStyle,
        borderRadius: BorderRadius.circular(7),
        dropdownColor: primary6Color, // Цвет фона выпадающего списка
        underline: Container(), // Убираем подчеркивание
        items: filterOptions.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value, style: dropdownButtonTextStyle),
          );
        }).toList(),
        onChanged: (newValue) {
          selectedFilter = newValue!;
          // Пример применения фильтрации
          // groupPageController.applyFilter(selectedFilter);
        },
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
        borderRadius: BorderRadius.circular(25),
      ),
      elevation: 4,
      child: SizedBox(
        width: 300,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
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
