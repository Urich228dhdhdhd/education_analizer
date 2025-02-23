import 'semester.dart';
import 'subject.dart';

class SubjectInfo {
  final Subject subject;
  final List<Semester> semesters;

  SubjectInfo({
    required this.semesters,
    required this.subject,
  });
  @override
  String toString() {
    return 'SubjectInfo(subject: ${subject.subjectNameShort}, semesters: ${semesters.map((s) => s.semesterNumber).toList()})';
  }
}
