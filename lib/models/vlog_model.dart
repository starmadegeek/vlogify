// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class Vlog {
  final String id;
  final String title;
  final String link;
  final String boardName;
  final String boardId;
  final String? description;
  final List<String> upvotes;
  final List<String> downvotes;
  final int commentCount;
  final String username;
  final String uid;
  final DateTime createdAt;
  Vlog({
    required this.id,
    required this.title,
    required this.link,
    required this.boardName,
    required this.boardId,
    this.description,
    required this.upvotes,
    required this.downvotes,
    required this.commentCount,
    required this.username,
    required this.uid,
    required this.createdAt,
  });

  Vlog copyWith({
    String? id,
    String? title,
    String? link,
    String? boardName,
    String? boardId,
    String? description,
    List<String>? upvotes,
    List<String>? downvotes,
    int? commentCount,
    String? username,
    String? uid,
    DateTime? createdAt,
  }) {
    return Vlog(
      id: id ?? this.id,
      title: title ?? this.title,
      link: link ?? this.link,
      boardName: boardName ?? this.boardName,
      boardId: boardId ?? this.boardId,
      description: description ?? this.description,
      upvotes: upvotes ?? this.upvotes,
      downvotes: downvotes ?? this.downvotes,
      commentCount: commentCount ?? this.commentCount,
      username: username ?? this.username,
      uid: uid ?? this.uid,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'link': link,
      'boardName': boardName,
      'boardId': boardId,
      'description': description,
      'upvotes': upvotes,
      'downvotes': downvotes,
      'commentCount': commentCount,
      'username': username,
      'uid': uid,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory Vlog.fromMap(Map<String, dynamic> map) {
    return Vlog(
      id: map['id'] as String,
      title: map['title'] as String,
      link: map['link'] as String,
      boardName: map['boardName'] as String,
      boardId: map['boardId'] as String,
      description:
          map['description'] != null ? map['description'] as String : null,
      upvotes: List<String>.from((map['upvotes'] as List<String>)),
      downvotes: List<String>.from((map['downvotes'] as List<String>)),
      commentCount: map['commentCount'] as int,
      username: map['username'] as String,
      uid: map['uid'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
    );
  }
  @override
  String toString() {
    return 'Vlog(id: $id, title: $title, link: $link, boardName: $boardName, boardId: $boardId, description: $description, upvotes: $upvotes, downvotes: $downvotes, commentCount: $commentCount, username: $username, uid: $uid, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant Vlog other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.link == link &&
        other.boardName == boardName &&
        other.boardId == boardId &&
        other.description == description &&
        listEquals(other.upvotes, upvotes) &&
        listEquals(other.downvotes, downvotes) &&
        other.commentCount == commentCount &&
        other.username == username &&
        other.uid == uid &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        link.hashCode ^
        boardName.hashCode ^
        boardId.hashCode ^
        description.hashCode ^
        upvotes.hashCode ^
        downvotes.hashCode ^
        commentCount.hashCode ^
        username.hashCode ^
        uid.hashCode ^
        createdAt.hashCode;
  }

  String toJson() => json.encode(toMap());

  factory Vlog.fromJson(String source) =>
      Vlog.fromMap(json.decode(source) as Map<String, dynamic>);
}
