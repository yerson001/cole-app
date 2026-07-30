import 'package:flutter/material.dart';
import 'package:coleapp/features/parent/presentation/agenda/AgendaContent.dart';

class AgendaPage extends StatelessWidget {
  const AgendaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: AgendaContent(),
    );
  }
}
