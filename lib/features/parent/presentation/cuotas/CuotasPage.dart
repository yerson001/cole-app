import 'package:flutter/material.dart';
import 'package:coleapp/features/parent/presentation/cuotas/CuotasContent.dart';

class CuotasPage extends StatelessWidget {
  const CuotasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: CuotasContent(),
    );
  }
}
