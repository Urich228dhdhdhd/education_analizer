class GroupAbsenceReport {
  int? groupId;
  AbsenceReport? absenceReport;

  GroupAbsenceReport({this.groupId, this.absenceReport});

  GroupAbsenceReport.fromJson(Map<String, dynamic> json) {
    groupId = json['group_id'];
    absenceReport = json['absence_report'] != null
        ? AbsenceReport.fromJson(json['absence_report'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['group_id'] = groupId;
    if (absenceReport != null) {
      data['absence_report'] = absenceReport!.toJson();
    }
    return data;
  }

  @override
  String toString() {
    return 'GroupAbsenceReport(groupId: $groupId, absenceReport: $absenceReport)';
  }
}

class AbsenceReport {
  int? illness;
  int? order;
  int? resp;
  int? disresp;

  AbsenceReport({this.illness, this.order, this.resp, this.disresp});

  AbsenceReport.fromJson(Map<String, dynamic> json) {
    illness = json['illness'];
    order = json['order'];
    resp = json['resp'];
    disresp = json['disresp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['illness'] = illness;
    data['order'] = order;
    data['resp'] = resp;
    data['disresp'] = disresp;
    return data;
  }

  @override
  String toString() {
    return 'AbsenceReport(illness: $illness, order: $order, resp: $resp, disresp: $disresp)';
  }
}
