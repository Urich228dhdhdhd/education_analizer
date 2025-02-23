class Report {
  final int id;
  final int userId;
  final String reportName;
  final String filePath;
  final DateTime createdAt;

  Report({
    required this.id,
    required this.userId,
    required this.reportName,
    required this.filePath,
    required this.createdAt,
  });

  // Фабричный метод для создания объекта из JSON
  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      id: json['id'],
      userId: json['user_id'],
      reportName: json['reportName'],
      filePath: json['filePath'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  // Преобразование объекта в JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'reportName': reportName,
      'filePath': filePath,
      'created_at': createdAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'Report(id: $id, userId: $userId, reportName: "$reportName", filePath: "$filePath", createdAt: ${createdAt.toIso8601String()})';
  }
}
