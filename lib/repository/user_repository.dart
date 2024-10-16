import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:education_analizer/model/user.dart';
import 'package:get/get.dart';

class UserRepository extends GetxService {
  final String url = "http://192.168.100.8:3000/api/users"; //192.168.100.8
  final dio = Dio();

  Future<List<User>> getAllUsers() async {
    final response = await dio.get(url);
    if (response.statusCode == 200) {
      return response.data.map<User>((e) => User.fromJson(e)).toList();
    } else {
      throw Error();
    }
  }

  Future<User> getUser(int id) async {
    final response = await dio.get("$url/$id");
    if (response.statusCode == 200) {
      return User.fromJson(response.data);
    } else {
      throw Error();
    }
  }

  Future<void> createUser(User user) async {
    final Map<String, dynamic> userData = user.toJson();
    final response = await dio.post("$url/", data: userData);
    if (response.statusCode == 201) {
      log("User create");
    } else {
      throw Error();
    }
  }

  Future<void> updateUser(User user) async {
    final Map<String, dynamic> userData = user.toJson();
    final response = await dio.put("$url/${user.id}", data: userData);
    if (response.statusCode == 200) {
      log("${user.username} обнавлен");
    } else {
      throw Error();
    }
  }

  Future<void> deleteUser(int id) async {
    final response = await dio.delete("$url/$id");
    if (response.statusCode == 204) {
      log("Удалено успешно");
    } else {
      throw Error();
    }
  }

  Future<User> loginUser(String username, String password) async {
    final response = await dio.post("$url/login", data: {
      "username": username,
      "password": password,
    });

    if (response.statusCode == 200) {
      return User.fromJson(response.data["user"]);
    } else {
      throw Exception();
    }
  }
}
