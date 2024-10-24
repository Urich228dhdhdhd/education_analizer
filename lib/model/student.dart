class Student {
  int? id;
  String? firstName;
  String? middleName;
  String? lastName;
  String? telNumber;
  String? dateBirthday;
  int? groupId;

  Student(
      {this.id,
      this.firstName,
      this.middleName,
      this.lastName,
      this.telNumber,
      this.dateBirthday,
      this.groupId});

  Student.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    middleName = json['middle_name'];
    lastName = json['last_name'];
    telNumber = json['tel_number'];
    dateBirthday = json['date_birthday'];
    groupId = json['group_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['middle_name'] = middleName;
    data['last_name'] = lastName;
    data['tel_number'] = telNumber;
    data['date_birthday'] = dateBirthday;
    data['group_id'] = groupId;
    return data;
  }

  // Переопределение метода toString для удобного логгирования
  @override
  String toString() {
    return 'Student{id: $id, firstName: $firstName, middleName: $middleName, lastName: $lastName, telNumber: $telNumber, dateBirthday: $dateBirthday, groupId: $groupId}';
  }
}
