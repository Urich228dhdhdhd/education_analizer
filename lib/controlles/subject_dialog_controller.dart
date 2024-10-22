import 'package:education_analizer/controlles/subject_page_controller.dart';
import 'package:get/get.dart';

class SubjectDialogController extends GetxController {
  final SubjectPageController subjectPageController;
  int? subjectId;
  String subjectNameShort = '';
  String subjectNameLong = '';

  SubjectDialogController({required this.subjectPageController});

  void setSubject(int id, {String? shortName, String? longName}) {
    subjectId = id;
    subjectNameShort = shortName ?? '';
    subjectNameLong = longName ?? '';
  }

  Future<void> saveSubject() async {
    if (subjectId == null) {
      // Создаем новый предмет
      await subjectPageController.subjectRepository
          .createSubject(subjectNameShort, subjectNameLong);
    } else {
      // Обновляем существующий предмет
      await subjectPageController.subjectRepository
          .updateSubject(subjectId!, subjectNameShort, subjectNameLong);
    }
  }
}
