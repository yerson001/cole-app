import 'package:flutter/material.dart';
import 'package:coleapp/core/themes/app_colors.dart';
import 'package:coleapp/features/parent/presentation/widgets/attendance_card.dart';

class AttendanceSection extends StatelessWidget {
  final int childrenCount;

  const AttendanceSection({super.key, required this.childrenCount});

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.check_circle_outline, color: c.success, size: 22),
            const SizedBox(width: 8),
            Text(
              'Asistencia hoy ($childrenCount)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: c.textPrimary),
            ),
            const Spacer(),
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.arrow_forward_ios, size: 12),
              label: const Text('Ver más'),
              style: TextButton.styleFrom(
                foregroundColor: c.primary,
                textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                padding: const EdgeInsets.symmetric(horizontal: 4),
                visualDensity: VisualDensity.compact,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 160,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: childrenCount,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (_, i) {
              final examples = [
                AttendanceCard(
                  name: 'CARLOS GUSTAVO',
                  lastName: 'CHIRA VALERIANO',
                  level: 'Secundaria',
                  grade: 'Primero',
                  section: 'B',
                  checkInTime: '07:45',
                  checkOutTime: '14:30',
                  checkInStatus: 'PRESENT',
                  checkOutStatus: 'PRESENT',
                  updatedInClass: true,
                ),
                AttendanceCard(
                  name: 'FRANKYE RICARDO',
                  lastName: 'CHIRA VALERIANO',
                  level: 'Secundaria',
                  grade: 'Cuarto',
                  section: 'C',
                  checkInTime: '08:10',
                  checkOutTime: null,
                  checkInStatus: 'LATE',
                  checkOutStatus: 'UNMARKED',
                  updatedInClass: false,
                ),
                AttendanceCard(
                  name: 'SOFIA LUCIANA',
                  lastName: 'RAMOS TORRES',
                  level: 'Primaria',
                  grade: 'Tercero',
                  section: 'A',
                  checkInTime: null,
                  checkOutTime: null,
                  checkInStatus: 'UNMARKED',
                  checkOutStatus: 'UNMARKED',
                  updatedInClass: false,
                ),
              ];
              return examples[i % examples.length];
            },
          ),
        ),
      ],
    );
  }
}
