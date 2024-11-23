import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:education_analizer/model/student.dart';
import 'package:education_analizer/repository/main_url.dart';
import 'package:get/get.dart';

class StudentRepository extends GetxService {
  final String url = "$mainUrl/api/students";
  final Dio dio = Dio();

  // Получение всех студентов
  Future<List<dynamic>> getStudents() async {
    try {
      final response = await dio.get(url);
      return response.data;
    } catch (e) {
      log("Ошибка при получении студентов: $e");
      throw Exception('Ошибка при получении студентов');
    }
  }

  // Получение студента по ID
  Future<dynamic> getStudentById(int id) async {
    try {
      final response = await dio.get('$url/$id');
      return response.data; // Предполагается, что ответ - это объект студента
    } catch (e) {
      log("Ошибка при получении студента с ID $id: $e");
      throw Exception('Ошибка при получении студента');
    }
  }

  // Создание студента
  Future<Student> createStudent(Map<String, dynamic> studentData) async {
    try {
      log(studentData.toString());
      final response = await dio.post(url, data: studentData);

      if (response.statusCode == 200) {
        return Student.fromJson(response.data);
      }
      if (response.statusCode == 400) {
        throw Exception(response.data["message"] ?? "Ошибка создания");
      }
      throw Exception("Неизвестная ошибка: ${response.statusCode}");
      // } on DioException catch (e) {
      //   log(e.toString());
      //   throw Exception(
      //       e.response?.data["message"] ?? 'Ошибка при создании студента');
    } catch (e) {
      log("Неожиданная ошибка: $e");
      throw Exception("Произошла ошибка при создании студента");
    }
  }

  // Обновление студента
  Future<dynamic> updateStudent(
      int id, Map<String, dynamic> studentData) async {
    try {
      final response = await dio.put('$url/$id', data: studentData);
      return response.data; // Возвращает обновленного студента
    } catch (e) {
      log("Ошибка при обновлении студента с ID $id: $e");
      throw Exception('Ошибка при обновлении студента');
    }
  }

  // Удаление студента
  Future<void> deleteStudent(int id) async {
    try {
      await dio.delete('$url/$id');
    } catch (e) {
      log("Ошибка при удалении студента с ID $id: $e");
      throw Exception('Ошибка при удалении студента');
    }
  }

  /// Получение студентов по ID и роли
  Future<List<dynamic>> getStudentsByRole(
      {required int userId, required String userRole}) async {
    try {
      final response = await dio.post('$url/get/by-role', data: {
        'userId': userId,
        'userRole': userRole,
      });
      return response.data; // Возвращает список студентов
    } catch (e) {
      log("Ошибка при получении студентов по роли: $e");
      throw Exception('Ошибка при получении студентов по роли');
    }
  }

  // Получение студентов по ID группы
  Future<List<Student>> getStudentsByGroupId(int groupId) async {
    try {
      final response = await dio.get('$url/get/by-group/$groupId');
      // Преобразование данных ответа в список объектов Student
      List<Student> students = (response.data as List)
          .map((studentJson) => Student.fromJson(studentJson))
          .toList();
      return students; // Возвращает список студентов
    } catch (e) {
      log("Ошибка при получении студентов по ID группы $groupId: $e");
      throw Exception('Ошибка при получении студентов по ID группы');
    }
  }
}
