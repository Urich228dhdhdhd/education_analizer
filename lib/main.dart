import 'dart:developer';

import 'package:education_analizer/bindings/absence_bindings.dart';
import 'package:education_analizer/bindings/global_bindings.dart';
import 'package:education_analizer/bindings/group_bildings.dart';
import 'package:education_analizer/bindings/login_bindings.dart';
import 'package:education_analizer/bindings/main_bindings.dart';
import 'package:education_analizer/bindings/performance_bindings.dart';
import 'package:education_analizer/bindings/report_bindings.dart';
import 'package:education_analizer/bindings/student_bindings.dart';
import 'package:education_analizer/bindings/subject_bildings.dart';
import 'package:education_analizer/bindings/user_bindings.dart';
import 'package:education_analizer/controlles/user_controller.dart';
import 'package:education_analizer/pages/absence_screan/absence_page.dart';
import 'package:education_analizer/pages/authorization_screan/login_page.dart';
import 'package:education_analizer/pages/group_screan/group_page.dart';
import 'package:education_analizer/pages/main_screan/main_page.dart';
import 'package:education_analizer/pages/performance_screan/performance_page.dart';
import 'package:education_analizer/pages/report_screan/report_page.dart';
import 'package:education_analizer/pages/student_screan/student_page.dart';
import 'package:education_analizer/pages/subject_screan/subject_page.dart';
import 'package:education_analizer/pages/user_manager_screan/user_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';

void main() {
  Get.put(UserController());
  log("start");
  runApp(GetMaterialApp(
    initialBinding: GlobalBindings(),
    initialRoute: "/login",
    localizationsDelegates: const [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: const [
      Locale('ru', 'RU'),
      Locale('en', 'US'),
    ],
    locale: const Locale('ru', 'RU'),
    getPages: [
      GetPage(
          name: "/login",
          page: () => const LoginPage(),
          binding: LoginBindings()),
      GetPage(
          name: "/home", page: () => const MainPage(), binding: MainBindings()),
      GetPage(
          name: "/group",
          page: () => const GroupPage(),
          binding: GroupBindings()),
      GetPage(
          name: "/subject",
          page: () => const SubjectPage(),
          binding: SubjectBildings()),
      GetPage(
          name: "/student",
          page: () => const StudentPage(),
          binding: StudentBindings()),
      GetPage(
          name: "/performance",
          page: () => const PerformancePage(),
          binding: PerformanceBindings()),
      GetPage(
          name: "/absence",
          page: () => const AbsencePage(),
          binding: AbsenceBindings()),
      GetPage(
          name: "/user", page: () => const UserPage(), binding: UserBindings()),
      GetPage(
          name: "/report",
          page: () => const ReportPage(),
          binding: ReportBindings()),
    ],
  ));
}
