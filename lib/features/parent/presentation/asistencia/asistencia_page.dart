import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coleapp/features/parent/data/models/student_model.dart';
import 'package:coleapp/features/parent/presentation/asistencia/bloc/asistencia_bloc.dart';
import 'package:coleapp/features/parent/presentation/asistencia/bloc/asistencia_event.dart';
import 'package:coleapp/features/parent/presentation/asistencia/widgets/asistencia_diaria_tab.dart';
import 'package:coleapp/features/parent/presentation/asistencia/widgets/asistencia_general_tab.dart';

class AsistenciaPage extends StatefulWidget {
  final List<StudentModel> students;
  final String tenant;
  final int branchId;
  final int? initialStudentId;

  const AsistenciaPage({
    super.key,
    required this.students,
    required this.tenant,
    this.branchId = 1,
    this.initialStudentId,
  });

  @override
  State<AsistenciaPage> createState() => _AsistenciaPageState();
}

class _AsistenciaPageState extends State<AsistenciaPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AsistenciaBloc>(
      create: (context) => AsistenciaBloc(context.read())
        ..add(InitializeAsistencia(
          tenant: widget.tenant,
          branchId: widget.branchId,
          students: widget.students,
          initialStudentId: widget.initialStudentId,
        )),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Asistencia'),
          centerTitle: true,
          bottom: TabBar(
            controller: _tabController,
            labelStyle: const TextStyle(fontWeight: FontWeight.w600),
            tabs: const [
              Tab(text: 'Diaria'),
              Tab(text: 'General'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: const [
            AsistenciaDiariaTab(),
            AsistenciaGeneralTab(),
          ],
        ),
      ),
    );
  }
}
