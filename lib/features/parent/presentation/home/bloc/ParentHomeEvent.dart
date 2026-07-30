abstract class ParentHomeEvent {}

class ChangePage extends ParentHomeEvent {
  final int pageIndex;
  ChangePage({required this.pageIndex});
}

class GetParentUser extends ParentHomeEvent {}

class GetBranch extends ParentHomeEvent {
  final int id;
  final String tenantId;
  GetBranch({required this.id, required this.tenantId});
}

class Logout extends ParentHomeEvent {}
