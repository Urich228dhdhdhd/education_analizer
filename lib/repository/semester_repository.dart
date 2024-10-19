import 'package:dio/dio.dart';
import 'package:get/get.dart';

class SemesterRepository extends GetxService {
  final String url =
      "http://192.168.100.8:3000/api/semesters"; // 192.168.100.8 localhost
  final Dio dio = Dio();

  // Получение всех семестров
  Future<List<dynamic>> getSemesters() async {
    try {
      final response = await dio.get(url);
      return response.data; // Здесь предполагается, что ответ в формате JSON
    } catch (e) {
      throw Exception('Ошибка при получении семестров: $e');
    }
  }

  // Получение семестра по ID
  Future<dynamic> getSemesterById(int id) async {
    try {
      final response = await dio.get('$url/$id');
      return response.data;
    } catch (e) {
      throw Exception('Ошибка при получении семестра: $e');
    }
  }

  // Создание нового семестра
  Future<dynamic> createSemester(
      String semesterNumber, String semesterYear) async {
    try {
      final response = await dio.post(url, data: {
        'semester_number': semesterNumber,
        'semester_year': semesterYear,
      });
      return response.data;
    } catch (e) {
      throw Exception('Ошибка при создании семестра: $e');
    }
  }

  // Обновление семестра
  Future<dynamic> updateSemester(
      int id, String semesterNumber, String semesterYear) async {
    try {
      final response = await dio.put('$url/$id', data: {
        'semester_number': semesterNumber,
        'semester_year': semesterYear,
      });
      return response.data;
    } catch (e) {
      throw Exception('Ошибка при обновлении семестра: $e');
    }
  }

  // Удаление семестра
  Future<void> deleteSemester(int id) async {
    try {
      await dio.delete('$url/$id');
    } catch (e) {
      throw Exception('Ошибка при удалении семестра: $e');
    }
  }
}
