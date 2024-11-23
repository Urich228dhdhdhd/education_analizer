import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:education_analizer/repository/main_url.dart';
import 'package:get/get.dart';

class SubjectRepository extends GetxService {
  final String url = "$mainUrl/api/subjects"; // 192.168.100.8 localhost
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
      if (response.statusCode == 201) {
        return response.data;
      } else {
        throw Exception(response.data['message'] ?? 'Ошибка авторизации');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Ошибка при авторизации');
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
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception(response.data['message'] ?? 'Ошибка авторизации');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Ошибка при авторизации');
    }
  }
}
