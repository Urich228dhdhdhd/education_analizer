import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:education_analizer/model/mark.dart';
import 'package:education_analizer/repository/main_url.dart';
import 'package:get/get.dart';

import '../design/widgets/dimentions.dart';

class MarkRepository extends GetxService {
  final String url = "$mainUrl/api/marks"; // URL сервера API
  final Dio dio = Dio();

  // Получить все оценки
  Future<List<Mark>> getMarks() async {
    try {
      final response = await dio.get(url);
      return (response.data as List)
          .map((markJson) => Mark.fromJson(markJson))
          .toList();
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  // Получить оценку по ID
  Future<Mark> getMarkById({required int markId}) async {
    try {
      final response = await dio.get("$url/$markId");
      return Mark.fromJson(response.data);
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  // Получение оценок по groupId, semesterNumber и subjectId
  Future<List<Mark>> getMarksByGroupIdSemesterNumberSubjectId({
    required int groupId,
    required int subjectId,
    required int semesterNumber,
    required int semesterYear,
  }) async {
    try {
      final response = await dio.get(
        "$url/filter/group/$groupId/semester/$semesterNumber/subject/$subjectId/year/$semesterYear",
      );

      // Если ответ null, возвращаем пустой список
      if (response.data == null) {
        log("Семестр не найден, данные отсутствуют");
        return [];
      }

      return (response.data as List)
          .map((markJson) => Mark.fromJson(markJson))
          .toList();
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  // Создание новой оценки
  Future<Mark> createMark({required Mark mark}) async {
    try {
      final markData = mark.toJson();
      final response = await dio.post(
        url,
        data: markData,
      );
      return Mark.fromJson(response.data);
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  // Обновление оценки
  Future<Mark> updateMark({required Mark mark}) async {
    try {
      final markData = mark.toJson();
      final response = await dio.put(
        "$url/${mark.id}",
        data: markData,
      );
      return Mark.fromJson(response.data);
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  // Удаление оценки по ID
  Future<void> deleteMark({required int markId}) async {
    try {
      await dio.delete("$url/$markId");
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }
}
