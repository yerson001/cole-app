import 'package:flutter/material.dart';
import 'package:coleapp/core/themes/app_colors.dart';
import 'package:coleapp/core/errors/resource.dart';
import 'package:coleapp/features/parent/data/models/agenda_detail_model.dart';
import 'package:coleapp/features/parent/data/models/agenda_model.dart';
import 'package:coleapp/features/parent/domain/usecases/parent_use_cases.dart';
import 'package:coleapp/features/parent/presentation/widgets/type_colors.dart';
import 'package:coleapp/injection.dart';

class AgendaDetailPage extends StatefulWidget {
  final AgendaItemModel item;
  final String tenantId;

  const AgendaDetailPage({
    super.key,
    required this.item,
    required this.tenantId,
  });

  @override
  State<AgendaDetailPage> createState() => _AgendaDetailPageState();
}

class _AgendaDetailPageState extends State<AgendaDetailPage> {
  HomeworkDetailModel? _homework;
  AnnouncementDetailModel? _announcement;
  ObservationDetailModel? _observation;
  bool _loading = true;
  String? _error;

  String get _type => widget.item.type;
  int get _refId => int.tryParse(widget.item.refId) ?? 0;
  String get _tenantId => widget.tenantId;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    final useCases = locator<ParentUseCases>();
    switch (_type) {
      case 'TASK':
        final result = await useCases.getHomeworkDetailUseCase
            .call(homeworkId: _refId, tenantId: _tenantId);
        if (result is SuccessResource<HomeworkDetailModel>) {
          setState(() {
            _homework = result.data;
            _loading = false;
          });
        } else {
          setState(() {
            _error = (result as ErrorResource).message;
            _loading = false;
          });
        }
        break;
      case 'ANNOUNCEMENT':
        final result = await useCases.getAnnouncementDetailUseCase
            .call(announcementId: _refId, tenantId: _tenantId);
        if (result is SuccessResource<AnnouncementDetailModel>) {
          setState(() {
            _announcement = result.data;
            _loading = false;
          });
        } else {
          setState(() {
            _error = (result as ErrorResource).message;
            _loading = false;
          });
        }
        break;
      case 'STUDENT_OBSERVATION':
        final result = await useCases.getObservationDetailUseCase
            .call(observationId: _refId, tenantId: _tenantId);
        if (result is SuccessResource<ObservationDetailModel>) {
          setState(() {
            _observation = result.data;
            _loading = false;
          });
        } else {
          setState(() {
            _error = (result as ErrorResource).message;
            _loading = false;
          });
        }
        break;
      default:
        setState(() {
          _error = 'Tipo de agenda no reconocido';
          _loading = false;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ac = context.appColors;
    return Scaffold(
      appBar: AppBar(
        title: Text(_detailTitle()),
        backgroundColor: ac.surface,
        foregroundColor: ac.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    final ac = context.appColors;

    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, size: 42, color: ac.error),
              const SizedBox(height: 12),
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: ac.textSecondary),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: _load,
                icon: const Icon(Icons.refresh),
                label: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    final title = _currentTitle();
    if (title == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'No se encontró ${_detailTitle().toLowerCase()}',
            style: TextStyle(fontSize: 14, color: ac.textSecondary),
          ),
        ),
      );
    }

    final sender = _currentSender();
    final notebookType = _typeInfo(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: ac.card,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: ac.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: notebookType.$1,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(notebookType.$2, color: Colors.white, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: ac.textPrimary,
                          height: 1.25,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _DetailRow(
                  icon: Icons.person_outline,
                  label: 'Creado por:',
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          sender?.fullName ?? '',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: ac.textPrimary,
                          ),
                        ),
                      ),
                      if (sender != null && sender.roles.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: ac.fill,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _roleLabel(sender.roles.first),
                            style: TextStyle(fontSize: 11.5, color: ac.textSecondary),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (_homework != null) ...[
                  _DetailRow(
                    icon: Icons.school_outlined,
                    label: 'Curso:',
                    child: Text(
                      _homework!.courseSection.courseName ?? '',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: ac.primary,
                      ),
                    ),
                  ),
                  _DetailRow(
                    icon: Icons.group_outlined,
                    label: 'Grado - Sección:',
                    child: Text(
                      _homework!.fullCourseSection ?? _homework!.courseSection.name,
                      style: TextStyle(fontSize: 13.5, color: ac.textPrimary),
                    ),
                  ),
                  _DetailRow(
                    icon: Icons.event_outlined,
                    label: 'Fecha de entrega:',
                    child: Text(
                      _formatNiceDate(_homework!.dueDate),
                      style: TextStyle(fontSize: 13.5, color: ac.textPrimary),
                    ),
                  ),
                  if (_homework!.dueTime != null && _homework!.dueTime!.isNotEmpty)
                    _DetailRow(
                      icon: Icons.schedule,
                      label: 'Hora de entrega:',
                      child: Text(
                        _homework!.dueTime!,
                        style: TextStyle(fontSize: 13.5, color: ac.textPrimary),
                      ),
                    ),
                ] else ...[
                  _DetailRow(
                    icon: Icons.schedule,
                    label: 'Publicado:',
                    child: Text(
                      _formatDateTime(_currentPublishedAt()),
                      style: TextStyle(fontSize: 13.5, color: ac.textPrimary),
                    ),
                  ),
                ],
                if (_observation != null && _observation!.severity != null)
                  _DetailRow(
                    icon: Icons.warning_amber_outlined,
                    label: 'Severidad:',
                    child: _SeverityBadge(severity: _observation!.severity!),
                  ),
                Divider(height: 32, thickness: 1, color: ac.divider),
                Text(
                  _currentContent() ?? '',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.55,
                    color: ac.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _detailTitle() {
    switch (_type) {
      case 'TASK':
        return 'Tarea';
      case 'ANNOUNCEMENT':
        return 'Aviso';
      case 'STUDENT_OBSERVATION':
        return 'Llamada de Atención';
      default:
        return 'Detalle';
    }
  }

  String? _currentTitle() {
    if (_homework != null) return _homework!.title;
    if (_announcement != null) return _announcement!.title;
    if (_observation != null) return _observation!.title;
    return null;
  }

  String? _currentContent() {
    if (_homework != null) return _homework!.content;
    if (_announcement != null) return _announcement!.content;
    if (_observation != null) return _observation!.content;
    return null;
  }

  String? _currentPublishedAt() {
    if (_homework != null) return _homework!.localDate?.toIso8601String();
    if (_announcement != null) {
      return _announcement!.localDate?.toIso8601String();
    }
    if (_observation != null) {
      return _observation!.localDate?.toIso8601String();
    }
    return null;
  }

  HomeworkSenderModel? _currentSender() {
    if (_homework != null) return _homework!.sender;
    if (_announcement != null) return _announcement!.sender;
    if (_observation != null) return _observation!.sender;
    return null;
  }

  (Color, IconData, String) _typeInfo(BuildContext context) {
    switch (_type) {
      case 'ANNOUNCEMENT':
        return (announcementColor, Icons.campaign_outlined, 'Aviso');
      case 'TASK':
        return (taskColor, Icons.assignment_outlined, 'Tarea');
      case 'STUDENT_OBSERVATION':
        return (observationColor, Icons.feedback_outlined, 'Observación');
      default:
        return (Colors.grey, Icons.event_note_outlined, 'Detalle');
    }
  }

  String _roleLabel(String role) {
    const map = {
      'ADMIN': 'Administrador',
      'PROMOTER': 'Promotor',
      'PRINCIPAL': 'Director',
      'SECRETARY': 'Secretario',
      'ASSISTANT': 'Asistente',
      'FACILITY_STAFF': 'Personal de servicio',
      'STUDENT': 'Estudiante',
      'PARENT': 'Apoderado',
      'TEACHER': 'Profesor',
    };
    return map[role] ?? role;
  }

  String _formatDateTime(String? value) {
    if (value == null) return '';
    final date = DateTime.tryParse(value);
    if (date == null) return value;
    final dd = date.day.toString().padLeft(2, '0');
    final mm = date.month.toString().padLeft(2, '0');
    final hh = date.hour.toString().padLeft(2, '0');
    final min = date.minute.toString().padLeft(2, '0');
    return '$dd/$mm/${date.year} $hh:$min';
  }

  String _formatNiceDate(String? value) {
    if (value == null) return '';
    final date = DateTime.tryParse(value);
    if (date == null) return value;
    const months = [
      'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
      'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre'
    ];
    return '${date.day} de ${months[date.month - 1]} de ${date.year}';
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget child;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final ac = context.appColors;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 17, color: ac.textSecondary),
          const SizedBox(width: 10),
          SizedBox(
            width: 118,
            child: Text(
              label,
              style: TextStyle(fontSize: 13.5, color: ac.textSecondary),
            ),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _SeverityBadge extends StatelessWidget {
  final String severity;

  const _SeverityBadge({required this.severity});

  @override
  Widget build(BuildContext context) {
    final ac = context.appColors;
    final (bg, fg, label) = switch (severity) {
      'baja' => (ac.successLight, ac.success, 'Baja'),
      'media' => (ac.warningLight, ac.warning, 'Media'),
      'alta' => (ac.errorLight, ac.error, 'Alta'),
      _ => (ac.fill, ac.textSecondary, severity),
    };
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: fg,
          ),
        ),
      ),
    );
  }
}