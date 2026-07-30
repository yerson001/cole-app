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

class GetStudents extends ParentHomeEvent {
  final int parentId;
  final String tenantId;
  GetStudents({required this.parentId, required this.tenantId});
}

class GetDayReport extends ParentHomeEvent {
  final String date;
  final int branchId;
  final List<int> studentIds;
  final String tenantId;
  GetDayReport({
    required this.date,
    required this.branchId,
    required this.studentIds,
    required this.tenantId,
  });
}

class Logout extends ParentHomeEvent {}
