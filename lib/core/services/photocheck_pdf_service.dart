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
    return pw.Container(
      decoration: pw.BoxDecoration(
        color: PdfColors.white,
        border: pw.Border.all(color: PdfColors.black, width: 1.5),
      ),
      padding: pw.EdgeInsets.all(6 * _mm),
      child: pw.Column(
        children: [
          pw.Image(logo, width: 34 * _mm, height: 11 * _mm, fit: pw.BoxFit.contain),
          pw.Spacer(),
          pw.Container(
            width: 29 * _mm,
            height: 29 * _mm,
            child: pw.BarcodeWidget(
              data: qrData,
              barcode: pw.Barcode.qrCode(),
              color: PdfColors.black,
              backgroundColor: PdfColors.white,
              width: 29 * _mm,
              height: 29 * _mm,
              drawText: false,
            ),
          ),
          pw.Spacer(),
          pw.Text(
            lastName.toUpperCase(),
            maxLines: 1,
            overflow: pw.TextOverflow.clip,
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(
              font: fontSemiBold,
              fontSize: 9,
              color: PdfColors.grey700,
            ),
          ),
        ],
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
    return pw.ClipRect(
      child: pw.Stack(
        fit: pw.StackFit.expand,
        children: [
          pw.Image(background, fit: pw.BoxFit.cover),
          pw.CustomPaint(
            painter: (canvas, size) => _paintFrontShapes(canvas, size, primary, secondary),
          ),
          pw.Padding(
            padding: pw.EdgeInsets.all(4.5 * _mm),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Expanded(
                      child: pw.Text(
                        schoolName.toUpperCase(),
                        style: pw.TextStyle(
                          font: fontBold,
                          fontSize: 6.5,
                          color: PdfColors.grey800,
                        ),
                      ),
                    ),
                    if (schoolLogo != null)
                      pw.SizedBox(
                        width: 16 * _mm,
                        height: 16 * _mm,
                        child: pw.Image(schoolLogo, fit: pw.BoxFit.contain),
                      ),
                  ],
                ),
                pw.SizedBox(height: 3 * _mm),
                pw.Container(
                  width: w,
                  padding: pw.EdgeInsets.symmetric(horizontal: 3 * _mm, vertical: 2.5 * _mm),
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
                          fontSize: 10,
                          color: PdfColors.grey800,
                        ),
                      ),
                      pw.SizedBox(height: 1.5 * _mm),
                      _buildInfoRow('Nivel', level, fontSemiBold),
                      _buildInfoRow('Grado', degree, fontSemiBold),
                      _buildInfoRow('Sección', section, fontSemiBold),
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
                      borderRadius: pw.BorderRadius.circular(2 * _mm),
                    ),
                    child: pw.SizedBox(
                      width: 29 * _mm,
                      height: 29 * _mm,
                      child: pw.BarcodeWidget(
                        data: qrData,
                        barcode: pw.Barcode.qrCode(),
                        color: PdfColors.black,
                        backgroundColor: PdfColors.white,
                        width: 29 * _mm,
                        height: 29 * _mm,
                        drawText: false,
                      ),
                    ),
                  ),
                ),
                pw.Spacer(),
                pw.Center(
                  child: pw.Text(
                    schoolLema,
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(
                      font: fontSemiBold,
                      fontSize: 7,
                      color: PdfColors.grey800,
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
    return pw.ClipRect(
      child: pw.Stack(
        fit: pw.StackFit.expand,
        children: [
          pw.Image(background, fit: pw.BoxFit.cover),
          pw.CustomPaint(
            painter: (canvas, size) => _paintBackShapes(canvas, size, primary, secondary),
          ),
          pw.Padding(
            padding: pw.EdgeInsets.fromLTRB(4.5 * _mm, 10 * _mm, 4.5 * _mm, 4.5 * _mm),
            child: pw.Column(
              children: [
                pw.Text(
                  schoolName.toUpperCase(),
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
                    borderRadius: pw.BorderRadius.circular(2 * _mm),
                  ),
                  child: pw.Column(
                    mainAxisSize: pw.MainAxisSize.min,
                    children: [
                      pw.Transform(
                        transform: Matrix4.diagonal3Values(-1, 1, 1),
                        alignment: pw.Alignment.center,
                        child: pw.SizedBox(
                          width: 29 * _mm,
                          height: 29 * _mm,
                          child: pw.BarcodeWidget(
                            data: qrData,
                            barcode: pw.Barcode.qrCode(),
                            color: PdfColors.black,
                            backgroundColor: PdfColors.white,
                            width: 29 * _mm,
                            height: 29 * _mm,
                            drawText: false,
                          ),
                        ),
                      ),
                      pw.Text(
                        prefix,
                        style: pw.TextStyle(
                          font: fontSemiBold,
                          fontSize: 6,
                          color: PdfColors.grey800,
                        ),
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 4 * _mm),
                pw.Image(
                  colecheckLogo,
                  width: 30 * _mm,
                  height: 9 * _mm,
                  fit: pw.BoxFit.contain,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildInfoRow(String label, String value, pw.Font font) {
    return pw.Padding(
      padding: pw.EdgeInsets.symmetric(vertical: 0.5 * _mm),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.center,
        children: [
          pw.Text(
            '$label: ',
            style: pw.TextStyle(font: font, fontSize: 6.5, color: PdfColors.grey800),
          ),
          pw.Text(
            value,
            style: pw.TextStyle(font: font, fontSize: 6.5, color: PdfColors.grey800),
          ),
        ],
      ),
    );
  }

  static void _paintFrontShapes(PdfGraphics canvas, PdfPoint size, PdfColor primary, PdfColor secondary) {
    final w = size.x;
    final h = size.y;

    void rect(PdfColor color, double tx, double ty, double angle, double rw, double rh) {
      canvas
        ..saveContext()
        ..setColor(color)
        ..setTransform(Matrix4.translationValues(tx, ty, 0))
        ..setTransform(Matrix4.rotationZ(angle))
        ..drawRect(-rw / 2, -rh / 2, rw, rh)
        ..restoreContext();
    }

    rect(primary, w * 0.95, h * 1.05, -0.52, w * 1.2, w * 1.2);
    rect(secondary, w * 0.5, h * 0.92, 0.17, w * 1.6, w * 1.6);
    rect(secondary, w * 0.05, h * 0.18, 0, w * 1.0, w * 1.0);
    rect(primary, w * 0.55, h * 0.1, 0.78, w * 1.2, w * 1.2);
    rect(primary, w * 0.22, h * 1.6, -1.48, w * 1.1, w * 1.1);

    canvas
      ..saveContext()
      ..setColor(secondary)
      ..setTransform(Matrix4.translationValues(w * 0.35, h * 0.95, 0))
      ..setTransform(Matrix4.rotationZ(-0.61))
      ..moveTo(0, 0)
      ..lineTo(w * 0.7, w * 0.7)
      ..strokePath()
      ..restoreContext();
  }

  static void _paintBackShapes(PdfGraphics canvas, PdfPoint size, PdfColor primary, PdfColor secondary) {
    final w = size.x;
    final h = size.y;

    void rect(PdfColor color, double tx, double ty, double angle, double rw, double rh) {
      canvas
        ..saveContext()
        ..setColor(color)
        ..setTransform(Matrix4.translationValues(tx, ty, 0))
        ..setTransform(Matrix4.rotationZ(angle))
        ..drawRect(-rw / 2, -rh / 2, rw, rh)
        ..restoreContext();
    }

    rect(primary, w * 1.1, h * 0.2, 1.05, w * 1.0, w * 1.0);
    rect(secondary, w * 1.35, h * 0.55, 1.92, w * 1.6, w * 1.6);
    rect(primary, w * 0.55, h * 0.35, 1.57, w * 0.9, w * 0.9);
    rect(primary, w * 1.15, h * 0.85, 1.57, w * 0.9, w * 0.9);

    canvas
      ..saveContext()
      ..setColor(secondary)
      ..setTransform(Matrix4.translationValues(w * 0.85, h * 0.35, 0))
      ..setTransform(Matrix4.rotationZ(1.13))
      ..moveTo(0, 0)
      ..lineTo(w * 0.8, w * 0.8)
      ..strokePath()
      ..restoreContext();
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
