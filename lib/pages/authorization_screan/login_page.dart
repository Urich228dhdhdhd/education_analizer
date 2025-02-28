import 'package:education_analizer/controlles/login_page_controller.dart';
import 'package:education_analizer/design/dialog/app_bar.dart';
import 'package:education_analizer/design/dialog/styles.dart';
import 'package:education_analizer/design/widgets/colors.dart';
import 'package:education_analizer/design/widgets/dimentions.dart';
import 'package:education_analizer/pages/authorization_screan/login_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    LoginPageController controller = Get.find();
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        backgroundColor: primaryColor,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    flex: 2,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'lib/images/college_image.png',
                            height: 150,
                            width: 150,
                          ),
                          const SizedBox(width: 20),
                          const Text(
                            'УО«Минский\n Государственный\nКолледж Цифровых\n Технологий»',
                            style: mainAuthorizationTextStyle,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )),
                Container(
                  constraints: const BoxConstraints(
                    maxWidth: 400,
                  ),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: primary2Color,
                    borderRadius: BorderRadius.circular(radius32),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0xFFc2d0e3),
                        spreadRadius: 10,
                        blurRadius: 10,
                        offset: Offset(3, 3),
                      ),
                    ],
                  ),
                  child: const LoginForm(),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: controller.launchURL,
                  child: const Text(
                    "Сайт колледжа",
                    style: linkAuthorizationTextStyle,
                  ),
                ),
                // const SizedBox(height: 5),
                // const Text(
                //   "Сообщить об ошибке",
                //   style: linkAuthorizationTextStyle,
                // ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    "© 2024-2025 Учреждение образования «Минский\nГосударственный Колледж  Цифровых Технологий",
                    style: style3.copyWith(color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
