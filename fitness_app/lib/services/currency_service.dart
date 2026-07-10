import '../database/database_helper.dart';
import '../models/currency.dart';

class CurrencyService {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<List<Currency>> getAllByTrainer(int trainerId) async {
    final db = await _dbHelper.database;
    
    final results = await db.query(
      'currencies',
      where: 'trainer_id = ?',
      whereArgs: [trainerId],
      orderBy: 'is_default DESC, name ASC',
    );

    return results.map((map) => Currency.fromMap(map)).toList();
  }

  Future<Currency?> getById(int id) async {
    final db = await _dbHelper.database;
    
    final results = await db.query(
      'currencies',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isEmpty) return null;
    return Currency.fromMap(results.first);
  }

  Future<Currency?> getDefault(int trainerId) async {
    final db = await _dbHelper.database;
    
    final results = await db.query(
      'currencies',
      where: 'trainer_id = ? AND is_default = 1',
      whereArgs: [trainerId],
      limit: 1,
    );

    if (results.isEmpty) return null;
    return Currency.fromMap(results.first);
  }

  Future<Currency> create(Currency currency) async {
    final db = await _dbHelper.database;
    
    final id = await db.insert('currencies', currency.toMap());
    return currency.copyWith(id: id);
  }

  Future<void> update(Currency currency) async {
    final db = await _dbHelper.database;
    
    await db.update(
      'currencies',
      currency.toMap(),
      where: 'id = ?',
      whereArgs: [currency.id],
    );
  }

  Future<bool> canDelete(int id) async {
    final db = await _dbHelper.database;
    
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM subscriptions WHERE currency_id = ?',
      [id],
    );

    return (result.first['count'] as int) == 0;
  }

  Future<void> delete(int id) async {
    final db = await _dbHelper.database;
    
    await db.delete(
      'currencies',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> setDefault(int trainerId, int currencyId) async {
    final db = await _dbHelper.database;
    
    // Clear all defaults for this trainer
    await db.update(
      'currencies',
      {'is_default': 0},
      where: 'trainer_id = ?',
      whereArgs: [trainerId],
    );
    
    // Set the new default
    await db.update(
      'currencies',
      {'is_default': 1},
      where: 'id = ?',
      whereArgs: [currencyId],
    );
  }
}
