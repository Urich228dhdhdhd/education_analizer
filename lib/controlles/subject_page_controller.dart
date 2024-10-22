import 'package:education_analizer/controlles/auth_controller.dart';
import 'package:education_analizer/model/subject.dart';
import 'package:education_analizer/repository/subject_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubjectPageController extends GetxController {
  final AuthController authController;
  final SubjectRepository subjectRepository;

  var subjects = <dynamic>[].obs; // RxList для реактивного списка
  var isLoading = false.obs;
  var searchText = "".obs;

  SubjectPageController({
    required this.subjectRepository,
    required this.authController,
  });

  @override
  void onInit() {
    super.onInit();
    fetchSubjects(); // Загружаем предметы при инициализации
  }

  List<dynamic> get filteredSubject {
    if (searchText.isEmpty) {
      return subjects;
    } else {
      return subjects.where((subject) {
        final longName = subject.subjectNameLong.toString().toLowerCase();
        final shortName = subject.subjectNameShort.toString().toLowerCase();
        final query = searchText.value.toLowerCase();
        return longName.contains(query) || shortName.contains(query);
      }).toList();
    }
  }

  // Метод для получения списка предметов
  Future<void> fetchSubjects() async {
    try {
      isLoading(true);
      List<dynamic> fetchedSubjects = await subjectRepository.getSubjects();

      // Преобразуем List<dynamic> в List<Subject>
      List<Subject> subjectList = fetchedSubjects
          .map((subjectJson) => Subject.fromJson(subjectJson))
          .toList();

      // Обновляем реактивный список
      subjects.assignAll(subjectList);
    } catch (e) {
      throw Exception("Ошибка при загрузке предметов: $e");
    } finally {
      isLoading(false);
    }
  }
}
