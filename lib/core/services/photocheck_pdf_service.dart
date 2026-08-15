import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:vector_math/vector_math_64.dart' show Matrix4;

class PhotocheckPdfService {
  PhotocheckPdfService._();

  static const double _mm = PdfPageFormat.mm;
  static const double _margin = 10 * PdfPageFormat.mm;
  static const double _spacingX = 5 * PdfPageFormat.mm;

  static Future<pw.Font> _semiBold = _loadFont('assets/fonts/NotoSerif-SemiBold.ttf');
  static Future<pw.Font> _bold = _loadFont('assets/fonts/NotoSerif-Bold.ttf');
  static Future<pw.Font> _extraBold = _loadFont('assets/fonts/NotoSerif-ExtraBold.ttf');

  static Future<pw.Font> _loadFont(String asset) async {
    final data = await rootBundle.load(asset);
    return pw.Font.ttf(data);
  }

  static Future<Uint8List> _loadAssetBytes(String asset) async {
    final data = await rootBundle.load(asset);
    return data.buffer.asUint8List();
  }

  static Future<File> buildPdf({
    required String qrData,
    required String prefix,
    required bool isSticker,
    required String schoolName,
    required String schoolLema,
    required String primaryColor,
    required String secondaryColor,
    required String studentLastName,
    required String level,
    required String degree,
    required String section,
    required String fileName,
    Uint8List? schoolLogoBytes,
  }) async {
    final background = pw.MemoryImage(
      await _loadAssetBytes('assets/images/photocheck-background.png'),
    );
    final colecheckLogo = pw.MemoryImage(
      await _loadAssetBytes('assets/images/colecheck.png'),
    );
    final fontSemiBold = await _semiBold;
    final fontBold = await _bold;
    final fontExtraBold = await _extraBold;

    final primary = _parsePdfColor(primaryColor, PdfColors.indigo);
    final secondary = _parsePdfColor(secondaryColor, PdfColors.grey700);

    final doc = pw.Document(compress: true);

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.zero,
        build: (pw.Context context) {
          if (isSticker) {
            return pw.Stack(
              children: [
                pw.Positioned(
                  left: _margin,
                  top: _margin,
                  child: pw.SizedBox(
                    width: 47 * _mm,
                    height: 40 * _mm,
                    child: _buildSticker(
                      qrData: qrData,
                      lastName: studentLastName,
                      logo: colecheckLogo,
                      fontBold: fontBold,
                      fontSemiBold: fontSemiBold,
                    ),
                  ),
                ),
              ],
            );
          }

          final frontWidth = 57 * _mm;
          final frontHeight = 78 * _mm;

          return pw.Stack(
            children: [
              pw.Positioned(
                left: _margin,
                top: _margin,
                child: pw.SizedBox(
                  width: frontWidth,
                  height: frontHeight,
                  child: _buildFront(
                    qrData: qrData,
                    schoolName: schoolName,
                    schoolLema: schoolLema,
                    lastName: studentLastName,
                    level: level,
                    degree: degree,
                    section: section,
                    primary: primary,
                    secondary: secondary,
                    background: background,
                    schoolLogo: schoolLogoBytes != null
                        ? pw.MemoryImage(schoolLogoBytes)
                        : null,
                    fontBold: fontBold,
                    fontSemiBold: fontSemiBold,
                    fontExtraBold: fontExtraBold,
                  ),
                ),
              ),
              pw.Positioned(
                left: _margin + frontWidth + _spacingX,
                top: _margin,
                child: pw.SizedBox(
                  width: frontWidth,
                  height: frontHeight,
                  child: _buildBack(
                    qrData: qrData,
                    prefix: prefix,
                    schoolName: schoolName,
                    primary: primary,
                    secondary: secondary,
                    background: background,
                    colecheckLogo: colecheckLogo,
                    fontBold: fontBold,
                    fontSemiBold: fontSemiBold,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );

    final bytes = await doc.save();
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/$fileName.pdf');
    await file.writeAsBytes(bytes);
    return file;
  }

  static Future<void> sharePdf({
    required File file,
  }) async {
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path, mimeType: 'application/pdf')],
      ),
    );
  }

  static pw.Widget _buildSticker({
    required String qrData,
    required String lastName,
    required pw.MemoryImage logo,
    required pw.Font fontBold,
    required pw.Font fontSemiBold,
  }) {
    return pw.ClipRRect(
      horizontalRadius: 2 * _mm,
      verticalRadius: 2 * _mm,
      child: pw.Container(
        decoration: pw.BoxDecoration(
          color: PdfColors.white,
          border: pw.Border.all(color: PdfColors.black, width: 1.5),
          borderRadius: pw.BorderRadius.circular(3 * _mm),
        ),
        padding: pw.EdgeInsets.all(3 * _mm),
      child: pw.Column(
        children: [
          pw.Spacer(),
          pw.SizedBox(
            width: 20 * _mm,
            height: 20 * _mm,
            child: pw.BarcodeWidget(
              data: qrData,
              barcode: pw.Barcode.qrCode(),
              color: PdfColors.black,
              backgroundColor: PdfColors.white,
              width: 20 * _mm,
              height: 20 * _mm,
              drawText: false,
            ),
          ),
          pw.Spacer(),
          pw.Image(logo, width: 14 * _mm, height: 5 * _mm, fit: pw.BoxFit.contain),
          pw.SizedBox(height: 1 * _mm),
          pw.Text(
            lastName.toUpperCase(),
            maxLines: 1,
            overflow: pw.TextOverflow.clip,
            textAlign: pw.TextAlign.center,
style: pw.TextStyle(
              font: fontSemiBold,
              fontSize: 6.5,
              color: PdfColors.grey800,
            ),
          ),
        ],
      ),
    ),
  );
}

  static pw.Widget _buildFront({
    required String qrData,
    required String schoolName,
    required String schoolLema,
    required String lastName,
    required String level,
    required String degree,
    required String section,
    required PdfColor primary,
    required PdfColor secondary,
    required pw.MemoryImage background,
    required pw.MemoryImage? schoolLogo,
    required pw.Font fontBold,
    required pw.Font fontSemiBold,
    required pw.Font fontExtraBold,
  }) {
    final w = 57 * _mm;
    if (w <= 0) return pw.SizedBox();
    return pw.ClipRRect(
      horizontalRadius: 2 * _mm,
      verticalRadius: 2 * _mm,
      child: pw.Stack(
        fit: pw.StackFit.expand,
        children: [
          pw.Image(background, fit: pw.BoxFit.cover),
          pw.CustomPaint(
            painter: (canvas, size) => _paintFrontShapes(canvas, size, primary, secondary),
          ),
          pw.Padding(
            padding: pw.EdgeInsets.fromLTRB(4.5 * _mm, 6.5 * _mm, 4.5 * _mm, 3.5 * _mm),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Expanded(
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          _outlinedText(
                            'INSTITUCIÓN EDUCATIVA',
                            pw.TextStyle(
                              font: fontBold,
                              fontSize: 6,
                              color: PdfColors.grey800,
                            ),
                            pw.TextAlign.left,
                            stroke: 0.7,
                          ),
                          _outlinedText(
                            schoolName.toUpperCase(),
                            pw.TextStyle(
                              font: fontBold,
                              fontSize: 6,
                              color: PdfColors.grey800,
                            ),
                            pw.TextAlign.left,
                            stroke: 0.7,
                          ),
                        ],
                      ),
                    ),
                    if (schoolLogo != null)
                      pw.SizedBox(
                        width: 9 * _mm,
                        height: 9 * _mm,
                        child: pw.Image(schoolLogo, fit: pw.BoxFit.contain),
                      ),
                  ],
                ),
                pw.SizedBox(height: 2 * _mm),
                pw.Container(
                  width: w - 9 * _mm,
                  padding: pw.EdgeInsets.symmetric(horizontal: 2 * _mm, vertical: 1.5 * _mm),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.white,
                    borderRadius: pw.BorderRadius.circular(2 * _mm),
                  ),
                  child: pw.Column(
                    children: [
                      pw.Text(
                        lastName.toUpperCase(),
                        maxLines: 2,
                        overflow: pw.TextOverflow.clip,
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                          font: fontExtraBold,
                          fontSize: 8,
                          color: PdfColors.grey800,
                        ),
                      ),
                      pw.SizedBox(height: 1 * _mm),
                      _buildInfoRow('NIVEL', level, fontBold),
                      _buildInfoRow('GRADO', degree, fontBold),
                      _buildInfoRow('SECCIÓN', section, fontBold),
                    ],
                  ),
                ),
                pw.Spacer(),
                pw.Center(
                  child: pw.Container(
                    padding: pw.EdgeInsets.all(1.5 * _mm),
                    decoration: pw.BoxDecoration(
                      color: PdfColors.white,
                      border: pw.Border.all(color: PdfColors.black, width: 1.5),
                      borderRadius: pw.BorderRadius.circular(3 * _mm),
                    ),
                    child: pw.SizedBox(
                      width: 22 * _mm,
                      height: 22 * _mm,
                      child: pw.BarcodeWidget(
                        data: qrData,
                        barcode: pw.Barcode.qrCode(),
                        color: PdfColors.black,
                        backgroundColor: PdfColors.white,
                        width: 22 * _mm,
                        height: 22 * _mm,
                        drawText: false,
                      ),
                    ),
                  ),
                ),
                pw.Spacer(),
                pw.Center(
                  child: _outlinedText(
                    schoolLema,
                    pw.TextStyle(
                      font: fontSemiBold,
                      fontSize: 6.5,
                      color: PdfColors.grey800,
                    ),
                    pw.TextAlign.center,
                    stroke: 0.7,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildBack({
    required String qrData,
    required String prefix,
    required String schoolName,
    required PdfColor primary,
    required PdfColor secondary,
    required pw.MemoryImage background,
    required pw.MemoryImage colecheckLogo,
    required pw.Font fontBold,
    required pw.Font fontSemiBold,
  }) {
    return pw.ClipRRect(
      horizontalRadius: 2 * _mm,
      verticalRadius: 2 * _mm,
      child: pw.Stack(
        fit: pw.StackFit.expand,
        children: [
          pw.Image(background, fit: pw.BoxFit.cover),
          pw.CustomPaint(
            painter: (canvas, size) => _paintBackShapes(canvas, size, primary, secondary),
          ),
          pw.Padding(
            padding: pw.EdgeInsets.fromLTRB(2.5 * _mm, 6 * _mm, 2.5 * _mm, 2.5 * _mm),
            child: pw.Column(
              children: [
                pw.Text(
                  'INSTITUCIÓN',
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                    font: fontBold,
                    fontSize: 8,
                    color: PdfColors.grey800,
                  ),
                ),
                pw.Text(
                  'EDUCATIVA ${schoolName.toUpperCase()}',
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                    font: fontBold,
                    fontSize: 8,
                    color: PdfColors.grey800,
                  ),
                ),
                pw.Spacer(),
                pw.Container(
                  padding: pw.EdgeInsets.all(1.5 * _mm),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.white,
                    border: pw.Border.all(color: PdfColors.black, width: 1.5),
                    borderRadius: pw.BorderRadius.circular(3 * _mm),
                  ),
                  child: pw.SizedBox(
                    width: 20 * _mm,
                    height: 20 * _mm,
                    child: pw.BarcodeWidget(
                      data: qrData,
                      barcode: pw.Barcode.qrCode(),
                      color: PdfColors.black,
                      backgroundColor: PdfColors.white,
                      width: 20 * _mm,
                      height: 20 * _mm,
                      drawText: false,
                    ),
                  ),
                ),
                pw.SizedBox(height: 1.5 * _mm),
                pw.Text(
                  prefix,
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                    font: fontSemiBold,
                    fontSize: 6,
                    color: PdfColors.grey800,
                  ),
                ),
                pw.SizedBox(height: 3 * _mm),
                pw.Image(
                  colecheckLogo,
                  width: 20 * _mm,
                  height: 6 * _mm,
                  fit: pw.BoxFit.contain,
                ),
                pw.Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _outlinedText(
    String text,
    pw.TextStyle style,
    pw.TextAlign align, {
    double stroke = 0.7,
  }) {
    final white = style.copyWith(color: PdfColors.white);
    final copies = <pw.Widget>[
      pw.Transform(transform: Matrix4.translationValues(-stroke, -stroke, 0), child: pw.Text(text, textAlign: align, style: white)),
      pw.Transform(transform: Matrix4.translationValues(0, -stroke, 0), child: pw.Text(text, textAlign: align, style: white)),
      pw.Transform(transform: Matrix4.translationValues(stroke, -stroke, 0), child: pw.Text(text, textAlign: align, style: white)),
      pw.Transform(transform: Matrix4.translationValues(-stroke, 0, 0), child: pw.Text(text, textAlign: align, style: white)),
      pw.Transform(transform: Matrix4.translationValues(stroke, 0, 0), child: pw.Text(text, textAlign: align, style: white)),
      pw.Transform(transform: Matrix4.translationValues(-stroke, stroke, 0), child: pw.Text(text, textAlign: align, style: white)),
      pw.Transform(transform: Matrix4.translationValues(0, stroke, 0), child: pw.Text(text, textAlign: align, style: white)),
      pw.Transform(transform: Matrix4.translationValues(stroke, stroke, 0), child: pw.Text(text, textAlign: align, style: white)),
      pw.Text(text, textAlign: align, style: style),
    ];
    return pw.Stack(alignment: pw.Alignment.center, children: copies);
  }

  static pw.Widget _buildInfoRow(String label, String value, pw.Font font) {
    return pw.Padding(
      padding: pw.EdgeInsets.symmetric(vertical: 0.5 * _mm),
      child: pw.Row(
        children: [
          pw.Expanded(
            child: pw.Text(
              label,
              textAlign: pw.TextAlign.right,
              style: pw.TextStyle(font: font, fontSize: 6, color: PdfColors.grey800),
            ),
          ),
          pw.SizedBox(
            width: 3 * _mm,
            child: pw.Text(
              ':',
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(font: font, fontSize: 6, color: PdfColors.grey800),
            ),
          ),
          pw.Expanded(
            child: pw.Text(
              value,
              textAlign: pw.TextAlign.left,
              style: pw.TextStyle(font: font, fontSize: 6, color: PdfColors.grey800),
            ),
          ),
        ],
      ),
    );
  }

  static void _paintFrontShapes(PdfGraphics canvas, PdfPoint size, PdfColor primary, PdfColor secondary) {
    final w = size.x;
    final h = size.y;
    final s = w * 0.56;

    _fillPolygon(canvas, primary, [
      [0, h],
      [s, h],
      [0, h - s],
    ]);

    _fillPolygon(canvas, primary, [
      [w - s, 0],
      [w, 0],
      [w, s],
    ]);

    _fillPolygon(canvas, secondary, [
      [0, 0],
      [0, s / 2],
      [w, s / 2 - w * 0.07463],
      [w, 0],
    ]);

    _fillPolygon(canvas, primary, [
      [w / 2 - w * 0.5597, 0],
      [w / 2 + w * 0.2612, 0],
      [w - w * 0.0746, w * 0.1866],
    ]);
  }

  static void _paintBackShapes(PdfGraphics canvas, PdfPoint size, PdfColor primary, PdfColor secondary) {
    final w = size.x;
    final h = size.y;
    final rightS = w * 0.3;
    final midY = h / 2;

    _fillPolygon(canvas, primary, [
      [w, h],
      [w - rightS, h],
      [w, midY - w * 0.149],
    ]);

    _fillPolygon(canvas, secondary, [
      [w, 0],
      [w - rightS, 0],
      [w, midY - w * 0.149],
    ]);

    _fillPolygon(canvas, primary, [
      [0, 1.4 * h],
      [w * 0.2, 0.59 * h],
      [w * 0.1, 0.41 * h],
      [0, 0.2 * h],
    ]);
  }

  static void _fillPolygon(PdfGraphics canvas, PdfColor color, List<List<double>> pts) {
    canvas
      ..saveContext()
      ..setFillColor(color)
      ..moveTo(pts[0][0], pts[0][1]);
    for (var i = 1; i < pts.length; i++) {
      canvas.lineTo(pts[i][0], pts[i][1]);
    }
    canvas.closePath();
    canvas.fillPath();
    canvas.restoreContext();
  }

  static PdfColor _parsePdfColor(String? hex, PdfColor fallback) {
    if (hex == null || hex.isEmpty) return fallback;
    var value = hex.replaceFirst('#', '');
    if (value.length == 6) value = 'FF$value';
    final parsed = int.tryParse(value, radix: 16);
    if (parsed == null) return fallback;
    return PdfColor.fromInt(parsed);
  }
}
