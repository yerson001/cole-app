import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coleapp/core/themes/app_colors.dart';
import 'package:coleapp/features/parent/data/models/agenda_model.dart';
import 'package:coleapp/features/parent/data/models/student_model.dart';
import 'package:coleapp/features/parent/domain/usecases/parent_use_cases.dart';
import 'package:coleapp/features/parent/presentation/agenda/AgendaDetailPage.dart';
import 'package:coleapp/features/parent/presentation/agenda/bloc/AgendaState.dart'
    show AgendaView;
import 'package:coleapp/features/parent/presentation/comunicados/bloc/ComunicadosBloc.dart';
import 'package:coleapp/features/parent/presentation/comunicados/bloc/ComunicadosEvent.dart';
import 'package:coleapp/features/parent/presentation/comunicados/bloc/ComunicadosState.dart';
import 'package:coleapp/features/parent/presentation/home/bloc/ParentHomeBloc.dart';
import 'package:coleapp/features/parent/presentation/home/bloc/ParentHomeState.dart';
import 'package:coleapp/features/parent/presentation/widgets/agenda_calendar.dart';
import 'package:coleapp/features/parent/presentation/widgets/child_selector.dart';
import 'package:coleapp/injection.dart';

class ComunicadosContent extends StatelessWidget {
  const ComunicadosContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ComunicadosBloc>(
      create: (_) => ComunicadosBloc(locator<ParentUseCases>()),
      child: const _ComunicadosBody(),
    );
  }
}

class _ComunicadosBody extends StatefulWidget {
  const _ComunicadosBody();

  @override
  State<_ComunicadosBody> createState() => _ComunicadosBodyState();
}

class _ComunicadosBodyState extends State<_ComunicadosBody> {
  bool _initialized = false;

  void _tryInitialize(ParentHomeState state) {
    final parentId = state.user?.profile?.id;
    final tenantId = state.tenant;
    if (parentId != null && tenantId.isNotEmpty && !_initialized) {
      _initialized = true;
      final now = DateTime.now();
      final range = _dateRangeForDate(now, AgendaView.daily);
      context.read<ComunicadosBloc>().add(LoadComunicados(
        parentId: parentId,
        tenantId: tenantId,
        startDate: range.startDate,
        endDate: range.endDate,
        students: state.students,
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
      child: BlocBuilder<ComunicadosBloc, ComunicadosState>(
        builder: (context, state) {
          final ac = context.appColors;
          final parentId = parentState.user?.profile?.id;
          final tenantId = parentState.tenant;

          if (parentId == null || tenantId.isEmpty) {
            return const Center(child: Text('No hay sesión de padre activa'));
          }

          if (state.isLoading && state.comunicados.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          final visible = state.selectedStudentId == null
              ? state.comunicados
              : state.comunicados
                  .where((c) => c.student?.id == state.selectedStudentId)
                  .toList();
          List<AgendaItemModel> itemsOn(DateTime day) =>
              visible.where((item) {
                final published = DateTime.tryParse(item.publishedAt ?? '');
                if (published == null) return false;
                return published.year == day.year &&
                    published.month == day.month &&
                    published.day == day.day;
              }).toList()
                ..sort((a, b) {
                  final aDate = DateTime.tryParse(a.publishedAt ?? '') ?? DateTime(0);
                  final bDate = DateTime.tryParse(b.publishedAt ?? '') ?? DateTime(0);
                  return bDate.compareTo(aDate);
                });
          final dayItems = itemsOn(state.selectedDate);

          return RefreshIndicator(
            onRefresh: () async {
              final range = _dateRangeForDate(state.selectedDate, state.view);
              context.read<ComunicadosBloc>().add(LoadComunicados(
                parentId: parentId,
                studentId: state.selectedStudentId,
                tenantId: tenantId,
                startDate: range.startDate,
                endDate: range.endDate,
                students: state.students,
              ));
            },
            child: Column(
              children: [
                _StudentSelector(
                  students: parentState.students,
                  selectedStudentId: state.selectedStudentId,
                ),
                CalendarViewFilter(
                  view: state.view,
                  onChanged: (view) =>
                    context.read<ComunicadosBloc>().add(ChangeView(view: view)),
                ),
                CalendarNavigationHeader(
                  view: state.view,
                  selectedDate: state.selectedDate,
                  onPrevious: () => _changeDate(context, -1),
                  onNext: () => _changeDate(context, 1),
                  onToday: () => _changeDate(context, 0, today: true),
                ),
                if (state.error != null && state.comunicados.isEmpty)
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
                    AgendaView.daily => Column(
                        children: [
                          Divider(height: 1, thickness: 1, color: ac.border),
                          Expanded(
                            child: _ComunicadosList(items: dayItems, tenantId: tenantId),
                          ),
                        ],
                      ),
                    AgendaView.weekly => Column(
                        children: [
                          CalendarWeekGrid(
                            selectedDate: state.selectedDate,
                            dayDots: (day) => itemsOn(day)
                                .map((i) => calendarTypeColor(i.type))
                                .toList(),
                            onDayTap: (day) =>
                              _changeDate(context, 0, date: day),
                          ),
                          Divider(height: 20, thickness: 1, color: ac.border),
                          Expanded(
                            child: _ComunicadosList(items: dayItems, tenantId: tenantId),
                          ),
                        ],
                      ),
                    AgendaView.monthly => Column(
                        children: [
                          CalendarMonthGrid(
                            selectedDate: state.selectedDate,
                            dayDots: (day) => itemsOn(day)
                                .map((i) => calendarTypeColor(i.type))
                                .toList(),
                            onDayTap: (day) =>
                              _changeDate(context, 0, date: day),
                          ),
                          Divider(height: 20, thickness: 1, color: ac.border),
                          Expanded(
                            child: _ComunicadosList(items: dayItems, tenantId: tenantId),
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

  void _changeDate(BuildContext context, int step,
      {bool today = false, DateTime? date}) {
    final bloc = context.read<ComunicadosBloc>();
    DateTime newDate;
    if (date != null) {
      newDate = date;
    } else if (today) {
      newDate = DateTime.now();
    } else {
      newDate = switch (bloc.state.view) {
        AgendaView.daily => bloc.state.selectedDate.add(Duration(days: step)),
        AgendaView.weekly => bloc.state.selectedDate.add(Duration(days: 7 * step)),
        AgendaView.monthly => DateTime(
            bloc.state.selectedDate.year,
            bloc.state.selectedDate.month + step,
            1,
          ),
      };
    }
    bloc.add(ChangeDate(date: newDate));
  }

  ({String startDate, String endDate}) _dateRangeForDate(
      DateTime date, AgendaView view) {
    switch (view) {
      case AgendaView.daily:
        final start = DateTime(date.year, date.month, date.day);
        final end = start.add(const Duration(days: 2));
        return (
          startDate: _formatDate(start),
          endDate: _formatDate(end),
        );
      case AgendaView.weekly:
        final start = date.subtract(Duration(days: date.weekday - 1));
        final startDay = DateTime(start.year, start.month, start.day);
        final end = startDay.add(const Duration(days: 8));
        return (
          startDate: _formatDate(startDay),
          endDate: _formatDate(end),
        );
      case AgendaView.monthly:
        final start = DateTime(date.year, date.month, 1);
        final end = DateTime(date.year, date.month + 1, 1);
        return (
          startDate: _formatDate(start),
          endDate: _formatDate(end),
        );
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}

class _StudentSelector extends StatelessWidget {
  final List<StudentModel> students;
  final int? selectedStudentId;

  const _StudentSelector({
    required this.students,
    this.selectedStudentId,
  });

  @override
  Widget build(BuildContext context) {
    if (students.isEmpty) return const SizedBox.shrink();

    StudentModel? selected;
    for (final s in students) {
      if (s.id == selectedStudentId) {
        selected = s;
        break;
      }
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: ChildSelector(
        students: students,
        selectedStudent: selected,
        showAll: true,
        clean: true,
        onChanged: (student) {
          context.read<ComunicadosBloc>().add(SelectStudent(studentId: student?.id));
        },
      ),
    );
  }
}

class _ComunicadosList extends StatelessWidget {
  final List<AgendaItemModel> items;
  final String tenantId;

  const _ComunicadosList({required this.items, required this.tenantId});

  @override
  Widget build(BuildContext context) {
    final ac = context.appColors;
    if (items.isEmpty) {
      return _EmptyState(
        icon: Icons.campaign_outlined,
        title: 'Sin avisos este día',
        message: 'Los avisos de esta fecha aparecerán aquí.',
      );
    }
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      separatorBuilder: (_, __) =>
          Divider(height: 1, thickness: 1, color: ac.border),
      itemBuilder: (context, index) => _ComunicadoTile(
        item: items[index],
        tenantId: tenantId,
      ),
    );
  }
}

class _ComunicadoTile extends StatelessWidget {
  final AgendaItemModel item;
  final String tenantId;

  const _ComunicadoTile({required this.item, required this.tenantId});

  static const Color _gold = Color(0xFFD4AF37);

  @override
  Widget build(BuildContext context) {
    final ac = context.appColors;

    return InkWell(
      onTap: () {
        if (!item.isRead) {
          context.read<ComunicadosBloc>().add(MarkComunicadoAsRead(itemId: item.id));
        }
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => AgendaDetailPage(item: item, tenantId: tenantId),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: ac.primary.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: ac.primary.withValues(alpha: 0.20)),
              ),
              alignment: Alignment.center,
              child: Icon(
                item.isRead ? Icons.campaign_outlined : Icons.campaign,
                size: 22,
                color: ac.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (!item.isRead)
                        Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.only(right: 6),
                          decoration: BoxDecoration(
                            color: ac.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      Expanded(
                        child: Text(
                          item.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: item.isRead
                                ? FontWeight.w600
                                : FontWeight.w700,
                            color: ac.textPrimary,
                          ),
                        ),
                      ),
                      if (item.course != null) ...[
                        Icon(Icons.menu_book, size: 14, color: _gold),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            item.course!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                              color: _gold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.35,
                      color: ac.textSecondary.withValues(alpha: 0.8),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (studentName.isNotEmpty) ...[
                        const Icon(Icons.person, size: 13, color: Colors.grey),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            studentName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                      ],
                      const Spacer(),
                      if (senderLabel.isNotEmpty)
                        Flexible(
                          child: Text(
                            senderLabel,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11.5,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String get studentName => (item.student?.name ?? '').trim();

  String get senderLabel {
    final name = item.sender.name.trim();
    final lastName = item.sender.lastName.trim();
    final joined = [name, lastName].where((s) => s.isNotEmpty).join(' ');
    return joined.isEmpty ? '' : 'Doc. $joined';
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;

  const _EmptyState({required this.icon, required this.title, required this.message});

  @override
  Widget build(BuildContext context) {
    final ac = context.appColors;
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.12),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Column(
              children: [
                Icon(icon, size: 28, color: ac.textDisabled),
                const SizedBox(height: 14),
                Text(
                  title,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: ac.textPrimary),
                ),
                const SizedBox(height: 6),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12.5, height: 1.5, color: ac.textSecondary),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}