import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ChildSelector(
                  students: state.students,
                  selectedStudent: state.selectedStudent,
                  onChanged: (s) => context.read<AsistenciaBloc>().add(SelectStudent(student: s)),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerLeft,
                  child: ElevatedButton.icon(
                    onPressed: state.isLoadingRange ? null : () {
                      context.read<AsistenciaBloc>().add(ReloadAll());
                    },
                    icon: state.isLoadingRange
                        ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.refresh),
                    label: const Text('Recargar'),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left),
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
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right),
                      onPressed: () {
                        context.read<AsistenciaBloc>().add(
                          ChangeMonth(month: DateTime(state.currentMonth.year, state.currentMonth.month + 1)),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: AttendanceCalendar(
                      month: state.currentMonth,
                      reports: state.rangeReports,
                      selectedDay: state.selectedCalendarDay,
                      onDaySelected: (day) => context.read<AsistenciaBloc>().add(SelectCalendarDay(day: day)),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                AttendanceSummary(reports: state.rangeReports),
                const SizedBox(height: 20),
                if (state.selectedCalendarDay != null) ...[
                  Text(
                    'Detalle del ${_formatDate(state.selectedCalendarDay!)}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  if (selectedReport != null)
                    DailyAttendanceCard(
                      report: selectedReport,
                      index: state.students.indexOf(state.selectedStudent!),
                    )
                  else
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Center(
                          child: Text(
                            'Sin registro de asistencia para este día',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
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
