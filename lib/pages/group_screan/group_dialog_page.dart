import 'package:education_analizer/design/dialog/styles.dart';
import 'package:education_analizer/design/widgets/colors.dart';
import 'package:flutter/material.dart';

class GroupDialog extends StatelessWidget {
  const GroupDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: primary2Color, // Установленный цвет фона
      child: SafeArea(
        child: SingleChildScrollView(
          // Оборачиваем в SingleChildScrollView для прокрутки при появлении клавиатуры
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Создать новую группу',
                  style: dialogMainTextStyle,
                ),
                const SizedBox(height: 10),
                // Поле для ввода названия группы
                TextField(
                  decoration: inputField("Название группы"),
                ),
                const SizedBox(height: 20),
                // Поле для ввода номера семестра с иконкой добавления
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: inputField("Номер семестра"),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add, color: Colors.grey),
                      onPressed: () {
                        // Действие для иконки добавления
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Лист с фиксированной высотой 200
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListView.builder(
                    itemCount: 3, // Для демонстрации 3 элемента
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text('Семестр $index'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.grey),
                              onPressed: () {
                                // Действие для иконки редактирования
                              },
                            ),
                            IconButton(
                              icon:
                                  const Icon(Icons.delete, color: Colors.grey),
                              onPressed: () {
                                // Действие для иконки удаления
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
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(
                          const Color(0xFF1D427A)), // Цвет фона кнопки
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              15), // Скругление углов на 15
                        ),
                      ),
                    ),
                    onPressed: () {
                      // Действие для кнопки
                    },
                    child: const Text(
                      'Добавить группу',
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
