import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:vlogify/core/constants/firebase_constants.dart';
import 'package:vlogify/core/utils/failure.dart';
import 'package:vlogify/core/providers/firebase_providers.dart';
import 'package:vlogify/core/type_defs.dart';
import 'package:vlogify/models/board_model.dart';

final boardRepositoryProvider = Provider((ref) {
  return BoardRepository(firestore: ref.watch(firestoreProvider));
});

class BoardRepository {
  final FirebaseFirestore _firestore;
  BoardRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  FutureVoid createBoard(Board board) async {
    try {
      var boardDoc = await _boards.doc(board.id).get();
      if (boardDoc.exists) {
        throw 'Board with the same name already exists!';
      }

      return right(_boards.doc(board.id).set(board.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Board>> getUserBoards(String uid) {
    return _boards
        .where('ownerId', isEqualTo: uid)
        .orderBy('isDefault', descending: true)
        .snapshots()
        .map((event) {
      List<Board> boards = [];
      for (var doc in event.docs) {
        boards.add(Board.fromMap(doc.data() as Map<String, dynamic>));
      }
      return boards;
    });
  }

  Stream<Board> getUserBoard(String uid, String boardId) {
    return _boards
        .doc(boardId)
        .snapshots()
        .map((event) => Board.fromMap(event.data() as Map<String, dynamic>));
  }

  Stream<List<Board>> getPublicBoardsByName(String name) {
    return _boards
        .where('isPublic', isEqualTo: true)
        .where('name', isEqualTo: name)
        .snapshots()
        .map((QuerySnapshot querySnapshot) {
      return querySnapshot.docs
          .map((doc) => Board.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  Stream<List<Board>> getUserPublicBoards(String uid) {
    return _boards
        .where('ownerId', isEqualTo: uid)
        .where('isPublic', isEqualTo: true)
        .snapshots()
        .map((event) {
      List<Board> boards = [];
      for (var doc in event.docs) {
        boards.add(Board.fromMap(doc.data() as Map<String, dynamic>));
      }
      return boards;
    });
  }

  FutureVoid editBoard(Board board) async {
    try {
      return right(_boards.doc(board.id).update(board.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Board>> searchBoard(String query) {
    return _boards
        .where(
          'name',
          isGreaterThanOrEqualTo: query.isEmpty ? 0 : query,
          isLessThan: query.isEmpty
              ? null
              : query.substring(0, query.length - 1) +
                  String.fromCharCode(
                    query.codeUnitAt(query.length - 1) + 1,
                  ),
        )
        .snapshots()
        .map((event) {
      List<Board> boards = [];
      for (var board in event.docs) {
        boards.add(Board.fromMap(board.data() as Map<String, dynamic>));
      }
      return boards;
    });
  }

  Stream<List<Board>> getUserFollowedBoards(String uid) {
    return _following
        .where('followerId', isEqualTo: uid)
        .snapshots()
        .map((event) {
      List<Board> boards = [];
      for (var doc in event.docs) {
        boards.add(Board.fromMap(doc.data() as Map<String, dynamic>));
      }
      return boards;
    });
  }

  FutureVoid followBoard(String followerId, String boardId) async {
    try {
      return right(_following.add({
        'followerId': _users.doc(followerId),
        'boardId': _boards.doc(boardId),
      }).then((value) => null));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureEither isFollowing(String followerId, String boardId) async {
    try {
      var querySnapshot = await _following
          .where('followerId', isEqualTo: _users.doc(followerId))
          .where('boardId', isEqualTo: _boards.doc(boardId))
          .get();

      return right(querySnapshot.docs.isNotEmpty);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid unfollowBoard(String followerId, String boardId) async {
    try {
      return right(_following
          .where('followerId', isEqualTo: _users.doc(followerId))
          .where('boardId', isEqualTo: _boards.doc(boardId))
          .get()
          .then((querySnapshot) {
        for (var doc in querySnapshot.docs) {
          doc.reference.delete();
        }
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  CollectionReference get _boards =>
      _firestore.collection(FirebaseConstants.boardsCollection);

  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);

  CollectionReference get _following =>
      _firestore.collection(FirebaseConstants.following);
}
