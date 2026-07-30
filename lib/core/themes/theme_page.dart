import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coleapp/core/themes/theme_cubit.dart';

class ThemePage extends StatelessWidget {
  const ThemePage({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<ThemeCubit>();
    final current = cubit.state;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Tema'),
        centerTitle: true,
      ),
      body: RadioGroup<ThemeMode>(
        groupValue: current,
        onChanged: (v) { if (v != null) cubit.cycleTo(v); },
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 8),
          children: [
            RadioListTile<ThemeMode>(
              title: const Text('Claro'),
              secondary: const Icon(Icons.light_mode),
              value: ThemeMode.light,
            ),
            RadioListTile<ThemeMode>(
              title: const Text('Oscuro'),
              secondary: const Icon(Icons.dark_mode),
              value: ThemeMode.dark,
            ),
            RadioListTile<ThemeMode>(
              title: const Text('Sistema (predeterminado)'),
              secondary: const Icon(Icons.brightness_auto),
              value: ThemeMode.system,
            ),
          ],
        ),
      ),
    );
  }
}
