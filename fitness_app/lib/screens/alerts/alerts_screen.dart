import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../models/subscription.dart';
import '../../providers/subscriptions_provider.dart';
import '../../providers/players_provider.dart';
import '../../providers/workout_plans_provider.dart';
import '../../providers/currencies_provider.dart';
import '../../utils/theme.dart';
import '../../utils/date_helpers.dart';
import '../subscriptions/subscription_form_screen.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n?.alerts ?? 'التنبيهات'),
          bottom: TabBar(
            indicatorColor: AppTheme.primaryColor,
            labelColor: AppTheme.primaryColor,
            unselectedLabelColor: AppTheme.textSecondary,
            tabs: [
              Tab(
                icon: const Icon(Icons.money_off),
                text: l10n?.unpaidSubscriptions ?? 'غير مدفوع',
              ),
              Tab(
                icon: const Icon(Icons.refresh),
                text: l10n?.needsRenewal ?? 'تجديد',
              ),
            ],
          ),
        ),
        body: Consumer<SubscriptionsProvider>(
          builder: (context, provider, child) {
            return TabBarView(
              children: [
                _UnpaidTab(subscriptions: provider.unpaidSubscriptions),
                _RenewalTab(subscriptions: provider.needsRenewal),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _UnpaidTab extends StatelessWidget {
  final List<Subscription> subscriptions;

  const _UnpaidTab({required this.subscriptions});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    if (subscriptions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_outline, size: 64, color: AppTheme.success.withOpacity(0.5)),
            const SizedBox(height: 16),
            Text(
              l10n?.noAlerts ?? 'لا توجد تنبيهات',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: subscriptions.length,
      itemBuilder: (context, index) {
        return _UnpaidCard(subscription: subscriptions[index]);
      },
    );
  }
}

class _UnpaidCard extends StatelessWidget {
  final Subscription subscription;

  const _UnpaidCard({required this.subscription});

  @override
  Widget build(BuildContext context) {
    final playersProvider = Provider.of<PlayersProvider>(context);
    final plansProvider = Provider.of<WorkoutPlansProvider>(context);
    final subscriptionsProvider = Provider.of<SubscriptionsProvider>(context, listen: false);
    final l10n = AppLocalizations.of(context);

    final player = playersProvider.getById(subscription.playerId);
    final plan = plansProvider.getById(subscription.planId);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: AppTheme.warning.withOpacity(0.05),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppTheme.warning.withOpacity(0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppTheme.warning.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.money_off, color: AppTheme.warning),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        player?.name ?? l10n?.unknownPlayer ?? 'لاعب غير معروف',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        plan?.name ?? l10n?.unknownPlan ?? 'خطة غير معروفة',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppTheme.warning.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    l10n?.unpaid ?? 'غير مدفوع',
                    style: const TextStyle(
                      color: AppTheme.warning,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.date_range, size: 14, color: AppTheme.textSecondary),
                const SizedBox(width: 6),
                Text(
                  '${DateHelpers.formatShortDate(subscription.startDate)} - ${DateHelpers.formatShortDate(subscription.endDate)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RenewalTab extends StatelessWidget {
  final List<Subscription> subscriptions;

  const _RenewalTab({required this.subscriptions});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    if (subscriptions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_outline, size: 64, color: AppTheme.success.withOpacity(0.5)),
            const SizedBox(height: 16),
            Text(
              l10n?.noAlerts ?? 'لا توجد تنبيهات',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: subscriptions.length,
      itemBuilder: (context, index) {
        return _RenewalCard(subscription: subscriptions[index]);
      },
    );
  }
}

class _RenewalCard extends StatelessWidget {
  final Subscription subscription;

  const _RenewalCard({required this.subscription});

  @override
  Widget build(BuildContext context) {
    final playersProvider = Provider.of<PlayersProvider>(context);
    final plansProvider = Provider.of<WorkoutPlansProvider>(context);
    final l10n = AppLocalizations.of(context);

    final player = playersProvider.getById(subscription.playerId);
    final plan = plansProvider.getById(subscription.planId);
    final daysOverdue = DateTime.now().difference(subscription.endDate).inDays;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: AppTheme.error.withOpacity(0.05),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppTheme.error.withOpacity(0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppTheme.error.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.refresh, color: AppTheme.error),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        player?.name ?? l10n?.unknownPlayer ?? 'لاعب غير معروف',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        plan?.name ?? l10n?.unknownPlan ?? 'خطة غير معروفة',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppTheme.error.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${l10n?.overdue ?? "متأخر"} $daysOverdue ${l10n?.daysUnit ?? "يوم"}',
                    style: const TextStyle(
                      color: AppTheme.error,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.event_busy, size: 14, color: AppTheme.textSecondary),
                const SizedBox(width: 6),
                Text(
                  '${l10n?.expiredOn ?? "انتهى في"}: ${DateHelpers.formatShortDate(subscription.endDate)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => SubscriptionFormScreen(
                        playerId: subscription.playerId,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.refresh),
                label: Text(l10n?.renewSubscription ?? 'تجديد الاشتراك'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
