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
import 'package:coleapp/features/parent/presentation/widgets/pill_segmented.dart';
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
      value: 0,
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

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: ChildSelector(
            students: students,
            selectedStudent: fotocheckState.selectedStudent,
            clean: true,
            onChanged: (s) {
              if (s != null) {
                context.read<FotocheckBloc>().add(SelectStudent(student: s));
              }
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: PillSegmented<PhotocheckTemplate>(
            selected: fotocheckState.template,
            onChanged: (template) {
              context.read<FotocheckBloc>().add(ChangeTemplate(template: template));
            },
            segments: const [
              PillSegment(
                value: PhotocheckTemplate.photocheck,
                label: 'Fotocheck',
                icon: Icons.badge_outlined,
              ),
              PillSegment(
                value: PhotocheckTemplate.sticker,
                label: 'Sticker',
                icon: Icons.sell_outlined,
              ),
            ],
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
                          ),
                          back: _PhotocheckBack(
                            branch: parentState.branch,
                            prefix: fotocheckState.prefix ?? '',
                            qrData: fotocheckState.qrData ?? '',
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

  const _PhotocheckFront({
    required this.branch,
    required this.student,
    required this.qrData,
  });

  @override
  Widget build(BuildContext context) {
    final primary = _parseColor(
      branch?.primaryColor,
      fallback: Theme.of(context).colorScheme.primary,
    );
    final secondary = _parseColor(
      branch?.secondaryColor,
      fallback: primary,
    );
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
          CustomPaint(
            painter: _CornerCutPainter(topColor: primary, bottomColor: secondary),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 30, 20, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _OutlinedText(
                            'INSTITUCIÓN EDUCATIVA',
                            style: const TextStyle(
                              fontFamily: 'NotoSerif',
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          _OutlinedText(
                            (branch?.name ?? '').toUpperCase(),
                            style: const TextStyle(
                              fontFamily: 'NotoSerif',
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (branch?.urlLogo != null && branch!.urlLogo!.isNotEmpty)
                      SizedBox(
                        width: 40,
                        height: 40,
                        child: CachedNetworkImage(
                          imageUrl: branch!.urlLogo!,
                          fit: BoxFit.contain,
                          errorWidget: (a, b, c) => const SizedBox.shrink(),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
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
                      _LabelRow(label: 'NIVEL', value: student.level.name),
                      _LabelRow(label: 'GRADO', value: student.grade.name),
                      _LabelRow(label: 'SECCIÓN', value: student.section.name),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
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
                      size: 132,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Center(
                  child: _OutlinedText(
                    branch?.lema ?? '',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'NotoSerif',
                      fontSize: 14,
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

  const _PhotocheckBack({
    required this.branch,
    required this.prefix,
    required this.qrData,
  });

  @override
  Widget build(BuildContext context) {
    final primary = _parseColor(
      branch?.primaryColor,
      fallback: Theme.of(context).colorScheme.primary,
    );
    final secondary = _parseColor(
      branch?.secondaryColor,
      fallback: primary,
    );
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
          CustomPaint(
            painter: _BackCutPainter(primary: primary, secondary: secondary),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 28, 10, 10),
            child: Column(
              children: [
                Text(
                  'INSTITUCIÓN',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'NotoSerif',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                _OutlinedText(
                  'EDUCATIVA ${(branch?.name ?? '').toUpperCase()}',
                  strokeWidth: 0.7,
                  style: const TextStyle(
                    fontFamily: 'NotoSerif',
                    fontSize: 16,
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
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.diagonal3Values(-1, 1, 1),
                    child: QrImageView(
                      data: qrData,
                      size: 132,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  prefix,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'NotoSerif',
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 14),
                Image.asset(
                  'assets/images/colecheck.png',
                  width: 84,
                  height: 30,
                  fit: BoxFit.contain,
                ),
                const Spacer(),
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
              const Spacer(),
              QrImageView(
                data: qrData,
                size: 150,
              ),
              const Spacer(),
              Image.asset(
                'assets/images/colecheck.png',
                height: 26,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 2),
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
        children: [
          Expanded(
            child: Text(
              label,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontFamily: 'NotoSerif',
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          SizedBox(
            width: 16,
            child: Text(
              ':',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'NotoSerif',
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontFamily: 'NotoSerif',
                fontSize: 10,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CornerCutPainter extends CustomPainter {
  final Color topColor;
  final Color bottomColor;

  _CornerCutPainter({required this.topColor, required this.bottomColor});

  @override
void paint(Canvas canvas, Size size) {
    final s = size.width * 0.56;
    final w = size.width;
    final h = size.height;
    final topLeft = Path()
      ..moveTo(0, 0)
      ..lineTo(s, 0)
      ..lineTo(0, s)
      ..close();
    canvas.drawPath(topLeft, Paint()..color = topColor);
    final bottomRight = Path()
      ..moveTo(w - s, h)
      ..lineTo(w, h)
      ..lineTo(w, h - s)
      ..close();
    canvas.drawPath(bottomRight, Paint()..color = topColor);
    final cut = Path()
      ..moveTo(0, h)
      ..lineTo(0, h - s / 2)
      ..lineTo(w, h - (s / 2 - 20))
      ..lineTo(w, h)
      ..close();
    canvas.drawPath(cut, Paint()..color = bottomColor);
final centerCut = Path()
      ..moveTo(w / 2 - 150, h)
      ..lineTo(w / 2 + 70, h)
      ..lineTo(w-20, h - 50)
      ..close();
    canvas.drawPath(centerCut, Paint()..color = topColor);
  }

  @override
  bool shouldRepaint(covariant _CornerCutPainter oldDelegate) =>
      oldDelegate.topColor != topColor || oldDelegate.bottomColor != bottomColor;
}

class _BackCutPainter extends CustomPainter {
  final Color primary;
  final Color secondary;

  _BackCutPainter({required this.primary, required this.secondary});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final rightS = w * 0.3;
    final midY = h / 2;

    final topTri = Path()
      ..moveTo(w, 0)
      ..lineTo(w - rightS, 0)
      ..lineTo(w, midY+40)
      ..close();
    canvas.drawPath(topTri, Paint()..color = primary);

    final bottomTri = Path()
      ..moveTo(w, h)
      ..lineTo(w - rightS, h)
      ..lineTo(w, midY+40)
      ..close();
    canvas.drawPath(bottomTri, Paint()..color = secondary);

    final trap = Path()
      ..moveTo(0, midY - h * 0.9)
      ..lineTo(w * 0.20, midY - h * 0.09)
      ..lineTo(w * 0.10, midY + h * 0.09)
      ..lineTo(0, midY + h * 0.30)
      ..close();
    canvas.drawPath(trap, Paint()..color = primary);
  }

  @override
  bool shouldRepaint(covariant _BackCutPainter oldDelegate) =>
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

class _OutlinedText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final TextAlign textAlign;
  final double strokeWidth;

  const _OutlinedText(
    this.text, {
    required this.style,
    this.textAlign = TextAlign.center,
    this.strokeWidth = 0.7,
  });

  @override
  Widget build(BuildContext context) {
    final strokeStyle = style.copyWith(
      color: null,
      foreground: Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeJoin = StrokeJoin.round
        ..color = Colors.white,
    );
    return Stack(
      children: [
        Text(text, textAlign: textAlign, style: strokeStyle),
        Text(text, textAlign: textAlign, style: style),
      ],
    );
  }
}
