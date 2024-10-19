import 'package:education_analizer/controlles/group_dialog_page_controller.dart';
import 'package:education_analizer/design/dialog/styles.dart';
import 'package:education_analizer/design/widgets/colors.dart';
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
    // Контроллеры для текстовых полей
    TextEditingController groupNameController =
        TextEditingController(text: initialGroupName ?? "");
    TextEditingController semesterNumberController = TextEditingController();

    GroupDialogPageController dialogController = Get.find();

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: primary2Color,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
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
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: inputField("Номер семестра"),
                        keyboardType: TextInputType.number,
                        controller: semesterNumberController,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add, color: Colors.grey),
                      onPressed: () {
                        // Здесь можно добавить логику для добавления нового семестра в список
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Список семестров
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListView.builder(
                    itemCount: 3, // Замените на актуальное количество семестров
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text('Семестр $index'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.grey),
                              onPressed: () {
                                // Здесь можно добавить логику для редактирования семестра
                              },
                            ),
                            IconButton(
                              icon:
                                  const Icon(Icons.delete, color: Colors.grey),
                              onPressed: () {
                                // Здесь можно добавить логику для удаления семестра
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                // Кнопка ниже списка
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
    );
  }

  ButtonStyle elevationButtonStyle() {
    return ButtonStyle(
      backgroundColor: WidgetStateProperty.all<Color>(
          const Color(0xFF1D427A)), // Цвет фона кнопки
      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15), // Скругление углов на 15
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
}
