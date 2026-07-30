abstract class ReunionesEvent {}

class LoadMeetings extends ReunionesEvent {
  final int parentId;
  final String tenantId;

  LoadMeetings({required this.parentId, required this.tenantId});
}

class CheckInMeeting extends ReunionesEvent {
  final int meetingId;

  CheckInMeeting({required this.meetingId});
}

class CheckOutMeeting extends ReunionesEvent {
  final int meetingId;

  CheckOutMeeting({required this.meetingId});
}
