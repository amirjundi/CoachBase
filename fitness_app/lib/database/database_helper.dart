import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const _databaseName = "fitness_trainer.db";
  static const _databaseVersion = 7; // Removed auto seeding lockers

  // Singleton pattern
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await _createTables(db);
    await _seedDefaultTrainer(db);
    // await _seedDefaultLockers(db, 1); // Removed: user wants empty lockers on install
    await _seedDefaultCurrencies(db, 1);
  }

  Future<void> _createTables(Database db) async {
    // Trainers Table
    await db.execute('''
      CREATE TABLE trainers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        password_hash TEXT NOT NULL, 
        phone TEXT,
        created_at TEXT NOT NULL
      )
    ''');

    // Players Table
    await db.execute('''
      CREATE TABLE players (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        trainer_id INTEGER NOT NULL,
        name TEXT NOT NULL,
        email TEXT,
        phone TEXT,
        notes TEXT,
        weight REAL,
        height REAL,
        created_at TEXT NOT NULL,
        FOREIGN KEY (trainer_id) REFERENCES trainers (id) ON DELETE CASCADE
      )
    ''');

    // Workout Plans Table
    await db.execute('''
      CREATE TABLE workout_plans (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        trainer_id INTEGER NOT NULL,
        name TEXT NOT NULL,
        description TEXT NOT NULL,
        difficulty_level TEXT NOT NULL,
        is_active INTEGER NOT NULL DEFAULT 1,
        created_at TEXT NOT NULL,
        FOREIGN KEY (trainer_id) REFERENCES trainers (id) ON DELETE CASCADE
      )
    ''');

    // Plan Days Table
    await db.execute('''
      CREATE TABLE plan_days (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        plan_id INTEGER NOT NULL,
        sequence_order INTEGER NOT NULL,
        is_rest_day INTEGER NOT NULL DEFAULT 0,
        focus_area TEXT,
        FOREIGN KEY (plan_id) REFERENCES workout_plans (id) ON DELETE CASCADE
      )
    ''');

    // Exercises Table (Refactored: Removed defaults)
    await db.execute('''
      CREATE TABLE exercises (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        trainer_id INTEGER NOT NULL,
        name TEXT NOT NULL,
        muscle_group TEXT NOT NULL,
        description TEXT,
        youtube_url TEXT,
        thumbnail_path TEXT,
        FOREIGN KEY (trainer_id) REFERENCES trainers (id) ON DELETE CASCADE
      )
    ''');

    // Day Exercises Table
    await db.execute('''
      CREATE TABLE day_exercises (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        day_id INTEGER NOT NULL,
        exercise_id INTEGER NOT NULL,
        order_index INTEGER NOT NULL,
        notes TEXT,
        set_goals_json TEXT,
        FOREIGN KEY (day_id) REFERENCES plan_days (id) ON DELETE CASCADE,
        FOREIGN KEY (exercise_id) REFERENCES exercises (id) ON DELETE CASCADE
      )
    ''');

    // Currencies Table
    await db.execute('''
      CREATE TABLE currencies (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        trainer_id INTEGER NOT NULL,
        name TEXT NOT NULL,
        code TEXT NOT NULL,
        symbol TEXT NOT NULL,
        is_default INTEGER NOT NULL DEFAULT 0,
        created_at TEXT NOT NULL,
        FOREIGN KEY (trainer_id) REFERENCES trainers (id) ON DELETE CASCADE
      )
    ''');

    // Subscriptions Table
    await db.execute('''
      CREATE TABLE subscriptions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        player_id INTEGER NOT NULL,
        plan_id INTEGER NOT NULL,
        start_date TEXT NOT NULL,
        end_date TEXT NOT NULL,
        amount_paid REAL,
        payment_notes TEXT,
        currency_id INTEGER,
        status TEXT NOT NULL,
        created_at TEXT NOT NULL,
        FOREIGN KEY (player_id) REFERENCES players (id) ON DELETE CASCADE,
        FOREIGN KEY (plan_id) REFERENCES workout_plans (id) ON DELETE CASCADE,
        FOREIGN KEY (currency_id) REFERENCES currencies (id) ON DELETE SET NULL
      )
    ''');

    // Lockers Table
    await db.execute('''
      CREATE TABLE lockers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        trainer_id INTEGER NOT NULL,
        locker_number TEXT NOT NULL,
        player_id INTEGER,
        assigned_at TEXT,
        notes TEXT,
        FOREIGN KEY (trainer_id) REFERENCES trainers (id) ON DELETE CASCADE,
        FOREIGN KEY (player_id) REFERENCES players (id) ON DELETE SET NULL,
        UNIQUE(trainer_id, locker_number)
      )
    ''');

    // Indexes
    await db.execute('CREATE INDEX idx_players_trainer ON players(trainer_id)');
    await db.execute('CREATE INDEX idx_plans_trainer ON workout_plans(trainer_id)');
    await db.execute('CREATE INDEX idx_days_plan ON plan_days(plan_id)');
    await db.execute('CREATE INDEX idx_day_exercises_day ON day_exercises(day_id)');
    await db.execute('CREATE INDEX idx_subscriptions_player ON subscriptions(player_id)');
    await db.execute('CREATE INDEX idx_lockers_trainer ON lockers(trainer_id)');
    await db.execute('CREATE INDEX idx_currencies_trainer ON currencies(trainer_id)');
  }

  Future<void> _seedDefaultTrainer(Database db) async {
    // Check if main trainer exists
    final List<Map<String, dynamic>> result = await db.query('trainers', limit: 1);
    if (result.isEmpty) {
        await db.insert('trainers', {
            'name': 'المدرب الرئيسي', // Localized Name
            'email': 'admin', // Dummy
            'password_hash': 'dummy_hash', 
            'created_at': DateTime.now().toIso8601String(),
        });
    }
  }

  Future<void> _seedDefaultLockers(Database db, int trainerId) async {
    final batch = db.batch();
    for (int i = 1; i <= 50; i++) {
      batch.insert('lockers', {
        'trainer_id': trainerId,
        'locker_number': i.toString(),
        'player_id': null,
        'assigned_at': null,
        'notes': null,
      });
    }
    await batch.commit(noResult: true);
  }

  Future<void> _seedDefaultCurrencies(Database db, int trainerId) async {
    final now = DateTime.now().toIso8601String();
    await db.insert('currencies', {
      'trainer_id': trainerId,
      'name': 'دولار أمريكي',
      'code': 'USD',
      'symbol': '\$',
      'is_default': 1,
      'created_at': now,
    });
    await db.insert('currencies', {
      'trainer_id': trainerId,
      'name': 'دينار عراقي',
      'code': 'IQD',
      'symbol': 'د.ع',
      'is_default': 0,
      'created_at': now,
    });
    await db.insert('currencies', {
      'trainer_id': trainerId,
      'name': 'دينار أردني',
      'code': 'JOD',
      'symbol': 'د.أ',
      'is_default': 0,
      'created_at': now,
    });
  }

  // Handle version upgrade - Drop and recreate related tables
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 7) {
      // Re-initialize tables for V7 (Lockers, Currencies, Currency on Subscriptions)
      // Dropping everything to ensure consistency as per user agreement
      await db.execute('PRAGMA foreign_keys = OFF');
      await db.execute('DROP TABLE IF EXISTS day_exercises');
      await db.execute('DROP TABLE IF EXISTS plan_days');
      await db.execute('DROP TABLE IF EXISTS workout_plans');
      await db.execute('DROP TABLE IF EXISTS subscriptions');
      await db.execute('DROP TABLE IF EXISTS exercises');
      await db.execute('DROP TABLE IF EXISTS lockers');
      await db.execute('DROP TABLE IF EXISTS currencies');
      await db.execute('DROP TABLE IF EXISTS players');
      await db.execute('DROP TABLE IF EXISTS trainers'); // Re-seed trainer
      await db.execute('PRAGMA foreign_keys = ON');
      
      await _createTables(db);
      await _seedDefaultTrainer(db);
      // await _seedDefaultLockers(db, 1); // Removed: user wants empty lockers on install
      await _seedDefaultCurrencies(db, 1);
    }
  }

  Future<void> close() async {
    final db = await database;
    db.close();
  }
}
