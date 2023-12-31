import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vlogify/controllers/board_controller.dart';
import 'package:vlogify/core/common/loader.dart';
import 'package:vlogify/responsive/responsive.dart';

class CreateBoardScreen extends ConsumerStatefulWidget {
  const CreateBoardScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateBoardScreenState();
}

class _CreateBoardScreenState extends ConsumerState<CreateBoardScreen> {
  final boardNameController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    boardNameController.dispose();
  }

  void createBoard() {
    ref.read(boardControllerProvider.notifier).createBoard(
          boardNameController.text.trim(),
          context,
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(boardControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a community'),
      ),
      body: isLoading
          ? const Loader()
          : Responsive(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.topLeft,
                      child: Text('Board name'),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: boardNameController,
                      decoration: const InputDecoration(
                        hintText: 'daily_turds',
                        filled: true,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(18),
                      ),
                      maxLength: 21,
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: createBoard,
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          )),
                      child: const Text(
                        'Create Board',
                        style: TextStyle(
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
