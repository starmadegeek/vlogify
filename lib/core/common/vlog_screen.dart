import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vlogify/core/providers/other_providers.dart';
import 'package:vlogify/models/vlog_model.dart';

class VlogDetailsScreen extends ConsumerWidget {
  final Vlog vlog;

  const VlogDetailsScreen({super.key, required this.vlog});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
  }
}
