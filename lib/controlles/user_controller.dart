import 'package:education_analizer/Repository/user_repository.dart';
import 'package:education_analizer/model/user.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  RxList<User> userList = RxList<User>();
  UserRepository repo = UserRepository();

  void loadList() async {
    userList.value = await repo.getAllUsers();
  }

  void addUser(User user) {
    repo.createUser(user);
  }

  void deleteUser(int id) {
    repo.deleteUser(id);
  }
}
