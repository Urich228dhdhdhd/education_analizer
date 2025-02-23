import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:education_analizer/model/semester.dart';
import 'package:education_analizer/repository/main_url.dart';
import 'package:get/get.dart';

import '../design/widgets/dimentions.dart';

class SemesterRepository extends GetxService {
  final String url = "$mainUrl/api/semesters"; // 192.168.100.8 localhost
  final Dio dio = Dio();

  // Получение всех семестров
  Future<List<Semester>> getSemesters() async {
    try {
      final response = await dio.get(url);
      // Преобразуем список JSON в список объектов Semester
      return (response.data as List)
          .map((semesterJson) => Semester.fromJson(semesterJson))
          .toList();
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  // Получение семестра по ID
  Future<Semester> getSemesterById(int id) async {
    try {
      final response = await dio.get('$url/$id');
      return Semester.fromJson(response.data);
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  Future<Semester> getSemesterBySemesterYear(
      {required int semesterNumber, required int year}) async {
    try {
      final response = await dio.get('$url/getsemester/$semesterNumber/$year');
      // log(response.data.toString());
      return Semester.fromJson(response.data);
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  // Создание нового семестра
  Future<Semester> createSemester(
      {required int semesterNumber,
      required int semesterYear,
      required int semesterPart}) async {
    try {
      final response = await dio.post(url, data: {
        'semester_number': semesterNumber,
        'semester_year': semesterYear,
        'semester_part': semesterPart, // Добавлено новое поле
      });
      return Semester.fromJson(response.data);
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  // Обновление семестра
  Future<Semester> updateSemester(
      int id, int semesterNumber, int semesterYear, int semesterPart) async {
    try {
      final response = await dio.put('$url/$id', data: {
        'semester_number': semesterNumber,
        'semester_year': semesterYear,
        'semester_part': semesterPart, // Добавлено новое поле
      });
      return Semester.fromJson(response.data);
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  // Удаление семестра
  Future<void> deleteSemester(int id) async {
    try {
      await dio.delete('$url/$id');
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  Future<bool> isSemesterExist(
      {required int semesterNumber, required int semesterYear}) async {
    try {
      final response =
          await dio.get('$url/check/$semesterNumber/$semesterYear');
      // Предполагается, что ответ возвращает true или false
      return response.data['exists'] == true;
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }
}
