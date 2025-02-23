import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:education_analizer/model/absence.dart';
import 'package:education_analizer/model/group.dart';
import 'package:education_analizer/model/group_absence_report.dart';
import 'package:education_analizer/repository/main_url.dart';
import 'package:get/get.dart';

import '../design/widgets/dimentions.dart';

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
    } on DioException catch (e) {
      throw handleDioError(e);
    }

    // catch (e) {
    //   print('Ошибка при получении всех пропусков: $e');
    //   rethrow;
    // }
  }

  // Получение пропуска по ID
  Future<Absence?> getAbsenceById(int id) async {
    try {
      final response = await dio.get('$url/$id');
      return Absence.fromJson(response.data);
    } on DioException catch (e) {
      throw handleDioError(e);
    }

    // catch (e) {
    //   print('Ошибка при получении пропуска по ID: $e');
    //   rethrow;
    // }
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
      // print('Ошибка при проверке пропуска: $e');
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

      return Map<String, dynamic>.from(response.data);
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  // Обновление записи пропуска по ID
  Future<Absence> updateAbsence(Absence absence) async {
    try {
      final response =
          await dio.put('$url/${absence.id}', data: absence.toJson());
      return Absence.fromJson(response.data);
    } on DioException catch (e) {
      throw handleDioError(e);
    }
    // catch (e) {
    //   print('Ошибка при обновлении записи пропуска: $e');
    //   rethrow;
    // }
  }

  // Удаление записи пропуска по ID
  Future<void> deleteAbsenceById(int id) async {
    try {
      await dio.delete('$url/$id');
    } on DioException catch (e) {
      throw handleDioError(e);
    }

    // catch (e) {
    //   print('Ошибка при удалении записи пропуска: $e');
    //   rethrow;
    // }
  }

  Future<List<GroupAbsenceReport>> getAbsenceReport({
    required List<Group> group,
    required int year,
    required int month,
    required List<String> absenceTypes,
  }) async {
    try {
      // log("getAbsenceReport: $groupIds $year $month $absenceTypes");

      final response = await dio.post(
        '$url/report',
        data: {
          'selectedGroups': group.map((item) => item.id).toList(),
          'selectedMonth': month,
          'selectedYear': year,
          'selectedAbsenceTypes': absenceTypes,
        },
      );

      List<dynamic> responseData = response.data;

      List<GroupAbsenceReport> reports = responseData
          .map((json) => GroupAbsenceReport.fromJson(json))
          .toList();
      // log(reports.toString());

      // log("Полученные отчеты: ${reports.map((report) => report.toString()).join(', ')}");

      return reports;
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }
}
