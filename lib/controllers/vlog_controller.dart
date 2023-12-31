import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:uuid/uuid.dart';
import 'package:vlogify/controllers/auth_controller.dart';
import 'package:vlogify/core/providers/storage_repository_provider.dart';
import 'package:vlogify/core/utils/utils.dart';
import 'package:vlogify/models/board_model.dart';
import 'package:vlogify/models/vlog_model.dart';
import 'package:vlogify/repositories/vlog_repository.dart';

final vlogControllerProvider =
    StateNotifierProvider<VlogController, bool>((ref) {
  final vlogRepository = ref.watch(vlogRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return VlogController(
    vlogRepository: vlogRepository,
    ref: ref,
    storageRepository: storageRepository,
  );
});

final getVlogByIdProvider = StreamProvider.family((ref, String vlogId) {
  final vlogController = ref.watch(vlogControllerProvider.notifier);
  return vlogController.getVlogById(vlogId);
});

final getVlogsByBoardProvider = StreamProvider.family((ref, String boardId) {
  final vlogController = ref.watch(vlogControllerProvider.notifier);
  return vlogController.getVlogsByBoardId(boardId);
});
// Get vlogCommentsProvider

class VlogController extends StateNotifier<bool> {
  final VlogRepository _vlogRepository;
  final StorageRepository _storageRepository;
  final Ref _ref;

  VlogController({
    required VlogRepository vlogRepository,
    required Ref ref,
    required StorageRepository storageRepository,
  })  : _vlogRepository = vlogRepository,
        _storageRepository = storageRepository,
        _ref = ref,
        super(false);

  void saveVlog({
    required BuildContext context,
    required String title,
    required Board selectedBoard,
    required File? file,
    required Uint8List? webFile,
  }) async {
    state = true;
    String vlogId = const Uuid().v1();
    final user = _ref.read(userProvider)!;
    final videoRes = await _storageRepository.storeFile(
      path: 'vlogs/${selectedBoard.id}',
      id: vlogId,
      file: file,
      webFile: webFile,
    );

    videoRes.fold((l) => showSnackBar(context, l.message), (r) async {
      final Vlog post = Vlog(
        id: vlogId,
        title: title,
        boardName: selectedBoard.name,
        boardId: selectedBoard.id,
        upvotes: [],
        downvotes: [],
        commentCount: 0,
        username: user.name,
        uid: user.uid,
        createdAt: DateTime.now(),
        link: r,
      );

      final res = await _vlogRepository.addVlog(post);
      state = false;
      res.fold((l) => showSnackBar(context, l.message), (r) {
        showSnackBar(context, 'Saved to board successfully!');
        Routemaster.of(context).pop();
      });
    });
  }

  void deleteVlog(Vlog vlog, BuildContext context) async {
    final res = await _vlogRepository.deleteVlog(vlog);
    res.fold((l) => null,
        (r) => showSnackBar(context, 'Vlog deleted successfully!'));
  }

  void upvote(Vlog post) async {
    final uid = _ref.read(userProvider)!.uid;
    _vlogRepository.upvote(post, uid);
  }

  void downvote(Vlog post) async {
    final uid = _ref.read(userProvider)!.uid;
    _vlogRepository.downvote(post, uid);
  }

  Stream<Vlog> getVlogById(String postId) {
    return _vlogRepository.getVlogById(postId);
  }

  Stream<List<Vlog>> getVlogsByBoardId(String boardId) {
    return _vlogRepository.getVlogsByBoardId(boardId);
  }
}
