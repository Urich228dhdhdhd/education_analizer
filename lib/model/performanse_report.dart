class PerformanseReport {
  List<StudentMarksData>? marksData;
  String? performancePercent;
  String? qualityOfKnowledgePercent;
  String? studentsLearningPercent;

  PerformanseReport({
    required this.marksData,
    required this.performancePercent,
    required this.qualityOfKnowledgePercent,
    required this.studentsLearningPercent,
  });

  // Фабричный метод для создания объекта из JSON
  factory PerformanseReport.fromJson(Map<String, dynamic> json) {
    // Функция для округления процентов
    String? roundPercent(dynamic value) {
      if (value == null || value == "null" || value == "NaN") {
        return "NaN";
      }
      final percent = double.tryParse(value.toString()); // Преобразуем в double
      return percent!.roundToDouble().toString(); // Округляем и возвращаем
    }

    return PerformanseReport(
      marksData: (json['allMarks'] as List)
          .map((e) => StudentMarksData.fromJson(e))
          .toList(),
      performancePercent: roundPercent(json['performancePercent']).toString(),
      qualityOfKnowledgePercent:
          roundPercent(json['qualityOfKnowledgePercent']).toString(),
      studentsLearningPercent:
          roundPercent(json['studentsLearningPercent']).toString(),
    );
  }

  // Преобразование объекта в JSON
  Map<String, dynamic> toJson() {
    return {
      'allMarks': marksData?.map((e) => e.toJson()).toList(),
      'performancePercent': performancePercent,
      'qualityOfKnowledgePercent': qualityOfKnowledgePercent,
      'studentsLearningPercent': studentsLearningPercent,
    };
  }

  @override
  String toString() {
    return 'PerformanseReport{marksData: $marksData, performancePercent: $performancePercent, qualityOfKnowledgePercent: $qualityOfKnowledgePercent, studentsLearningPercent: $studentsLearningPercent}';
  }
}

class StudentMarksData {
  String? studentName;
  List<SubjectMarkData>? markData;

  StudentMarksData(this.studentName, this.markData);

  factory StudentMarksData.fromJson(Map<String, dynamic> json) {
    return StudentMarksData(
      json['student'],
      (json['subjects'] as List)
          .map((e) => SubjectMarkData.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'student': studentName,
      'subjects': markData?.map((e) => e.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'StudentMarksData{studentName: $studentName, markData: $markData}';
  }
}

class SubjectMarkData {
  String? subjectName;
  String? mark;
  bool? isExam;

  SubjectMarkData(this.subjectName, this.mark, this.isExam);

  factory SubjectMarkData.fromJson(Map<String, dynamic> json) {
    return SubjectMarkData(
      json['subject'],
      json['marks'].toString(),
      json['is_exam'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subject': subjectName,
      'marks': mark,
      'is_exam': isExam,
    };
  }

  @override
  String toString() {
    return 'SubjectMarkData{subjectName: $subjectName, mark: $mark, isExam: $isExam}';
  }
}
