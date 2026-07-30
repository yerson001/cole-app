import 'package:flutter/material.dart';
import 'package:coleapp/features/parent/data/models/student_model.dart';

class ChildSelector extends StatelessWidget {
  final List<StudentModel> students;
  final StudentModel? selectedStudent;
  final ValueChanged<StudentModel> onChanged;

  const ChildSelector({
    super.key,
    required this.students,
    this.selectedStudent,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: Border.all(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: DropdownButton<StudentModel>(
          isExpanded: true,
          value: selectedStudent,
          hint: const Text('Seleccionar estudiante'),
          icon: const Icon(Icons.arrow_drop_down),
          items: students.map((s) {
            return DropdownMenuItem<StudentModel>(
              value: s,
              child: Text(
                '${s.name} ${s.lastName}',
                style: const TextStyle(fontSize: 14),
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) onChanged(value);
          },
        ),
      ),
    );
  }
}
