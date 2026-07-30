import 'package:equatable/equatable.dart';
import 'package:coleapp/features/parent/data/models/meeting_model.dart';

class ReunionesState extends Equatable {
  final List<ParentMeetingModel> meetings;
  final bool isLoading;
  final String? error;
  final int parentId;
  final String tenantId;

  const ReunionesState({
    this.meetings = const [],
    this.isLoading = false,
    this.error,
    this.parentId = 0,
    this.tenantId = '',
  });

  ReunionesState copyWith({
    List<ParentMeetingModel>? meetings,
    bool? isLoading,
    String? error,
    int? parentId,
    String? tenantId,
    bool clearError = false,
  }) {
    return ReunionesState(
      meetings: meetings ?? this.meetings,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      parentId: parentId ?? this.parentId,
      tenantId: tenantId ?? this.tenantId,
    );
  }

  @override
  List<Object?> get props => [meetings, isLoading, error, parentId, tenantId];
}
