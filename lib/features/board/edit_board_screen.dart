import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vlogify/controllers/board_controller.dart';
import 'package:vlogify/core/common/error_text.dart';
import 'package:vlogify/core/common/loader.dart';
import 'package:vlogify/core/constants/constants.dart';
import 'package:vlogify/core/utils/utils.dart';
import 'package:vlogify/models/board_model.dart';
import 'package:vlogify/responsive/responsive.dart';
import 'package:vlogify/theme/pallete.dart';

class EditBoardScreen extends ConsumerStatefulWidget {
  final String boardId;
  const EditBoardScreen({
    super.key,
    required this.boardId,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditBoardScreenState();
}

class _EditBoardScreenState extends ConsumerState<EditBoardScreen> {
  File? bannerFile;
  Uint8List? bannerWebFile;

  late TextEditingController nameController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(
        text: ref.read(getBoardByIdProvider(widget.boardId)).value?.name);
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  void selectBannerImage() async {
    final res = await pickImage();

    if (res != null) {
      if (kIsWeb) {
        setState(() {
          bannerWebFile = res.files.first.bytes;
        });
      } else {
        setState(() {
          bannerFile = File(res.files.first.path!);
        });
      }
    }
  }

  void save(Board board) {
    ref.read(boardControllerProvider.notifier).editBoard(
          bannerFile: bannerFile,
          context: context,
          board: board,
          name: nameController.text.trim(),
          bannerWebFile: bannerWebFile,
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(boardControllerProvider);
    final currentTheme = ref.watch(themeNotifierProvider);

    return ref.watch(getBoardByIdProvider(widget.boardId)).when(
          data: (board) => Scaffold(
            backgroundColor: currentTheme.colorScheme.background,
            appBar: AppBar(
              title: const Text('Edit Board'),
              centerTitle: false,
              actions: [
                TextButton(
                  onPressed: () => save(board),
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
                          SizedBox(
                            height: 200,
                            child: Stack(
                              children: [
                                GestureDetector(
                                  onTap: selectBannerImage,
                                  child: DottedBorder(
                                    borderType: BorderType.RRect,
                                    radius: const Radius.circular(10),
                                    dashPattern: const [10, 4],
                                    strokeCap: StrokeCap.round,
                                    color: currentTheme
                                        .textTheme.bodyMedium!.color!,
                                    child: Container(
                                      width: double.infinity,
                                      height: 150,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: bannerWebFile != null
                                          ? Image.memory(bannerWebFile!)
                                          : bannerFile != null
                                              ? Image.file(bannerFile!)
                                              : board.banner.isEmpty ||
                                                      board.banner ==
                                                          Constants
                                                              .bannerDefault
                                                  ? const Center(
                                                      child: Icon(
                                                        Icons
                                                            .camera_alt_outlined,
                                                        size: 40,
                                                      ),
                                                    )
                                                  : Image.network(board.banner),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          TextField(
                            controller: nameController,
                            decoration: InputDecoration(
                              filled: true,
                              hintText: 'Name',
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.blue),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(18),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
          loading: () => const Loader(),
          error: (error, stackTrace) => ErrorText(
            error: error.toString(),
          ),
        );
  }
}
