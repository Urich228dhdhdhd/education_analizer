import 'package:education_analizer/controlles/group_dialog_page_controller.dart';
import 'package:education_analizer/design/dialog/styles.dart';
import 'package:education_analizer/design/widgets/colors.dart';
import 'package:education_analizer/model/subject.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GroupDialog extends StatelessWidget {
  final int? groupId; // ID группы для редактирования
  final String? initialGroupName; // Начальное имя группы для редактирования

  const GroupDialog({
    super.key,
    this.groupId,
    this.initialGroupName,
  });

  @override
  Widget build(BuildContext context) {
    // Получаем контроллер
    final GroupDialogPageController dialogController = Get.find();
    dialogController.fetchAllSubjects();

    // dialogController.fetchAllSubjects();
    if (groupId != null) {
      dialogController.fetchAllListOfSubjectByGroupId(groupId!);
    }

    // Контроллеры
    final TextEditingController groupNameController =
        TextEditingController(text: initialGroupName ?? "");
    final TextEditingController searchController = TextEditingController();

    // Запрашиваем все предметы
    dialogController.fetchAllSubjects();
    if (groupId != null) {
      dialogController.fetchAllListOfSubjectByGroupId(groupId!);
    }

    // Слушаем изменения в поле поиска
    searchController.addListener(() {
      dialogController.filterSubjects(searchController.text);
    });

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: primary2Color,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 400,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    groupId == null
                        ? 'Создать новую группу'
                        : 'Редактировать группу',
                    style: dialogMainTextStyle,
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    decoration: inputField("Название группы"),
                    controller: groupNameController,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    decoration:
                        inputFieldWithIcon("Поиск предмета", Icons.search),
                    controller: searchController,
                  ),
                  const SizedBox(height: 20),
                  // Список предметов
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Obx(() {
                      return ListView.builder(
                        itemCount: dialogController.filteredSubjects.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    dialogController.filteredSubjects[index]
                                            .subjectNameShort ??
                                        '',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: const TextField(
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Описание',
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: elevationButtonStyle(),
                      onPressed: () {
                        if (groupId == null) {
                          dialogController.createNewGroup(
                            groupName: groupNameController.text.trim(),
                          );
                        } else {
                          dialogController.editGroup(
                            id: groupId!,
                            groupName: groupNameController.text.trim(),
                          );
                        }
                        Get.back(); // Закрыть диалог после выполнения действия
                      },
                      child: const Text(
                        'Сохранить',
                        style: dropdownButtonTextStyle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  ButtonStyle elevationButtonStyle() {
    return ButtonStyle(
      backgroundColor: WidgetStateProperty.all<Color>(
        const Color(0xFF1D427A),
      ),
      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }

  InputDecoration inputField(String labelText) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: styleDrawer,
      filled: true,
      fillColor: primary8Color,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }

  InputDecoration inputFieldWithIcon(String labelText, IconData icon) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: styleDrawer,
      filled: true,
      fillColor: primary8Color,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      suffixIcon: Icon(icon, color: Colors.grey),
    );
  }
}
