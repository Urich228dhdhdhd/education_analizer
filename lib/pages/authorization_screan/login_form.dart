import 'package:education_analizer/controlles/login_page_controller.dart';
import 'package:education_analizer/design/dialog/styles.dart';
import 'package:education_analizer/design/widgets/colors.dart';
import 'package:education_analizer/design/widgets/dimentions.dart';
import 'package:education_analizer/design/widgets/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    TextEditingController loginController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    LoginPageController pageController = Get.find();

    return Form(
      child: Column(
        mainAxisSize: MainAxisSize.min, // Минимальное пространство
        children: [
          const Text(
            'Анализ учебного\nпроцесса',
            style: mainAuthorizationTextStyle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(
              height: 20), // Уменьшили отступ между заголовком и полями ввода
          TextField(
            controller: loginController,
            style: style2,
            decoration: StylishInput(label: "Логин", image: userImage),
          ),
          const SizedBox(height: 15), // Уменьшили отступ между полями ввода
          TextField(
              controller: passwordController,
              style: style2,
              obscureText: true, // Скрываем текст пароля
              decoration: StylishInput(label: "Пароль", image: passwordImage)),
          const SizedBox(height: 25), // Отступ перед кнопкой
          ElevatedButton(
              onPressed: () {
                pageController.goAuth(
                    login: loginController.text.toString(),
                    password: passwordController.text.toString());
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: primary6Color,
                  minimumSize: const Size(double.infinity, 55)),
              child: const Text("Войти", style: buttonAuthorizationTextStyle)),
        ],
      ),
    );
  }

  InputDecoration StylishInput(
      {required String label, required SvgPicture image}) {
    return InputDecoration(
      labelStyle: style2,
      labelText: label,
      prefixIcon: Padding(
        padding: const EdgeInsets.all(12),
        child: image,
      ),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius32),
          borderSide: const BorderSide(color: Colors.grey)),
      filled: true,
      fillColor: primary4Color,
    );
  }
}
