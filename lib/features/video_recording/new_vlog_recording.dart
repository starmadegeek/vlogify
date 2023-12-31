import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vlogify/core/bloc/camera/camera_bloc.dart';
import 'package:vlogify/core/utils/camera_utils.dart';
import 'package:vlogify/core/utils/permission_utils.dart';
import 'package:vlogify/features/video_recording/pages/camera_page.dart';

class NewRecording extends StatelessWidget {
  const NewRecording({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return CameraBloc(
          cameraUtils: CameraUtils(),
          permissionUtils: PermissionUtils(),
        )..add(const CameraInitialize(recordingLimit: 15));
      },
      child: const CameraPage(),
    );
  }
}
