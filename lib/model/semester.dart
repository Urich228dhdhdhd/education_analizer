class Semester {
  int? id;
  int? semesterNumber;
  int? semesterYear;

  Semester({this.id, this.semesterNumber, this.semesterYear});

  Semester.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    semesterNumber = json['semester_number'];
    semesterYear = json['semester_year'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['semester_number'] = semesterNumber;
    data['semester_year'] = semesterYear;
    return data;
  }
}
