class Subject {
  int? id;
  String? subjectNameShort;
  String? subjectNameLong;

  Subject({this.id, this.subjectNameShort, this.subjectNameLong});

  Subject.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    subjectNameShort = json['subject_name_short'];
    subjectNameLong = json['subject_name_long'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['subject_name_short'] = subjectNameShort;
    data['subject_name_long'] = subjectNameLong;
    return data;
  }

  @override
  String toString() {
    return 'Subject{id: $id, shortName: $subjectNameShort, longName: $subjectNameLong}';
  }
}
