import 'package:flutter/material.dart';
import 'package:coleapp/features/parent/data/models/day_report_model.dart';

const _dayNames = ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'];
const _monthNames = ['ENE', 'FEB', 'MAR', 'ABR', 'MAY', 'JUN', 'JUL', 'AGO', 'SEP', 'OCT', 'NOV', 'DIC'];

class HistorialReciente extends StatelessWidget {
  final List<DayReportModel> reports;
  final List<DateTime> days;

  const HistorialReciente({super.key, required this.reports, required this.days});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 12),
          child: Text('Historial Reciente', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        ...days.map((day) {
          final report = _findReport(day);
          final a = report?.attendances.firstOrNull;
          final status = a?.statusCheckIn ?? 'UNMARKED';
          final statusColor = _statusColor(status);
          return Card(
            elevation: 1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            margin: const EdgeInsets.only(bottom: 10),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  SizedBox(
                    width: 42,
                    child: Column(
                      children: [
                        Text(_monthNames[day.month - 1], style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                        Text('${day.day}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_dayNames[day.weekday - 1], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                        Text(
                          'Ingreso: ${a?.checkInTime != null ? a!.checkInTime!.substring(0, 5) : '--:--'}',
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
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

  Color _statusColor(String? status) {
    switch (status) {
      case 'PRESENT': return Colors.green;
      case 'LATE': return Colors.orange;
      case 'ABSENT': return Colors.red;
      default: return Colors.grey;
    }
  }

  String _statusLabel(String? status) {
    switch (status) {
      case 'PRESENT': return 'Presente';
      case 'LATE': return 'Tarde';
      case 'ABSENT': return 'Falta';
      default: return 'Sin marcar';
    }
  }
}
