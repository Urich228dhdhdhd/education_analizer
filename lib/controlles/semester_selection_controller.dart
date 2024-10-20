import 'package:get/get.dart';

class SemesterSelectionController extends GetxController {
  // Список для хранения выбранных семестров
  final RxList<int> selectedSemesters = <int>[].obs;

  // Метод инициализации выбранных семестров
  void initializeSelectedSemesters(List<int> initialSelectedSemesters) {
    selectedSemesters.value = initialSelectedSemesters;
  }

  // Метод для переключения состояния семестра
  void toggleSemester(int semester) {
    if (selectedSemesters.contains(semester)) {
      _removeSemester(semester); // Удаляем семестр, если он уже выбран
    } else {
      _addSemester(semester); // Добавляем семестр, если он не выбран
    }
  }

  // Заготовка функции для добавления семестра
  void _addSemester(int semester) {
    selectedSemesters.add(semester);
    // Дополнительные действия, которые нужно выполнить при добавлении
    print('Добавлен семестр $semester');
  }

  // Заготовка функции для удаления семестра
  void _removeSemester(int semester) {
    selectedSemesters.remove(semester);
    // Дополнительные действия, которые нужно выполнить при удалении
    print('Удален семестр $semester');
  }

  // Метод для получения выбранных семестров
  List<int> getSelectedSemesters() {
    return selectedSemesters.toList();
  }
}
