import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:vlogify/core/constants/firebase_constants.dart';
import 'package:vlogify/core/utils/failure.dart';
import 'package:vlogify/core/providers/firebase_providers.dart';
import 'package:vlogify/core/type_defs.dart';
import 'package:vlogify/models/comment_model.dart';
import 'package:vlogify/models/vlog_model.dart';

final vlogRepositoryProvider = Provider((ref) {
  return VlogRepository(
    firestore: ref.watch(firestoreProvider),
  );
});

class VlogRepository {
  final FirebaseFirestore _firestore;
  VlogRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _vlogs =>
      _firestore.collection(FirebaseConstants.vlogsCollection);
  CollectionReference get _comments =>
      _firestore.collection(FirebaseConstants.commentsCollection);

  FutureVoid addVlog(Vlog vlog) async {
    try {
      return right(_vlogs.doc(vlog.id).set(vlog.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid deleteVlog(Vlog vlog) async {
    try {
      return right(_vlogs.doc(vlog.id).delete());
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  void upvote(Vlog vlog, String userId) async {
    if (vlog.downvotes.contains(userId)) {
      _vlogs.doc(vlog.id).update({
        'downvotes': FieldValue.arrayRemove([userId]),
      });
    }

    if (vlog.upvotes.contains(userId)) {
      _vlogs.doc(vlog.id).update({
        'upvotes': FieldValue.arrayRemove([userId]),
      });
    } else {
      _vlogs.doc(vlog.id).update({
        'upvotes': FieldValue.arrayUnion([userId]),
      });
    }
  }

  void downvote(Vlog vlog, String userId) async {
    if (vlog.upvotes.contains(userId)) {
      _vlogs.doc(vlog.id).update({
        'upvotes': FieldValue.arrayRemove([userId]),
      });
    }

    if (vlog.downvotes.contains(userId)) {
      _vlogs.doc(vlog.id).update({
        'downvotes': FieldValue.arrayRemove([userId]),
      });
    } else {
      _vlogs.doc(vlog.id).update({
        'downvotes': FieldValue.arrayUnion([userId]),
      });
    }
  }

  Stream<Vlog> getVlogById(String vlogId) {
    return _vlogs
        .doc(vlogId)
        .snapshots()
        .map((event) => Vlog.fromMap(event.data() as Map<String, dynamic>));
  }

  Stream<List<Vlog>> getVlogsByBoardId(String boardId) {
    return _vlogs
        .where('boardId', isEqualTo: boardId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((event) {
      List<Vlog> vlogs = [];
      for (var doc in event.docs) {
        vlogs.add(Vlog.fromMap(doc.data() as Map<String, dynamic>));
      }
      return vlogs;
    });
  }

  FutureVoid addComment(Comment comment) async {
    try {
      await _comments.doc(comment.id).set(comment.toMap());

      return right(_vlogs.doc(comment.vlogId).update({
        'commentCount': FieldValue.increment(1),
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Comment>> getCommentsOfVlog(String vlogId) {
    return _comments
        .where('vlogId', isEqualTo: vlogId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (event) => event.docs
              .map(
                (e) => Comment.fromMap(
                  e.data() as Map<String, dynamic>,
                ),
              )
              .toList(),
        );
  }
}
