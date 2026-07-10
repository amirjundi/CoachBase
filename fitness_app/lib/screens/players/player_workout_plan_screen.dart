import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:printing/printing.dart';

import '../../l10n/app_localizations.dart';
import '../../models/player.dart';
import '../../models/workout_plan.dart';
import '../../providers/workout_plans_provider.dart';
import '../../services/pdf_service.dart';
import '../../utils/theme.dart';

class PlayerWorkoutPlanScreen extends StatefulWidget {
  final Player player;
  final WorkoutPlan plan;

  const PlayerWorkoutPlanScreen({
    super.key,
    required this.player,
    required this.plan,
  });

  @override
  State<PlayerWorkoutPlanScreen> createState() => _PlayerWorkoutPlanScreenState();
}

class _PlayerWorkoutPlanScreenState extends State<PlayerWorkoutPlanScreen> {
  bool _isLoading = true;
  bool _isExporting = false;

  @override
  void initState() {
    super.initState();
    _loadPlanDetails();
  }

  Future<void> _loadPlanDetails() async {
    final provider = Provider.of<WorkoutPlansProvider>(context, listen: false);
    await provider.loadPlanDetails(widget.plan.id!);
    setState(() => _isLoading = false);
  }

  String get _pdfFileName {
    final sanitized = widget.player.name.replaceAll(RegExp(r'[^\w\s]'), '').trim();
    return '${sanitized}_${widget.plan.name}.pdf';
  }

  Future<void> _showExportOptions(WorkoutPlan plan) async {
    final l10n = AppLocalizations.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surfaceColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.textSecondary.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                l10n?.pdfExportOptions ?? 'خيارات التصدير',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 24),
              
              // Share Option
              _ExportOption(
                icon: Icons.share,
                title: l10n?.share ?? 'مشاركة',
                subtitle: 'WhatsApp, Telegram, Email...',
                color: AppTheme.primaryColor,
                onTap: () {
                  Navigator.pop(context);
                  _sharePdf(plan);
                },
              ),
              const SizedBox(height: 12),
              
              // Download Option
              _ExportOption(
                icon: Icons.download,
                title: l10n?.download ?? 'تحميل',
                subtitle: l10n?.saveToDevice ?? 'حفظ في الجهاز',
                color: AppTheme.accentColor,
                onTap: () {
                  Navigator.pop(context);
                  _downloadPdf(plan);
                },
              ),
              const SizedBox(height: 12),
              
              // Print Option
              _ExportOption(
                icon: Icons.print,
                title: l10n?.printLabel ?? 'طباعة',
                subtitle: l10n?.systemPrintDialog ?? 'نافذة الطباعة',
                color: AppTheme.textSecondary,
                onTap: () {
                  Navigator.pop(context);
                  _printPdf(plan);
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _sharePdf(WorkoutPlan plan) async {
    setState(() => _isExporting = true);
    final pdfService = PdfService();
    final l10n = AppLocalizations.of(context);
    try {
      final pdfData = await pdfService.generatePlayerPlanPdf(
        widget.player, plan, plan.days,
      );
      await pdfService.sharePdf(pdfData, _pdfFileName);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n?.error ?? "خطأ"}: $e'),
            backgroundColor: AppTheme.error,
          ),
        );
      }
    }
    if (mounted) setState(() => _isExporting = false);
  }

  Future<void> _downloadPdf(WorkoutPlan plan) async {
    setState(() => _isExporting = true);
    final pdfService = PdfService();
    final l10n = AppLocalizations.of(context);
    try {
      final pdfData = await pdfService.generatePlayerPlanPdf(
        widget.player, plan, plan.days,
      );
      final filePath = await pdfService.savePdfToDevice(pdfData, _pdfFileName);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n?.fileSaved ?? "تم حفظ الملف في"}: $filePath'),
            backgroundColor: AppTheme.success,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n?.error ?? "خطأ"}: $e'),
            backgroundColor: AppTheme.error,
          ),
        );
      }
    }
    if (mounted) setState(() => _isExporting = false);
  }

  Future<void> _printPdf(WorkoutPlan plan) async {
    setState(() => _isExporting = true);
    final pdfService = PdfService();
    final l10n = AppLocalizations.of(context);
    try {
      final pdfData = await pdfService.generatePlayerPlanPdf(
        widget.player, plan, plan.days,
      );
      await Printing.layoutPdf(
        onLayout: (format) async => pdfData,
        name: _pdfFileName,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n?.error ?? "خطأ"}: $e'),
            backgroundColor: AppTheme.error,
          ),
        );
      }
    }
    if (mounted) setState(() => _isExporting = false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Consumer<WorkoutPlansProvider>(
      builder: (context, provider, child) {
        final plan = provider.selectedPlan ?? widget.plan;
        
        return Scaffold(
          appBar: AppBar(
            title: Text(l10n?.playerWorkoutPlan ?? 'خطة تمرين اللاعب'),
            actions: [
              if (_isExporting)
                const Padding(
                  padding: EdgeInsets.all(12),
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              else
                IconButton(
                  icon: const Icon(Icons.picture_as_pdf),
                  tooltip: l10n?.exportPdf ?? 'تصدير PDF',
                  onPressed: () => _showExportOptions(plan),
                ),
            ],
          ),
          body: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // Player Info Card
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                gradient: AppTheme.primaryGradient,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Center(
                                child: Text(
                                  widget.player.name.isNotEmpty 
                                      ? widget.player.name[0].toUpperCase() 
                                      : '?',
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.player.name,
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      if (widget.player.weight != null) ...[
                                        Icon(Icons.monitor_weight_outlined, size: 16, color: AppTheme.textSecondary),
                                        const SizedBox(width: 4),
                                        Text('${widget.player.weight} كغ'),
                                        const SizedBox(width: 16),
                                      ],
                                      if (widget.player.height != null) ...[
                                        Icon(Icons.height_outlined, size: 16, color: AppTheme.textSecondary),
                                        const SizedBox(width: 4),
                                        Text('${widget.player.height} سم'),
                                      ],
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Plan Info
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              plan.name,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (plan.description != null && plan.description!.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(plan.description!),
                              ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                plan.difficultyLevel,
                                style: const TextStyle(
                                  color: AppTheme.primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Days
                    Text(
                      l10n?.weeklySchedule ?? 'جدول التدريب',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    
                    ...plan.days.map((day) => Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ExpansionTile(
                        title: Text(
                          l10n?.day(day.sequenceOrder) ?? 'اليوم ${day.sequenceOrder}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: day.isRestDay 
                            ? Text(l10n?.restDay ?? 'راحة', style: const TextStyle(color: AppTheme.accentColor))
                            : Text('${day.exercises.length} ${l10n?.exercises ?? "تمرين"}'),
                        leading: Icon(
                          day.isRestDay ? Icons.hotel : Icons.fitness_center,
                          color: day.isRestDay ? AppTheme.accentColor : AppTheme.primaryColor,
                        ),
                        children: [
                          if (!day.isRestDay && day.exercises.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: day.exercises.asMap().entries.map((entry) {
                                  final idx = entry.key;
                                  final ex = entry.value;
                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: AppTheme.surfaceColor,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 28,
                                          height: 28,
                                          decoration: BoxDecoration(
                                            color: AppTheme.primaryColor.withOpacity(0.2),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Center(
                                            child: Text(
                                              '${idx + 1}',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: AppTheme.primaryColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                ex.exerciseName ?? 'تمرين',
                                                style: const TextStyle(fontWeight: FontWeight.w600),
                                              ),
                                              if (ex.sets.isNotEmpty)
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 4),
                                                  child: Text(
                                                    '${ex.sets.length} ${l10n?.sets ?? "مجموعات"}',
                                                    style: Theme.of(context).textTheme.bodySmall,
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                        ],
                      ),
                    )).toList(),

                    if (plan.days.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Text(
                            l10n?.noWorkoutDays ?? 'لا توجد أيام تمرين',
                            style: const TextStyle(color: AppTheme.textSecondary),
                          ),
                        ),
                      ),
                  ],
                ),
        );
      },
    );
  }
}

class _ExportOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _ExportOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: AppTheme.textSecondary, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
