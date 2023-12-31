import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vlogify/controllers/auth_controller.dart';
import 'package:vlogify/controllers/board_controller.dart';
import 'package:vlogify/controllers/vlog_controller.dart';
import 'package:vlogify/core/common/error_text.dart';
import 'package:vlogify/core/common/loader.dart';
import 'package:vlogify/core/utils/utils.dart';
import 'package:vlogify/models/board_model.dart';
import 'package:vlogify/responsive/responsive.dart';

class AddVlogScreen extends ConsumerStatefulWidget {
  const AddVlogScreen({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddVlogTypeScreenState();
}

class _AddVlogTypeScreenState extends ConsumerState<AddVlogScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  late final String vlogLink;

  List<Board> boards = [];
  Board? selectedBoard;

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descriptionController.dispose();
  }

  void shareVlog() {
    if (true && // TODO videoFile
        titleController.text.isNotEmpty) {
      ref.read(vlogControllerProvider.notifier).saveVlog(
            context: context,
            title: titleController.text.trim(),
            selectedBoard: selectedBoard ?? boards[0],
            file: null,
            webFile: null,
          );
    } else {
      showSnackBar(context, 'Please enter all the fields');
    }
  }

  @override
  Widget build(BuildContext context) {
    // final currentTheme = ref.watch(themeNotifierProvider);
    final isLoading = ref.watch(vlogControllerProvider);
    final String uid = ref.watch(userProvider)!.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Vlog'),
        actions: [
          TextButton(
            onPressed: shareVlog,
            child: const Text('Save'),
          ),
        ],
      ),
      body: isLoading
          ? const Loader()
          : Responsive(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        filled: true,
                        hintText: 'Enter Title here',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(18),
                      ),
                      maxLength: 30,
                    ),
                    const SizedBox(height: 10),
                    // TODO video display
                    const SizedBox(height: 20),
                    const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Select Board',
                      ),
                    ),
                    ref.watch(userBoardsProvider(uid)).when(
                          data: (data) {
                            boards = data;

                            if (data.isEmpty) {
                              return const SizedBox();
                            }

                            return DropdownButton(
                              value: selectedBoard ?? data[0],
                              items: data
                                  .map(
                                    (e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(e.name),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (val) {
                                setState(() {
                                  selectedBoard = val;
                                });
                              },
                            );
                          },
                          error: (error, stackTrace) => ErrorText(
                            error: error.toString(),
                          ),
                          loading: () => const Loader(),
                        ),
                  ],
                ),
              ),
            ),
    );
  }
}
