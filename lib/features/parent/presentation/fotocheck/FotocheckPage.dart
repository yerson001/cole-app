import 'package:flutter/material.dart';
import 'package:coleapp/features/parent/presentation/fotocheck/FotocheckContent.dart';

class FotocheckPage extends StatelessWidget {
  const FotocheckPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: FotocheckContent(),
    );
  }
}
