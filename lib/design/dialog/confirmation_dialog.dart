import 'package:education_analizer/design/widgets/colors.dart';
import 'package:education_analizer/design/widgets/dimentions.dart';
import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final Future<void> Function() onConfirm;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: whiteColor,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius8)),
      child: Padding(
        padding: const EdgeInsets.all(padding10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 80, // Размер круга
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle, // Круглая форма
                  gradient: RadialGradient(
                    colors: [
                      Colors.red
                          .withOpacity(0.8), // Красный цвет с прозрачностью
                      Colors.red.withOpacity(0.3), // Размытие краёв
                    ],
                    stops: const [0.5, 1.0], // Управление размытием
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red
                          .withOpacity(0.5), // Тень для эффекта размытия
                      blurRadius: 20, // Радиус размытия
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.warning_amber_rounded,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: padding6,
            ),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
            const SizedBox(
              height: padding6,
            ),
            Text(
              textAlign: TextAlign.center,
              message,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
            ),
            const SizedBox(
              height: padding12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ButtonStyle(
                        shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(radius6))),
                        backgroundColor:
                            WidgetStatePropertyAll(greyColor[300])),
                    child: Text(
                      "Отмена",
                      style: TextStyle(color: greyColor[600]),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: TextButton(
                      onPressed: () async {
                        await onConfirm();
                        Navigator.of(context).pop();
                      },
                      style: ButtonStyle(
                          shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(radius6))),
                          backgroundColor:
                              WidgetStatePropertyAll(Colors.red[400])),
                      child: const Text(
                        "Подтвердить",
                        style: TextStyle(color: whiteColor),
                      )),
                ),
                const SizedBox(
                  width: 20,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
