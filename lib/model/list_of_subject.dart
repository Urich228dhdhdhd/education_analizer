class ListOfSubject {
  int? id;
  int? subjectId;
  int? groupId;
  int? semesterId;

  ListOfSubject({this.id, this.subjectId, this.groupId, this.semesterId});

  ListOfSubject.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    subjectId = json['subject_id'];
    groupId = json['group_id'];
    semesterId = json['semester_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['subject_id'] = subjectId;
    data['group_id'] = groupId;
    data['semester_id'] = semesterId;
    return data;
  }

  @override
  String toString() {
    return 'ListOfSubject(id: $id, subjectId: $subjectId, groupId: $groupId, semesterId: $semesterId)';
  }
}
