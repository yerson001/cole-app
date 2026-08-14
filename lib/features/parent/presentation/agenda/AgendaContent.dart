import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coleapp/core/themes/app_colors.dart';
import 'package:coleapp/features/parent/data/models/agenda_model.dart';
import 'package:coleapp/features/parent/data/models/student_model.dart';
import 'package:coleapp/features/parent/domain/usecases/parent_use_cases.dart';
import 'package:coleapp/features/parent/presentation/agenda/bloc/AgendaBloc.dart';
import 'package:coleapp/features/parent/presentation/agenda/bloc/AgendaEvent.dart';
import 'package:coleapp/features/parent/presentation/agenda/bloc/AgendaState.dart';
import 'package:coleapp/features/parent/presentation/home/bloc/ParentHomeBloc.dart';
import 'package:coleapp/features/parent/presentation/home/bloc/ParentHomeState.dart';
import 'package:coleapp/features/parent/presentation/widgets/child_selector.dart';
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
  bool _initialized = false;

  void _tryInitialize(ParentHomeState state) {
    final parentId = state.user?.profile?.id;
    final tenantId = state.tenant;
    if (parentId != null && tenantId.isNotEmpty && !_initialized) {
      _initialized = true;
      final now = DateTime.now();
      final range = _initialRange(now);
      context.read<AgendaBloc>().add(LoadAgenda(
        parentId: parentId,
        tenantId: tenantId,
        startDate: range.startDate,
        endDate: range.endDate,
      ));
      context.read<AgendaBloc>().add(SelectStudent(
        student: state.students.isNotEmpty ? state.students.first : null,
      ));
    }
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
          final parentId = parentState.user?.profile?.id;
          final tenantId = parentState.tenant;

          if (parentId == null || tenantId.isEmpty) {
            return const Center(child: Text('No hay sesión de padre activa'));
          }

          if (state.isLoading && state.items.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return RefreshIndicator(
            onRefresh: () async {
              final range = _initialRange(state.selectedDate);
              context.read<AgendaBloc>().add(LoadAgenda(
                parentId: parentId,
                studentId: state.selectedStudent?.id,
                tenantId: tenantId,
                startDate: range.startDate,
                endDate: range.endDate,
              ));
            },
            child: Column(
              children: [
                _StudentSelector(
                  students: parentState.students,
                  selectedStudent: state.selectedStudent,
                  tenantId: tenantId,
                  parentId: parentId,
                ),
                _ViewFilter(
                  view: state.view,
                  onChanged: (view) =>
                    context.read<AgendaBloc>().add(ChangeView(view: view)),
                ),
                _NavigationHeader(
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
                      style: TextStyle(color: Theme.of(context).colorScheme.error),
                    ),
                  ),
                Expanded(
                  child: switch (state.view) {
                    AgendaView.daily => _AgendaList(state: state),
                    AgendaView.weekly => Column(
                        children: [
                          _WeekGrid(
                            state: state,
                            onDayTap: (day) => _changeDate(context, 0, date: day),
                          ),
                          Expanded(child: _AgendaList(state: state)),
                        ],
                      ),
                    AgendaView.monthly => Column(
                        children: [
                          _MonthGrid(
                            state: state,
                            onDayTap: (day) => _changeDate(context, 0, date: day),
                          ),
                          Expanded(child: _AgendaList(state: state)),
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

  void _changeDate(BuildContext context, int step, {bool today = false, DateTime? date}) {
    final bloc = context.read<AgendaBloc>();
    DateTime newDate;
    if (date != null) {
      newDate = date;
    } else if (today) {
      newDate = DateTime.now();
    } else {
      newDate = switch (bloc.state.view) {
        AgendaView.daily => bloc.state.selectedDate.add(Duration(days: step)),
        AgendaView.weekly => bloc.state.selectedDate.add(Duration(days: 7 * step)),
        AgendaView.monthly =>
          DateTime(
            bloc.state.selectedDate.year,
            bloc.state.selectedDate.month + step,
            1,
          ),
      };
    }
    bloc.add(ChangeDate(date: newDate));
  }

  ({String startDate, String endDate}) _initialRange(DateTime date) {
    final startDay = DateTime(date.year, date.month, date.day);
    final end = startDay.add(const Duration(days: 30));
    return (
      startDate: _formatDate(startDay),
      endDate: _formatDate(end),
    );
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
        onChanged: (student) {
          context.read<AgendaBloc>().add(SelectStudent(student: student));
        },
      ),
    );
  }
}

class _ViewFilter extends StatelessWidget {
  final AgendaView view;
  final ValueChanged<AgendaView> onChanged;

  const _ViewFilter({required this.view, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SegmentedButton<AgendaView>(
        segments: const [
          ButtonSegment(
            value: AgendaView.monthly,
            label: Text('Mensual'),
          ),
          ButtonSegment(
            value: AgendaView.weekly,
            label: Text('Semanal'),
          ),
          ButtonSegment(
            value: AgendaView.daily,
            label: Text('Diario'),
          ),
        ],
        selected: {view},
        onSelectionChanged: (selection) => onChanged(selection.first),
        showSelectedIcon: false,
        style: const ButtonStyle(
          visualDensity: VisualDensity.compact,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ),
    );
  }
}

class _NavigationHeader extends StatelessWidget {
  final AgendaView view;
  final DateTime selectedDate;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onToday;

  const _NavigationHeader({
    required this.view,
    required this.selectedDate,
    required this.onPrevious,
    required this.onNext,
    required this.onToday,
  });

  @override
  Widget build(BuildContext context) {
    final title = switch (view) {
      AgendaView.daily => _formatDayHeader(selectedDate),
      AgendaView.weekly => _formatWeekHeader(selectedDate),
      AgendaView.monthly => _formatMonthHeader(selectedDate),
    };
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: onPrevious,
          ),
          Expanded(
            child: GestureDetector(
              onTap: onToday,
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: onNext,
          ),
        ],
      ),
    );
  }
}

class _WeekGrid extends StatelessWidget {
  final AgendaState state;
  final ValueChanged<DateTime> onDayTap;

  const _WeekGrid({required this.state, required this.onDayTap});

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    const dayNames = ['LUN', 'MAR', 'MIE', 'JUE', 'VIE', 'SAB', 'DOM'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: List.generate(7, (i) {
          final day = state.weekDays[i];
          final items = state.itemsOn(day);
          final isSelected = state.isSameDay(day, state.selectedDate);
          final isToday = state.isSameDay(day, today);
          return Expanded(
            child: InkWell(
              onTap: () => onDayTap(day),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                padding: const EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected ? Theme.of(context).colorScheme.primary : null,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Text(
                      dayNames[i],
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? Theme.of(context).colorScheme.onPrimary
                            : Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${day.day}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: isToday ? FontWeight.bold : FontWeight.w500,
                        color: isSelected
                            ? Theme.of(context).colorScheme.onPrimary
                            : isToday
                            ? Theme.of(context).colorScheme.primary
                            : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 2,
                      children: [
                        for (final item in items)
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: _dotColor(item.type),
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Color _dotColor(String type) {
    switch (type) {
      case 'ANNOUNCEMENT':
        return Colors.green;
      case 'TASK':
        return Colors.orange;
      case 'STUDENT_OBSERVATION':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

class _MonthGrid extends StatelessWidget {
  final AgendaState state;
  final ValueChanged<DateTime> onDayTap;

  const _MonthGrid({required this.state, required this.onDayTap});

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    const dayNames = ['LU', 'MA', 'MI', 'JU', 'VI', 'SA', 'DO'];
    final days = state.monthDays;
    final weeks = <List<DateTime>>[];
    for (var i = 0; i < days.length; i += 7) {
      weeks.add(days.sublist(i, i + 7));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            children: List.generate(7, (i) => Expanded(
              child: Text(
                dayNames[i],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: (i == 5 || i == 6)
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey,
                ),
              ),
            )),
          ),
          const SizedBox(height: 4),
          ...weeks.map((week) => Row(
            children: List.generate(7, (i) {
              final day = week[i];
              final isCurrentMonth = day.month == state.selectedDate.month;
              final isSelected = state.isSameDay(day, state.selectedDate);
              final isToday = state.isSameDay(day, today);
              final items = state.itemsOn(day);
              return Expanded(
                child: InkWell(
                  onTap: () => onDayTap(day),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    margin: const EdgeInsets.all(1),
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.15)
                          : null,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Opacity(
                      opacity: isCurrentMonth ? 1 : 0.35,
                      child: Column(
                        children: [
                          Text(
                            '${day.day}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isToday
                                  ? FontWeight.bold
                                  : FontWeight.w400,
                              color: isToday
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Wrap(
                            spacing: 2,
                            children: [
                              for (final item in items)
                                Container(
                                  width: 5,
                                  height: 5,
                                  decoration: BoxDecoration(
                                    color: _dotColor(item.type),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          )),
        ],
      ),
    );
  }

  Color _dotColor(String type) {
    switch (type) {
      case 'ANNOUNCEMENT':
        return Colors.green;
      case 'TASK':
        return Colors.orange;
      case 'STUDENT_OBSERVATION':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

class _AgendaList extends StatelessWidget {
  final AgendaState state;

  const _AgendaList({required this.state});

  @override
  Widget build(BuildContext context) {
    final items = state.itemsForSelectedDate;
    if (items.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.15),
          const Center(
            child: Text(
              'No hay eventos para este día',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      );
    }
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _AgendaItemCard(item: item);
      },
    );
  }
}

class _AgendaItemCard extends StatelessWidget {
  final AgendaItemModel item;

  const _AgendaItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final ac = context.appColors;
    final (typeColor, icon, typeLabel) = _typeInfo(item.type);
    final published = item.publishedAt != null
        ? _formatDateTime(DateTime.parse(item.publishedAt!))
        : null;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: typeColor.withValues(alpha: 0.4), width: 1),
      ),
      child: InkWell(
        onTap: () {
          if (!item.isRead) {
            context.read<AgendaBloc>().add(MarkItemAsRead(itemId: item.id));
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: typeColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: typeColor, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            style: TextStyle(
                              fontWeight: item.isRead ? FontWeight.w500 : FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        if (!item.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: ac.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: typeColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        typeLabel,
                        style: TextStyle(
                          color: typeColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.description,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                        fontWeight: item.isRead ? FontWeight.normal : FontWeight.w500,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.person_outline, size: 14, color: Colors.grey.shade600),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            item.sender.fullName,
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (published != null) ...[
                          const SizedBox(width: 8),
                          Icon(Icons.access_time, size: 14, color: Colors.grey.shade600),
                          const SizedBox(width: 4),
                          Text(
                            published,
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  (Color, IconData, String) _typeInfo(String type) {
    switch (type) {
      case 'ANNOUNCEMENT':
        return (Colors.green, Icons.campaign_outlined, 'Comunicado');
      case 'TASK':
        return (Colors.orange, Icons.assignment_outlined, 'Tarea');
      case 'STUDENT_OBSERVATION':
        return (Colors.red, Icons.feedback_outlined, 'Observación');
      default:
        return (Colors.grey, Icons.event_note_outlined, type);
    }
  }
}

String _formatDayHeader(DateTime date) {
  const days = ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'];
  const months = [
    'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
    'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre'
  ];
  final dayName = days[date.weekday - 1];
  final monthName = months[date.month - 1];
  return '$dayName, ${date.day} de $monthName';
}

String _formatWeekHeader(DateTime date) {
  const months = ['ene', 'feb', 'mar', 'abr', 'may', 'jun', 'jul', 'ago', 'sep', 'oct', 'nov', 'dic'];
  final monday = date.subtract(Duration(days: date.weekday - 1));
  final sunday = monday.add(const Duration(days: 6));
  final startMonth = months[monday.month - 1];
  final endMonth = months[sunday.month - 1];
  final year = sunday.year;
  if (monday.month == sunday.month) {
    return '${monday.day} $startMonth - ${sunday.day} $endMonth $year';
  }
  return '${monday.day} $startMonth - ${sunday.day} $endMonth $year';
}

String _formatMonthHeader(DateTime date) {
  const months = [
    'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
    'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre'
  ];
  final monthName = months[date.month - 1];
  return '$monthName ${date.year}';
}

String _formatDateTime(DateTime date) {
  const months = [
    'ene', 'feb', 'mar', 'abr', 'may', 'jun',
    'jul', 'ago', 'sep', 'oct', 'nov', 'dic'
  ];
  final month = months[date.month - 1];
  final hour = date.hour.toString().padLeft(2, '0');
  final minute = date.minute.toString().padLeft(2, '0');
  return '${date.day} $month · $hour:$minute';
}
