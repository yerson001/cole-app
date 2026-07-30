import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coleapp/features/roles/presentation/bloc/roles_bloc.dart';
import 'package:coleapp/features/roles/presentation/bloc/roles_state.dart';

class RolesPage extends StatefulWidget {
  const RolesPage({super.key});

  @override
  State<RolesPage> createState() => _RolesPageState();
}

class _RolesPageState extends State<RolesPage> {
  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<RolesBloc, RolesState>(
        builder: (context, state) {
          final roles = state.roles ?? [];
          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final role in roles)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundColor: c.primary.withValues(alpha: 0.15),
                            child: Icon(Icons.person, size: 56, color: c.primary),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            role.displayName,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: c.onSurface,
                            ),
                          ),
                          const SizedBox(height: 32),
                          SizedBox(
                            width: 200,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.pushNamedAndRemoveUntil(
                                  context, role.route, (route) => false);
                              },
                              icon: const Icon(Icons.login),
                              label: const Text('Ingresar'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (roles.isEmpty)
                    const Text('No hay roles disponibles'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
