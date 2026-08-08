import 'package:flutter/material.dart';
import 'package:coleapp/core/themes/app_colors.dart';
import 'package:coleapp/features/parent/data/models/day_report_model.dart';

const _dayNames = ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'];
const _monthNames = ['ENE', 'FEB', 'MAR', 'ABR', 'MAY', 'JUN', 'JUL', 'AGO', 'SEP', 'OCT', 'NOV', 'DIC'];

class HistorialReciente extends StatelessWidget {
  final List<DayReportModel> reports;
  final List<DateTime> days;

  const HistorialReciente({super.key, required this.reports, required this.days});

  static const _verde = Color(0xFF54DEB1);
  static const _naranja = Color(0xFFFCB700);
  static const _gris = Color(0xFF9E9E9E);

  @override
  Widget build(BuildContext context) {
    final ac = context.appColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            'Historial Reciente',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: ac.textPrimary),
          ),
        ),
        ...days.map((day) {
          final report = _findReport(day);
          final a = report?.attendances.firstOrNull;
          final hasMark = a?.checkInTime != null;
          final status = hasMark ? (a?.statusCheckIn ?? 'PRESENT') : 'UNMARKED';
          final statusColor = _statusColor(status, ac);
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: ac.card,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: ac.border),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 42,
                  child: Column(
                    children: [
                      Text(_monthNames[day.month - 1], style: TextStyle(fontSize: 11, color: ac.textSecondary)),
                      Text('${day.day}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: ac.textPrimary)),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_dayNames[day.weekday - 1],
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: ac.textPrimary)),
                      Row(
                        children: [
                          Text(
                            'Ingreso: ',
                            style: TextStyle(fontSize: 12, color: ac.textSecondary),
                          ),
                          if (hasMark)
                            Text(
                              _formatTime(a!.checkInTime!),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: statusColor,
                              ),
                            )
                          else
                            Text(
                              '--:--',
                              style: TextStyle(fontSize: 12, color: ac.textSecondary),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _statusLabel(status),
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: statusColor),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  DayReportModel? _findReport(DateTime day) {
    final dateStr = '${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}';
    try {
      return reports.firstWhere((r) => r.attendances.any((a) => a.date == dateStr));
    } catch (_) {
      return null;
    }
  }

  Color _statusColor(String? status, AppColors ac) {
    switch (status) {
      case 'PRESENT':
      case 'EARLY':
      case 'ON_TIME':
        return _verde;
      case 'LATE':
        return _naranja;
      case 'ABSENT':
        return ac.error;
      default:
        return _gris;
    }
  }

  String _statusLabel(String? status) {
    switch (status) {
      case 'PRESENT':
      case 'EARLY':
      case 'ON_TIME':
        return 'Presente';
      case 'LATE':
        return 'Tarde';
      case 'ABSENT':
        return 'Falta';
      default:
        return 'Sin marcar';
    }
  }

  String _formatTime(String raw) {
    final parts = raw.split(':');
    if (parts.length < 2) return raw;
    var hour = int.tryParse(parts[0]) ?? 0;
    final minute = parts[1];
    final suffix = hour >= 12 ? 'PM' : 'AM';
    if (hour == 0) hour = 12;
    if (hour > 12) hour -= 12;
    return '${hour.toString().padLeft(2, '0')}:$minute $suffix';
  }
}
