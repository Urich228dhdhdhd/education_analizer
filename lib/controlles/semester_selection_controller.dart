import 'dart:developer';

import 'package:education_analizer/model/list_of_subject.dart';
import 'package:education_analizer/repository/listofsubject_repository.dart';
import 'package:get/get.dart';

class SemesterSelectionController extends GetxController {
  final ListofsubjectRepository listOfSubjectRepository;

  final RxList<int> selectedSemesters = <int>[].obs;
  final List<int> initialSemesters = <int>[];

  // Конструктор контроллера
  SemesterSelectionController({required this.listOfSubjectRepository});

  // Метод инициализации выбранных семестров
  void initializeSelectedSemesters(List<ListOfSubject> subjects) {
    // Инициализируем начальные семестры на основе переданных данных
    initialSemesters
        .addAll(subjects.map((subject) => subject.semesterId!).toList());
    // Инициализируем выбранные семестры в контроллере
    selectedSemesters.clear();
    selectedSemesters.addAll(initialSemesters);
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
        await listOfSubjectRepository.createListOfSubject(
            listOfSubject: ListOfSubject(
                subjectId: subjectId, groupId: groupId, semesterId: semester));
      }
    }
    for (int semester in initialSemesters) {
      if (!selectedSemesters.contains(semester)) {
        await listOfSubjectRepository.deleteListOfSubjectbyAllParams(
            listOfSubject: ListOfSubject(
                groupId: groupId, subjectId: subjectId, semesterId: semester));
      }
    }
    selectedSemesters.clear();
    initialSemesters.clear();
  }

  // Метод для получения выбранных семестров
  List<int> getSelectedSemesters() {
    return selectedSemesters.toList();
  }
}
