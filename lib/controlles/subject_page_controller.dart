import 'package:education_analizer/controlles/auth_controller.dart';
import 'package:education_analizer/model/subject.dart';
import 'package:education_analizer/repository/subject_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class SubjectPageController extends GetxController {
  final AuthController authController;
  final SubjectRepository subjectRepository;

  var subjects = <Subject>[].obs;
  var filteredSubjects = <Subject>[].obs;
  var isLoading = false.obs;
  TextEditingController searchText = TextEditingController();

  SubjectPageController({
    required this.subjectRepository,
    required this.authController,
  });

  void searchSubjects(String query) {
    if (query.isEmpty || query == "") {
      filteredSubjects
          .assignAll([...subjects]); // Показать все, если запрос пустой
    } else {
      filteredSubjects.assignAll(
        [...subjects]
            .where((info) =>
                (info.subjectNameShort
                        ?.toLowerCase()
                        .contains(query.toLowerCase()) ??
                    false) ||
                (info.subjectNameLong
                        ?.toLowerCase()
                        .contains(query.toLowerCase()) ??
                    false))
            .toList(),
      );
    }
  }

  // Метод для получения списка предметов
  Future<void> fetchSubjects() async {
    try {
      isLoading(true);
      List<Subject> subjectList = await subjectRepository.getSubjects();

      // Обновляем реактивный список
      subjects.assignAll(subjectList);
      filteredSubjects.assignAll(subjectList);
      if (searchText.text.isNotEmpty) {
        searchSubjects(searchText.text);
      }
    } catch (e) {
      throw Exception("Ошибка при загрузке предметов: $e");
    } finally {
      isLoading(false);
    }
  }
}
