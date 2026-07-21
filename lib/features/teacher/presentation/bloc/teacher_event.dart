abstract class TeacherEvent {}

class ChangeDrawerPage extends TeacherEvent {
  final int pageIndex;
  ChangeDrawerPage({required this.pageIndex});
}

class Logout extends TeacherEvent {}
