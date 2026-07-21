abstract class ParentEvent {}

class ChangeDrawerPage extends ParentEvent {
  final int pageIndex;
  ChangeDrawerPage({required this.pageIndex});
}

class Logout extends ParentEvent {}
