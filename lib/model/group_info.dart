import 'group.dart';

class GroupInfo {
  final Group? group;
  final int? studentCount;

  GroupInfo({required this.group, required this.studentCount});
  @override
  String toString() {
    return 'GroupInfo(group: ${group?.toString() ?? "null"}, studentCount: $studentCount)';
  }
}
