class ParentMeetingModel {
  final int id;
  final MeetingInfo parentMeeting;
  final String status;
  final String? updatedAt;

  ParentMeetingModel({
    required this.id,
    required this.parentMeeting,
    required this.status,
    this.updatedAt,
  });

  factory ParentMeetingModel.fromJson(Map<String, dynamic> json) => ParentMeetingModel(
    id: json['id'] as int,
    parentMeeting: MeetingInfo.fromJson(json['parentMeeting'] as Map<String, dynamic>),
    status: json['status'] as String,
    updatedAt: json['updatedAt'] as String?,
  );
}

class MeetingInfo {
  final int id;
  final String date;
  final String startTime;
  final String endTime;
  final int toleranceTime;
  final String subject;

  MeetingInfo({
    required this.id,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.toleranceTime,
    required this.subject,
  });

  factory MeetingInfo.fromJson(Map<String, dynamic> json) => MeetingInfo(
    id: json['id'] as int,
    date: json['date'] as String,
    startTime: json['startTime'] as String,
    endTime: json['endTime'] as String,
    toleranceTime: json['toleranceTime'] as int,
    subject: json['subject'] as String,
  );

  String get timeRange => '${startTime.substring(0, 5)} - ${endTime.substring(0, 5)}';
}

class MeetingCheckParent {
  final int parentId;
  final int meetingId;

  MeetingCheckParent({required this.parentId, required this.meetingId});

  Map<String, dynamic> toJson() => {
    'parentId': parentId,
    'meetingId': meetingId,
  };
}
