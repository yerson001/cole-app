import 'package:flutter/material.dart';
import 'package:coleapp/core/themes/app_colors.dart';
import 'package:coleapp/features/parent/data/models/day_report_model.dart';

class AttendanceSummary extends StatelessWidget {
  final List<DayReportModel> reports;

  const AttendanceSummary({super.key, required this.reports});

  static const _verde = Color(0xFF54DEB1);
  static const _naranja = Color(0xFFFCB700);

  @override
  Widget build(BuildContext context) {
    final ac = context.appColors;
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
        Expanded(child: _card('Presente', present, _verde)),
        const SizedBox(width: 8),
        Expanded(child: _card('Tarde', late, _naranja)),
        const SizedBox(width: 8),
        Expanded(child: _card('Falta', absent, ac.error)),
      ],
    );
  }

  Widget _card(String label, int count, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 12, color: color.withValues(alpha: 0.85))),
          const SizedBox(height: 4),
          Text('$count', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: color)),
        ],
      ),
    );
  }
}
