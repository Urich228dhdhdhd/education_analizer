import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:education_analizer/model/list_of_subject.dart';
import 'package:education_analizer/model/subject.dart';
import 'package:education_analizer/repository/main_url.dart';
import 'package:get/get.dart';

import '../design/widgets/dimentions.dart';

class ListofsubjectRepository extends GetxService {
  final String url = "$mainUrl/api/listOfSubjects"; // 192.168.100.8 localhost
  final Dio dio = Dio();

  // Получение всех предметов
  Future<List<dynamic>> getListOfSubjects() async {
    try {
      final response = await dio.get(url);
      return response.data;
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  Future<List<ListOfSubject>> getListOfSubjectsByGroupId(int groupId) async {
    try {
      final response = await dio.get("$url/group/$groupId");
      return response.data
          .map<ListOfSubject>((item) => ListOfSubject.fromJson(item))
          .toList();
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  Future<List<ListOfSubject>> getListOfSubjectsBySubjectGroupId(
      int groupId, int subjectId) async {
    try {
      final response = await dio.get("$url/group/$groupId/subject/$subjectId");

      // Преобразуем данные в List<ListOfSubject>
      List<dynamic> data =
          response.data; // Получаем данные в виде List<dynamic>
      return data
          .map((item) => ListOfSubject.fromJson(item))
          .toList(); // Преобразуем в List<ListOfSubject>
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  // Получение предмета по ID
  Future<dynamic> getListSubjectById(int id) async {
    try {
      final response = await dio.get('$url/$id');
      return response.data;
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  Future<List<Subject>> getSubjectsByGroupId(int groupId) async {
    try {
      final response = await dio.get('$url/subjectIds/$groupId');

      // Извлекаем данные из вложенного объекта subject
      List<dynamic> data = response.data;
      final subjects = data.map((item) {
        return Subject.fromJson({
          'id': item['subject_id'],
          'subject_name_short': item['subject']?['subject_name_short'],
          'subject_name_long': item['subject']?['subject_name_long'],
        });
      }).toList();

      return subjects;
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  // Создание нового предмета
  Future<dynamic> createListOfSubject(
      {required ListOfSubject listOfSubject}) async {
    try {
      final listOfSubjectData = listOfSubject.toJson();
      final response = await dio.post(url, data: listOfSubjectData);
      return response.data;
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  // Обновление предмета по ID
  Future<dynamic> updateListOfSubject(
      {required ListOfSubject listOfSubject}) async {
    try {
      final listOfSubjectData = listOfSubject.toJson();

      final response =
          await dio.put('$url/${listOfSubject.id}', data: listOfSubjectData);
      return response.data;
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  // Удаление предмета по ID
  Future<void> delete1ListOfSubject(int id) async {
    try {
      await dio.delete('$url/$id');
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  // Проверка существования предмета
  Future<bool> checkListOfSubjectExists(
      {required ListOfSubject listOfSubject}) async {
    try {
      final listOfSubjectData = listOfSubject.toJson();

      final response = await dio.post("$url/isexist", data: listOfSubjectData);
      return response.statusCode == 200; // Если статус 200, запись существует
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  Future<void> deleteListOfSubjectbyAllParams(
      {required ListOfSubject listOfSubject}) async {
    try {
      final listOfSubjectData = listOfSubject.toJson();

      await dio.delete(
          "$url/group/${listOfSubject.groupId}/subject/${listOfSubject.subjectId}/semester/${listOfSubject.semesterId}",
          data: listOfSubjectData);
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }
}
