class HomeworkDetailModel {
  final int id;
  final String title;
  final String content;
  final String? dueDate;
  final String? dueTime;
  final String? publishedAt;
  final String? createdAt;
  final HomeworkCourseSectionModel courseSection;
  final HomeworkSenderModel sender;

  HomeworkDetailModel({
    required this.id,
    required this.title,
    required this.content,
    this.dueDate,
    this.dueTime,
    this.publishedAt,
    this.createdAt,
    required this.courseSection,
    required this.sender,
  });

  factory HomeworkDetailModel.fromJson(Map<String, dynamic> json) {
    return HomeworkDetailModel(
      id: json['id'] as int,
      title: json['title'] as String,
      content: json['content'] as String? ?? '',
      dueDate: json['dueDate'] as String?,
      dueTime: json['dueTime'] as String?,
      publishedAt: json['publishedAt'] as String?,
      createdAt: json['createdAt'] as String?,
      courseSection: json['courseSection'] != null
          ? HomeworkCourseSectionModel.fromJson(
              json['courseSection'] as Map<String, dynamic>)
          : HomeworkCourseSectionModel.fromJson(const {}),
      sender: HomeworkSenderModel.fromJson(
        json['sender'] as Map<String, dynamic>? ?? const {},
      ),
    );
  }

  DateTime? get localDate =>
      DateTime.tryParse(publishedAt ?? createdAt ?? '')?.toLocal();

  String? get fullCourseSection {
    final section = courseSection.section;
    if (section?.degrees == null) return courseSection.name;
    final degrees = section!.degrees!;
    return '${degrees.level.name} - ${degrees.name} - ${section.name}'
        .trim();
  }
}

class HomeworkCourseSectionModel {
  final int id;
  final String name;
  final String? courseName;
  final HomeworkSectionModel? section;

  HomeworkCourseSectionModel({
    required this.id,
    required this.name,
    this.courseName,
    this.section,
  });

  factory HomeworkCourseSectionModel.fromJson(Map<String, dynamic> json) {
    return HomeworkCourseSectionModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      courseName:
          (json['course'] as Map<String, dynamic>?)?['name'] as String?,
      section: json['section'] != null
          ? HomeworkSectionModel.fromJson(json['section'] as Map<String, dynamic>)
          : null,
    );
  }
}

class HomeworkSectionModel {
  final String name;
  final HomeworkDegreesModel? degrees;

  HomeworkSectionModel({required this.name, this.degrees});

  factory HomeworkSectionModel.fromJson(Map<String, dynamic> json) {
    return HomeworkSectionModel(
      name: json['name'] as String? ?? '',
      degrees: json['degrees'] != null
          ? HomeworkDegreesModel.fromJson(json['degrees'] as Map<String, dynamic>)
          : null,
    );
  }
}

class HomeworkDegreesModel {
  final String name;
  final HomeworkLevelModel level;

  HomeworkDegreesModel({required this.name, required this.level});

  factory HomeworkDegreesModel.fromJson(Map<String, dynamic> json) {
    return HomeworkDegreesModel(
      name: json['name'] as String? ?? '',
      level: json['level'] != null
          ? HomeworkLevelModel.fromJson(json['level'] as Map<String, dynamic>)
          : const HomeworkLevelModel(name: ''),
    );
  }
}

class HomeworkLevelModel {
  final String name;

  const HomeworkLevelModel({required this.name});

  factory HomeworkLevelModel.fromJson(Map<String, dynamic> json) {
    return HomeworkLevelModel(name: json['name'] as String? ?? '');
  }
}

class HomeworkSenderModel {
  final String name;
  final String lastName;
  final List<String> roles;

  HomeworkSenderModel({
    required this.name,
    required this.lastName,
    required this.roles,
  });

  factory HomeworkSenderModel.fromJson(Map<String, dynamic> json) {
    final person = json['person'] as Map<String, dynamic>? ?? const {};
    final roles = (json['roles'] as List? ?? [])
        .whereType<Map<String, dynamic>>()
        .map((r) => r['name']?.toString() ?? '')
        .where((n) => n.isNotEmpty)
        .toList();
    return HomeworkSenderModel(
      name: person['name'] as String? ?? '',
      lastName: person['lastName'] as String? ?? '',
      roles: roles,
    );
  }

  String get fullName => '$name $lastName'.trim();
}

class AnnouncementDetailModel {
  final int id;
  final String title;
  final String content;
  final String? publishedAt;
  final String? createdAt;
  final HomeworkSenderModel sender;

  AnnouncementDetailModel({
    required this.id,
    required this.title,
    required this.content,
    this.publishedAt,
    this.createdAt,
    required this.sender,
  });

  factory AnnouncementDetailModel.fromJson(Map<String, dynamic> json) {
    return AnnouncementDetailModel(
      id: json['id'] as int,
      title: json['title'] as String,
      content: json['content'] as String? ?? '',
      publishedAt: json['publishedAt'] as String?,
      createdAt: json['createdAt'] as String?,
      sender: HomeworkSenderModel.fromJson(
        json['sender'] as Map<String, dynamic>? ?? const {},
      ),
    );
  }

  DateTime? get localDate =>
      DateTime.tryParse(publishedAt ?? createdAt ?? '')?.toLocal();
}

class ObservationDetailModel {
  final int id;
  final String title;
  final String content;
  final String? publishedAt;
  final String? createdAt;
  final String? severity;
  final HomeworkSenderModel sender;

  ObservationDetailModel({
    required this.id,
    required this.title,
    required this.content,
    this.publishedAt,
    this.createdAt,
    this.severity,
    required this.sender,
  });

  factory ObservationDetailModel.fromJson(Map<String, dynamic> json) {
    return ObservationDetailModel(
      id: json['id'] as int,
      title: json['title'] as String,
      content: json['content'] as String? ?? '',
      publishedAt: json['publishedAt'] as String?,
      createdAt: json['createdAt'] as String?,
      severity: json['severity'] as String?,
      sender: HomeworkSenderModel.fromJson(
        json['sender'] as Map<String, dynamic>? ?? const {},
      ),
    );
  }

  DateTime? get localDate =>
      DateTime.tryParse(publishedAt ?? createdAt ?? '')?.toLocal();
}