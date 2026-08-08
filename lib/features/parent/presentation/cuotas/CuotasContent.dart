import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coleapp/features/parent/data/models/fee_model.dart';
import 'package:coleapp/features/parent/data/models/student_model.dart';
import 'package:coleapp/features/parent/domain/usecases/parent_use_cases.dart';
import 'package:coleapp/features/parent/presentation/cuotas/bloc/CuotasBloc.dart';
import 'package:coleapp/features/parent/presentation/cuotas/bloc/CuotasEvent.dart';
import 'package:coleapp/features/parent/presentation/cuotas/bloc/CuotasState.dart';
import 'package:coleapp/features/parent/presentation/home/bloc/ParentHomeBloc.dart';
import 'package:coleapp/features/parent/presentation/home/bloc/ParentHomeState.dart';
import 'package:coleapp/injection.dart';

class CuotasContent extends StatelessWidget {
  const CuotasContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CuotasBloc>(
      create: (_) => CuotasBloc(locator<ParentUseCases>()),
      child: const _CuotasBody(),
    );
  }
}

class _CuotasBody extends StatefulWidget {
  const _CuotasBody();

  @override
  State<_CuotasBody> createState() => _CuotasBodyState();
}

class _CuotasBodyState extends State<_CuotasBody> {
  bool _initialized = false;

  void _tryInitialize(ParentHomeState state) {
    final tenantId = state.tenant;
    if (state.students.isNotEmpty && tenantId.isNotEmpty && !_initialized) {
      _initialized = true;
      context.read<CuotasBloc>().add(LoadCuotas(
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
      child: BlocBuilder<CuotasBloc, CuotasState>(
        builder: (context, state) {
          final tenantId = parentState.tenant;

          if (parentState.students.isEmpty) {
            return const Center(child: Text('No hay hijos registrados'));
          }

          if (state.isLoading && state.fees.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return RefreshIndicator(
            onRefresh: () async {
              if (state.selectedStudent != null) {
                context.read<CuotasBloc>().add(LoadCuotas(
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
                              'No hay cuotas registradas',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ],
                      )
                    : ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(16),
                        itemCount: state.fees.length,
                        itemBuilder: (context, index) {
                          return _FeeCard(fee: state.fees[index]);
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
            context.read<CuotasBloc>().add(SelectStudent(student: student));
          }
        },
      ),
    );
  }
}

class _FeeCard extends StatelessWidget {
  final FeeModel fee;

  const _FeeCard({required this.fee});

  @override
  Widget build(BuildContext context) {
    final isPaid = fee.paymentItems.isNotEmpty && fee.paymentItems.first.isPaid;
    final name = fee.notes == null || fee.notes!.isEmpty ? 'Cuota General' : fee.notes!;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isPaid
                        ? Colors.green.withValues(alpha: 0.12)
                        : Colors.red.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    isPaid ? 'PAGADO' : 'ADEUDA',
                    style: TextStyle(
                      color: isPaid ? Colors.green.shade700 : Colors.red.shade700,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (fee.paymentDate != null && fee.paymentDate!.isNotEmpty)
              Text(
                'Vence el ${_formatDate(fee.paymentDate!)}',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            const SizedBox(height: 8),
            Text(
              'S/ ${fee.amount.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _formatDate(String date) {
  final parsed = DateTime.tryParse(date);
  if (parsed == null) return date;
  final day = parsed.day.toString().padLeft(2, '0');
  final month = parsed.month.toString().padLeft(2, '0');
  return '$day/$month/${parsed.year}';
}
