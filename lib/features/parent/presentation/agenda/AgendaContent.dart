import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coleapp/core/themes/app_colors.dart';
import 'package:coleapp/features/parent/data/models/agenda_model.dart';
import 'package:coleapp/features/parent/data/models/student_model.dart';
import 'package:coleapp/features/parent/domain/usecases/parent_use_cases.dart';
import 'package:coleapp/features/parent/presentation/agenda/AgendaDetailPage.dart';
import 'package:coleapp/features/parent/presentation/agenda/bloc/AgendaBloc.dart';
import 'package:coleapp/features/parent/presentation/agenda/bloc/AgendaEvent.dart';
import 'package:coleapp/features/parent/presentation/agenda/bloc/AgendaState.dart';
import 'package:coleapp/features/parent/presentation/home/bloc/ParentHomeBloc.dart';
import 'package:coleapp/features/parent/presentation/home/bloc/ParentHomeState.dart';
import 'package:coleapp/features/parent/presentation/widgets/agenda_calendar.dart';
import 'package:coleapp/features/parent/presentation/widgets/child_selector.dart';
import 'package:coleapp/features/parent/presentation/widgets/type_colors.dart';
import 'package:coleapp/features/parent/presentation/widgets/unread_indicator.dart';
import 'package:coleapp/injection.dart';

class AgendaContent extends StatelessWidget {
  const AgendaContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AgendaBloc>(
      create: (_) => AgendaBloc(locator<ParentUseCases>()),
      child: const _AgendaBody(),
    );
  }
}

class _AgendaBody extends StatefulWidget {
  const _AgendaBody();

  @override
  State<_AgendaBody> createState() => _AgendaBodyState();
}

class _AgendaBodyState extends State<_AgendaBody> {
  int? _loadedStudentsLength;

  void _tryInitialize(ParentHomeState state) {
    final parentId = state.user?.profile?.id;
    final tenantId = state.tenant;
    final students = state.students;
    if (parentId == null || tenantId.isEmpty || students.isEmpty) return;
    if (_loadedStudentsLength == students.length) return;
    _loadedStudentsLength = students.length;
    final now = DateTime.now();
    final range = _initialRange(now);
    context.read<AgendaBloc>().add(
      LoadAgenda(
        parentId: parentId,
        tenantId: tenantId,
        startDate: range.startDate,
        endDate: range.endDate,
        students: students,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final parentState = context.watch<ParentHomeBloc>().state;
    _tryInitialize(parentState);

    return BlocListener<ParentHomeBloc, ParentHomeState>(
      listenWhen: (previous, current) =>
          previous.user?.profile?.id != current.user?.profile?.id ||
          previous.tenant != current.tenant ||
          previous.students.length != current.students.length,
      listener: (context, state) => _tryInitialize(state),
      child: BlocBuilder<AgendaBloc, AgendaState>(
        builder: (context, state) {
          final ac = context.appColors;
          final parentId = parentState.user?.profile?.id;
          final tenantId = parentState.tenant;

          if (parentId == null || tenantId.isEmpty) {
            return const Center(child: Text('No hay sesión de padre activa'));
          }

          if (parentState.students.isEmpty ||
              (state.isLoading && state.items.isEmpty)) {
            return const Center(child: CircularProgressIndicator());
          }

          return RefreshIndicator(
            onRefresh: () async {
              final range = _initialRange(state.selectedDate);
              context.read<AgendaBloc>().add(
                LoadAgenda(
                  parentId: parentId,
                  studentId: state.selectedStudent?.id,
                  tenantId: tenantId,
                  startDate: range.startDate,
                  endDate: range.endDate,
                  students: parentState.students,
                ),
              );
            },
            child: Column(
              children: [
                _StudentSelector(
                  students: parentState.students,
                  selectedStudent: state.selectedStudent,
                  tenantId: tenantId,
                  parentId: parentId,
                ),
                CalendarViewFilter(
                  view: state.view,
                  onChanged: (view) =>
                      context.read<AgendaBloc>().add(ChangeView(view: view)),
                ),
                CalendarNavigationHeader(
                  view: state.view,
                  selectedDate: state.selectedDate,
                  onPrevious: () => _changeDate(context, -1),
                  onNext: () => _changeDate(context, 1),
                  onToday: () => _changeDate(context, 0, today: true),
                ),
                if (state.error != null && state.items.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      state.error!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                Expanded(
                  child: switch (state.view) {
                    AgendaView.daily => Column(
                      children: [
                        Divider(height: 1, thickness: 1, color: ac.border),
                        Expanded(
                          child: _AgendaList(state: state, tenantId: tenantId),
                        ),
                      ],
                    ),
                    AgendaView.weekly => Column(
                      children: [
                        CalendarWeekGrid(
                          selectedDate: state.selectedDate,
                          dayDots: (day) => state
                              .itemsOn(day)
                              .map((i) => calendarTypeColor(i.type))
                              .toList(),
                          onDayTap: (day) =>
                              _changeDate(context, 0, date: day),
                        ),
                        Divider(height: 20, thickness: 1, color: ac.border),
                        Expanded(
                          child: _AgendaList(state: state, tenantId: tenantId),
                        ),
                      ],
                    ),
                    AgendaView.monthly => Column(
                      children: [
                        CalendarMonthGrid(
                          selectedDate: state.selectedDate,
                          dayDots: (day) => state
                              .itemsOn(day)
                              .map((i) => calendarTypeColor(i.type))
                              .toList(),
                          onDayTap: (day) =>
                              _changeDate(context, 0, date: day),
                        ),
                        Divider(height: 20, thickness: 1, color: ac.border),
                        Expanded(
                          child: _AgendaList(state: state, tenantId: tenantId),
                        ),
                      ],
                    ),
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _changeDate(
    BuildContext context,
    int step, {
    bool today = false,
    DateTime? date,
  }) {
    final bloc = context.read<AgendaBloc>();
    DateTime newDate;
    if (date != null) {
      newDate = date;
    } else if (today) {
      newDate = DateTime.now();
    } else {
      newDate = switch (bloc.state.view) {
        AgendaView.daily => bloc.state.selectedDate.add(Duration(days: step)),
        AgendaView.weekly => bloc.state.selectedDate.add(
          Duration(days: 7 * step),
        ),
        AgendaView.monthly => DateTime(
          bloc.state.selectedDate.year,
          bloc.state.selectedDate.month + step,
          1,
        ),
      };
    }
    bloc.add(ChangeDate(date: newDate));
  }

  ({String startDate, String endDate}) _initialRange(DateTime date) {
    final start = DateTime(date.year, date.month, 1);
    final end = DateTime(date.year, date.month + 1, 1);
    return (startDate: _formatDate(start), endDate: _formatDate(end));
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}

class _StudentSelector extends StatelessWidget {
  final List<StudentModel> students;
  final StudentModel? selectedStudent;
  final String tenantId;
  final int parentId;

  const _StudentSelector({
    required this.students,
    this.selectedStudent,
    required this.tenantId,
    required this.parentId,
  });

  @override
  Widget build(BuildContext context) {
    if (students.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: ChildSelector(
        students: students,
        selectedStudent: selectedStudent,
        showAll: true,
        clean: true,
        onChanged: (student) {
          context.read<AgendaBloc>().add(SelectStudent(student: student));
        },
      ),
    );
  }
}

class _AgendaList extends StatelessWidget {
  final AgendaState state;
  final String tenantId;

  const _AgendaList({required this.state, required this.tenantId});

  @override
  Widget build(BuildContext context) {
    final ac = context.appColors;
    final items = state.itemsForSelectedDate;
    if (items.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.12),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Column(
                children: [
                  Icon(Icons.calendar_today, size: 28, color: ac.textDisabled),
                  const SizedBox(height: 14),
                  Text(
                    'Sin eventos este día',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: ac.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Reuniones, actividades y fechas importantes aparecerán aquí.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12.5,
                      color: ac.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      separatorBuilder: (_, __) =>
          Divider(height: 1, thickness: 1, color: ac.border),
      itemBuilder: (context, index) {
        final item = items[index];
        return _AgendaItemTile(item: item, tenantId: tenantId);
      },
    );
  }
}

class _AgendaItemTile extends StatelessWidget {
  final AgendaItemModel item;
  final String tenantId;

  const _AgendaItemTile({required this.item, required this.tenantId});

  @override
  Widget build(BuildContext context) {
    final ac = context.appColors;
    final (typeColor, icon, typeLabel) = _typeInfo(item.type);
    final course = item.course;
    final due = item.dueDate != null
        ? _formatDateOnly(DateTime.parse(item.dueDate!))
        : null;
    final studentName = (item.student?.name ?? '').trim();

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        if (!item.isRead) {
          context.read<AgendaBloc>().add(MarkItemAsRead(itemId: item.id));
        }
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => AgendaDetailPage(item: item, tenantId: tenantId),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: ac.fill,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: typeColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: typeColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          typeLabel,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Spacer(),
                      if (course != null) ...[
                        Icon(
                          Icons.menu_book,
                          size: 14,
                          color: ac.textPrimary,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            course,
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.normal,
                              color: ac.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          style: TextStyle(
                            fontWeight: item.isRead
                                ? FontWeight.w500
                                : FontWeight.bold,
                            fontSize: 14.5,
                            color: item.isRead ? null : ac.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    item.description,
                    style: TextStyle(
                      fontSize: 12.5,
                      height: 1.3,
                      color: Colors.grey.shade700,
                      fontWeight: item.isRead
                          ? FontWeight.normal
                          : FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (due != null || _hasSender || studentName.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        if (studentName.isNotEmpty) ...[
                          Icon(
                            Icons.person,
                            size: 13,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              studentName,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.normal,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 10),
                        ],
                        if (_hasSender) ...[
                          Icon(
                            Icons.person_outline,
                            size: 13,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              _docenteLabel(item.sender),
                              style: TextStyle(
                                fontSize: 11.5,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                        const Spacer(),
                        if (due != null) ...[
                          Icon(
                            Icons.event,
                            size: 13,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Entrega: $due',
                            style: TextStyle(
                              fontSize: 11.5,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ],
              ),
            ),
            if (!item.isRead) ...[
              const SizedBox(width: 10),
              const UnreadIndicator(),
            ],
          ],
        ),
      ),
    );
  }

  (Color, IconData, String) _typeInfo(String type) {
    switch (type) {
      case 'ANNOUNCEMENT':
        return (announcementColor, Icons.campaign_outlined, 'Aviso');
      case 'TASK':
        return (taskColor, Icons.assignment_outlined, 'Tarea');
      case 'STUDENT_OBSERVATION':
        return (observationColor, Icons.feedback_outlined, 'Observación');
      default:
        return (Colors.grey, Icons.event_note_outlined, type);
    }
  }

  bool get _hasSender {
    final name = item.sender.name.trim();
    final lastName = item.sender.lastName.trim();
    return name.isNotEmpty || lastName.isNotEmpty;
  }

  String _docenteLabel(AgendaSenderModel sender) {
    final name = sender.name.trim();
    final lastName = sender.lastName.trim();
    final joined = [name, lastName].where((s) => s.isNotEmpty).join(' ');
    return joined.isEmpty ? '' : 'Prof. $joined';
  }
}

String _formatDateOnly(DateTime date) {
  const months = [
    'ene',
    'feb',
    'mar',
    'abr',
    'may',
    'jun',
    'jul',
    'ago',
    'sep',
    'oct',
    'nov',
    'dic',
  ];
  final month = months[date.month - 1];
  return '${date.day} $month ${date.year}';
}
