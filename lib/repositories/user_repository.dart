import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:vlogify/core/constants/firebase_constants.dart';
import 'package:vlogify/core/providers/firebase_providers.dart';
import 'package:vlogify/core/utils/failure.dart';
import 'package:vlogify/core/type_defs.dart';
import 'package:vlogify/models/user_model.dart';

final userRepositoryProvider = Provider((ref) {
  return UserRepository(firestore: ref.watch(firestoreProvider));
});

class UserRepository {
  final FirebaseFirestore _firestore;
  UserRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);

  FutureVoid editProfile(UserModel user) async {
    try {
      return right(_users.doc(user.uid).update(user.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Future<UserModel?> getUserById(String userId) async {
    DocumentSnapshot userDoc = await _users.doc(userId).get();
    if (userDoc.exists) {
      return UserModel.fromMap(userDoc.data() as Map<String, dynamic>);
    }
    return null;
  }

  Stream<List<UserModel>> searchCommunity(String query) {
    return _users
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
      List<UserModel> users = [];
      for (var user in event.docs) {
        users.add(UserModel.fromMap(user.data() as Map<String, dynamic>));
      }
      return users;
    });
  }
  // Stream<List<Board>> getUserBoards(String uid) {
  //   return _firestore
  //       .collection(FirebaseConstants.usersCollection)
  //       .doc(uid)
  //       .collection(FirebaseConstants.boardsCollection)
  //       .orderBy('createdAt', descending: true)
  //       .snapshots()
  //       .map(
  //         (event) => event.docs
  //             .map(
  //               (e) => Board.fromMap(
  //                 e.data(),
  //               ),
  //             )
  //             .toList(),
  //       );
  // }

  // Stream<List<Board>> getUserFollowedBoards(String uid) {
  //   List<String> boardList =
  //       await _firestore.collection(FirebaseConstants.usersCollection).doc(uid).get('boardsFollowed');
  //   List<Board> boards = boardList.forEach((element) {
  //     _firestore.collection(FirebaseConstants.usersCollection).where(field)
  //   })
  //   return _firestore
  //       .collection(FirebaseConstants.usersCollection)
  //       .doc(uid)
  //       .collection(FirebaseConstants.boardsCollection)
  //       .orderBy('createdAt', descending: true)
  //       .snapshots()
  //       .map(
  //         (event) => event.docs
  //             .map(
  //               (e) => Board.fromMap(
  //                 e.data(),
  //               ),
  //             )
  //             .toList(),
  //       );
  // }
}
