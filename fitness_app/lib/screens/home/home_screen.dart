import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitness_app/l10n/app_localizations.dart';

import '../../providers/auth_provider.dart';
import '../../providers/players_provider.dart';
import '../../providers/workout_plans_provider.dart';
import '../../providers/exercises_provider.dart';
import '../../providers/subscriptions_provider.dart';
import '../../providers/lockers_provider.dart';
import '../../providers/currencies_provider.dart';
import '../../utils/theme.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/stat_card.dart';
import '../players/players_list_screen.dart';
import '../workout_plans/plans_list_screen.dart';
import '../exercises/exercises_list_screen.dart';
import '../subscriptions/subscriptions_list_screen.dart';
import '../lockers/lockers_list_screen.dart';
import '../alerts/alerts_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    _DashboardTab(),
    PlayersListScreen(),
    PlansListScreen(),
    ExercisesListScreen(),
    SubscriptionsListScreen(),
    LockersListScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final trainerId = authProvider.trainerId;
    
    if (trainerId != null) {
      final playersProvider = Provider.of<PlayersProvider>(context, listen: false);
      final plansProvider = Provider.of<WorkoutPlansProvider>(context, listen: false);
      final exercisesProvider = Provider.of<ExercisesProvider>(context, listen: false);
      final subscriptionsProvider = Provider.of<SubscriptionsProvider>(context, listen: false);
      final lockersProvider = Provider.of<LockersProvider>(context, listen: false);
      final currenciesProvider = Provider.of<CurrenciesProvider>(context, listen: false);

      await Future.wait([
        playersProvider.loadPlayers(trainerId),
        plansProvider.loadPlans(trainerId),
        exercisesProvider.loadExercises(trainerId),
        subscriptionsProvider.loadSubscriptions(trainerId),
        lockersProvider.loadLockers(trainerId),
        currenciesProvider.loadCurrencies(trainerId),
      ]);
    }
  }

  // Global key to access the drawer from child widgets
  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: AppDrawer(
        onNavigate: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.dashboard_outlined),
              activeIcon: const Icon(Icons.dashboard),
              label: AppLocalizations.of(context)?.dashboard ?? 'لوحة التحكم',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.people_outlined),
              activeIcon: const Icon(Icons.people),
              label: AppLocalizations.of(context)?.players ?? 'اللاعبين',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.fitness_center_outlined),
              activeIcon: const Icon(Icons.fitness_center),
              label: AppLocalizations.of(context)?.workoutPlans ?? 'خطة التمارين',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.sports_gymnastics_outlined),
              activeIcon: const Icon(Icons.sports_gymnastics),
              label: AppLocalizations.of(context)?.exercises ?? 'التمارين',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.card_membership_outlined),
              activeIcon: const Icon(Icons.card_membership),
              label: AppLocalizations.of(context)?.subscriptions ?? 'الاشتراكات',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.lock_outlined),
              activeIcon: const Icon(Icons.lock),
              label: AppLocalizations.of(context)?.lockers ?? 'الخزائن',
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardTab extends StatelessWidget {
  const _DashboardTab();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final trainer = authProvider.currentTrainer;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _HomeScreenState.scaffoldKey.currentState?.openDrawer(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n?.welcome ?? 'Welcome back,',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
            Text(
              trainer?.name ?? 'مدرب',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
        actions: [
          // Notification bell with alert badge
          Consumer<SubscriptionsProvider>(
            builder: (context, subsProvider, child) {
              final alertCount = subsProvider.alertCount;
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const AlertsScreen(),
                        ),
                      );
                    },
                  ),
                  if (alertCount > 0)
                    Positioned(
                      right: 6,
                      top: 6,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppTheme.error,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                        child: Text(
                          '$alertCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          final trainerId = authProvider.trainerId;
          if (trainerId != null) {
            final playersProvider = Provider.of<PlayersProvider>(context, listen: false);
            final plansProvider = Provider.of<WorkoutPlansProvider>(context, listen: false);
            final exercisesProvider = Provider.of<ExercisesProvider>(context, listen: false);
            final subscriptionsProvider = Provider.of<SubscriptionsProvider>(context, listen: false);
            final lockersProvider = Provider.of<LockersProvider>(context, listen: false);
            final currenciesProvider = Provider.of<CurrenciesProvider>(context, listen: false);

            await Future.wait([
              playersProvider.loadPlayers(trainerId),
              plansProvider.loadPlans(trainerId),
              exercisesProvider.loadExercises(trainerId),
              subscriptionsProvider.loadSubscriptions(trainerId),
              lockersProvider.loadLockers(trainerId),
              currenciesProvider.loadCurrencies(trainerId),
            ]);
          }
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Stats Grid
              _buildStatsGrid(context),
              const SizedBox(height: 24),

              // Alerts Section
              _buildAlertsSection(context),
              const SizedBox(height: 24),

              // Expiring Soon Section
              _buildExpiringSoonSection(context),
              const SizedBox(height: 24),

              // Quick Actions
              _buildQuickActions(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsGrid(BuildContext context) {
    return Consumer4<PlayersProvider, WorkoutPlansProvider, ExercisesProvider, SubscriptionsProvider>(
      builder: (context, players, plans, exercises, subscriptions, child) {
        final l10n = AppLocalizations.of(context);
        final lockersProvider = Provider.of<LockersProvider>(context);
        return GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.1,
          children: [
            StatCard(
              title: l10n?.players ?? 'اللاعبين',
              value: players.count.toString(),
              icon: Icons.people,
              gradient: AppTheme.primaryGradient,
            ),
            StatCard(
              title: l10n?.workoutPlans ?? 'خطط التمارين',
              value: plans.count.toString(),
              icon: Icons.fitness_center,
              gradient: const LinearGradient(
                colors: [Color(0xFF7C4DFF), Color(0xFFB388FF)],
              ),
            ),
            StatCard(
              title: l10n?.activeSubscription ?? 'اشتراكات نشطة',
              value: subscriptions.activeCount.toString(),
              icon: Icons.card_membership,
              gradient: const LinearGradient(
                colors: [Color(0xFF00C853), Color(0xFF69F0AE)],
              ),
            ),
            StatCard(
              title: l10n?.lockers ?? 'الخزائن',
              value: '${lockersProvider.occupiedCount}/${lockersProvider.totalCount}',
              icon: Icons.lock,
              gradient: AppTheme.accentGradient,
            ),
          ],
        );
      },
    );
  }

  Widget _buildAlertsSection(BuildContext context) {
    return Consumer<SubscriptionsProvider>(
      builder: (context, subscriptions, child) {
        final l10n = AppLocalizations.of(context);
        final unpaidCount = subscriptions.unpaidCount;
        final renewalCount = subscriptions.renewalCount;

        if (unpaidCount == 0 && renewalCount == 0) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n?.alerts ?? 'التنبيهات',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            if (unpaidCount > 0)
              _AlertBanner(
                icon: Icons.money_off,
                color: AppTheme.warning,
                title: '$unpaidCount ${l10n?.unpaidSubscriptions ?? "اشتراك غير مدفوع"}',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const AlertsScreen()),
                  );
                },
              ),
            if (unpaidCount > 0 && renewalCount > 0) const SizedBox(height: 8),
            if (renewalCount > 0)
              _AlertBanner(
                icon: Icons.refresh,
                color: AppTheme.error,
                title: '$renewalCount ${l10n?.needsRenewal ?? "اشتراك يحتاج تجديد"}',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const AlertsScreen()),
                  );
                },
              ),
          ],
        );
      },
    );
  }

  Widget _buildExpiringSoonSection(BuildContext context) {
    return Consumer<SubscriptionsProvider>(
      builder: (context, subscriptions, child) {
        final expiring = subscriptions.expiringSoon;
        final l10n = AppLocalizations.of(context);
        
        if (expiring.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n?.expiringSoon ?? 'تنتهي قريباً',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                TextButton(
                  onPressed: () {
                    // Navigate to subscriptions tab
                  },
                  child: const Text('عرض الكل'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.warning.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppTheme.warning.withOpacity(0.3),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.warning.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.warning_amber_rounded,
                          color: AppTheme.warning,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${expiring.length} subscription${expiring.length == 1 ? '' : 's'} expiring',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: AppTheme.warning,
                              ),
                            ),
                            Text(
                              'within the next 7 days',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'إجراءات سريعة',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _QuickActionButton(
                icon: Icons.person_add,
                label: l10n?.addPlayer ?? 'إضافة لاعب',
                color: AppTheme.primaryColor,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const PlayersListScreen(showAddDialog: true),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _QuickActionButton(
                icon: Icons.add_box,
                label: l10n?.newPlan ?? 'خطة جديدة',
                color: AppTheme.accentColor,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const PlansListScreen(showAddDialog: true),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _AlertBanner extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final VoidCallback onTap;

  const _AlertBanner({
    required this.icon,
    required this.color,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(color: color, fontWeight: FontWeight.w600),
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: color, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
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
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(height: 8),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: color,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
