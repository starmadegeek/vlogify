import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:vlogify/core/providers/other_providers.dart';
import 'package:vlogify/models/vlog_model.dart';

class VlogCard extends ConsumerWidget {
  final Vlog vlog;

  const VlogCard({super.key, required this.vlog});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chewieController = ref.watch(chewieControllerProvider(vlog.link));

    return GestureDetector(
      onTap: () {
        // Handle vlog card click, navigate to vlog details screen
        Routemaster.of(context).push('/vlog/${vlog.id}');
      },
      child: Card(
        // Customize card appearance as needed
        child: Column(
          children: [
            // Video player widget (replace with your video player implementation)
            // You might want to use a package like chewie for video playback
            // Placeholder for video content
            Chewie(controller: chewieController),
            // Vlog details
            ListTile(
              title: Text(vlog.title),
              subtitle: Text(
                  '${vlog.upvotes.length} Upvotes | ${vlog.downvotes.length} Downvotes'),
            ),
            // Date and comment count
            ListTile(
              title: Text('${vlog.createdAt.toLocal()}'),
              subtitle: Text('${vlog.commentCount} Comments'),
            ),
          ],
        ),
      ),
    );
  }
}
