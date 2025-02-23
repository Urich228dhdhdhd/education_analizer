import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:education_analizer/design/widgets/dimentions.dart';
import 'package:education_analizer/model/user.dart';
import 'package:education_analizer/repository/main_url.dart';
import 'package:get/get.dart';

class UserRepository extends GetxService {
  final String url = "$mainUrl/api/users"; //192.168.100.8
  final dio = Dio();

  Future<List<User>> getAllUsers() async {
    try {
      final response = await dio.get(url);
      return response.data.map<User>((e) => User.fromJson(e)).toList();
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  Future<User> getUserbyId(int id) async {
    try {
      final response = await dio.get("$url/$id");
      return User.fromJson(response.data);
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  Future<User> createUser(User user) async {
    try {
      final Map<String, dynamic> userData = user.toJson();
      final response = await dio.post("$url/", data: userData);
      return User.fromJson(response.data);
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  Future<void> updateUser(User user) async {
    try {
      final Map<String, dynamic> userData = user.toJson();
      await dio.put("$url/${user.id}", data: userData);
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  Future<void> deleteUser(int id) async {
    try {
      await dio.delete("$url/$id");
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  Future<User> loginUser(String username, String password) async {
    try {
      final response = await dio.post("$url/login", data: {
        "username": username,
        "password": password,
      });

      return User.fromJson(response.data["user"]);
    } on DioException catch (e) {
      throw handleDioError(e);
      //  errorMessage;
    }
  }
}
