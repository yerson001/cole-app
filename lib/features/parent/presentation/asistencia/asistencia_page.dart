import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coleapp/core/themes/app_colors.dart';
import 'package:coleapp/features/parent/data/models/student_model.dart';
import 'package:coleapp/features/parent/presentation/asistencia/bloc/asistencia_bloc.dart';
import 'package:coleapp/features/parent/presentation/asistencia/bloc/asistencia_event.dart';
import 'package:coleapp/features/parent/presentation/asistencia/widgets/asistencia_diaria_tab.dart';
import 'package:coleapp/features/parent/presentation/asistencia/widgets/asistencia_general_tab.dart';
import 'package:coleapp/features/parent/domain/usecases/parent_use_cases.dart';
import 'package:coleapp/injection.dart';

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

  static const _tabLabels = ['Diaria', 'General'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabLabels.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AsistenciaBloc>(
      create: (context) => AsistenciaBloc(locator<ParentUseCases>())
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
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: _SegmentedTabs(controller: _tabController, labels: _tabLabels),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  AsistenciaDiariaTab(),
                  AsistenciaGeneralTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SegmentedTabs extends StatelessWidget {
  final TabController controller;
  final List<String> labels;

  const _SegmentedTabs({required this.controller, required this.labels});

  @override
  Widget build(BuildContext context) {
    final ac = context.appColors;
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: ac.fill,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              for (var i = 0; i < labels.length; i++)
                Expanded(
                  child: GestureDetector(
                    onTap: () => controller.animateTo(i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: controller.index == i ? ac.card : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: controller.index == i ? ac.border : Colors.transparent,
                        ),
                        boxShadow: controller.index == i
                            ? [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: Text(
                        labels[i],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: controller.index == i ? FontWeight.w600 : FontWeight.w500,
                          color: controller.index == i ? ac.primary : ac.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
