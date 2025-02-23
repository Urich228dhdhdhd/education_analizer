class Mark {
  int? id;
  int? studentId;
  int? semesterId;
  int? subjectId;
  String? mark;
  bool? isExam;

  Mark(
      {this.id,
      this.studentId,
      this.semesterId,
      this.subjectId,
      this.mark,
      this.isExam});

  Mark.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    studentId = json['student_id'];
    semesterId = json['semester_id'];
    subjectId = json['subject_id'];
    mark = json['mark'];
    isExam = json['is_exam'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['student_id'] = studentId;
    data['semester_id'] = semesterId;
    data['subject_id'] = subjectId;
    data['mark'] = mark;
    data['is_exam'] = isExam;
    return data;
  }

  @override
  String toString() {
    return 'Mark(id: $id, studentId: $studentId, semesterId: $semesterId, subjectId: $subjectId,mark: $mark, isExam: $isExam)\n';
  }
}
