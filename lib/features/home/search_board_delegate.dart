import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vlogify/controllers/board_controller.dart';
import 'package:vlogify/core/common/error_text.dart';
import 'package:vlogify/core/common/loader.dart';
import 'package:routemaster/routemaster.dart';

class SearchBoardDelegate extends SearchDelegate {
  final WidgetRef ref;
  SearchBoardDelegate(this.ref);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.close),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    return const SizedBox();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ref.watch(searchBoardProvider(query)).when(
          data: (boards) => ListView.builder(
            itemCount: boards.length,
            itemBuilder: (BuildContext context, int index) {
              final board = boards[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(board.banner),
                ),
                title: Text(board.name),
                onTap: () => navigateToBoard(context, board.name),
              );
            },
          ),
          error: (error, stackTrace) => ErrorText(
            error: error.toString(),
          ),
          loading: () => const Loader(),
        );
  }

  void navigateToBoard(BuildContext context, String boardName) {
    Routemaster.of(context).push('/b/$boardName');
  }
}
