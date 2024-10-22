import 'package:education_analizer/design/dialog/styles.dart';
import 'package:education_analizer/design/widgets/colors.dart';
import 'package:education_analizer/design/widgets/dimentions.dart';
import 'package:education_analizer/pages/authorization_screan/login_form.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Spacer(),
              // Row для изображения и текста
              Row(
                mainAxisAlignment: MainAxisAlignment
                    .center, // Центрируем содержимое по горизонтали
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 0), // Отступ сверху
                    child: Image.asset(
                      'lib/images/college_image.png', // Путь к изображению
                      height: 150, // Высота изображения
                      width: 150, // Ширина изображения
                    ),
                  ),
                  const SizedBox(
                      width: 20), // Отступ между изображением и текстом
                  const Text(
                    'УО«Минский\n Государственный\nКолледж Цифровых\n Технологий»',
                    style: mainAuthorizationTextStyle,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              const Spacer(),
              const SizedBox(height: 30), // Отступ между текстом и контейнером
              Container(
                constraints: const BoxConstraints(
                  maxWidth: 400, // Устанавливаем максимальную ширину контейнера
                ),
                margin: const EdgeInsets.symmetric(
                    horizontal: 40, vertical: 20), // Уменьшили отступы
                padding: const EdgeInsets.all(30), // Отступ внутри контейнера
                decoration: BoxDecoration(
                  color: primary2Color,
                  borderRadius: BorderRadius.circular(radius32),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0xFFc2d0e3),
                      spreadRadius: 10,
                      blurRadius: 10,
                      offset: Offset(3, 3), // смещение тени
                    ),
                  ],
                ),
                child: const LoginForm(),
              ),
              const SizedBox(
                  height: 10), // Уменьшили отступ перед текстом "Сайт колледжа"

              const Text(
                "Сайт колледжа",
                style: linkAuthorizationTextStyle,
              ),

              const Spacer(),
              const Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Text(
                  "© 2024-2025 Учреждение образования «Минский\nГосударственный Колледж  Цифровых Технологий",
                  style: style3,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
