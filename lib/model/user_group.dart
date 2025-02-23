import 'group.dart';
import 'user.dart';

class UserGroup {
  final User? user;
  final List<Group>? groups;

  UserGroup({required this.user, required this.groups});

  @override
  String toString() {
    return 'CuratorUser(user: ${user.toString()}, groups: ${groups.toString()})';
  }
}
