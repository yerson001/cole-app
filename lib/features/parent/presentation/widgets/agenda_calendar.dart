import 'package:flutter/material.dart';
import 'package:coleapp/core/themes/app_colors.dart';
import 'package:coleapp/features/parent/presentation/agenda/bloc/AgendaState.dart'
    show AgendaView;

typedef CalendarDayDots = List<Color> Function(DateTime day);

Color calendarTypeColor(String type) {
  switch (type) {
    case 'ANNOUNCEMENT':
      return Colors.green;
    case 'TASK':
      return Colors.orange;
    case 'STUDENT_OBSERVATION':
      return Colors.red;
    default:
      return Colors.grey;
  }
}

class CalendarViewFilter extends StatelessWidget {
  final AgendaView view;
  final ValueChanged<AgendaView> onChanged;

  const CalendarViewFilter({super.key, required this.view, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final ac = context.appColors;
    const labels = {
      AgendaView.monthly: 'Mensual',
      AgendaView.weekly: 'Semanal',
      AgendaView.daily: 'Diario',
    };
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: ac.fill,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(3),
        child: Row(
          children: [
            for (final entry in labels.entries)
              Expanded(
                child: _ViewOption(
                  label: entry.value,
                  isSelected: view == entry.key,
                  onTap: () => onChanged(entry.key),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ViewOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ViewOption({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final ac = context.appColors;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? ac.card : Colors.transparent,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
              color: isSelected ? ac.textPrimary : ac.primary,
            ),
          ),
        ),
      ),
    );
  }
}

class CalendarNavigationHeader extends StatelessWidget {
  final AgendaView view;
  final DateTime selectedDate;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onToday;

  const CalendarNavigationHeader({
    super.key,
    required this.view,
    required this.selectedDate,
    required this.onPrevious,
    required this.onNext,
    required this.onToday,
  });

  @override
  Widget build(BuildContext context) {
    final title = switch (view) {
      AgendaView.daily => formatDayHeader(selectedDate),
      AgendaView.weekly => formatWeekHeader(selectedDate),
      AgendaView.monthly => formatMonthHeader(selectedDate),
    };
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: onPrevious,
          ),
          Expanded(
            child: GestureDetector(
              onTap: onToday,
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: onNext,
          ),
        ],
      ),
    );
  }
}

class CalendarWeekGrid extends StatelessWidget {
  final DateTime selectedDate;
  final CalendarDayDots dayDots;
  final ValueChanged<DateTime> onDayTap;

  const CalendarWeekGrid({
    super.key,
    required this.selectedDate,
    required this.dayDots,
    required this.onDayTap,
  });

  @override
  Widget build(BuildContext context) {
    final ac = context.appColors;
    final today = DateTime.now();
    final monday = selectedDate.subtract(
      Duration(days: selectedDate.weekday - 1),
    );
    final weekDays = List.generate(
      7,
      (i) => DateTime(
        monday.year,
        monday.month,
        monday.day + i,
      ),
    );
    const dayNames = ['LUN', 'MAR', 'MIE', 'JUE', 'VIE', 'SAB', 'DOM'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: List.generate(7, (i) {
          final day = weekDays[i];
          final dots = dayDots(day);
          final isSelected = isSameDay(day, selectedDate);
          final isToday = isSameDay(day, today);
          return Expanded(
            child: GestureDetector(
              onTap: () => onDayTap(day),
              child: Column(
                children: [
                  Text(
                    dayNames[i],
                    style: TextStyle(
                      fontSize: 10.5,
                      color: isSelected ? ac.primary : ac.textDisabled,
                      fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected ? ac.primary : Colors.transparent,
                    ),
                    child: Center(
                      child: Text(
                        '${day.day}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isSelected
                              ? Colors.white
                              : (isToday ? ac.primary : ac.textPrimary),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    height: 8,
                    child: Wrap(
                      spacing: 2,
                      children: [
                        for (final color in dots)
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class CalendarMonthGrid extends StatelessWidget {
  final DateTime selectedDate;
  final CalendarDayDots dayDots;
  final ValueChanged<DateTime> onDayTap;

  const CalendarMonthGrid({
    super.key,
    required this.selectedDate,
    required this.dayDots,
    required this.onDayTap,
  });

  @override
  Widget build(BuildContext context) {
    final ac = context.appColors;
    final today = DateTime.now();
    final first = DateTime(selectedDate.year, selectedDate.month, 1);
    final daysInMonth = DateTime(
      selectedDate.year,
      selectedDate.month + 1,
      0,
    ).day;
    final leading = first.weekday - 1;
    final total = ((leading + daysInMonth) / 7).ceil() * 7;
    final start = first.subtract(Duration(days: leading));
    final days = List.generate(
      total,
      (i) => DateTime(start.year, start.month, start.day + i),
    );
    final weeks = <List<DateTime>>[];
    for (var i = 0; i < days.length; i += 7) {
      weeks.add(days.sublist(i, i + 7));
    }
    const dayNames = ['LU', 'MA', 'MI', 'JU', 'VI', 'SA', 'DO'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            children: List.generate(7, (i) => Expanded(
              child: Text(
                dayNames[i],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: (i == 5 || i == 6) ? ac.primary : ac.textDisabled,
                ),
              ),
            )),
          ),
          const SizedBox(height: 4),
          ...weeks.map((week) => Row(
            children: List.generate(7, (i) {
              final day = week[i];
              final isCurrentMonth = day.month == selectedDate.month;
              final isSelected = isSameDay(day, selectedDate);
              final isToday = isSameDay(day, today);
              final dots = dayDots(day);
              return Expanded(
                child: InkWell(
                  onTap: () => onDayTap(day),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    margin: const EdgeInsets.all(1),
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? ac.primary.withValues(alpha: 0.15)
                          : null,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Opacity(
                      opacity: isCurrentMonth ? 1 : 0.35,
                      child: Column(
                        children: [
                          Text(
                            '${day.day}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isToday
                                  ? FontWeight.bold
                                  : FontWeight.w400,
                              color: isToday ? ac.primary : ac.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Wrap(
                            spacing: 2,
                            children: [
                              for (final color in dots)
                                Container(
                                  width: 5,
                                  height: 5,
                                  decoration: BoxDecoration(
                                    color: color,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          )),
        ],
      ),
    );
  }
}

bool isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

String formatDayHeader(DateTime date) {
  const days = ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'];
  const months = [
    'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
    'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre'
  ];
  final dayName = days[date.weekday - 1];
  final monthName = months[date.month - 1];
  return '$dayName, ${date.day} de $monthName';
}

String formatWeekHeader(DateTime date) {
  const months = ['ene', 'feb', 'mar', 'abr', 'may', 'jun', 'jul', 'ago', 'sep', 'oct', 'nov', 'dic'];
  final monday = date.subtract(Duration(days: date.weekday - 1));
  final sunday = monday.add(const Duration(days: 6));
  final startMonth = months[monday.month - 1];
  final endMonth = months[sunday.month - 1];
  final year = sunday.year;
  return '${monday.day} $startMonth - ${sunday.day} $endMonth $year';
}

String formatMonthHeader(DateTime date) {
  const months = [
    'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
    'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre'
  ];
  final monthName = months[date.month - 1];
  return '$monthName ${date.year}';
}