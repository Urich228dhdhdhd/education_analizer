import 'dart:developer';
import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:education_analizer/controlles/main_page_controller.dart';
import 'package:education_analizer/design/dialog/app_bar.dart';
import 'package:education_analizer/design/dialog/drawer.dart';
import 'package:education_analizer/design/dialog/styles.dart';
import 'package:education_analizer/design/widgets/colors.dart';
import 'package:education_analizer/design/widgets/dimentions.dart';
import 'package:education_analizer/model/group_info.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    MainPageController mainPageController = Get.find();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await mainPageController.findGroupsByRole();
    });

    return WillPopScope(
      onWillPop: () async {
        Get.offAllNamed("/login");
        return false;
      },
      child: Scaffold(
        backgroundColor: primaryColor,
        resizeToAvoidBottomInset: false,
        appBar:
            CustomAppBar(role: mainPageController.authController.role.value),
        drawer:
            CustomDrawer(role: mainPageController.authController.role.value),
        body: SafeArea(
            child: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            Obx(() {
              if (mainPageController.isGroupLoading.value) {
                return const Expanded(
                  child: Center(child: CircularProgressIndicator.adaptive()),
                );
              }
              if (mainPageController.groups.isEmpty) {
                return SizedBox(
                  child: Text(
                    "Группы не найдены",
                    style: textFieldtext.copyWith(fontSize: 14),
                  ),
                );
              }
              return CarouselSlider.builder(
                itemCount: mainPageController.groups.length,
                options: CarouselOptions(
                  aspectRatio: 2,
                  enlargeCenterPage: true,
                  enlargeStrategy: CenterPageEnlargeStrategy.zoom,
                  enlargeFactor: 0.3,
                  initialPage: mainPageController.currentCarouselIndex.value,
                  onPageChanged: (index, reason) async {
                    var groupId = mainPageController.groups[index].keys.first;
                    mainPageController.currentCarouselIndex.value = index;
                    await mainPageController.setSelectedGroup(
                        groupInfo: mainPageController.groups[index][groupId]!);
                  },
                ),
                itemBuilder: (context, index, realIndex) {
                  var groupId = mainPageController.groups[index].keys.first;
                  var groupInfo = mainPageController.groups[index][groupId];

                  return GroupCard(groupInfo: groupInfo);
                },
              );
            }),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: padding12),
              child: Obx(() {
                return Visibility(
                  visible: mainPageController.groups.isNotEmpty,
                  child: AnimatedSmoothIndicator(
                    activeIndex: mainPageController.currentCarouselIndex.value,
                    count: mainPageController.groups.length,
                    effect: WormEffect(
                        type: WormType.thin,
                        spacing: 10,
                        dotWidth: 8,
                        dotHeight: 8,
                        activeDotColor: greyColor[600]!,
                        dotColor: greyColor[400]!),
                  ),
                );
              }),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: padding12, left: 12, right: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 200,
                          child: Container(
                            decoration: BoxDecoration(
                                color: whiteColor,
                                borderRadius: BorderRadius.circular(radius10)),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Obx(() {
                                  return PieChart(
                                    curve: Curves.bounceIn,
                                    PieChartData(
                                      startDegreeOffset: 270,
                                      sections: [
                                        PieChartSectionData(
                                          color: greyColor[300],
                                          value: 100 -
                                              mainPageController
                                                  .diogramPercent.value,
                                          showTitle: false,
                                          radius: 10,
                                        ),
                                        PieChartSectionData(
                                          color: primary6Color,
                                          value: mainPageController
                                              .diogramPercent.value,
                                          showTitle: false,
                                          radius: 10,
                                        ),
                                      ],
                                      centerSpaceRadius: 68,
                                      sectionsSpace: 2,
                                    ),
                                  );
                                }),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text("Процент\nуспеваемости",
                                        textAlign: TextAlign.center,
                                        style: primaryStyle.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: greyColor[700],
                                            fontSize: 14)),
                                    Obx(() {
                                      return Text(
                                          mainPageController
                                              .performancePercent.value,
                                          textAlign: TextAlign.center,
                                          style: primaryStyle.copyWith(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 22));
                                    })
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 14,
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 200,
                      // color: Colors.green,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Container(
                                decoration: BoxDecoration(
                                    color: whiteColor,
                                    borderRadius:
                                        BorderRadius.circular(radius10)),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: padding12),
                                child: Row(
                                  // mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Количество \nчеловек",
                                        style: primaryStyle.copyWith(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: greyColor[700])),
                                    Expanded(
                                      child: Center(
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 12),
                                          width: 2,
                                          decoration: BoxDecoration(
                                              color: greyColor,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      radius6)),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Center(
                                        child: Obx(() {
                                          final selectedGroupInfo =
                                              mainPageController
                                                  .selectedGroupInfo.value;

                                          if (mainPageController
                                                  .selectedGroupInfo.value ==
                                              null) {
                                            return const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          }
                                          return Text(
                                              mainPageController
                                                  .selectedGroupInfo
                                                  .value!
                                                  .studentCount
                                                  .toString(),
                                              textAlign: TextAlign.center,
                                              style: primaryStyle.copyWith(
                                                  fontSize: 24));
                                        }),
                                      ),
                                    )
                                  ],
                                )),
                          ),
                          const SizedBox(
                            height: 14,
                          ),
                          Expanded(
                            child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.circular(radius10)),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "Куратор",
                                          style: primaryStyle.copyWith(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: greyColor[700]),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 6),
                                      child: Row(
                                        children: [
                                          Container(
                                            height: 2,
                                            width: 60,
                                            color: greyColor,
                                          )
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Obx(() {
                                          final curatorData = mainPageController
                                              .curatorData.value;

                                          return Text(
                                            curatorData != null &&
                                                    curatorData.firstName !=
                                                        null &&
                                                    curatorData.lastName != null
                                                ? "${curatorData.middleName ?? ''} ${curatorData.firstName![0]}.${curatorData.lastName![0]}."
                                                : "Куратор не назначен",
                                            style: primaryStyle.copyWith(
                                                fontSize: 14),
                                          );
                                        })
                                      ],
                                    ),
                                  ],
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: padding14,
            ),
            Expanded(
              child: Padding(
                  padding: const EdgeInsets.only(
                      left: padding12, right: padding12, bottom: padding12),
                  child: Container(
                      decoration: _containerDecoration(),
                      padding: const EdgeInsets.only(
                          top: 10, bottom: 10, left: 10, right: 10),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Obx(() {
                                if (mainPageController.absences.values
                                    .every((value) => value == 0)) {
                                  return const SizedBox();
                                }
                                return Text(
                                  "Пропуски ${mainPageController.selectedGroupInfo.value!.group!.groupName} за ${DateTime.now().month}.${DateTime.now().year}",
                                  style: primaryStyle.copyWith(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: greyColor[700]),
                                );
                              })
                            ],
                          ),
                          // const SizedBox(
                          //   height: 30,
                          // ),
                          Expanded(
                            child: Obx(() {
                              if (mainPageController.isGroupLoading.value) {
                                return const Center(
                                  child: CircularProgressIndicator.adaptive(),
                                );
                              }
                              if (mainPageController.absences.values
                                  .every((value) => value == 0)) {
                                return Center(
                                    child: Text(
                                  "Пропуски не обнаружены",
                                  style: textFieldtext.copyWith(fontSize: 16),
                                ));
                              }
                              return BarChart(
                                BarChartData(
                                    maxY: mainPageController.absences.values
                                            .reduce(max)
                                            .toDouble() *
                                        1.2,
                                    barGroups:
                                        mainPageController.generateBarGroups(),
                                    titlesData: FlTitlesData(
                                      topTitles: const AxisTitles(
                                        sideTitles: SideTitles(
                                            showTitles: false,
                                            reservedSize: 30),
                                      ),
                                      leftTitles: const AxisTitles(
                                        sideTitles: SideTitles(
                                            showTitles: false,
                                            reservedSize: 30),
                                      ),
                                      rightTitles: const AxisTitles(
                                        sideTitles: SideTitles(
                                            showTitles: false,
                                            reservedSize: 30),
                                      ),
                                      bottomTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: true,
                                          getTitlesWidget: mainPageController
                                              .bottomTitleWidgets,
                                          reservedSize: 20,
                                        ),
                                      ),
                                    ),
                                    barTouchData: BarTouchData(
                                      enabled: false,
                                      touchTooltipData: BarTouchTooltipData(
                                        direction: TooltipDirection.top,
                                        fitInsideVertically: true,
                                        getTooltipColor: (group) =>
                                            Colors.transparent,
                                        tooltipPadding: EdgeInsets.zero,
                                        tooltipMargin: 0,
                                        getTooltipItem:
                                            (group, groupIndex, rod, rodIndex) {
                                          return BarTooltipItem(
                                            rod.toY.round().toString(),
                                            const TextStyle(
                                              color: primary6Color,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    borderData: FlBorderData(
                                      show: false,
                                    ),
                                    gridData: const FlGridData(show: false),
                                    alignment: BarChartAlignment.spaceAround
                                    // alignment: BarChartAlignment.spaceAround,

                                    ),
                                curve: Curves.easeOutCirc,
                                duration: const Duration(milliseconds: 800),
                              );
                            }),
                          ),
                        ],
                      ))),
            )
          ],
        )),
      ),
    );
  }

  BoxDecoration _containerDecoration() {
    return BoxDecoration(
        color: whiteColor, borderRadius: BorderRadius.circular(radius10));
  }
}

class GroupCard extends StatelessWidget {
  const GroupCard({
    super.key,
    required this.groupInfo,
  });

  final GroupInfo? groupInfo;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
          color: whiteColor, borderRadius: BorderRadius.circular(radius20)),
      child: Center(
        child: Text(
            groupInfo!.group?.groupName != null
                ? groupInfo!.group!.groupName!
                : "Нет групп",
            style: primaryStyle),
      ),
    );
  }
}
