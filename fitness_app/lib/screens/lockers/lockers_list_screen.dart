import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../models/locker.dart';
import '../../providers/lockers_provider.dart';
import '../../providers/players_provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/theme.dart';
import '../../utils/date_helpers.dart';

class LockersListScreen extends StatefulWidget {
  const LockersListScreen({super.key});

  @override
  State<LockersListScreen> createState() => _LockersListScreenState();
}

class _LockersListScreenState extends State<LockersListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.lockers ?? 'الخزائن'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'bulk_add') {
                _showBulkAddDialog(context);
              } else if (value == 'clear_all') {
                _showClearAllDialog(context);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'bulk_add',
                child: Text('إضافة مجموعة'),
              ),
              const PopupMenuItem(
                value: 'clear_all',
                child: Text('حذف جميع الخزائن', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ],
      ),
      body: Consumer<LockersProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          List<Locker> filteredLockers = provider.lockers;
          if (_searchQuery.isNotEmpty) {
            filteredLockers = provider.lockers.where((l) => 
                l.lockerNumber.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
          }

          return Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'بحث عن خزانة...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
              ),
              // Stats Bar
              _buildStatsBar(context, provider, l10n),
              // Lockers Grid
              Expanded(
                child: filteredLockers.isEmpty
                  ? Center(child: Text(l10n?.noLockers ?? 'لا توجد خزائن'))
                  : GridView.builder(
                      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 80),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 1.0,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: filteredLockers.length,
                      itemBuilder: (context, index) {
                        final locker = filteredLockers[index];
                        return _LockerTile(locker: locker);
                      },
                    ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddLockerDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('إضافة خزانة'), // Add Locker
      ),
    );
  }

  void _showAddLockerDialog(BuildContext context) {
    final numberController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('إضافة خزانة'), // Add Locker
        content: TextField(
          controller: numberController,
          decoration: const InputDecoration(labelText: 'رقم الخزانة'), // Locker Number
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء'), // Cancel
          ),
          ElevatedButton(
            onPressed: () async {
              final val = numberController.text.trim();
              if (val.isEmpty) return;
              final trainerId = Provider.of<AuthProvider>(context, listen: false).trainerId ?? 1;
              final provider = Provider.of<LockersProvider>(context, listen: false);
              
              Navigator.pop(ctx);
              final success = await provider.addLocker(trainerId, val);
              if (!success && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(provider.error ?? 'خطأ')), // Error
                );
              }
            },
            child: const Text('إضافة'), // Add
          ),
        ],
      ),
    );
  }

  void _showClearAllDialog(BuildContext context) {
    final provider = Provider.of<LockersProvider>(context, listen: false);
    final trainerId = Provider.of<AuthProvider>(context, listen: false).trainerId ?? 1;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('حذف جميع الخزائن', style: TextStyle(color: Colors.red)),
        content: const Text('هل أنت متأكد من حذف جميع الخزائن؟ هذا الإجراء لا يمكن التراجع عنه وسيلغي تعيين جميع اللاعبين.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.error),
            onPressed: () async {
              Navigator.pop(ctx);
              final success = await provider.clearAllLockers(trainerId);
              if (!success && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(provider.error ?? 'خطأ')),
                );
              }
            },
            child: const Text('حذف الجميع'),
          ),
        ],
      ),
    );
  }

  void _showBulkAddDialog(BuildContext context) {
    final prefixController = TextEditingController();
    final suffixController = TextEditingController();
    final startController = TextEditingController(text: '1');
    final endController = TextEditingController(text: '10');
    final provider = Provider.of<LockersProvider>(context, listen: false);
    final trainerId = Provider.of<AuthProvider>(context, listen: false).trainerId ?? 1;

    void updateStartNumber() {
      final nextNum = provider.getNextAvailableNumber(prefixController.text, suffixController.text);
      startController.text = nextNum.toString();
      endController.text = (nextNum + 9).toString();
    }

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('إضافة مجموعة خزائن'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: prefixController,
                    decoration: const InputDecoration(labelText: 'بادئة (اختياري)', hintText: 'A-'),
                    onChanged: (_) => setState(updateStartNumber),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: suffixController,
                    decoration: const InputDecoration(labelText: 'لاحقة (اختياري)', hintText: '-X'),
                    onChanged: (_) => setState(updateStartNumber),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: startController,
                          decoration: const InputDecoration(labelText: 'من رقم'),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: endController,
                          decoration: const InputDecoration(labelText: 'إلى رقم'),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text('ملاحظة: سيتم تخطي الخزائن الموجودة مسبقاً تلقائياً.', style: TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('إلغاء'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final start = int.tryParse(startController.text) ?? 0;
                  final end = int.tryParse(endController.text) ?? 0;
                  if (start > end || start == 0) return;

                  Navigator.pop(ctx);
                  final successCount = await provider.addBulkLockers(
                    trainerId, 
                    prefixController.text, 
                    suffixController.text, 
                    start, 
                    end
                  );
                  
                  if (context.mounted) {
                    if (provider.error != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(provider.error!)),
                      );
                    } else {
                      final totalRequested = end - start + 1;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('تم إضافة $successCount خزائن بنجاح. تم تخطي ${totalRequested - successCount} مكررة.'),
                          backgroundColor: successCount > 0 ? AppTheme.success : AppTheme.error,
                        ),
                      );
                    }
                  }
                },
                child: const Text('إضافة'),
              ),
            ],
          );
        }
      ),
    );
  }

  Widget _buildStatsBar(BuildContext context, LockersProvider provider, AppLocalizations? l10n) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF3A3A3A)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatItem(
            label: l10n?.occupied ?? 'مشغول',
            value: provider.occupiedCount.toString(),
            color: AppTheme.accentColor,
          ),
          Container(width: 1, height: 30, color: const Color(0xFF3A3A3A)),
          _StatItem(
            label: l10n?.available ?? 'متاح',
            value: provider.availableLockers.length.toString(),
            color: AppTheme.primaryColor,
          ),
          Container(width: 1, height: 30, color: const Color(0xFF3A3A3A)),
          _StatItem(
            label: l10n?.total ?? 'المجموع',
            value: provider.totalCount.toString(),
            color: AppTheme.textSecondary,
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatItem({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _LockerTile extends StatelessWidget {
  final Locker locker;

  const _LockerTile({required this.locker});

  @override
  Widget build(BuildContext context) {
    final playersProvider = Provider.of<PlayersProvider>(context);
    final player = locker.playerId != null 
        ? playersProvider.getById(locker.playerId!) 
        : null;

    return Material(
      color: locker.isAvailable
          ? AppTheme.primaryColor.withOpacity(0.15)
          : AppTheme.accentColor.withOpacity(0.15),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () => locker.isAvailable
            ? _showAssignDialog(context)
            : _showDetailsDialog(context, player?.name),
        onLongPress: () => _showDeleteDialog(context),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: locker.isAvailable
                  ? AppTheme.primaryColor.withOpacity(0.4)
                  : AppTheme.accentColor.withOpacity(0.4),
              width: 1.5,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                locker.isAvailable ? Icons.lock_open : Icons.lock,
                color: locker.isAvailable ? AppTheme.primaryColor : AppTheme.accentColor,
                size: 22,
              ),
              const SizedBox(height: 4),
              Text(
                '${locker.lockerNumber}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: locker.isAvailable ? AppTheme.primaryColor : AppTheme.accentColor,
                ),
              ),
              if (player != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Text(
                    player.name,
                    style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAssignDialog(BuildContext context) {
    final playersProvider = Provider.of<PlayersProvider>(context, listen: false);
    final lockersProvider = Provider.of<LockersProvider>(context, listen: false);
    final l10n = AppLocalizations.of(context);
    int? selectedPlayerId;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(l10n?.assignLocker ?? 'تعيين خزانة ${locker.lockerNumber}'),
          content: DropdownButtonFormField<int>(
            value: selectedPlayerId,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.person_outlined),
              hintText: l10n?.selectPlayer ?? 'اختر لاعباً',
            ),
            items: playersProvider.players.map((player) {
              final hasLocker = lockersProvider.getByPlayer(player.id!) != null;
              return DropdownMenuItem(
                value: player.id,
                enabled: !hasLocker,
                child: Text(
                  '${player.name}${hasLocker ? ' (لديه خزانة)' : ''}',
                  style: TextStyle(
                    color: hasLocker ? AppTheme.textSecondary : null,
                  ),
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() => selectedPlayerId = value);
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n?.cancel ?? 'إلغاء'),
            ),
            ElevatedButton(
              onPressed: selectedPlayerId == null ? null : () async {
                await lockersProvider.assignLocker(locker.id!, selectedPlayerId!);
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n?.lockerAssigned ?? 'تم تعيين الخزانة'),
                      backgroundColor: AppTheme.success,
                    ),
                  );
                }
              },
              child: Text(l10n?.assignLocker ?? 'تعيين'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDetailsDialog(BuildContext context, String? playerName) {
    final lockersProvider = Provider.of<LockersProvider>(context, listen: false);
    final l10n = AppLocalizations.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${l10n?.lockerNumber ?? "خزانة"} ${locker.lockerNumber}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.person, color: AppTheme.primaryColor, size: 20),
                const SizedBox(width: 8),
                Text(playerName ?? l10n?.unknownPlayer ?? 'لاعب غير معروف'),
              ],
            ),
            if (locker.assignedAt != null) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.calendar_today, color: AppTheme.textSecondary, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    DateHelpers.formatDate(locker.assignedAt!),
                    style: const TextStyle(color: AppTheme.textSecondary),
                  ),
                ],
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n?.cancel ?? 'إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              await lockersProvider.unassignLocker(locker.id!);
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n?.lockerUnassigned ?? 'تم إلغاء تعيين الخزانة'),
                    backgroundColor: AppTheme.success,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.error),
            child: Text(l10n?.unassignLocker ?? 'إلغاء التعيين'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    final lockersProvider = Provider.of<LockersProvider>(context, listen: false);
    
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('حذف خزانة'), // Delete Locker
        content: Text('هل أنت متأكد من حذف الخزانة ${locker.lockerNumber}؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.error),
            onPressed: () async {
              Navigator.pop(ctx);
              final success = await lockersProvider.deleteLocker(locker.id!);
              if (!success && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(lockersProvider.error ?? 'خطأ')),
                );
              }
            },
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }
}
