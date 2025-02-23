class Group {
  int? id;
  String? groupName;
  int? curatorId;
  String? statusGroup;
  int? startYear;
  int? endYear;

  Group(
      {this.id,
      this.groupName,
      this.curatorId,
      this.statusGroup,
      this.startYear,
      this.endYear});

  Group.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    groupName = json['group_name'];
    curatorId = json['curator_id'];
    statusGroup = json['status_group'];
    startYear = json['start_year'];
    endYear = json['end_year'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['group_name'] = groupName;
    data['curator_id'] = curatorId;
    data['status_group'] = statusGroup;
    data['start_year'] = startYear;
    data['end_year'] = endYear;
    return data;
  }

  // Переопределение метода toString
  @override
  String toString() {
    return 'Group{id: $id, groupName: $groupName, curatorId: $curatorId, statusGroup: $statusGroup, startYear: $startYear, endYear $endYear }';
  }

  /// ✅ Переопределяем оператор "==", чтобы сравнивать группы по `id`
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Group && id != null && other.id == id);

  /// ✅ Используем `id.hashCode` для корректного сравнения в списках
  @override
  int get hashCode => id.hashCode;
}
