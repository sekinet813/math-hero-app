/// プレイヤー情報を管理するモデルクラス
class Player {
  final int? id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Player({
    this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  /// MapからPlayerオブジェクトを作成
  factory Player.fromMap(Map<String, dynamic> map) {
    return Player(
      id: map['id'] as int?,
      name: map['name'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  /// PlayerオブジェクトをMapに変換
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// 新しいPlayerオブジェクトを作成（IDなし）
  Player copyWith({
    int? id,
    String? name,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Player(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
