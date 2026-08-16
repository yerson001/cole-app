class AgendaModel {
  final List<AgendaItemModel> items;
  final String? createdAt;
  final String? updatedAt;

  AgendaModel({
    required this.items,
    this.createdAt,
    this.updatedAt,
  });

  factory AgendaModel.fromJson(Map<String, dynamic> json) {
    final list = json['items'] as List? ?? [];
    return AgendaModel(
      items: list.map((e) => AgendaItemModel.fromJson(e as Map<String, dynamic>)).toList(),
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );
  }
}

class AgendaItemModel {
  final int id;
  final String type;
  final String refId;
  final String title;
  final String description;
  final String? dueDate;
  final String? dueTime;
  final String? publishedAt;
  final AgendaSenderModel sender;
  final bool completed;
  final String? createdAt;
  final AgendaStudentModel? student;
  final String? readAt;
  final bool isRead;
  final String? course;
  final int? courseSectionId;

  AgendaItemModel({
    required this.id,
    required this.type,
    required this.refId,
    required this.title,
    required this.description,
    this.dueDate,
    this.dueTime,
    this.publishedAt,
    required this.sender,
    required this.completed,
    this.createdAt,
    this.student,
    this.readAt,
    this.isRead = false,
    this.course,
    this.courseSectionId,
  });

  factory AgendaItemModel.fromJson(Map<String, dynamic> json) {
    return AgendaItemModel(
      id: json['id'] as int,
      type: json['type'] as String,
      refId: json['refId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      dueDate: json['dueDate'] as String?,
      dueTime: json['dueTime'] as String?,
      publishedAt: json['publishedAt'] as String?,
      sender: AgendaSenderModel.fromJson(json['sender'] as Map<String, dynamic>),
      completed: json['completed'] as bool? ?? false,
      createdAt: json['createdAt'] as String?,
      student: json['student'] != null
          ? AgendaStudentModel.fromJson(json['student'] as Map<String, dynamic>)
          : null,
      readAt: json['readAt'] as String?,
      isRead: json['isRead'] as bool? ?? (json['readAt'] != null),
      course: json['course'] as String?,
      courseSectionId: json['courseSectionId'] as int?,
    );
  }

  AgendaItemModel copyWith({
    String? readAt,
    bool? isRead,
    AgendaStudentModel? student,
  }) {
    return AgendaItemModel(
      id: id,
      type: type,
      refId: refId,
      title: title,
      description: description,
      dueDate: dueDate,
      dueTime: dueTime,
      publishedAt: publishedAt,
      sender: sender,
      completed: completed,
      createdAt: createdAt,
      student: student ?? this.student,
      readAt: readAt ?? this.readAt,
      isRead: isRead ?? this.isRead,
      course: course,
      courseSectionId: courseSectionId,
    );
  }
}

class AgendaSenderModel {
  final int id;
  final String name;
  final String lastName;

  AgendaSenderModel({
    required this.id,
    required this.name,
    required this.lastName,
  });

  factory AgendaSenderModel.fromJson(Map<String, dynamic> json) {
    return AgendaSenderModel(
      id: json['id'] as int,
      name: json['name'] as String,
      lastName: json['lastName'] as String,
    );
  }

  String get fullName => '$name $lastName';
}

class AgendaStudentModel {
  final int id;
  final String name;
  final String lastName;

  AgendaStudentModel({
    required this.id,
    required this.name,
    required this.lastName,
  });

  factory AgendaStudentModel.fromJson(Map<String, dynamic> json) {
    return AgendaStudentModel(
      id: json['id'] as int,
      name: json['name'] as String,
      lastName: json['lastName'] as String,
    );
  }

  String get fullName => '$name $lastName';
}
