class Locker {
  final int? id;
  final int trainerId;
  final String lockerNumber;
  final int? playerId;
  final DateTime? assignedAt;
  final String? notes;

  Locker({
    this.id,
    required this.trainerId,
    required this.lockerNumber,
    this.playerId,
    this.assignedAt,
    this.notes,
  });

  bool get isAvailable => playerId == null;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'trainer_id': trainerId,
      'locker_number': lockerNumber,
      'player_id': playerId,
      'assigned_at': assignedAt?.toIso8601String(),
      'notes': notes,
    };
  }

  factory Locker.fromMap(Map<String, dynamic> map) {
    return Locker(
      id: map['id'] as int?,
      trainerId: map['trainer_id'] as int,
      lockerNumber: map['locker_number'].toString(),
      playerId: map['player_id'] as int?,
      assignedAt: map['assigned_at'] != null
          ? DateTime.parse(map['assigned_at'] as String)
          : null,
      notes: map['notes'] as String?,
    );
  }

  Locker copyWith({
    int? id,
    int? trainerId,
    String? lockerNumber,
    int? playerId,
    bool clearPlayer = false,
    DateTime? assignedAt,
    bool clearAssignedAt = false,
    String? notes,
  }) {
    return Locker(
      id: id ?? this.id,
      trainerId: trainerId ?? this.trainerId,
      lockerNumber: lockerNumber ?? this.lockerNumber,
      playerId: clearPlayer ? null : (playerId ?? this.playerId),
      assignedAt: clearAssignedAt ? null : (assignedAt ?? this.assignedAt),
      notes: notes ?? this.notes,
    );
  }
}
