import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../models/currency.dart';
import '../../providers/auth_provider.dart';
import '../../providers/currencies_provider.dart';
import '../../utils/theme.dart';

class CurrenciesScreen extends StatelessWidget {
  const CurrenciesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.currencies ?? 'العملات'),
      ),
      body: Consumer<CurrenciesProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.currencies.isEmpty) {
            return Center(
              child: Text(l10n?.noCurrencies ?? 'لا توجد عملات'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.currencies.length,
            itemBuilder: (context, index) {
              final currency = provider.currencies[index];
              return _CurrencyCard(currency: currency);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCurrencyDialog(context),
        icon: const Icon(Icons.add),
        label: Text(l10n?.addCurrency ?? 'إضافة عملة'),
      ),
    );
  }

  void _showCurrencyDialog(BuildContext context, {Currency? currency}) {
    final l10n = AppLocalizations.of(context);
    final isEditing = currency != null;
    final nameController = TextEditingController(text: currency?.name ?? '');
    final codeController = TextEditingController(text: currency?.code ?? '');
    final symbolController = TextEditingController(text: currency?.symbol ?? '');
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEditing
            ? (l10n?.editCurrency ?? 'تعديل العملة')
            : (l10n?.addCurrency ?? 'إضافة عملة')),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: l10n?.currencyName ?? 'اسم العملة',
                  hintText: 'مثال: دولار أمريكي',
                  prefixIcon: const Icon(Icons.label_outlined),
                ),
                validator: (v) => v == null || v.isEmpty
                    ? (l10n?.requiredField ?? 'حقل مطلوب')
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: codeController,
                decoration: InputDecoration(
                  labelText: l10n?.currencyCode ?? 'رمز العملة',
                  hintText: 'مثال: USD',
                  prefixIcon: const Icon(Icons.code),
                ),
                textCapitalization: TextCapitalization.characters,
                validator: (v) => v == null || v.isEmpty
                    ? (l10n?.requiredField ?? 'حقل مطلوب')
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: symbolController,
                decoration: InputDecoration(
                  labelText: l10n?.currencySymbol ?? 'رمز العملة',
                  hintText: 'مثال: \$',
                  prefixIcon: const Icon(Icons.attach_money),
                ),
                validator: (v) => v == null || v.isEmpty
                    ? (l10n?.requiredField ?? 'حقل مطلوب')
                    : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n?.cancel ?? 'إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;

              final authProvider = Provider.of<AuthProvider>(context, listen: false);
              final currenciesProvider = Provider.of<CurrenciesProvider>(context, listen: false);
              final trainerId = authProvider.trainerId ?? 1;

              if (isEditing) {
                await currenciesProvider.updateCurrency(currency!.copyWith(
                  name: nameController.text,
                  code: codeController.text,
                  symbol: symbolController.text,
                ));
              } else {
                await currenciesProvider.createCurrency(Currency(
                  trainerId: trainerId,
                  name: nameController.text,
                  code: codeController.text,
                  symbol: symbolController.text,
                ));
              }

              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(isEditing ? 'تم تحديث العملة' : 'تم إضافة العملة'),
                    backgroundColor: AppTheme.success,
                  ),
                );
              }
            },
            child: Text(isEditing
                ? (l10n?.saveChanges ?? 'حفظ التغييرات')
                : (l10n?.add ?? 'إضافة')),
          ),
        ],
      ),
    );
  }
}

class _CurrencyCard extends StatelessWidget {
  final Currency currency;

  const _CurrencyCard({required this.currency});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final currenciesProvider = Provider.of<CurrenciesProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: currency.isDefault
            ? const BorderSide(color: AppTheme.primaryColor, width: 1.5)
            : BorderSide.none,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: currency.isDefault
                ? AppTheme.primaryColor.withOpacity(0.2)
                : AppTheme.surfaceColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              currency.symbol,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: currency.isDefault ? AppTheme.primaryColor : AppTheme.textPrimary,
              ),
            ),
          ),
        ),
        title: Text(
          currency.name,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          currency.code,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (currency.isDefault)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  l10n?.defaultLabel ?? 'افتراضي',
                  style: const TextStyle(
                    color: AppTheme.primaryColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            else
              IconButton(
                icon: const Icon(Icons.star_border, color: AppTheme.textSecondary),
                tooltip: l10n?.setAsDefault ?? 'تعيين كافتراضي',
                onPressed: () async {
                  final trainerId = authProvider.trainerId ?? 1;
                  await currenciesProvider.setDefault(trainerId, currency.id!);
                },
              ),
            PopupMenuButton<String>(
              onSelected: (value) async {
                if (value == 'set_default') {
                  final trainerId = authProvider.trainerId ?? 1;
                  await currenciesProvider.setDefault(trainerId, currency.id!);
                } else if (value == 'edit') {
                  // Access the parent widget's method through context
                  final screen = context.findAncestorWidgetOfExactType<CurrenciesScreen>();
                  if (screen != null) {
                    // Reconstruct the dialog - simpler to just call it inline
                    _showEditDialog(context, currency);
                  }
                } else if (value == 'delete') {
                  final success = await currenciesProvider.deleteCurrency(currency.id!);
                  if (!success && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(currenciesProvider.error ?? l10n?.currencyInUse ?? 'لا يمكن حذف عملة مستخدمة'),
                        backgroundColor: AppTheme.error,
                      ),
                    );
                  }
                }
              },
              itemBuilder: (context) => [
                if (!currency.isDefault)
                  PopupMenuItem(
                    value: 'set_default',
                    child: Row(
                      children: [
                        const Icon(Icons.star, size: 18),
                        const SizedBox(width: 8),
                        Text(l10n?.setAsDefault ?? 'تعيين كافتراضي'),
                      ],
                    ),
                  ),
                PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      const Icon(Icons.edit_outlined, size: 20),
                      const SizedBox(width: 8),
                      Text(l10n?.edit ?? 'تعديل'),
                    ],
                  ),
                ),
                if (!currency.isDefault)
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        const Icon(Icons.delete_outline, color: AppTheme.error, size: 20),
                        const SizedBox(width: 8),
                        Text(l10n?.delete ?? 'حذف', style: const TextStyle(color: AppTheme.error)),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, Currency currency) {
    final l10n = AppLocalizations.of(context);
    final nameController = TextEditingController(text: currency.name);
    final codeController = TextEditingController(text: currency.code);
    final symbolController = TextEditingController(text: currency.symbol);
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n?.editCurrency ?? 'تعديل العملة'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: l10n?.currencyName ?? 'اسم العملة',
                  prefixIcon: const Icon(Icons.label_outlined),
                ),
                validator: (v) => v == null || v.isEmpty ? (l10n?.requiredField ?? 'حقل مطلوب') : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: codeController,
                decoration: InputDecoration(
                  labelText: l10n?.currencyCode ?? 'رمز العملة',
                  prefixIcon: const Icon(Icons.code),
                ),
                textCapitalization: TextCapitalization.characters,
                validator: (v) => v == null || v.isEmpty ? (l10n?.requiredField ?? 'حقل مطلوب') : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: symbolController,
                decoration: InputDecoration(
                  labelText: l10n?.currencySymbol ?? 'رمز العملة',
                  prefixIcon: const Icon(Icons.attach_money),
                ),
                validator: (v) => v == null || v.isEmpty ? (l10n?.requiredField ?? 'حقل مطلوب') : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n?.cancel ?? 'إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;
              final currenciesProvider = Provider.of<CurrenciesProvider>(context, listen: false);
              await currenciesProvider.updateCurrency(currency.copyWith(
                name: nameController.text,
                code: codeController.text,
                symbol: symbolController.text,
              ));
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم تحديث العملة'), backgroundColor: AppTheme.success),
                );
              }
            },
            child: Text(l10n?.saveChanges ?? 'حفظ التغييرات'),
          ),
        ],
      ),
    );
  }
}
