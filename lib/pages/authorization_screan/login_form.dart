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
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Анализ учебного\nпроцесса',
            style: mainAuthorizationTextStyle.copyWith(fontSize: 21),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          TextField(
            controller: loginController,
            style: style2,
            decoration: stylishInput(label: "Логин", image: userImage),
          ),
          const SizedBox(height: 15),
          Obx(() {
            return TextField(
                controller: passwordController,
                style: style2,
                obscureText: !pageController.isPasswordVisible.value,
                decoration: stylishInput(label: "Пароль", image: passwordImage)
                    .copyWith(
                  suffixIcon: IconButton(
                    icon: Icon(
                      pageController.isPasswordVisible.value
                          ? Icons.sentiment_satisfied_alt_outlined
                          : Icons.sentiment_very_dissatisfied,
                      color: primary6Color,
                    ),
                    onPressed: () {
                      pageController.isPasswordVisible.toggle();
                    },
                  ),
                ));
          }),
          const SizedBox(height: 25),
          ElevatedButton(
              onPressed: pageController.isButtonDisabled.value
                  ? null
                  : () {
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

  InputDecoration stylishInput(
      {required String label, required SvgPicture image}) {
    return InputDecoration(
      labelStyle: style2,
      labelText: label,
      prefixIcon: Padding(
        padding: const EdgeInsets.all(12),
        child: image,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius20), // Закругленные углы
        borderSide: BorderSide(
          color: greyColor[400]!, // Цвет границы
          width: 1.0, // Толщина границы
        ),
      ),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius20), // Закругленные углы
          borderSide: const BorderSide(
            color: greyColor, // Цвет границы в обычном состоянии
            width: 1.0,
          )),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14), // Закругленные углы при фокусе
        borderSide: const BorderSide(
          color: primary6Color, // Цвет границы при фокусе
          width: 2,
        ),
      ),
      // border: OutlineInputBorder(
      //     borderRadius: BorderRadius.circular(radius32),
      //     borderSide: const BorderSide(color: Colors.grey)),
      filled: true,
      fillColor: primary4Color,
    );
  }
}
