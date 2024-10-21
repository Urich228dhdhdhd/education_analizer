import 'package:education_analizer/model/list_of_subject.dart';
import 'package:education_analizer/repository/listofsubject_repository.dart';
import 'package:get/get.dart';

class SemesterSelectionController extends GetxController {
  final ListofsubjectRepository listOfSubjectRepository; // Объявляем переменную

  // Список для хранения выбранных семестров
  final RxList<int> selectedSemesters = <int>[].obs;
  // Локальный список для отслеживания изменений
  final List<int> initialSemesters = <int>[];

  // Конструктор контроллера
  SemesterSelectionController({required this.listOfSubjectRepository});

  // Метод инициализации выбранных семестров
  void initializeSelectedSemesters(List<ListOfSubject> subjects) {
    selectedSemesters.value = subjects
        .map((subject) => subject.semesterNumber)
        .where((semester) => semester != null)
        .map((semester) => semester!)
        .toList();

    // Сохраняем исходное состояние семестров для сравнения
    initialSemesters.clear();
    initialSemesters.addAll(selectedSemesters);
  }

  // Метод для переключения состояния семестра
  void toggleSemester(int semester) {
    if (selectedSemesters.contains(semester)) {
      selectedSemesters.remove(semester); // Убираем семестр из списка
    } else {
      selectedSemesters.add(semester); // Добавляем семестр в список
    }
  }

  // Метод для применения изменений при нажатии "ОК"
  Future<void> applyChanges(int groupId, int subjectId) async {
    // Проходим по всем семестрам, чтобы добавить или удалить их в базе
    for (int semester in selectedSemesters) {
      if (!initialSemesters.contains(semester)) {
        // Новый семестр - добавляем в базу
        await listOfSubjectRepository.createListOfSubject({
          'semester_number': semester,
          'group_id': groupId,
          'subject_id': subjectId,
        });
      }
    }

    for (int semester in initialSemesters) {
      if (!selectedSemesters.contains(semester)) {
        // Семестр был убран - удаляем из базы
        await listOfSubjectRepository.deleteListOfSubjectbyAllParams(
            groupId, subjectId, semester);
      }
    }
  }

  // Метод для получения выбранных семестров
  List<int> getSelectedSemesters() {
    return selectedSemesters.toList();
  }
}
