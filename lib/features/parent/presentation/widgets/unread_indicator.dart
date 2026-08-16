import 'package:flutter/material.dart';
import 'package:coleapp/features/parent/presentation/widgets/type_colors.dart';

class UnreadIndicator extends StatelessWidget {
  const UnreadIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 9,
          height: 9,
          decoration: const BoxDecoration(
            color: taskColor,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          'No leído',
          style: TextStyle(
            fontSize: 8.5,
            fontWeight: FontWeight.w600,
            color: taskColor,
            height: 1,
          ),
        ),
      ],
    );
  }
}