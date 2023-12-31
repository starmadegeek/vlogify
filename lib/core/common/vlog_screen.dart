import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vlogify/controllers/vlog_controller.dart';
import 'package:vlogify/core/common/error_text.dart';
import 'package:vlogify/core/common/loader.dart';
import 'package:vlogify/core/providers/other_providers.dart';

class VlogDetailsScreen extends ConsumerWidget {
  final String vlogId;

  const VlogDetailsScreen({super.key, required this.vlogId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vlogWatch = ref.watch(getVlogByIdProvider(vlogId));

    return vlogWatch.when(
      loading: () => const Loader(),
      error: (error, stackTrace) => ErrorText(error: error.toString()),
      data: (vlog) {
        final chewieController = ref.watch(chewieControllerProvider(vlog.link));
        return Scaffold(
          appBar: AppBar(
            title: Text(vlog.title),
          ),
          body: Column(
            children: [
              // Chewie player widget
              Chewie(controller: chewieController),
              // Vlog details (unchanged)
              ListTile(
                title: Text(vlog.title),
                subtitle: Text(
                    '${vlog.upvotes.length} Upvotes | ${vlog.downvotes.length} Downvotes'),
              ),
              // Date and comment count
              ListTile(
                title: Text('Created on ${vlog.createdAt.toLocal()}'),
                subtitle: Text('${vlog.commentCount} Comments'),
              ),
              // Placeholder for comments (you need to implement this part separately)
              const Expanded(
                child: Center(
                  child: Text('Swipe up to view comments'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
