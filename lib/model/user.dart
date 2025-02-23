class User {
  int? id;
  String? firstName;
  String? middleName;
  String? lastName;
  String? username;
  String? password;
  String? role;

  User({
    this.id,
    this.firstName,
    this.middleName,
    this.lastName,
    this.username,
    this.password,
    this.role,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    middleName = json['middle_name'];
    lastName = json['last_name'];
    username = json['username'];
    password = json['password'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'middle_name': middleName,
      'last_name': lastName,
      'username': username,
      'password': password,
      'role': role,
    };
  }

  @override
  String toString() {
    return 'User(id: $id, firstName: $firstName, middleName: $middleName, lastName: $lastName, '
        'username: $username, password: $password, role: $role)';
  }
}
