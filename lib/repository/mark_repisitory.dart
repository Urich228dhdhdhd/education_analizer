import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:education_analizer/model/mark.dart';
import 'package:education_analizer/repository/main_url.dart';
import 'package:get/get.dart';

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
    } catch (e) {
      throw Exception("Ошибка при получении всех отметок: $e");
    }
  }

  // Получить оценку по ID
  Future<Mark> getMarkById({required int markId}) async {
    try {
      final response = await dio.get("$url/$markId");
      return Mark.fromJson(response.data);
    } catch (e) {
      throw Exception("Ошибка при получении отметки: $e");
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
    } catch (e) {
      throw Exception("Ошибка при получении оценок по фильтру: $e");
    }
  }

  // Создание новой оценки
  Future<Mark> createMark({
    required int studentId,
    required int semesterId,
    required int subjectId,
    required String mark,
  }) async {
    try {
      final response = await dio.post(
        url,
        data: {
          "student_id": studentId,
          "semester_id": semesterId,
          "subject_id": subjectId,
          "mark": mark,
        },
      );
      return Mark.fromJson(response.data);
    } catch (e) {
      throw Exception("Ошибка при создании оценки: $e");
    }
  }

  // Обновление оценки
  Future<Mark> updateMark({
    required int markId,
    required int? studentId,
    required int? semesterId,
    required int? subjectId,
    required String? mark,
  }) async {
    try {
      final response = await dio.put(
        "$url/$markId",
        data: {
          if (studentId != null) "student_id": studentId,
          if (semesterId != null) "semester_id": semesterId,
          if (subjectId != null) "subject_id": subjectId,
          if (mark != null) "mark": mark,
        },
      );
      return Mark.fromJson(response.data);
    } catch (e) {
      throw Exception("Ошибка при обновлении оценки: $e");
    }
  }

  // Удаление оценки по ID
  Future<void> deleteMark({required int markId}) async {
    try {
      await dio.delete("$url/$markId");
    } catch (e) {
      throw Exception("Ошибка при удалении оценки: $e");
    }
  }
}
