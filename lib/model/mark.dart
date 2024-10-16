class Mark {
  int? id;
  int? studentId;
  int? semesterId;
  int? subjectId;
  String? mark;

  Mark({this.id, this.studentId, this.semesterId, this.subjectId, this.mark});

  Mark.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    studentId = json['student_id'];
    semesterId = json['semester_id'];
    subjectId = json['subject_id'];
    mark = json['mark'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['student_id'] = studentId;
    data['semester_id'] = semesterId;
    data['subject_id'] = subjectId;
    data['mark'] = mark;
    return data;
  }
}
