abstract class DirectorEvent {}

class ChangeDrawerPage extends DirectorEvent {
  final int pageIndex;
  ChangeDrawerPage({required this.pageIndex});
}

class Logout extends DirectorEvent {}
