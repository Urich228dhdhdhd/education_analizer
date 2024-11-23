import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:education_analizer/model/absence.dart';
import 'package:education_analizer/model/group_absence_report.dart';
import 'package:education_analizer/repository/main_url.dart';
import 'package:get/get.dart';

class AbsenceRepository extends GetxService {
  final String url = "$mainUrl/api/absences";
  final Dio dio = Dio();

  // Получение всех пропусков
  Future<List<Absence>> getAbsences() async {
    try {
      final response = await dio.get(url);
      return (response.data as List)
          .map((json) => Absence.fromJson(json))
          .toList();
    } catch (e) {
      print('Ошибка при получении всех пропусков: $e');
      rethrow;
    }
  }

  // Получение пропуска по ID
  Future<Absence?> getAbsenceById(int id) async {
    try {
      final response = await dio.get('$url/$id');
      return Absence.fromJson(response.data);
    } catch (e) {
      print('Ошибка при получении пропуска по ID: $e');
      rethrow;
    }
  }

  // Проверка наличия пропуска
  Future<Absence?> checkAbsence(int studentId, int year, int month) async {
    try {
      final response = await dio.post(
        '$url/check',
        data: {'student_id': studentId, 'year': year, 'month': month},
      );
      // log(response.data.toString());
      return response.data != null ? Absence.fromJson(response.data) : null;
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 404) {
        return null;
      }
      print('Ошибка при проверке пропуска: $e');
      rethrow;
    }
  }

  // Создание новой записи о пропусках
  Future<Map<String, dynamic>> createAbsence({
    required int studentId,
    required int year,
    required int month,
    int? absenceIllness,
    int? absenceOrder,
    int? absenceResp,
    int? absenceDisresp,
  }) async {
    try {
      final response = await dio.post(
        url,
        data: {
          "student_id": studentId,
          "year": year,
          "month": month,
          "absence_illness": absenceIllness,
          "absence_order": absenceOrder,
          "absence_resp": absenceResp,
          "absence_disresp": absenceDisresp,
        },
      );

      if (response.statusCode == 201) {
        return Map<String, dynamic>.from(response.data);
      } else {
        throw Exception(
            'Ошибка при создании записи о пропусках: ${response.statusCode}');
      }
    } catch (e) {
      log('Ошибка при создании записи о пропусках: $e');
      throw Exception('Не удалось выполнить запрос');
    }
  }

  // Обновление записи пропуска по ID
  Future<Absence> updateAbsence(int id, Absence absence) async {
    try {
      final response = await dio.put('$url/$id', data: absence.toJson());
      return Absence.fromJson(response.data);
    } catch (e) {
      print('Ошибка при обновлении записи пропуска: $e');
      rethrow;
    }
  }

  // Удаление записи пропуска по ID
  Future<void> deleteAbsenceById(int id) async {
    try {
      await dio.delete('$url/$id');
    } catch (e) {
      print('Ошибка при удалении записи пропуска: $e');
      rethrow;
    }
  }

  Future<List<GroupAbsenceReport>> getAbsenceReport({
    required List<int> groupIds,
    required int year,
    required int month,
    required List<String> absenceTypes,
  }) async {
    try {
      // log("getAbsenceReport: $groupIds $year $month $absenceTypes");

      final response = await dio.post(
        '$url/report',
        data: {
          'selectedGroups': groupIds,
          'selectedMonth': month,
          'selectedYear': year,
          'selectedAbsenceTypes': absenceTypes,
        },
      );

      if (response.statusCode == 200) {
        // Преобразование JSON-ответа в список объектов GroupAbsenceReport
        List<dynamic> responseData = response.data;

        // Преобразуем JSON в список объектов
        List<GroupAbsenceReport> reports = responseData
            .map((json) => GroupAbsenceReport.fromJson(json))
            .toList();

        // Логирование преобразованных объектов
        // Явное преобразование в строку с использованием toString()
        log("Полученные отчеты: ${reports.map((report) => report.toString()).join(', ')}");

        return reports;
      } else {
        throw Exception('Ошибка при получении отчета: ${response.statusCode}');
      }
    } catch (e) {
      log('Ошибка при получении отчета: $e');
      throw Exception('Не удалось получить отчет о пропусках');
    }
  }
}
