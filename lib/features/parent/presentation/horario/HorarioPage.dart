import 'package:flutter/material.dart';
import 'package:coleapp/features/parent/presentation/horario/HorarioContent.dart';

class HorarioPage extends StatelessWidget {
  const HorarioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: HorarioContent(),
    );
  }
}
