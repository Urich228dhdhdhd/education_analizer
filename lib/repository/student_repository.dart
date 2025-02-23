import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:education_analizer/model/student.dart';
import 'package:education_analizer/repository/main_url.dart';
import 'package:get/get.dart';

import '../design/widgets/dimentions.dart';

class StudentRepository extends GetxService {
  final String url = "$mainUrl/api/students";
  final Dio dio = Dio();

  // Получение всех студентов
  Future<List<dynamic>> getStudents() async {
    try {
      final response = await dio.get(url);
      return response.data;
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  // Получение студента по ID
  Future<dynamic> getStudentById(int id) async {
    try {
      final response = await dio.get('$url/$id');
      return response.data; // Предполагается, что ответ - это объект студента
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  // Создание студента
  Future<Student> createStudent(Map<String, dynamic> studentData) async {
    try {
      log(studentData.toString());
      final response = await dio.post(url, data: studentData);

      return Student.fromJson(response.data);
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  // Обновление студента
  Future<dynamic> updateStudent(
      int id, Map<String, dynamic> studentData) async {
    try {
      final response = await dio.put('$url/$id', data: studentData);
      return response.data; // Возвращает обновленного студента
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  // Удаление студента
  Future<void> deleteStudent(int id) async {
    try {
      await dio.delete('$url/$id');
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Получение студентов по ID и роли
  Future<List<Student>> getStudentsByRole(
      {required int userId, required String userRole}) async {
    try {
      final response = await dio.post('$url/get/by-role', data: {
        'userId': userId,
        'userRole': userRole,
      });
      return response.data
          .map<Student>((student) => Student.fromJson(student))
          .toList(); // Возвращает список студентов
    } on DioException catch (e) {
      throw handleDioError(e);
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
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }
}
