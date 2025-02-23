import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:education_analizer/model/group_absence_report.dart';
import 'package:education_analizer/model/semester.dart';
import 'package:education_analizer/model/subject.dart';
import 'package:education_analizer/repository/main_url.dart';
import 'package:get/get.dart';

import '../design/widgets/dimentions.dart';
import '../model/group.dart';
import '../model/performanse_report.dart';
import '../model/report.dart';

class ReportRepository extends GetxService {
  final String url = "$mainUrl/api/reports";
  final Dio dio = Dio();

  Future<Map<String, dynamic>> getPerformancePercent(
      {required int groupId}) async {
    try {
      final response = await dio
          .post("$url/performance-percent", data: {"group_id": groupId});
      return Map<String, dynamic>.from(response.data);
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  Future<PerformanseReport> getPerformanceReport(
      {required Group group,
      required List<Semester> semesters,
      required List<Subject> subjects}) async {
    try {
      final response = await dio.post("$url/performance-report", data: {
        "group_id": group.id,
        "semester_ids": semesters.map((sem) => sem.id).toList(),
        "subject_ids": subjects.map((sub) => sub.id).toList(),
      });

      return PerformanseReport.fromJson(response.data);
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  Future<List<Report>> getReportsByUserId({required int userId}) async {
    try {
      final response = await dio.post("$url/reports", data: {
        "user_id": userId,
      });

      return response.data
          .map<Report>((report) => Report.fromJson(report))
          .toList();
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  Future<Map<String, dynamic>> getReportDateByReportId(
      {required int reportId}) async {
    try {
      final response = await dio.get("$url/$reportId");

      return response.data;
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  Future<void> savePerformanseReport(
      {required int userId,
      required dynamic reportData,
      required Group selectedGroup,
      required String period,
      required List<Subject> selectedSubjects}) async {
    try {
      final jsonData = reportData is PerformanseReport
          ? reportData.toJson() // Преобразуем в JSON
          : reportData;
      await dio.post("$url/save-performance", data: {
        "type": "Performance",
        "user_id": userId,
        "report_data": jsonData,
        "selected_group": selectedGroup.toJson(),
        "period": period,
        "selected_subjects":
            selectedSubjects.map((sub) => sub.toJson()).toList(),
      });
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  Future<void> saveAbsenceReport(
      {required int userId,
      required dynamic reportData,
      required List<Group> selectedGroups,
      required DateTime date,
      required List<String> typesOfAbsence}) async {
    try {
      final jsonData = reportData is GroupAbsenceReport
          ? reportData.toJson() // Преобразуем в JSON
          : reportData;
      await dio.post("$url/save-absence", data: {
        "type": "Absence",
        "user_id": userId,
        "report_data": jsonData,
        "selected_groups":
            selectedGroups.map((group) => group.toJson()).toList(),
        "date": date.toIso8601String(),
        "types_of_absence": typesOfAbsence
      });
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  Future<Map<String, dynamic>> getSummaryGroupAbsenceById(
      {required int groupId}) async {
    try {
      final response =
          await dio.post("$url/group-absence", data: {"group_id": groupId});

      return response.data;
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  Future<void> deleteReport({required int report_id}) async {
    try {
      await dio.delete("$url/$report_id");
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }
}
