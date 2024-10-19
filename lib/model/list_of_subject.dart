class ListOfSubject {
  int? id;
  int? subjectId;
  int? groupId;
  int? semesterNumber;

  ListOfSubject({this.id, this.subjectId, this.groupId, this.semesterNumber});

  ListOfSubject.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    subjectId = json['subject_id'];
    groupId = json['group_id'];
    semesterNumber = json['semester_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['subject_id'] = subjectId;
    data['group_id'] = groupId;
    data['semester_number'] = semesterNumber;
    return data;
  }

  @override
  String toString() {
    return 'ListOfSubject(id: $id, subjectId: $subjectId, groupId: $groupId, semesterNumber: $semesterNumber)';
  }
}
