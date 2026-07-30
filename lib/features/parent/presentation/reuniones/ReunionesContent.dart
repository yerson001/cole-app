import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coleapp/core/themes/app_colors.dart';
import 'package:coleapp/features/parent/data/models/meeting_model.dart';
import 'package:coleapp/features/parent/domain/usecases/parent_use_cases.dart';
import 'package:coleapp/features/parent/presentation/home/bloc/ParentHomeBloc.dart';
import 'package:coleapp/features/parent/presentation/home/bloc/ParentHomeState.dart';
import 'package:coleapp/features/parent/presentation/reuniones/bloc/ReunionesBloc.dart';
import 'package:coleapp/features/parent/presentation/reuniones/bloc/ReunionesEvent.dart';
import 'package:coleapp/features/parent/presentation/reuniones/bloc/ReunionesState.dart';
import 'package:coleapp/injection.dart';

class ReunionesContent extends StatelessWidget {
  const ReunionesContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ReunionesBloc>(
      create: (_) => ReunionesBloc(locator<ParentUseCases>()),
      child: const _ReunionesBody(),
    );
  }
}

class _ReunionesBody extends StatefulWidget {
  const _ReunionesBody();

  @override
  State<_ReunionesBody> createState() => _ReunionesBodyState();
}

class _ReunionesBodyState extends State<_ReunionesBody> {
  bool _initialized = false;

  void _tryInitialize(ParentHomeState state) {
    final parentId = state.user?.profile?.id;
    final tenantId = state.tenant;
    if (parentId != null && tenantId.isNotEmpty && !_initialized) {
      _initialized = true;
      context.read<ReunionesBloc>().add(
        LoadMeetings(parentId: parentId, tenantId: tenantId),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final parentState = context.watch<ParentHomeBloc>().state;
    _tryInitialize(parentState);
    return BlocListener<ParentHomeBloc, ParentHomeState>(
      listenWhen: (previous, current) =>
        previous.user?.profile?.id != current.user?.profile?.id ||
        previous.tenant != current.tenant,
      listener: (context, state) => _tryInitialize(state),
      child: BlocBuilder<ReunionesBloc, ReunionesState>(
        builder: (context, state) {
          final parentId = parentState.user?.profile?.id;
          final tenantId = parentState.tenant;

          if (parentId == null || tenantId.isEmpty) {
            return const Center(child: Text('No hay sesión de padre activa'));
          }

          if (state.isLoading && state.meetings.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.error != null && state.meetings.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Error al cargar reuniones',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(state.error!, textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context.read<ReunionesBloc>().add(
                        LoadMeetings(parentId: parentId, tenantId: tenantId),
                      ),
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state.meetings.isEmpty) {
            return RefreshIndicator(
              onRefresh: () async => context.read<ReunionesBloc>().add(
                LoadMeetings(parentId: parentId, tenantId: tenantId),
              ),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 120),
                  Center(
                    child: Text(
                      'No tienes reuniones programadas',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => context.read<ReunionesBloc>().add(
              LoadMeetings(parentId: parentId, tenantId: tenantId),
            ),
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: state.meetings.length,
              itemBuilder: (context, index) => _MeetingCard(
                meeting: state.meetings[index],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _MeetingCard extends StatelessWidget {
  final ParentMeetingModel meeting;

  const _MeetingCard({required this.meeting});

  @override
  Widget build(BuildContext context) {
    final ac = context.appColors;
    final meetingInfo = meeting.parentMeeting;
    final (statusColor, statusLabel) = _statusInfo(meeting.status);
    final date = DateTime.tryParse(meetingInfo.date);
    final dateText = date != null
        ? '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}'
        : meetingInfo.date;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    meetingInfo.subject,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    statusLabel,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _InfoRow(icon: Icons.calendar_today_outlined, text: dateText),
            const SizedBox(height: 6),
            _InfoRow(icon: Icons.access_time, text: meetingInfo.timeRange),
            const SizedBox(height: 6),
            _InfoRow(
              icon: Icons.timer_outlined,
              text: 'Tolerancia: ${meetingInfo.toleranceTime} min',
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (meeting.status == 'ABSENT')
                  FilledButton.icon(
                    onPressed: () => context.read<ReunionesBloc>().add(
                      CheckInMeeting(meetingId: meetingInfo.id),
                    ),
                    icon: const Icon(Icons.login, size: 18),
                    label: const Text('Marcar ingreso'),
                  )
                else if (meeting.status == 'PRESENT')
                  OutlinedButton.icon(
                    onPressed: () => context.read<ReunionesBloc>().add(
                      CheckOutMeeting(meetingId: meetingInfo.id),
                    ),
                    icon: const Icon(Icons.logout, size: 18),
                    label: const Text('Marcar salida'),
                  )
                else
                  Text(
                    'Estado: $statusLabel',
                    style: TextStyle(color: ac.primary),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  (Color, String) _statusInfo(String status) {
    switch (status) {
      case 'PRESENT':
        return (Colors.green, 'Asistió');
      case 'ABSENT':
        return (Colors.red, 'Pendiente');
      case 'LATE':
        return (Colors.orange, 'Tarde');
      default:
        return (Colors.grey, status);
    }
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(fontSize: 14, color: Colors.black87),
        ),
      ],
    );
  }
}
