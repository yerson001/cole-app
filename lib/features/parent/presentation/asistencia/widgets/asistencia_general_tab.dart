import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coleapp/core/themes/app_colors.dart';
import 'package:coleapp/features/parent/data/models/day_report_model.dart';
import 'package:coleapp/features/parent/presentation/asistencia/bloc/asistencia_bloc.dart';
import 'package:coleapp/features/parent/presentation/asistencia/bloc/asistencia_event.dart';
import 'package:coleapp/features/parent/presentation/asistencia/bloc/asistencia_state.dart';
import 'package:coleapp/features/parent/presentation/asistencia/widgets/attendance_calendar.dart';
import 'package:coleapp/features/parent/presentation/asistencia/widgets/attendance_summary.dart';
import 'package:coleapp/features/parent/presentation/asistencia/widgets/child_selector.dart';
import 'package:coleapp/features/parent/presentation/asistencia/widgets/daily_attendance_card.dart';

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
                  onChanged: (s) => context.read<AsistenciaBloc>().add(SelectStudent(student: s)),
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
                          backgroundColor: ac.card,
                          foregroundColor: ac.primary,
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
                          backgroundColor: ac.card,
                          foregroundColor: ac.primary,
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
                    DailyAttendanceCard(
                      report: selectedReport,
                      index: state.students.indexOf(state.selectedStudent!),
                    )
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
