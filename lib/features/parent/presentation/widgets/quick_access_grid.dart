import 'package:flutter/material.dart';
import 'package:coleapp/core/themes/app_colors.dart';

class QuickAccessGrid extends StatelessWidget {
  const QuickAccessGrid({super.key});

  static const _row1 = [
    ('Fotocheck', Icons.badge_outlined),
    ('Horario', Icons.schedule_outlined),
    ('Calificaciones', Icons.grade_outlined),
    ('Pensiones', Icons.account_balance_outlined),
  ];

  static const _row2 = [
    ('Cuotas', Icons.payments_outlined),
    ('Reuniones', Icons.handshake_outlined),
    ('Agenda', Icons.calendar_month_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final w = (MediaQuery.of(context).size.width - 80) / 4;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _row1.map((item) => _Item(icon: item.$2, label: item.$1, w: w, c: c)).toList(),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ..._row2.map((item) => _Item(icon: item.$2, label: item.$1, w: w, c: c)),
              _Item(icon: Icons.add, label: 'Más', w: w, c: c, isAdd: true),
            ],
          ),
        ],
      ),
    );
  }
}

class _Item extends StatelessWidget {
  final IconData icon;
  final String label;
  final double w;
  final AppColors c;
  final bool isAdd;

  const _Item({
    required this.icon,
    required this.label,
    required this.w,
    required this.c,
    this.isAdd = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: c.fill,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 26, color: isAdd ? c.textDisabled : c.primary),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: isAdd ? c.textDisabled : c.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
