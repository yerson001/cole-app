import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coleapp/core/themes/app_colors.dart';
import 'package:coleapp/features/teacher/presentation/bloc/teacher_bloc.dart';
import 'package:coleapp/features/teacher/presentation/bloc/teacher_event.dart';
import 'package:coleapp/features/teacher/presentation/bloc/teacher_state.dart';
import 'package:coleapp/features/roles/presentation/screens/roles_page.dart';
import 'package:coleapp/features/auth/presentation/screens/login_page.dart';

class TeacherScreen extends StatefulWidget {
  const TeacherScreen({super.key});

  @override
  State<TeacherScreen> createState() => _TeacherScreenState();
}

class _TeacherScreenState extends State<TeacherScreen> {
  final List<Widget> pageList = <Widget>[
    const _PlaceholderPage(icon: Icons.book, label: 'Mis Cursos'),
    const _PlaceholderPage(icon: Icons.schedule, label: 'Horarios'),
    const _PlaceholderPage(icon: Icons.people, label: 'Alumnos'),
    const _PlaceholderPage(icon: Icons.fact_check, label: 'Asistencia'),
    const _PlaceholderPage(icon: Icons.grading, label: 'Notas'),
    const RolesPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('Profesor'),
      ),
      body: BlocBuilder<TeacherBloc, TeacherState>(
        builder: (context, state) {
          return pageList[state.pageIndex];
        },
      ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: () {
          context.read<TeacherBloc>().add(Logout());
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const LoginPage()), (route) => false);
        },
        backgroundColor: Colors.red,
        child: const Icon(Icons.logout, color: Colors.white),
      ),
      drawer: BlocBuilder<TeacherBloc, TeacherState>(
        builder: (context, state) {
          return Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: const BoxDecoration(color: AppColors.primary),
                  child: const Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      'Menú del Profesor',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text('GENERAL', style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold)),
                ),
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.book, color: Colors.black),
                        title: const Text('Mis Cursos', style: TextStyle(fontWeight: FontWeight.bold)),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        selected: state.pageIndex == 0,
                        onTap: () {
                          context.read<TeacherBloc>().add(ChangeDrawerPage(pageIndex: 0));
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.schedule, color: Colors.black),
                        title: const Text('Horarios', style: TextStyle(fontWeight: FontWeight.bold)),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        selected: state.pageIndex == 1,
                        onTap: () {
                          context.read<TeacherBloc>().add(ChangeDrawerPage(pageIndex: 1));
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.people, color: Colors.black),
                        title: const Text('Alumnos', style: TextStyle(fontWeight: FontWeight.bold)),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        selected: state.pageIndex == 2,
                        onTap: () {
                          context.read<TeacherBloc>().add(ChangeDrawerPage(pageIndex: 2));
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.fact_check, color: Colors.black),
                        title: const Text('Asistencia', style: TextStyle(fontWeight: FontWeight.bold)),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        selected: state.pageIndex == 3,
                        onTap: () {
                          context.read<TeacherBloc>().add(ChangeDrawerPage(pageIndex: 3));
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.grading, color: Colors.black),
                        title: const Text('Notas', style: TextStyle(fontWeight: FontWeight.bold)),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        selected: state.pageIndex == 4,
                        onTap: () {
                          context.read<TeacherBloc>().add(ChangeDrawerPage(pageIndex: 4));
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: Text('PREFERENCIAS', style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold)),
                ),
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.security, color: Colors.black),
                        title: const Text('Roles de usuario', style: TextStyle(fontWeight: FontWeight.bold)),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        selected: state.pageIndex == 5,
                        onTap: () {
                          context.read<TeacherBloc>().add(ChangeDrawerPage(pageIndex: 5));
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.logout, color: Colors.red),
                        title: const Text('Cerrar sesión', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          context.read<TeacherBloc>().add(Logout());
                          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const LoginPage()), (route) => false);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _PlaceholderPage extends StatelessWidget {
  final IconData icon;
  final String label;
  const _PlaceholderPage({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: AppColors.primary.withValues(alpha: 0.3)),
          const SizedBox(height: 16),
          Text(label, style: const TextStyle(fontSize: 24, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}
