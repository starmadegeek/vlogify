import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vlogify/core/common/board_card.dart';
import 'package:vlogify/core/common/error_text.dart';
import 'package:vlogify/core/common/loader.dart';
import 'package:vlogify/core/providers/other_providers.dart';
import 'package:vlogify/models/board_model.dart';

class BoardsTab extends ConsumerWidget {
  final StreamProvider<List<Board>> streamProvider;

  const BoardsTab({super.key, required this.streamProvider});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boards = ref.watch(streamProvider);
    final isGridView = ref.watch(gridViewToggleProvider.notifier).state;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              icon: Icon(isGridView ? Icons.view_list : Icons.grid_on),
              onPressed: () {
                ref.read(gridViewToggleProvider.notifier).state = !isGridView;
              },
            ),
          ],
        ),
        Expanded(
          child: boards.when(
            loading: () => const Loader(),
            error: (error, stackTrace) => ErrorText(error: error.toString()),
            data: (boardList) {
              return isGridView
                  ? _buildGridView(boardList)
                  : _buildListView(boardList);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildGridView(List<Board> boards) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemCount: boards.length,
      itemBuilder: (context, index) {
        return BoardCard(
          board: boards[index],
        );
      },
    );
  }

  Widget _buildListView(List<Board> boards) {
    return ListView.builder(
      itemCount: boards.length,
      itemBuilder: (context, index) {
        return BoardCard(
          board: boards[index],
        );
      },
    );
  }
}
