import 'package:flutter/material.dart';
import 'package:coleapp/core/themes/app_colors.dart';
import 'package:coleapp/features/parent/data/models/student_model.dart';

const _avatarColors = [
  Color(0xFF225BAA),
  Color(0xFF2E7D32),
  Color(0xFFE65100),
  Color(0xFF6A1B9A),
  Color(0xFFC62828),
  Color(0xFF00838F),
];

class ChildSelector extends StatelessWidget {
  final List<StudentModel> students;
  final StudentModel? selectedStudent;
  final ValueChanged<StudentModel?> onChanged;
  final bool showAll;
  final String allLabel;
  final bool clean;

  const ChildSelector({
    super.key,
    required this.students,
    this.selectedStudent,
    required this.onChanged,
    this.showAll = false,
    this.allLabel = 'Todos',
    this.clean = false,
  });

  String _initials(StudentModel s) {
    final parts = [s.name, s.lastName].where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    return parts
        .map((p) => p[0].toUpperCase())
        .take(2)
        .join();
  }

  @override
  Widget build(BuildContext context) {
    if (students.isEmpty) return const SizedBox.shrink();
    final ac = context.appColors;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          if (showAll) ...[
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: _allCircle(ac),
            ),
          ],
          for (var i = 0; i < students.length; i++)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: _childCircle(students[i], i, ac),
            ),
        ],
      ),
    );
  }

  Widget _allCircle(AppColors ac) {
    final selected = selectedStudent == null;
    final labelColor = clean ? (selected ? ac.primary : ac.textSecondary) : (selected ? ac.primary : ac.textSecondary);
    return GestureDetector(
      onTap: () => onChanged(null),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (clean)
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? ac.primary : ac.border,
                  width: selected ? 2 : 1.2,
                ),
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.groups,
                size: 22,
                color: selected ? ac.primary : ac.textSecondary,
              ),
            )
          else
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? ac.primary : ac.border,
                  width: selected ? 2.5 : 1.5,
                ),
              ),
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: ac.primary,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.groups,
                  size: 22,
                  color: Colors.white,
                ),
              ),
            ),
          const SizedBox(height: 4),
          SizedBox(
            width: 64,
            child: Text(
              allLabel,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: clean ? TextAlign.start : TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                color: labelColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _childCircle(StudentModel s, int index, AppColors ac) {
    final selected = selectedStudent?.id == s.id;
    final labelColor = clean ? (selected ? ac.primary : ac.textSecondary) : (selected ? ac.primary : ac.textSecondary);
    return GestureDetector(
      onTap: () => onChanged(s),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (clean)
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? ac.primary : ac.border,
                  width: selected ? 2 : 1.2,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                _initials(s),
                style: TextStyle(
                  color: selected ? ac.primary : ac.textSecondary,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            )
          else
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? ac.primary : ac.border,
                  width: selected ? 2.5 : 1.5,
                ),
              ),
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: _avatarColors[index % _avatarColors.length],
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  _initials(s),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          const SizedBox(height: 4),
          SizedBox(
            width: 64,
            child: Text(
              s.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: clean ? TextAlign.start : TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                color: labelColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
