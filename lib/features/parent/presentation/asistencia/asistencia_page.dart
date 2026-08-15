import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coleapp/core/themes/app_colors.dart';
import 'package:coleapp/features/parent/data/models/student_model.dart';
import 'package:coleapp/features/parent/presentation/asistencia/bloc/asistencia_bloc.dart';
import 'package:coleapp/features/parent/presentation/asistencia/bloc/asistencia_event.dart';
import 'package:coleapp/features/parent/presentation/asistencia/widgets/asistencia_diaria_tab.dart';
import 'package:coleapp/features/parent/presentation/asistencia/widgets/asistencia_general_tab.dart';
import 'package:coleapp/features/parent/presentation/widgets/pill_segmented.dart';
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
          backgroundColor: context.appColors.surface,
          foregroundColor: context.appColors.textPrimary,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: AnimatedBuilder(
                animation: _tabController,
                builder: (context, _) {
                  return PillSegmented<int>(
                    selected: _tabController.index,
                    onChanged: (i) => _tabController.animateTo(i),
                    segments: const [
                      PillSegment(
                        value: 0,
                        label: 'Diaria',
                        icon: Icons.today_outlined,
                      ),
                      PillSegment(
                        value: 1,
                        label: 'General',
                        icon: Icons.calendar_month_outlined,
                      ),
                    ],
                  );
                },
              ),
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
