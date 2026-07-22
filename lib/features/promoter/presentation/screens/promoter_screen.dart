import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coleapp/features/auth/presentation/screens/login_page.dart';
import 'package:coleapp/features/promoter/presentation/bloc/promoter_bloc.dart';
import 'package:coleapp/features/promoter/presentation/bloc/promoter_event.dart';

class PromoterScreen extends StatelessWidget {
  const PromoterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Promotor', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.person_pin, size: 80, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 20),
            const Text('Promotor', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Rol asignado', style: TextStyle(fontSize: 16, color: Colors.grey[600])),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: () {
          context.read<PromoterBloc>().add(Logout());
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const LoginPage()),
            (route) => false,
          );
        },
        backgroundColor: Colors.red,
        child: const Icon(Icons.logout, color: Colors.white),
      ),
    );
  }
}
