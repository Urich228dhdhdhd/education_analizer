import 'package:get/get.dart';

class AuthController extends GetxController {
  RxInt id = 0.obs;
  RxString role = "".obs;
  RxString name = "".obs;
  void logout() {
    role.value = '';
    name.value = '';
    id.value = 0;
  }
}
