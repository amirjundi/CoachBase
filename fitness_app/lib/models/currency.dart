class Currency {
  final int? id;
  final int trainerId;
  final String name;
  final String code;
  final String symbol;
  final bool isDefault;
  final DateTime createdAt;

  Currency({
    this.id,
    required this.trainerId,
    required this.name,
    required this.code,
    required this.symbol,
    this.isDefault = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  String formatAmount(double amount) {
    return '$symbol${amount.toStringAsFixed(2)}';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'trainer_id': trainerId,
      'name': name,
      'code': code,
      'symbol': symbol,
      'is_default': isDefault ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory Currency.fromMap(Map<String, dynamic> map) {
    return Currency(
      id: map['id'] as int?,
      trainerId: map['trainer_id'] as int,
      name: map['name'] as String,
      code: map['code'] as String,
      symbol: map['symbol'] as String,
      isDefault: (map['is_default'] as int?) == 1,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  Currency copyWith({
    int? id,
    int? trainerId,
    String? name,
    String? code,
    String? symbol,
    bool? isDefault,
    DateTime? createdAt,
  }) {
    return Currency(
      id: id ?? this.id,
      trainerId: trainerId ?? this.trainerId,
      name: name ?? this.name,
      code: code ?? this.code,
      symbol: symbol ?? this.symbol,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
