import 'package:sqflite/sqflite.dart';
import '../database/database_helper.dart';
import '../models/locker.dart';

class LockerService {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<List<Locker>> getAllByTrainer(int trainerId) async {
    final db = await _dbHelper.database;
    
    final results = await db.query(
      'lockers',
      where: 'trainer_id = ?',
      whereArgs: [trainerId],
      orderBy: 'locker_number ASC',
    );

    return results.map((map) => Locker.fromMap(map)).toList();
  }

  Future<List<Locker>> getAvailableLockers(int trainerId) async {
    final db = await _dbHelper.database;
    
    final results = await db.query(
      'lockers',
      where: 'trainer_id = ? AND player_id IS NULL',
      whereArgs: [trainerId],
      orderBy: 'locker_number ASC',
    );

    return results.map((map) => Locker.fromMap(map)).toList();
  }

  Future<Locker?> getByPlayer(int playerId) async {
    final db = await _dbHelper.database;
    
    final results = await db.query(
      'lockers',
      where: 'player_id = ?',
      whereArgs: [playerId],
      limit: 1,
    );

    if (results.isEmpty) return null;
    return Locker.fromMap(results.first);
  }

  Future<void> assignLocker(int lockerId, int playerId) async {
    final db = await _dbHelper.database;
    
    await db.update(
      'lockers',
      {
        'player_id': playerId,
        'assigned_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [lockerId],
    );
  }

  Future<void> unassignLocker(int lockerId) async {
    final db = await _dbHelper.database;
    
    await db.update(
      'lockers',
      {
        'player_id': null,
        'assigned_at': null,
        'notes': null,
      },
      where: 'id = ?',
      whereArgs: [lockerId],
    );
  }

  Future<int> getOccupiedCount(int trainerId) async {
    final db = await _dbHelper.database;
    
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM lockers WHERE trainer_id = ? AND player_id IS NOT NULL',
      [trainerId],
    );

    return result.first['count'] as int;
  }

  Future<int> getTotalCount(int trainerId) async {
    final db = await _dbHelper.database;
    
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM lockers WHERE trainer_id = ?',
      [trainerId],
    );

    return result.first['count'] as int;
  }
  Future<Locker> createLocker(Locker locker) async {
    final db = await _dbHelper.database;
    final id = await db.insert('lockers', locker.toMap());
    return locker.copyWith(id: id);
  }

  Future<void> deleteLocker(int id) async {
    final db = await _dbHelper.database;
    await db.delete('lockers', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteAllLockers(int trainerId) async {
    final db = await _dbHelper.database;
    await db.delete('lockers', where: 'trainer_id = ?', whereArgs: [trainerId]);
  }

  Future<int> addBulkLockers(List<Locker> lockers) async {
    final db = await _dbHelper.database;
    int successCount = 0;
    await db.transaction((txn) async {
      for (final locker in lockers) {
        final id = await txn.insert(
          'lockers', 
          locker.toMap(), 
          conflictAlgorithm: ConflictAlgorithm.ignore,
        );
        if (id > 0) successCount++;
      }
    });
    return successCount;
  }
}
