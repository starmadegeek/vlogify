import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';
import 'package:vlogify/core/constants/constants.dart';
import 'package:vlogify/core/constants/firebase_constants.dart';
import 'package:vlogify/core/utils/failure.dart';
import 'package:vlogify/core/providers/storage_repository_provider.dart';
import 'package:vlogify/core/utils/utils.dart';
import 'package:vlogify/controllers/auth_controller.dart';
import 'package:vlogify/models/board_model.dart';
import 'package:vlogify/models/vlog_model.dart';
import 'package:routemaster/routemaster.dart';
import 'package:vlogify/repositories/board_repository.dart';
import 'package:vlogify/repositories/vlog_repository.dart';

final userBoardsProvider = StreamProvider.family((ref, String uid) {
  final boardController = ref.watch(boardControllerProvider.notifier);
  return boardController.getUserBoards(uid);
});

final userFollwedBoardsProvider = StreamProvider.family((ref, String uid) {
  final boardController = ref.watch(boardControllerProvider.notifier);
  return boardController.getUserFollowedBoards(uid);
});

final boardControllerProvider =
    StateNotifierProvider<BoardController, bool>((ref) {
  final boardRepository = ref.watch(boardRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  final vlogRepository = ref.watch(vlogRepositoryProvider);
  return BoardController(
    boardRepository: boardRepository,
    storageRepository: storageRepository,
    vlogRepository: vlogRepository,
    ref: ref,
  );
});

// final getBoardByNameProvider = StreamProvider.family((ref, String name) {
//   return ref.watch(boardControllerProvider.notifier).getBoardByName(name);
// });
final getBoardByIdProvider = StreamProvider.family((ref, String boardId) {
  return ref.watch(boardControllerProvider.notifier).getBoardById(boardId);
});

final searchBoardProvider = StreamProvider.family((ref, String query) {
  return ref.watch(boardControllerProvider.notifier).searchBoard(query);
});

final getBoardVlogsProvider = StreamProvider.family((ref, String boardId) {
  return ref.read(boardControllerProvider.notifier).getBoardVlogs(boardId);
});

class BoardController extends StateNotifier<bool> {
  final BoardRepository _boardRepository;
  final StorageRepository _storageRepository;
  final VlogRepository _vlogRepository;
  final Ref _ref;
  BoardController({
    required BoardRepository boardRepository,
    required Ref ref,
    required StorageRepository storageRepository,
    required VlogRepository vlogRepository,
  })  : _boardRepository = boardRepository,
        _storageRepository = storageRepository,
        _vlogRepository = vlogRepository,
        _ref = ref,
        super(false);

  void createBoard(String name, BuildContext context) async {
    state = true;
    final user = _ref.read(userProvider);
    Board board = Board(
        id: const Uuid().v1(),
        name: name,
        banner: Constants.bannerDefault,
        isPublic: false,
        ownerId: user?.uid ?? " ",
        ownerName: user?.name ?? " ",
        isDefault: false);

    final res = await _boardRepository.createBoard(board);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, 'Board created successfully!');
      Routemaster.of(context).pop();
    });
  }

  void followOrUnfollowBoard(Board board, BuildContext context) async {
    final user = _ref.read(userProvider);
    var isFollowingRes =
        await _boardRepository.isFollowing(user!.uid, board.id);
    bool isFollowing = false;
    isFollowingRes.fold((l) => showSnackBar(context, l.message), (r) {
      isFollowing = r;
    });

    Either<Failure, void> res;
    if (isFollowing) {
      res = await _boardRepository.unfollowBoard(user.uid, board.id);
    } else {
      res = await _boardRepository.followBoard(user.uid, board.id);
    }

    res.fold((l) => showSnackBar(context, l.message), (r) {
      if (isFollowing) {
        showSnackBar(context, 'Board left successfully!');
      } else {
        showSnackBar(context, 'Board joined successfully!');
      }
    });
  }

  Stream<List<Board>> getUserBoards(String uid) {
    return _boardRepository.getUserBoards(uid);
  }

  Stream<List<Board>> getUserFollowedBoards(String uid) {
    return _boardRepository.getUserFollowedBoards(uid);
  }

  Stream<Board> getBoardById(String boardId) {
    final uid = _ref.read(userProvider)!.uid;
    return _boardRepository.getUserBoard(uid, boardId);
  }

  Stream<List<Vlog>> getBoardVlogs(String boardId) {
    return _vlogRepository.getVlogsByBoardId(boardId);
  }

  void editBoard({
    required File? bannerFile,
    required Uint8List? bannerWebFile,
    required BuildContext context,
    required Board board,
  }) async {
    state = true;

    if (bannerFile != null || bannerWebFile != null) {
      // boards/banner/memes
      final res = await _storageRepository.storeFile(
        path: FirebaseConstants.boardsBanner,
        id: board.id,
        file: bannerFile,
        webFile: bannerWebFile,
      );
      res.fold(
        (l) => showSnackBar(context, l.message),
        (r) => board = board.copyWith(banner: r),
      );
    }

    final res = await _boardRepository.editBoard(board);
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) => Routemaster.of(context).pop(),
    );
  }

  Stream<List<Board>> searchBoard(String query) {
    return _boardRepository.searchBoard(query);
  }
}
