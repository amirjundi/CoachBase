import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart' show rootBundle;
import 'package:fitness_app/utils/date_helpers.dart';

import '../models/workout_plan.dart';
import '../models/plan_day.dart';
import '../models/day_exercise.dart';
import '../models/player.dart';

class PdfService {
  static pw.Font? _arabicFont;
  static pw.Font? _arabicBoldFont;
  static bool _fontsLoaded = false;

  /// Load fonts from bundled assets
  static Future<void> ensureFontsLoaded() async {
    if (_fontsLoaded) return;
    
    try {
      final fontData = await rootBundle.load('assets/fonts/Amiri-Regular.ttf');
      final boldFontData = await rootBundle.load('assets/fonts/Amiri-Bold.ttf');
      
      _arabicFont = pw.Font.ttf(fontData);
      _arabicBoldFont = pw.Font.ttf(boldFontData);
      _fontsLoaded = true;
    } catch (e) {
      print('Error loading fonts: $e');
      // Fallback only if asset load fails drastically
      _arabicFont = pw.Font.helvetica();
      _arabicBoldFont = pw.Font.helveticaBold();
    }
  }

  Future<Uint8List> generatePlanPdf(WorkoutPlan plan, List<PlanDay> days, {Player? player}) async {
    await ensureFontsLoaded();
    
    final pdf = pw.Document();
    
    // Use the potentially-loaded Arabic font, or fallback
    final theme = pw.ThemeData.withFont(
      base: _arabicFont!,
      bold: _arabicBoldFont!,
    );

    // Create header page
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        textDirection: pw.TextDirection.rtl, // RTL is critical for Arabic
        theme: theme,
        build: (pw.Context context) {
          return _buildHeader(plan, player, days.length);
        },
      ),
    );

    // Create separate page for each day
    for (final day in days) {
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          textDirection: pw.TextDirection.rtl,
          theme: theme,
          build: (pw.Context context) {
            return _buildDayPage(day, plan.name);
          },
        ),
      );
    }

    return pdf.save();
  }

  pw.Widget _buildHeader(WorkoutPlan plan, Player? player, int totalDays) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      mainAxisAlignment: pw.MainAxisAlignment.center,
      children: [
        pw.SizedBox(height: 100),
        pw.Text(
          plan.name,
          style: pw.TextStyle(fontSize: 32, fontWeight: pw.FontWeight.bold),
          textAlign: pw.TextAlign.center,
        ),
        pw.SizedBox(height: 30),
        if (player != null) ...[
          pw.Container(
            padding: const pw.EdgeInsets.all(20),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey400),
              borderRadius: pw.BorderRadius.circular(8),
            ),
            child: pw.Column(
              children: [
                pw.Text(
                  player.name,
                  style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 15),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                    if (player.weight != null)
                      pw.Container(
                        padding: const pw.EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                        decoration: pw.BoxDecoration(
                          color: PdfColors.blue50,
                          borderRadius: pw.BorderRadius.circular(4),
                        ),
                        child: pw.Text(
                          'الوزن: ${player.weight} كغ',
                          style: const pw.TextStyle(fontSize: 14),
                        ),
                      ),
                    if (player.weight != null && player.height != null)
                      pw.SizedBox(width: 20),
                    if (player.height != null)
                      pw.Container(
                        padding: const pw.EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                        decoration: pw.BoxDecoration(
                          color: PdfColors.green50,
                          borderRadius: pw.BorderRadius.circular(4),
                        ),
                        child: pw.Text(
                          'الطول: ${player.height} سم',
                          style: const pw.TextStyle(fontSize: 14),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
        pw.SizedBox(height: 30),
        if (plan.description != null && plan.description!.isNotEmpty) ...[
          pw.Text(
            plan.description!,
            style: const pw.TextStyle(fontSize: 14),
            textAlign: pw.TextAlign.center,
          ),
          pw.SizedBox(height: 20),
        ],
        pw.Container(
          padding: const pw.EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: pw.BoxDecoration(
            color: PdfColors.teal50,
            borderRadius: pw.BorderRadius.circular(4),
          ),
          child: pw.Text(
            'عدد الأيام: $totalDays',
            style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
          ),
        ),
        pw.SizedBox(height: 20),
        pw.Text(
          plan.difficultyLevel,
          style: const pw.TextStyle(fontSize: 14, color: PdfColors.grey700),
        ),
      ],
    );
  }

  pw.Widget _buildDayPage(PlanDay day, String planName) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        // Day Header
        pw.Container(
          padding: const pw.EdgeInsets.all(15),
          decoration: pw.BoxDecoration(
            color: day.isRestDay ? PdfColors.orange100 : PdfColors.blue100,
            borderRadius: pw.BorderRadius.circular(8),
          ),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                'اليوم ${day.sequenceOrder}',
                style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold),
              ),
              if (day.isRestDay)
                pw.Container(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.orange,
                    borderRadius: pw.BorderRadius.circular(4),
                  ),
                  child: pw.Text(
                    'يوم راحة',
                    style: pw.TextStyle(
                      fontSize: 14,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.white,
                    ),
                  ),
                )
              else if (day.focusArea != null && day.focusArea!.isNotEmpty)
                pw.Text(
                  day.focusArea!,
                  style: const pw.TextStyle(fontSize: 14, color: PdfColors.grey700),
                ),
            ],
          ),
        ),
        pw.SizedBox(height: 20),

        // Exercises Table
        if (!day.isRestDay && day.exercises.isNotEmpty)
          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.grey400),
            columnWidths: {
              0: const pw.FlexColumnWidth(1.5), // Video
              1: const pw.FlexColumnWidth(2), // Notes
              2: const pw.FlexColumnWidth(2), // Sets/Reps
              3: const pw.FlexColumnWidth(3), // Exercise Name
            },
            children: [
              // Header Row (reversed for RTL: leftmost = Exercise)
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                children: [
                  _buildTableCell('فيديو', isHeader: true),
                  _buildTableCell('ملاحظات', isHeader: true),
                  _buildTableCell('المجموعات', isHeader: true),
                  _buildTableCell('التمرين', isHeader: true),
                ],
              ),
              // Exercise Rows
              ...day.exercises.map((ex) {
                return pw.TableRow(
                  children: [
                    _buildVideoLink(ex.youtubeUrl),
                    _buildTableCell(ex.notes ?? '-'),
                    _buildSetDetails(ex),
                    _buildTableCell(ex.exerciseName ?? 'تمرين'),
                  ],
                );
              }),
            ],
          )
        else if (!day.isRestDay)
          pw.Center(
            child: pw.Padding(
              padding: const pw.EdgeInsets.all(40),
              child: pw.Text(
                'لا توجد تمارين مضافة لهذا اليوم',
                style: const pw.TextStyle(fontSize: 14, color: PdfColors.grey600),
              ),
            ),
          )
        else
          pw.Center(
            child: pw.Padding(
              padding: const pw.EdgeInsets.all(60),
              child: pw.Column(
                children: [
                  pw.Text(
                    'استرح واستعد لليوم التالي',
                    style: const pw.TextStyle(fontSize: 18, color: PdfColors.grey700),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
  
  /// Convenience wrapper specifically for player workout exports
  Future<Uint8List> generatePlayerPlanPdf(Player player, WorkoutPlan plan, List<PlanDay> days) async {
    return generatePlanPdf(plan, days, player: player);
  }

  pw.Widget _buildTableCell(String text, {bool isHeader = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: isHeader ? 12 : 11,
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
      ),
    );
  }

  pw.Widget _buildSetDetails(DayExercise ex) {
    if (ex.sets.isEmpty) {
      return _buildTableCell('-');
    }
    
    final setsText = ex.sets.asMap().entries.map((entry) {
      final idx = entry.key + 1;
      final s = entry.value;
      return 'م$idx: ${s.reps} تكرار';
    }).join('\n');
    
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        setsText,
        style: const pw.TextStyle(fontSize: 10),
      ),
    );
  }

  pw.Widget _buildVideoLink(String? url) {
    if (url == null || url.isEmpty) {
      return _buildTableCell('-');
    }
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: pw.UrlLink(
        destination: url,
        child: pw.Text(
          'مشاهدة',
          style: const pw.TextStyle(
            fontSize: 11,
            color: PdfColors.blue700,
            decoration: pw.TextDecoration.underline,
          ),
        ),
      ),
    );
  }
}
