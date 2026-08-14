import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coleapp/core/themes/app_colors.dart';
import 'package:coleapp/features/parent/data/models/day_report_model.dart';
import 'package:coleapp/features/parent/presentation/asistencia/bloc/asistencia_bloc.dart';
import 'package:coleapp/features/parent/presentation/asistencia/bloc/asistencia_event.dart';
import 'package:coleapp/features/parent/presentation/asistencia/bloc/asistencia_state.dart';
import 'package:coleapp/features/parent/presentation/asistencia/widgets/attendance_calendar.dart';
import 'package:coleapp/features/parent/presentation/asistencia/widgets/attendance_summary.dart';
import 'package:coleapp/features/parent/presentation/widgets/child_selector.dart';

class AsistenciaGeneralTab extends StatelessWidget {
  const AsistenciaGeneralTab({super.key});

  String _monthLabel(DateTime month) {
    final names = ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'];
    return '${names[month.month - 1]} ${month.year}';
  }

  DayReportModel? _reportForDay(List<DayReportModel> reports, DateTime day) {
    final dateStr = '${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}';
    for (final r in reports) {
      if (r.attendances.any((a) => a.date == dateStr)) return r;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final ac = context.appColors;
    return BlocBuilder<AsistenciaBloc, AsistenciaState>(
      builder: (context, state) {
        final selectedReport = state.selectedCalendarDay != null
            ? _reportForDay(state.rangeReports, state.selectedCalendarDay!)
            : null;
        return RefreshIndicator(
          onRefresh: () async {
            context.read<AsistenciaBloc>().add(ReloadAll());
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 48),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ChildSelector(
                  students: state.students,
                  selectedStudent: state.selectedStudent,
                  onChanged: (s) {
                    if (s != null) {
                      context.read<AsistenciaBloc>().add(SelectStudent(student: s));
                    }
                  },
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  decoration: BoxDecoration(
                    color: ac.fill,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: ac.border),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        style: IconButton.styleFrom(
                          backgroundColor: ac.primary,
                          foregroundColor: Colors.white,
                        ),
                        icon: const Icon(Icons.chevron_left, size: 22),
                        onPressed: () {
                          context.read<AsistenciaBloc>().add(
                            ChangeMonth(month: DateTime(state.currentMonth.year, state.currentMonth.month - 1)),
                          );
                        },
                      ),
                      Expanded(
                        child: Text(
                          _monthLabel(state.currentMonth),
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: ac.textPrimary),
                        ),
                      ),
                      IconButton(
                        style: IconButton.styleFrom(
                          backgroundColor: ac.primary,
                          foregroundColor: Colors.white,
                        ),
                        icon: const Icon(Icons.chevron_right, size: 22),
                        onPressed: () {
                          context.read<AsistenciaBloc>().add(
                            ChangeMonth(month: DateTime(state.currentMonth.year, state.currentMonth.month + 1)),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 6),
                  decoration: BoxDecoration(
                    color: ac.card,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: ac.border),
                  ),
                  child: AttendanceCalendar(
                    month: state.currentMonth,
                    reports: state.rangeReports,
                    selectedDay: state.selectedCalendarDay,
                    onDaySelected: (day) => context.read<AsistenciaBloc>().add(SelectCalendarDay(day: day)),
                  ),
                ),
                const SizedBox(height: 14),
                AttendanceSummary(reports: state.rangeReports),
                const SizedBox(height: 16),
                if (state.selectedCalendarDay != null) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: ac.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: ac.primary.withValues(alpha: 0.25)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.event_note, size: 18, color: ac.primary),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Detalle del ${_formatDate(state.selectedCalendarDay!)}',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: ac.primary),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (selectedReport != null)
                    _DayDetailCard(report: selectedReport)
                  else
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: ac.card,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: ac.border),
                      ),
                      child: Center(
                        child: Text(
                          'Sin registro de asistencia para este día',
                          style: TextStyle(fontSize: 14, color: ac.textSecondary),
                        ),
                      ),
                    ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    final days = ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'];
    final months = ['enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio', 'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre'];
    return '${days[date.weekday - 1]} ${date.day} de ${months[date.month - 1]}';
  }
}

class _DayDetailCard extends StatelessWidget {
  final DayReportModel report;

  const _DayDetailCard({required this.report});

  static const _verde = Color(0xFF54DEB1);
  static const _naranja = Color(0xFFFCB700);

  String _initials() {
    final s = report.student;
    final parts = [s.name, s.lastName].where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    return parts.map((p) => p[0].toUpperCase()).take(2).join();
  }

  (String, Color) _statusOf() {
    final a = report.attendances.isNotEmpty ? report.attendances.first : null;
    switch (a?.statusCheckIn) {
      case 'PRESENT':
      case 'EARLY':
      case 'ON_TIME':
        return ('Presente', _verde);
      case 'LATE':
        return ('Tarde', _naranja);
      case 'ABSENT':
        return ('Falta', const Color(0xFFFE4349));
      default:
        return ('Sin registro', const Color(0xFF9E9E9E));
    }
  }

  @override
  Widget build(BuildContext context) {
    final ac = context.appColors;
    final (label, color) = _statusOf();
    final s = report.student;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ac.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ac.border),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              _initials(),
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${s.name} ${s.lastName}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: ac.textPrimary),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: color),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, size: 16, color: color),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: color),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
