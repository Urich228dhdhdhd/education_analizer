class Group {
  int? id;
  String? groupName;
  int? curatorId;
  String? statusGroup;
  int? semesterNumber;

  Group(
      {this.id,
      this.groupName,
      this.curatorId,
      this.statusGroup,
      this.semesterNumber});

  Group.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    groupName = json['group_name'];
    curatorId = json['curator_id'];
    statusGroup = json['status_group'];
    semesterNumber = json['semester_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['group_name'] = groupName;
    data['curator_id'] = curatorId;
    data['status_group'] = statusGroup;
    data['semester_number'] = semesterNumber;
    return data;
  }
}
