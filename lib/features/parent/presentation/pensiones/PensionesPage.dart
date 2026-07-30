import 'package:flutter/material.dart';
import 'package:coleapp/features/parent/presentation/pensiones/PensionesContent.dart';

class PensionesPage extends StatelessWidget {
  const PensionesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: PensionesContent(),
    );
  }
}
