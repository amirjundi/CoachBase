import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/subscription.dart';
import '../../providers/auth_provider.dart';
import '../../providers/subscriptions_provider.dart';
import '../../providers/players_provider.dart';
import '../../providers/workout_plans_provider.dart';
import '../../providers/currencies_provider.dart';
import '../../utils/theme.dart';
import '../../utils/date_helpers.dart';
import '../../utils/constants.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import '../../services/notification_service.dart';

class SubscriptionFormScreen extends StatefulWidget {
  final int? playerId;
  final Subscription? subscription;

  const SubscriptionFormScreen({
    super.key, 
    this.playerId,
    this.subscription,
  });

  @override
  State<SubscriptionFormScreen> createState() => _SubscriptionFormScreenState();
}

class _SubscriptionFormScreenState extends State<SubscriptionFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();
  
  int? _selectedPlayerId;
  int? _selectedPlanId;
  int? _selectedCurrencyId;
  DateTime _startDate = DateTime.now();
  
  int _durationMonths = 1; // 1, 3, 6, 12. 0 for week. -1 for custom.
  DateTime? _customEndDate;
  
  bool _isLoading = false;
  bool _playerHasActiveSub = false;

  bool get isEditing => widget.subscription != null;

  @override
  void initState() {
    super.initState();
    _selectedPlayerId = widget.playerId ?? widget.subscription?.playerId;
    
    if (isEditing) {
      _selectedPlanId = widget.subscription!.planId;
      _selectedCurrencyId = widget.subscription!.currencyId;
      _startDate = widget.subscription!.startDate;
      _amountController.text = widget.subscription!.amountPaid?.toString() ?? '';
      _notesController.text = widget.subscription!.paymentNotes ?? '';
      
      // Calculate duration from dates
      final diffDays = widget.subscription!.endDate.difference(widget.subscription!.startDate).inDays;
      if (diffDays == 7) {
        _durationMonths = 0; // week
      } else {
        final months = widget.subscription!.endDate.month - widget.subscription!.startDate.month + 
            (widget.subscription!.endDate.year - widget.subscription!.startDate.year) * 12;
        if (months == 1 || months == 3 || months == 6 || months == 12) {
          _durationMonths = months;
        } else {
          _durationMonths = -1; // custom
          _customEndDate = widget.subscription!.endDate;
        }
      }
    }

    // Set default currency
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currenciesProvider = Provider.of<CurrenciesProvider>(context, listen: false);
      if (_selectedCurrencyId == null && currenciesProvider.defaultCurrency != null) {
        setState(() {
          _selectedCurrencyId = currenciesProvider.defaultCurrency!.id;
        });
      }
      // Check if selected player already has active sub
      if (_selectedPlayerId != null && !isEditing) {
        _checkPlayerSubscription(_selectedPlayerId!);
      }
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  DateTime get _endDate {
    if (_durationMonths == -1 && _customEndDate != null) {
      return _customEndDate!;
    } else if (_durationMonths == 0) {
      return _startDate.add(const Duration(days: 7));
    }
    return DateHelpers.addMonths(_startDate, _durationMonths);
  }

  Future<void> _checkPlayerSubscription(int playerId) async {
    final subscriptionsProvider = Provider.of<SubscriptionsProvider>(context, listen: false);
    final hasActive = await subscriptionsProvider.hasActiveSubscription(playerId);
    setState(() {
      _playerHasActiveSub = hasActive;
    });
  }

  Future<void> _selectStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppTheme.primaryColor,
              surface: AppTheme.surfaceColor,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
        // Reset custom end date if it is before new start date
        if (_customEndDate != null && _customEndDate!.isBefore(_startDate)) {
          _customEndDate = _startDate.add(const Duration(days: 1));
        }
      });
    }
  }

  Future<void> _selectCustomEndDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _customEndDate ?? _startDate.add(const Duration(days: 30)),
      firstDate: _startDate.add(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
    );
    if (picked != null) {
      setState(() {
        _customEndDate = picked;
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (_selectedPlayerId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('الرجاء اختيار لاعب'),
          backgroundColor: AppTheme.error,
        ),
      );
      return;
    }
    
    if (_selectedPlanId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('الرجاء اختيار خطة تمرين'),
          backgroundColor: AppTheme.error,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final subscriptionsProvider = Provider.of<SubscriptionsProvider>(context, listen: false);

    final subscription = Subscription(
      id: widget.subscription?.id,
      playerId: _selectedPlayerId!,
      planId: _selectedPlanId!,
      startDate: _startDate,
      endDate: _endDate,
      status: Subscription.statusActive,
      amountPaid: _amountController.text.isEmpty 
          ? null 
          : double.tryParse(_amountController.text),
      paymentNotes: _notesController.text.isEmpty ? null : _notesController.text,
      currencyId: _selectedCurrencyId,
      createdAt: widget.subscription?.createdAt,
    );

    bool success;
    Subscription? newSub;
    if (isEditing) {
      success = await subscriptionsProvider.updateSubscription(subscription);
    } else {
      newSub = await subscriptionsProvider.createSubscription(subscription);
      success = newSub != null;
    }

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (success) {
      // Schedule notifications
      final playersProvider = Provider.of<PlayersProvider>(context, listen: false);
      final player = playersProvider.getById(subscription.playerId);
      if (player != null && (isEditing ? true : (newSub != null))) {
        final savedSub = isEditing ? subscription : newSub!;
        await NotificationService.instance.scheduleSubscriptionAlerts(savedSub, player.name);
      }

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isEditing ? 'تم تحديث الاشتراك' : 'تم إنشاء الاشتراك'),
            backgroundColor: AppTheme.success,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(subscriptionsProvider.error ?? 'فشل حفظ الاشتراك'),
          backgroundColor: AppTheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final playersProvider = Provider.of<PlayersProvider>(context);
    final plansProvider = Provider.of<WorkoutPlansProvider>(context);
    final currenciesProvider = Provider.of<CurrenciesProvider>(context);
    final subscriptionsProvider = Provider.of<SubscriptionsProvider>(context);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'تعديل الاشتراك' : 'اشتراك جديد'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Player Selection
            Text(
              l10n?.selectPlayerTitle ?? 'اختر اللاعب',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<int>(
              value: _selectedPlayerId,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.person_outlined),
                hintText: l10n?.choosePlayer ?? 'اختر لاعباً',
              ),
              items: playersProvider.players.map((player) {
                // Check if player has active subscription
                final activeSub = subscriptionsProvider.subscriptions
                    .where((s) => s.playerId == player.id && s.isActive)
                    .isNotEmpty;
                return DropdownMenuItem(
                  value: player.id,
                  child: Row(
                    children: [
                      Expanded(child: Text(player.name)),
                      if (activeSub)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppTheme.success,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: widget.playerId == null ? (value) {
                setState(() => _selectedPlayerId = value);
                if (value != null && !isEditing) {
                  _checkPlayerSubscription(value);
                }
              } : null,
            ),
            // Active subscription warning
            if (_playerHasActiveSub && !isEditing) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.warning.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.warning.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning_amber_rounded, color: AppTheme.warning, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'هذا اللاعب لديه اشتراك نشط بالفعل',
                        style: TextStyle(color: AppTheme.warning, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 24),

            // Plan Selection
            Text(
              l10n?.selectPlanTitle ?? 'اختر خطة التمرين',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<int>(
              value: _selectedPlanId,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.fitness_center_outlined),
                hintText: l10n?.choosePlan ?? 'اختر خطة',
              ),
              items: plansProvider.plans.where((p) => p.isActive).map((plan) {
                return DropdownMenuItem(
                  value: plan.id,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(plan.name),
                      Text(
                        plan.difficultyLevel,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => _selectedPlanId = value);
              },
            ),
            const SizedBox(height: 24),

            // Duration
            Text(
              l10n?.subscriptionDuration ?? 'مدة الاشتراك',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: Constants.subscriptionDurations.map((duration) {
                final months = duration['months'] as int;
                final isSelected = _durationMonths == months;
                return ChoiceChip(
                  label: Text(duration['label'] as String), 
                  selected: isSelected,
                  onSelected: (_) {
                    setState(() {
                      _durationMonths = months;
                      if (months == -1 && _customEndDate == null) {
                        _customEndDate = _startDate.add(const Duration(days: 30));
                      }
                    });
                  },
                  selectedColor: AppTheme.primaryColor,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.black : AppTheme.textPrimary,
                  ),
                );
              }).toList(),
            ),
            if (_durationMonths == -1) ...[
              const SizedBox(height: 16),
              Text(
                'تاريخ الانتهاء المخصص', // Custom End Date
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: _selectCustomEndDate,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF3A3A3A)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.event, color: AppTheme.primaryColor),
                      const SizedBox(width: 12),
                      Text(
                        _customEndDate != null ? DateHelpers.formatDate(_customEndDate!) : 'اختر تاريخ الانتهاء',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 24),

            // Start Date
            Text(
              l10n?.startDate ?? 'تاريخ البدء',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: _selectStartDate,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF3A3A3A)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, color: AppTheme.textSecondary),
                    const SizedBox(width: 12),
                    Text(
                      DateHelpers.formatDate(_startDate),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const Spacer(),
                    const Icon(Icons.edit, size: 18, color: AppTheme.textSecondary),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // End Date (calculated)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.primaryColor.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.event, color: AppTheme.primaryColor),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n?.endDate ?? 'تاريخ الانتهاء',
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        DateHelpers.formatDate(_endDate),
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Payment (optional)
            Text(
              l10n?.paymentOptional ?? 'الدفع (اختياري)',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),

            // Currency selector
            DropdownButtonFormField<int>(
              value: _selectedCurrencyId,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.currency_exchange),
                hintText: l10n?.selectCurrency ?? 'اختر العملة',
              ),
              items: currenciesProvider.currencies.map((currency) {
                return DropdownMenuItem(
                  value: currency.id,
                  child: Text('${currency.name} (${currency.symbol})'),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => _selectedCurrencyId = value);
              },
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: l10n?.amount ?? 'المبلغ',
                prefixIcon: _selectedCurrencyId != null
                    ? Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          currenciesProvider.getById(_selectedCurrencyId)?.symbol ?? '',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      )
                    : const Icon(Icons.attach_money),
                hintText: '0.00',
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notesController,
              maxLines: 2,
              decoration: InputDecoration(
                labelText: l10n?.paymentNotes ?? 'ملاحظات الدفع',
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(bottom: 24),
                  child: Icon(Icons.notes_outlined),
                ),
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 32),

            // Save Button
            ElevatedButton(
              onPressed: (_isLoading || (_playerHasActiveSub && !isEditing)) ? null : _save,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                      ),
                    )
                  : Text(isEditing 
                      ? (l10n?.saveChanges ?? 'حفظ التغييرات')
                      : (l10n?.createSubscription ?? 'إنشاء اشتراك')),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
