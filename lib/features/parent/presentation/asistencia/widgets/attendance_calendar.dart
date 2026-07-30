import 'package:flutter/material.dart';
import 'package:coleapp/features/parent/data/models/day_report_model.dart';

class AttendanceCalendar extends StatelessWidget {
  final DateTime month;
  final List<DayReportModel> reports;

  const AttendanceCalendar({super.key, required this.month, required this.reports});

  @override
  Widget build(BuildContext context) {
    final firstDay = DateTime(month.year, month.month, 1);
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final startWeekday = firstDay.weekday % 7;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            Text('D', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            Text('L', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            Text('M', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            Text('M', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            Text('J', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            Text('V', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            Text('S', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
          ],
        ),
        const SizedBox(height: 8),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 7,
          childAspectRatio: 1,
          children: [
            for (var i = 0; i < startWeekday; i++) const SizedBox.shrink(),
            for (var day = 1; day <= daysInMonth; day++)
              _dayCell(day),
          ],
        ),
      ],
    );
  }

  Widget _dayCell(int day) {
    final date = DateTime(month.year, month.month, day);
    final dateStr = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    final status = _statusForDate(dateStr);
    final bgColor = _statusColor(status);
    final isWeekend = date.weekday == DateTime.saturday || date.weekday == DateTime.sunday;
    return Center(
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: status != null ? bgColor : (isWeekend ? Colors.grey[300] : Colors.grey[200]),
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: Text(
          '$day',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: status != null ? Colors.white : Colors.grey[600],
          ),
        ),
      ),
    );
  }

  String? _statusForDate(String dateStr) {
    for (final r in reports) {
      for (final a in r.attendances) {
        if (a.date == dateStr) return a.statusCheckIn;
      }
    }
    return null;
  }

  Color _statusColor(String? status) {
    switch (status) {
      case 'PRESENT': return Colors.green;
      case 'LATE': return Colors.orange;
      case 'ABSENT': return Colors.red;
      default: return Colors.grey;
    }
  }
}
