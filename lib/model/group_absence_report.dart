class GroupAbsenceReport {
  int? groupId; // Идентификатор группы
  AbsenceReport? absenceReport; // Отчет о пропусках

  // Конструктор с именованными параметрами
  GroupAbsenceReport({this.groupId, this.absenceReport});

  // Фабричный конструктор для создания объекта из JSON
  GroupAbsenceReport.fromJson(Map<String, dynamic> json) {
    groupId = json['group_id'];
    absenceReport = json['absence_report'] != null
        ? AbsenceReport.fromJson(json['absence_report'])
        : null;
  }

  // Метод для преобразования объекта в JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['group_id'] = groupId;
    if (absenceReport != null) {
      data['absence_report'] = absenceReport!.toJson();
    }
    return data;
  }

  // Переопределение метода toString для GroupAbsenceReport
  @override
  String toString() {
    return 'GroupAbsenceReport(groupId: $groupId, absenceReport: $absenceReport)';
  }
}

class AbsenceReport {
  int? illness; // Пропуски по болезни
  int? order; // Пропуски по уважительной причине
  int? resp; // Подтвержденные пропуски
  int? disresp; // Пропуски по неуважительной причине

  // Конструктор с именованными параметрами
  AbsenceReport({this.illness, this.order, this.resp, this.disresp});

  // Фабричный конструктор для создания объекта из JSON
  AbsenceReport.fromJson(Map<String, dynamic> json) {
    illness = json['illness'];
    order = json['order'];
    resp = json['resp'];
    disresp = json['disresp'];
  }

  // Метод для преобразования объекта в JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['illness'] = illness;
    data['order'] = order;
    data['resp'] = resp;
    data['disresp'] = disresp;
    return data;
  }

  // Переопределение метода toString для AbsenceReport
  @override
  String toString() {
    return 'AbsenceReport(illness: $illness, order: $order, resp: $resp, disresp: $disresp)';
  }
}
