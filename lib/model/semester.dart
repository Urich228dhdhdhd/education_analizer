class Semester {
  int? id;
  int? semesterPart;
  int? semesterNumber;
  int? semesterYear;

  Semester(
      {this.id, this.semesterPart, this.semesterNumber, this.semesterYear});

  Semester.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    semesterPart = json['semester_part'];
    semesterNumber = json['semester_number'];
    semesterYear = json['semester_year'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['semester_part'] = semesterPart;
    data['semester_number'] = semesterNumber;
    data['semester_year'] = semesterYear;
    return data;
  }

  @override
  String toString() {
    return 'Semester(id: $id, semesterPart: $semesterPart, semesterNumber: $semesterNumber, semesterYear: $semesterYear)';
  }
}
