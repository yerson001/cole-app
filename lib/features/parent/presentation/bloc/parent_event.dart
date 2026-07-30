abstract class ParentEvent {}

class ChangePage extends ParentEvent {
  final int pageIndex;
  ChangePage({required this.pageIndex});
}

class GetParentUser extends ParentEvent {}

class Logout extends ParentEvent {}
