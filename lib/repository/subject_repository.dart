import 'package:dio/dio.dart';
import 'package:get/get.dart';

class SubjectRepository extends GetxService {
  final String url =
      "http://192.168.100.8:3000/api/subjects"; // 192.168.100.8 localhost
  final Dio dio = Dio();

  // Получить все предметы
  Future<List<dynamic>> getSubjects() async {
    try {
      final response = await dio.get(url);
      return response.data; // Возвращаем список предметов
    } catch (e) {
      print("Ошибка при получении предметов: $e");
      throw Exception('Ошибка при получении предметов');
    }
  }

  // Получить предмет по ID
  Future<dynamic> getSubjectById(int id) async {
    try {
      final response = await dio.get('$url/$id');
      return response.data; // Возвращаем предмет
    } catch (e) {
      print("Ошибка при получении предмета с ID $id: $e");
      throw Exception('Ошибка при получении предмета');
    }
  }

  // Создать новый предмет
  Future<dynamic> createSubject(
      String subjectNameShort, String subjectNameLong) async {
    try {
      final response = await dio.post(url, data: {
        'subject_name_short': subjectNameShort,
        'subject_name_long': subjectNameLong,
      });
      return response.data; // Возвращаем созданный предмет
    } catch (e) {
      print("Ошибка при создании предмета: $e");
      throw Exception('Ошибка при создании предмета');
    }
  }

  // Удалить предмет
  Future<void> deleteSubject(int id) async {
    try {
      await dio.delete('$url/$id');
    } catch (e) {
      print("Ошибка при удалении предмета с ID $id: $e");
      throw Exception('Ошибка при удалении предмета');
    }
  }

  // Обновить предмет
  Future<dynamic> updateSubject(
      int id, String subjectNameShort, String subjectNameLong) async {
    try {
      final response = await dio.put('$url/$id', data: {
        'subject_name_short': subjectNameShort,
        'subject_name_long': subjectNameLong,
      });
      return response.data; // Возвращаем обновленный предмет
    } catch (e) {
      print("Ошибка при обновлении предмета с ID $id: $e");
      throw Exception('Ошибка при обновлении предмета');
    }
  }
}
