abstract class ParentEvent {}

class ChangePage extends ParentEvent {
  final int pageIndex;
  ChangePage({required this.pageIndex});
}

class Logout extends ParentEvent {}
