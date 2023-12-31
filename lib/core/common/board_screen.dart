import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:vlogify/controllers/board_controller.dart';
import 'package:vlogify/controllers/vlog_controller.dart';
import 'package:vlogify/core/common/error_text.dart';
import 'package:vlogify/core/common/loader.dart';
import 'package:vlogify/core/common/vlog_card.dart';

class BoardScreen extends ConsumerWidget {
  final String boardId;

  const BoardScreen({super.key, required this.boardId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final board = ref.watch(getBoardByIdProvider(boardId));
    return board.when(
      loading: () => const Loader(),
      error: (error, stackTrace) => ErrorText(error: error.toString()),
      data: (board) {
        return Scaffold(
          appBar: AppBar(
            title: Text(board.name),
            actions: [
              IconButton(
                onPressed: () {
                  Routemaster.of(context).push('/edit-board/${board.id}');
                },
                icon: const Icon(Icons.edit),
              ),
            ],
          ),
          body: ref.watch(getVlogsByBoardProvider(board.id)).when(
                loading: () => const Loader(),
                error: (error, stackTrace) =>
                    ErrorText(error: error.toString()),
                data: (vlogList) {
                  return ListView.builder(
                    itemCount: vlogList.length,
                    itemBuilder: (context, index) {
                      return VlogCard(vlog: vlogList[index]);
                    },
                  );
                },
              ),
        );
      },
    );
  }
}
