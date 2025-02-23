import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:education_analizer/model/subject.dart';
import 'package:education_analizer/repository/main_url.dart';
import 'package:get/get.dart';

import '../design/widgets/dimentions.dart';

class SubjectRepository extends GetxService {
  final String url = "$mainUrl/api/subjects"; // 192.168.100.8 localhost
  final Dio dio = Dio();

  // Получить все предметы
  Future<List<Subject>> getSubjects() async {
    try {
      final response = await dio.get(url);
      return response.data
          .map<Subject>((subject) => Subject.fromJson(subject))
          .toList(); // Возвращаем список предметов
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  // Получить предмет по ID
  Future<Subject> getSubjectById(int id) async {
    try {
      final response = await dio.get('$url/$id');
      return Subject.fromJson(response.data); // Возвращаем предмет
    } on DioException catch (e) {
      throw handleDioError(e);
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
      return response.data;
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  // Удалить предмет
  Future<void> deleteSubject(int id) async {
    try {
      await dio.delete('$url/$id');
    } on DioException catch (e) {
      throw handleDioError(e);
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
      return response.data;
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }
}
