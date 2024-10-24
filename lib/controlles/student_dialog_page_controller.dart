import 'package:education_analizer/controlles/student_page_controller.dart';
import 'package:education_analizer/model/student.dart';
import 'package:get/get.dart';

class StudentDialogController extends GetxController {
  final StudentPageController studentPageController;

  var studentId = Rxn<int>(); // Используем Rxn для Nullable
  var firstName = ''.obs;
  var middleName = ''.obs;
  var lastName = ''.obs;
  var telNumber = ''.obs;
  var dateBirthday =
      DateTime.now().obs; // Используем DateTime для удобства работы
  var groupId = Rxn<int>();

  StudentDialogController({required this.studentPageController});

  // Теперь передаем весь объект студента
  void setStudent(Student? student) {
    if (student != null) {
      studentId.value = student.id;
      firstName.value = student.firstName ?? "";
      middleName.value = student.middleName ?? "";
      lastName.value = student.lastName ?? "";
      telNumber.value = student.telNumber ?? "";
      dateBirthday.value = DateTime.parse(student.dateBirthday!); // Парсим дату
      groupId.value = student.groupId;
    } else {
      // Сброс полей, если это создание нового студента
      studentId.value = null;
      firstName.value = '';
      middleName.value = '';
      lastName.value = '';
      telNumber.value = '';
      dateBirthday.value = DateTime.now(); // Устанавливаем текущую дату
      groupId.value = null;
    }
  }

  // Метод для сохранения студента (создание или обновление)
  Future<void> saveStudent() async {
    final birthdayString =
        "${dateBirthday.value.toIso8601String().split('T')[0]}T00:00:00.000Z"; // Форматируем дату

    if (studentId.value == null) {
      // Создаем нового студента
      await studentPageController.studentRepository.createStudent({
        'first_name': firstName.value,
        'middle_name': middleName.value,
        'last_name': lastName.value,
        'tel_number': telNumber.value,
        'date_birthday': birthdayString,
        'group_id': groupId.value
      });
    } else {
      // Обновляем существующего студента
      await studentPageController.studentRepository
          .updateStudent(studentId.value!, {
        'first_name': firstName.value,
        'middle_name': middleName.value,
        'last_name': lastName.value,
        'tel_number': telNumber.value,
        'date_birthday': birthdayString,
        'group_id': groupId.value
      });
    }
  }
}
