import 'package:flutter/foundation.dart';
import '../models/locker.dart';
import '../services/locker_service.dart';

class LockersProvider with ChangeNotifier {
  final LockerService _lockerService = LockerService();
  List<Locker> _lockers = [];
  bool _isLoading = false;
  String? _error;

  List<Locker> get lockers => _lockers;
  List<Locker> get availableLockers => _lockers.where((l) => l.isAvailable).toList();
  List<Locker> get occupiedLockers => _lockers.where((l) => !l.isAvailable).toList();
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get occupiedCount => occupiedLockers.length;
  int get totalCount => _lockers.length;

  Future<void> loadLockers(int trainerId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _lockers = await _lockerService.getAllByTrainer(trainerId);
      _lockers.sort((a, b) => _naturalCompare(a.lockerNumber, b.lockerNumber));
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> assignLocker(int lockerId, int playerId) async {
    _error = null;

    try {
      await _lockerService.assignLocker(lockerId, playerId);
      final index = _lockers.indexWhere((l) => l.id == lockerId);
      if (index != -1) {
        _lockers[index] = _lockers[index].copyWith(
          playerId: playerId,
          assignedAt: DateTime.now(),
        );
        notifyListeners();
      }
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> unassignLocker(int lockerId) async {
    _error = null;

    try {
      await _lockerService.unassignLocker(lockerId);
      final index = _lockers.indexWhere((l) => l.id == lockerId);
      if (index != -1) {
        _lockers[index] = _lockers[index].copyWith(
          clearPlayer: true,
          clearAssignedAt: true,
        );
        notifyListeners();
      }
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Locker? getByPlayer(int playerId) {
    try {
      return _lockers.firstWhere((l) => l.playerId == playerId);
    } catch (_) {
      return null;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
  int _naturalCompare(String a, String b) {
    final aMatch = RegExp(r'\d+').allMatches(a).toList();
    final bMatch = RegExp(r'\d+').allMatches(b).toList();
    if (aMatch.isNotEmpty && bMatch.isNotEmpty) {
      final aInt = int.tryParse(aMatch.last.group(0)!);
      final bInt = int.tryParse(bMatch.last.group(0)!);
      if (aInt != null && bInt != null && aInt != bInt) {
        final aPrefix = a.substring(0, aMatch.last.start);
        final bPrefix = b.substring(0, bMatch.last.start);
        if (aPrefix == bPrefix) return aInt.compareTo(bInt);
      }
    }
    return a.compareTo(b);
  }

  Future<bool> addLocker(int trainerId, String lockerNumberStr) async {
    _error = null;
    try {
      final lockerNumber = lockerNumberStr.trim();
      if (lockerNumber.isEmpty) throw Exception('رقم الخزانة غير صحيح'); // Invalid locker number

      // Check if locker already exists
      if (_lockers.any((l) => l.lockerNumber == lockerNumber)) {
        _error = 'هذه الخزانة موجودة مسبقاً'; // This locker already exists
        notifyListeners();
        return false;
      }

      final newLocker = Locker(
        trainerId: trainerId,
        lockerNumber: lockerNumber,
      );
      final createdLocker = await _lockerService.createLocker(newLocker);
      _lockers.add(createdLocker);
      _lockers.sort((a, b) => _naturalCompare(a.lockerNumber, b.lockerNumber));
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteLocker(int id) async {
    _error = null;
    try {
      await _lockerService.deleteLocker(id);
      _lockers.removeWhere((l) => l.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> clearAllLockers(int trainerId) async {
    _error = null;
    try {
      await _lockerService.deleteAllLockers(trainerId);
      _lockers.clear();
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<int> addBulkLockers(int trainerId, String prefix, String suffix, int start, int end) async {
    _error = null;
    try {
      final List<Locker> newLockers = [];
      for (int i = start; i <= end; i++) {
        newLockers.add(Locker(
          trainerId: trainerId,
          lockerNumber: '$prefix$i$suffix',
        ));
      }
      
      final successCount = await _lockerService.addBulkLockers(newLockers);
      if (successCount > 0) {
        await loadLockers(trainerId); // Reload all lockers from db
      }
      return successCount;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return 0;
    }
  }

  int getNextAvailableNumber(String prefix, String suffix) {
    int maxNum = 0;
    bool found = false;
    
    // Create regex to match prefix + digits + suffix
    final escapedPrefix = RegExp.escape(prefix);
    final escapedSuffix = RegExp.escape(suffix);
    final regex = RegExp('^$escapedPrefix(\\d+)$escapedSuffix\$');
    
    for (final locker in _lockers) {
      final match = regex.firstMatch(locker.lockerNumber);
      if (match != null) {
        final numStr = match.group(1);
        if (numStr != null) {
          final num = int.tryParse(numStr);
          if (num != null && num > maxNum) {
            maxNum = num;
            found = true;
          }
        }
      }
    }
    
    return found ? maxNum + 1 : 1;
  }
}
