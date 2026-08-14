import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:qr_flutter/qr_flutter.dart';
import 'package:coleapp/core/services/photocheck_pdf_service.dart';
import 'package:coleapp/features/parent/data/models/branch_model.dart';
import 'package:coleapp/features/parent/data/models/student_model.dart';
import 'package:coleapp/features/parent/domain/usecases/parent_use_cases.dart';
import 'package:coleapp/features/parent/presentation/fotocheck/bloc/FotocheckBloc.dart';
import 'package:coleapp/features/parent/presentation/fotocheck/bloc/FotocheckEvent.dart';
import 'package:coleapp/features/parent/presentation/fotocheck/bloc/FotocheckState.dart';
import 'package:coleapp/features/parent/presentation/home/bloc/ParentHomeBloc.dart';
import 'package:coleapp/features/parent/presentation/home/bloc/ParentHomeState.dart';
import 'package:coleapp/features/parent/presentation/widgets/child_selector.dart';
import 'package:coleapp/injection.dart';

class FotocheckContent extends StatelessWidget {
  const FotocheckContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FotocheckBloc>(
      create: (_) => FotocheckBloc(locator<ParentUseCases>()),
      child: const _FotocheckBody(),
    );
  }
}

class _FotocheckBody extends StatefulWidget {
  const _FotocheckBody();

  @override
  State<_FotocheckBody> createState() => _FotocheckBodyState();
}

class _FotocheckBodyState extends State<_FotocheckBody> {
  bool _initialized = false;

  void _tryInitialize(ParentHomeState parentState) {
    if (parentState.students.isNotEmpty &&
        parentState.tenant.isNotEmpty &&
        parentState.branch != null &&
        !_initialized) {
      _initialized = true;
      context.read<FotocheckBloc>().add(LoadFotocheck(
        tenantKey: parentState.tenant,
        branchId: parentState.branch!.id,
        student: parentState.students.first,
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
        previous.branch?.id != current.branch?.id ||
        previous.students.length != current.students.length,
      listener: (context, state) => _tryInitialize(state),
      child: BlocBuilder<FotocheckBloc, FotocheckState>(
        builder: (context, state) {
          if (parentState.students.isEmpty) {
            return const Center(child: Text('No hay hijos registrados'));
          }

          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return _FotocheckView(
            parentState: parentState,
            fotocheckState: state,
          );
        },
      ),
    );
  }
}

class _FotocheckView extends StatefulWidget {
  final ParentHomeState parentState;
  final FotocheckState fotocheckState;

  const _FotocheckView({
    required this.parentState,
    required this.fotocheckState,
  });

  @override
  State<_FotocheckView> createState() => _FotocheckViewState();
}

class _FotocheckViewState extends State<_FotocheckView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _flipController;
  bool _generating = false;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
      value: 1,
    );
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  void _toggleFlip() {
    if (_flipController.value == 1) {
      _flipController.reverse();
    } else {
      _flipController.forward();
    }
  }

  Future<void> _generatePdf() async {
    final state = widget.fotocheckState;
    final student = state.selectedStudent ?? widget.parentState.students.first;
    final branch = widget.parentState.branch;
    final isSticker = state.template == PhotocheckTemplate.sticker;
    if (_generating) return;

    setState(() => _generating = true);
    try {
      Uint8List? logoBytes;
      final logoUrl = branch?.urlLogo;
      if (logoUrl != null && logoUrl.isNotEmpty) {
        try {
          final res = await http.get(Uri.parse(logoUrl));
          if (res.statusCode == 200) {
            logoBytes = res.bodyBytes;
          }
        } catch (_) {
          logoBytes = null;
        }
      }

      final safeName = student.lastName.trim().toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '_');
      final file = await PhotocheckPdfService.buildPdf(
        qrData: state.qrData ?? '',
        prefix: state.prefix ?? '',
        isSticker: isSticker,
        schoolName: branch?.name ?? 'Colegio',
        schoolLema: branch?.lema ?? '',
        primaryColor: branch?.primaryColor ?? '',
        secondaryColor: branch?.secondaryColor ?? '',
        studentLastName: student.lastName,
        level: student.level.name,
        degree: student.grade.name,
        section: student.section.name,
        fileName: 'fotocheck_$safeName',
        schoolLogoBytes: logoBytes,
      );
      await PhotocheckPdfService.sharePdf(file: file);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se pudo generar el PDF: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _generating = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final parentState = widget.parentState;
    final fotocheckState = widget.fotocheckState;
    final students = parentState.students;
    final student = fotocheckState.selectedStudent ?? students.first;
    final isSticker = fotocheckState.template == PhotocheckTemplate.sticker;
    final primary = _parseColor(
      parentState.branch?.primaryColor,
      fallback: Theme.of(context).colorScheme.primary,
    );
    final secondary = _parseColor(
      parentState.branch?.secondaryColor,
      fallback: primary,
    );

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: ChildSelector(
            students: students,
            selectedStudent: fotocheckState.selectedStudent,
            onChanged: (s) {
              if (s != null) {
                context.read<FotocheckBloc>().add(SelectStudent(student: s));
              }
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: SegmentedButton<PhotocheckTemplate>(
            segments: const [
              ButtonSegment(
                value: PhotocheckTemplate.photocheck,
                label: Text('Fotocheck'),
                icon: Icon(Icons.badge_outlined),
              ),
              ButtonSegment(
                value: PhotocheckTemplate.sticker,
                label: Text('Sticker'),
                icon: Icon(Icons.sell_outlined),
              ),
            ],
            selected: {fotocheckState.template},
            onSelectionChanged: (selection) {
              context.read<FotocheckBloc>().add(
                ChangeTemplate(template: selection.first),
              );
            },
          ),
        ),
        Expanded(
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            children: [
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 300),
                  child: isSticker
                      ? _StickerCard(
                          student: student,
                          qrData: fotocheckState.qrData ?? '',
                        )
                      : _FlipCard(
                          controller: _flipController,
                          onTap: _toggleFlip,
                          front: _PhotocheckFront(
                            branch: parentState.branch,
                            student: student,
                            qrData: fotocheckState.qrData ?? '',
                            primary: primary,
                            secondary: secondary,
                          ),
                          back: _PhotocheckBack(
                            branch: parentState.branch,
                            prefix: fotocheckState.prefix ?? '',
                            qrData: fotocheckState.qrData ?? '',
                            primary: primary,
                            secondary: secondary,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: Text(
                  isSticker ? 'Sticker del estudiante' : 'Toca la tarjeta para ver el reverso',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontFamily: 'NotoSerif',
                  ),
                ),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: _generating ? null : _generatePdf,
                icon: _generating
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.picture_as_pdf_outlined),
                label: Text(_generating ? 'Generando…' : 'Generar PDF'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FlipCard extends StatelessWidget {
  final AnimationController controller;
  final VoidCallback onTap;
  final Widget front;
  final Widget back;

  const _FlipCard({
    required this.controller,
    required this.onTap,
    required this.front,
    required this.back,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AspectRatio(
        aspectRatio: 64 / 90,
        child: AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            final angle = controller.value * 3.141592653589793;
            final showFront = controller.value <= 0.5;
            final transform = Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.0012)
                ..rotateY(showFront ? angle : angle - 3.141592653589793),
              child: showFront ? front : back,
            );
            return ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: transform,
            );
          },
        ),
      ),
    );
  }
}

class _PhotocheckFront extends StatelessWidget {
  final BranchModel? branch;
  final StudentModel student;
  final String qrData;
  final Color primary;
  final Color secondary;

  const _PhotocheckFront({
    required this.branch,
    required this.student,
    required this.qrData,
    required this.primary,
    required this.secondary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/photocheck-background.png',
            fit: BoxFit.cover,
          ),
          CustomPaint(painter: _ShapesPainter(primary: primary, secondary: secondary)),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        (branch?.name ?? '').toUpperCase(),
                        style: const TextStyle(
                          fontFamily: 'NotoSerif',
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    if (branch?.urlLogo != null && branch!.urlLogo!.isNotEmpty)
                      SizedBox(
                        width: 34,
                        height: 34,
                        child: CachedNetworkImage(
                          imageUrl: branch!.urlLogo!,
                          fit: BoxFit.contain,
                          errorWidget: (a, b, c) => const SizedBox.shrink(),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text(
                        student.lastName.toUpperCase(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'NotoSerif',
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 3),
                      _LabelRow(label: 'Nivel', value: student.level.name),
                      _LabelRow(label: 'Grado', value: student.grade.name),
                      _LabelRow(label: 'Sección', value: student.section.name),
                    ],
                  ),
                ),
                const Spacer(),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black, width: 1.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: QrImageView(
                      data: qrData,
                      size: 96,
                    ),
                  ),
                ),
                const Spacer(),
                Center(
                  child: Text(
                    branch?.lema ?? '',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'NotoSerif',
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PhotocheckBack extends StatelessWidget {
  final BranchModel? branch;
  final String prefix;
  final String qrData;
  final Color primary;
  final Color secondary;

  const _PhotocheckBack({
    required this.branch,
    required this.prefix,
    required this.qrData,
    required this.primary,
    required this.secondary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/photocheck-background.png',
            fit: BoxFit.cover,
          ),
          CustomPaint(painter: _ShapesPainterBack(primary: primary, secondary: secondary)),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 28, 10, 10),
            child: Column(
              children: [
                Text(
                  (branch?.name ?? '').toUpperCase(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'NotoSerif',
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black, width: 1.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.diagonal3Values(-1, 1, 1),
                        child: QrImageView(
                          data: qrData,
                          size: 96,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        prefix,
                        style: const TextStyle(
                          fontFamily: 'NotoSerif',
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Image.asset(
                  'assets/images/colecheck.png',
                  width: 84,
                  height: 30,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StickerCard extends StatelessWidget {
  final StudentModel student;
  final String qrData;

  const _StickerCard({
    required this.student,
    required this.qrData,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black, width: 1.5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Image.asset(
                'assets/images/colecheck.png',
                height: 34,
                fit: BoxFit.contain,
              ),
              const Spacer(),
              QrImageView(
                data: qrData,
                size: 110,
              ),
              const Spacer(),
              Text(
                student.lastName.toUpperCase(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'NotoSerif',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LabelRow extends StatelessWidget {
  final String label;
  final String value;

  const _LabelRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontFamily: 'NotoSerif',
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'NotoSerif',
              fontSize: 10,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

class _ShapesPainter extends CustomPainter {
  final Color primary;
  final Color secondary;

  _ShapesPainter({required this.primary, required this.secondary});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    Paint paint(Color c) => Paint()..color = c;

    canvas.save();
    canvas.translate(w * 0.95, h * 1.05);
    canvas.rotate(-0.52);
    canvas.drawRect(Rect.fromLTWH(-w * 0.6, -w * 0.6, w * 1.2, w * 1.2), paint(primary));
    canvas.restore();

    canvas.save();
    canvas.translate(w * 0.5, h * 0.92);
    canvas.rotate(0.17);
    canvas.drawRect(Rect.fromLTWH(-w * 0.8, -w * 0.8, w * 1.6, w * 1.6), paint(secondary));
    canvas.restore();

    canvas.save();
    canvas.translate(w * 0.05, h * 0.18);
    canvas.drawRect(Rect.fromLTWH(-w * 0.5, -w * 0.5, w * 1.0, w * 1.0), paint(secondary));
    canvas.restore();

    canvas.save();
    canvas.translate(w * 0.55, h * 0.1);
    canvas.rotate(0.78);
    canvas.drawRect(Rect.fromLTWH(-w * 0.6, -w * 0.6, w * 1.2, w * 1.2), paint(primary));
    canvas.restore();

    canvas.save();
    canvas.translate(w * 0.22, h * 1.6);
    canvas.rotate(-1.48);
    canvas.scale(1.1);
    canvas.drawRect(Rect.fromLTWH(-w * 0.5, -w * 0.5, w, w), paint(primary));
    canvas.restore();

    canvas.save();
    canvas.translate(w * 0.35, h * 0.95);
    canvas.rotate(-0.61);
    final line = Paint()
      ..color = secondary
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset.zero, Offset(w * 0.7, w * 0.7), line);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _ShapesPainter oldDelegate) =>
      oldDelegate.primary != primary || oldDelegate.secondary != secondary;
}

class _ShapesPainterBack extends CustomPainter {
  final Color primary;
  final Color secondary;

  _ShapesPainterBack({required this.primary, required this.secondary});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    Paint paint(Color c) => Paint()..color = c;

    canvas.save();
    canvas.translate(w * 1.1, h * 0.2);
    canvas.rotate(1.05);
    canvas.drawRect(Rect.fromLTWH(-w * 0.5, -w * 0.5, w, w), paint(primary));
    canvas.restore();

    canvas.save();
    canvas.translate(w * 1.35, h * 0.55);
    canvas.rotate(1.92);
    canvas.drawRect(Rect.fromLTWH(-w * 0.8, -w * 0.8, w * 1.6, w * 1.6), paint(secondary));
    canvas.restore();

    canvas.save();
    canvas.translate(w * 0.55, h * 0.35);
    canvas.rotate(1.57);
    canvas.drawRect(Rect.fromLTWH(-w * 0.45, -w * 0.45, w * 0.9, w * 0.9), paint(primary));
    canvas.restore();

    canvas.save();
    canvas.translate(w * 1.15, h * 0.85);
    canvas.rotate(1.57);
    canvas.drawRect(Rect.fromLTWH(-w * 0.45, -w * 0.45, w * 0.9, w * 0.9), paint(primary));
    canvas.restore();

    canvas.save();
    canvas.translate(w * 0.85, h * 0.35);
    canvas.rotate(1.13);
    final line = Paint()
      ..color = secondary
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset.zero, Offset(w * 0.8, w * 0.8), line);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _ShapesPainterBack oldDelegate) =>
      oldDelegate.primary != primary || oldDelegate.secondary != secondary;
}

Color _parseColor(String? hex, {required Color fallback}) {
  if (hex == null || hex.isEmpty) return fallback;
  var value = hex.replaceFirst('#', '');
  if (value.length == 6) value = 'FF$value';
  final parsed = int.tryParse(value, radix: 16);
  if (parsed == null) return fallback;
  return Color(parsed);
}
