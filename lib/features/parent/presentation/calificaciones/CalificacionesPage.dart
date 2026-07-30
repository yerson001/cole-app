import 'package:flutter/material.dart';
import 'package:coleapp/features/parent/presentation/calificaciones/CalificacionesContent.dart';

class CalificacionesPage extends StatelessWidget {
  const CalificacionesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: CalificacionesContent(),
    );
  }
}
