class Absence {
  int? id;
  int? studentId;
  int? year;
  int? month;
  int? absenceIllness;
  int? absenceOrder;
  int? absenceResp;
  int? absenceDisresp;

  Absence(
      {this.id,
      this.studentId,
      this.year,
      this.month,
      this.absenceIllness,
      this.absenceOrder,
      this.absenceResp,
      this.absenceDisresp});

  Absence.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    studentId = json['student_id'];
    year = json['year'];
    month = json['month'];
    absenceIllness = json['absence_illness'];
    absenceOrder = json['absence_order'];
    absenceResp = json['absence_resp'];
    absenceDisresp = json['absence_disresp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['student_id'] = studentId;
    data['year'] = year;
    data['month'] = month;
    data['absence_illness'] = absenceIllness;
    data['absence_order'] = absenceOrder;
    data['absence_resp'] = absenceResp;
    data['absence_disresp'] = absenceDisresp;
    return data;
  }
}
