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
      appBar: CustomAppBar(role: groupPageController.authController.role.value),
      drawer: CustomDrawer(role: groupPageController.authController.role.value),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _dropContainer(selectedFilter, filterOptions),
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
                    itemCount: groupPageController.groups.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> group =
                          groupPageController.groups[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: GroupCard(
                          groupId: group['id'],
                          groupName: group['group_name'],
                          studentCount: group['student_count'],
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

  Container _dropContainer(String selectedFilter, List<String> filterOptions) {
    return Container(
      width: 180,
      decoration: BoxDecoration(
        color: primary6Color,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: DropdownButton<String>(
        value: selectedFilter,
        isExpanded: true,
        icon: const Icon(Icons.arrow_downward, color: Colors.white),
        style: dropdownButtonTextStyle,
        dropdownColor: primary6Color,
        underline: Container(),
        items: filterOptions.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value, style: dropdownButtonTextStyle),
          );
        }).toList(),
        onChanged: (newValue) {
          selectedFilter = newValue!;
          // Можно добавить логику фильтрации здесь
        },
      ),
    );
  }
}

class GroupCard extends StatelessWidget {
  final String groupName;
  final int studentCount;
  final int groupId;

  const GroupCard({
    super.key,
    required this.groupName,
    required this.studentCount,
    required this.groupId,
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
        height: 200,
        width: 300,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
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
            Positioned(
              right: 3,
              top: 5,
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.more_vert, size: 20),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return GroupDialog(
                          groupId: groupId,
                          initialGroupName: groupName,
                        );
                      });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
