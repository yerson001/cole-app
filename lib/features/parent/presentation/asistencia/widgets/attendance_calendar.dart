import 'package:flutter/material.dart';
import 'package:coleapp/core/themes/app_colors.dart';
import 'package:coleapp/features/parent/data/models/day_report_model.dart';

class AttendanceCalendar extends StatelessWidget {
  final DateTime month;
  final List<DayReportModel> reports;
  final DateTime? selectedDay;
  final ValueChanged<DateTime>? onDaySelected;

  const AttendanceCalendar({
    super.key,
    required this.month,
    required this.reports,
    this.selectedDay,
    this.onDaySelected,
  });

  static const _verde = Color(0xFF54DEB1);
  static const _naranja = Color(0xFFFCB700);
  static const _gris = Color(0xFF9E9E9E);

  @override
  Widget build(BuildContext context) {
    final ac = context.appColors;
    final firstDay = DateTime(month.year, month.month, 1);
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final startWeekday = firstDay.weekday % 7;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            for (final label in const ['D', 'L', 'M', 'M', 'J', 'V', 'S'])
              Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: ac.textSecondary)),
          ],
        ),
        const SizedBox(height: 6),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 7,
          childAspectRatio: 1.30,
          children: [
            for (var i = 0; i < startWeekday; i++) const SizedBox.shrink(),
            for (var day = 1; day <= daysInMonth; day++)
              _dayCell(day, ac, context),
          ],
        ),
      ],
    );
  }

  Widget _dayCell(int day, AppColors ac, BuildContext context) {
    final date = DateTime(month.year, month.month, day);
    final dateStr = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    final status = _statusForDate(dateStr);
    final accent = _statusColor(status, ac);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isWeekend = date.weekday == DateTime.saturday || date.weekday == DateTime.sunday;
    final isSelected = selectedDay != null &&
        selectedDay!.year == date.year &&
        selectedDay!.month == date.month &&
        selectedDay!.day == date.day;
    return Center(
      child: GestureDetector(
        onTap: () => onDaySelected?.call(date),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: isSelected
                ? ac.primary
                : (status != null
                    ? accent.withValues(alpha: 0.35)
                    : (isWeekend ? ac.border.withValues(alpha: 0.6) : ac.fill)),
            borderRadius: BorderRadius.circular(8),
            border: !isSelected && status != null
                ? Border.all(color: accent.withValues(alpha: 0.55))
                : null,
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: ac.primary.withValues(alpha: 0.35),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          alignment: Alignment.center,
          child: Text(
            '$day',
            style: TextStyle(
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w700,
              color: isSelected
                  ? Colors.white
                  : (isDark ? Colors.white : Colors.black87),
            ),
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
}
