import 'package:flutter/material.dart';
import 'package:coleapp/features/parent/data/models/day_report_model.dart';

class AttendanceSummary extends StatelessWidget {
  final List<DayReportModel> reports;

  const AttendanceSummary({super.key, required this.reports});

  @override
  Widget build(BuildContext context) {
    var present = 0;
    var late = 0;
    var absent = 0;
    for (final r in reports) {
      for (final a in r.attendances) {
        switch (a.statusCheckIn) {
          case 'PRESENT':
            present++;
          case 'LATE':
            late++;
          case 'ABSENT':
            absent++;
        }
      }
    }
    return Row(
      children: [
        Expanded(child: _card('Presente', present, Colors.green, Colors.green[50]!)),
        const SizedBox(width: 8),
        Expanded(child: _card('Tarde', late, Colors.orange, Colors.orange[50]!)),
        const SizedBox(width: 8),
        Expanded(child: _card('Falta', absent, Colors.red, Colors.red[50]!)),
      ],
    );
  }

  Widget _card(String label, int count, Color textColor, Color bgColor) {
    return Card(
      elevation: 1,
      color: bgColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: 12, color: textColor.withValues(alpha: 0.8))),
            const SizedBox(height: 4),
            Text('$count', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textColor)),
          ],
        ),
      ),
    );
  }
}
