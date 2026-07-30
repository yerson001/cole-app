import 'package:flutter/material.dart';
import 'package:coleapp/features/parent/presentation/reuniones/ReunionesContent.dart';

class ReunionesPage extends StatelessWidget {
  const ReunionesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ReunionesContent(),
    );
  }
}
