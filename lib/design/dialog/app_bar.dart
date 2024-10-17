import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:education_analizer/design/widgets/colors.dart';
import 'package:education_analizer/design/widgets/images.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String role;

  const CustomAppBar({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: primary7Color,
      leading: Container(
        height: 48,
        width: 48,
        decoration: BoxDecoration(
          color: Colors.transparent, // Цвет фона (можно изменить на ваш)
          borderRadius: BorderRadius.circular(24), // Радиус скругления
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(24), // Скругляем область нажатия
          child: const Icon(
            Icons.menu, // Встроенная иконка меню
            color: primary3Color, // Устанавливаем цвет иконки
          ),
          onTap: () {
            Scaffold.of(context).openDrawer();
            // Открываем боковое меню
          },
        ),
      ),
      actions: [
        // Картинка и текст, зависящие от поля role
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _getImageForRole(role),
              ),
              Text(
                _getTextForRole(role),
                style: const TextStyle(
                  color: primary3Color,
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  SvgPicture _getImageForRole(String role) {
    switch (role) {
      case 'CURATOR':
        return curatorImage; // Замените на вашу картинку куратора
      case 'ADMINISTRATOR':
        return adminImage; // Замените на вашу картинку администратора
      default:
        return curatorImage; // Значение по умолчанию
    }
  }

  String _getTextForRole(String role) {
    switch (role) {
      case 'ADMINISTRATOR':
        return 'Администратор';
      case 'CURATOR':
        return 'Куратор';
      default:
        return 'Куратор'; // Значение по умолчанию
    }
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
