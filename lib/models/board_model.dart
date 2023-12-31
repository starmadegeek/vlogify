// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Board {
  final String id;
  final String name;
  final String banner;
  final bool isPublic;
  final String ownerId;
  final String ownerName;
  final bool isDefault;
  Board({
    required this.id,
    required this.name,
    required this.banner,
    required this.isPublic,
    required this.ownerId,
    required this.ownerName,
    required this.isDefault,
  });

  Board copyWith({
    String? id,
    String? name,
    String? banner,
    bool? isPublic,
    String? ownerId,
    String? ownerName,
    bool? isDefault,
  }) {
    return Board(
      id: id ?? this.id,
      name: name ?? this.name,
      banner: banner ?? this.banner,
      isPublic: isPublic ?? this.isPublic,
      ownerId: ownerId ?? this.ownerId,
      ownerName: ownerName ?? this.ownerName,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'banner': banner,
      'isPublic': isPublic,
      'ownerId': ownerId,
      'ownerName': ownerName,
      'isDefault': isDefault,
    };
  }

  factory Board.fromMap(Map<String, dynamic> map) {
    return Board(
      id: map['id'] as String,
      name: map['name'] as String,
      banner: map['banner'] as String,
      isPublic: map['isPublic'] as bool,
      ownerId: map['ownerId'] as String,
      ownerName: map['ownerName'] as String,
      isDefault: map['isDefault'] as bool,
    );
  }

  @override
  String toString() {
    return 'Board(id: $id, name: $name, banner: $banner, isPublic: $isPublic, ownerId: $ownerId, ownerName: $ownerName, isDefault: $isDefault)';
  }

  @override
  bool operator ==(covariant Board other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.banner == banner &&
        other.isPublic == isPublic &&
        other.ownerId == ownerId &&
        other.ownerName == ownerName &&
        other.isDefault == isDefault;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        banner.hashCode ^
        isPublic.hashCode ^
        ownerId.hashCode ^
        ownerName.hashCode ^
        isDefault.hashCode;
  }

  String toJson() => json.encode(toMap());

  factory Board.fromJson(String source) =>
      Board.fromMap(json.decode(source) as Map<String, dynamic>);
}
