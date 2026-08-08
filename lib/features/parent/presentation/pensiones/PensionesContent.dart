import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coleapp/features/parent/data/models/student_model.dart';
import 'package:coleapp/features/parent/domain/usecases/parent_use_cases.dart';
import 'package:coleapp/features/parent/presentation/home/bloc/ParentHomeBloc.dart';
import 'package:coleapp/features/parent/presentation/home/bloc/ParentHomeState.dart';
import 'package:coleapp/features/parent/presentation/pensiones/bloc/PensionesBloc.dart';
import 'package:coleapp/features/parent/presentation/pensiones/bloc/PensionesEvent.dart';
import 'package:coleapp/features/parent/presentation/pensiones/bloc/PensionesState.dart';
import 'package:coleapp/injection.dart';

class PensionesContent extends StatelessWidget {
  const PensionesContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PensionesBloc>(
      create: (_) => PensionesBloc(locator<ParentUseCases>()),
      child: const _PensionesBody(),
    );
  }
}

class _PensionesBody extends StatefulWidget {
  const _PensionesBody();

  @override
  State<_PensionesBody> createState() => _PensionesBodyState();
}

class _PensionesBodyState extends State<_PensionesBody> {
  bool _initialized = false;

  void _tryInitialize(ParentHomeState state) {
    final tenantId = state.tenant;
    if (state.students.isNotEmpty && tenantId.isNotEmpty && !_initialized) {
      _initialized = true;
      context.read<PensionesBloc>().add(LoadPensiones(
        student: state.students.first,
        tenantId: tenantId,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final parentState = context.watch<ParentHomeBloc>().state;
    _tryInitialize(parentState);

    return BlocListener<ParentHomeBloc, ParentHomeState>(
      listenWhen: (previous, current) =>
        previous.tenant != current.tenant ||
        previous.students.length != current.students.length,
      listener: (context, state) => _tryInitialize(state),
      child: BlocBuilder<PensionesBloc, PensionesState>(
        builder: (context, state) {
          final tenantId = parentState.tenant;

          if (parentState.students.isEmpty) {
            return const Center(child: Text('No hay hijos registrados'));
          }

          if (state.isLoading && state.months.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return RefreshIndicator(
            onRefresh: () async {
              if (state.selectedStudent != null) {
                context.read<PensionesBloc>().add(LoadPensiones(
                  student: state.selectedStudent!,
                  tenantId: tenantId,
                ));
              }
            },
            child: Column(
              children: [
                _StudentSelector(
                  students: parentState.students,
                  selectedStudent: state.selectedStudent,
                ),
                Expanded(
                  child: state.fees.isEmpty
                    ? ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          SizedBox(height: MediaQuery.of(context).size.height * 0.15),
                          const Center(
                            child: Text(
                              'No hay pensiones registradas',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ],
                      )
                    : ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(16),
                        itemCount: state.months.length,
                        itemBuilder: (context, index) {
                          return _MonthCard(row: state.months[index]);
                        },
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

class _StudentSelector extends StatelessWidget {
  final List<StudentModel> students;
  final StudentModel? selectedStudent;

  const _StudentSelector({
    required this.students,
    this.selectedStudent,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: DropdownButtonFormField<StudentModel>(
        value: selectedStudent,
        isExpanded: true,
        decoration: InputDecoration(
          labelText: 'Hijo',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        items: students.map((s) => DropdownMenuItem(
          value: s,
          child: Text(
            '${s.name} ${s.lastName}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 13),
          ),
        )).toList(),
        onChanged: (student) {
          if (student != null) {
            context.read<PensionesBloc>().add(SelectStudent(student: student));
          }
        },
      ),
    );
  }
}

class _MonthCard extends StatelessWidget {
  final PensionMonthRow row;

  const _MonthCard({required this.row});

  @override
  Widget build(BuildContext context) {
    final paid = row.isPaid;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    row.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (paid)
                    Text(
                      'Pagado ${_formatPaymentDate(row.paymentDate)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    )
                  else
                    Text(
                      'S/ ${row.debt.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: paid
                    ? Colors.green.withValues(alpha: 0.12)
                    : Colors.red.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                paid ? 'PAGADO' : 'ADEUDA',
                style: TextStyle(
                  color: paid ? Colors.green.shade700 : Colors.red.shade700,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _formatPaymentDate(String? date) {
  if (date == null || date.isEmpty) return '';
  final parsed = DateTime.tryParse(date);
  if (parsed == null) return date;
  final month = parsed.month.toString().padLeft(2, '0');
  final day = parsed.day.toString().padLeft(2, '0');
  return 'el $day/$month/${parsed.year}';
}
