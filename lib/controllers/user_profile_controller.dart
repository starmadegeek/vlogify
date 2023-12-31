import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vlogify/core/constants/firebase_constants.dart';
import 'package:vlogify/core/providers/storage_repository_provider.dart';
import 'package:vlogify/core/utils/utils.dart';
import 'package:vlogify/controllers/auth_controller.dart';
import 'package:vlogify/models/user_model.dart';
import 'package:routemaster/routemaster.dart';
import 'package:vlogify/repositories/user_repository.dart';

final userProfileControllerProvider =
    StateNotifierProvider<UserProfileController, bool>((ref) {
  final userProfileRepository = ref.watch(userRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return UserProfileController(
    userProfileRepository: userProfileRepository,
    storageRepository: storageRepository,
    ref: ref,
  );
});

class UserProfileController extends StateNotifier<bool> {
  final UserRepository _userProfileRepository;
  final StorageRepository _storageRepository;
  final Ref _ref;
  UserProfileController({
    required UserRepository userProfileRepository,
    required Ref ref,
    required StorageRepository storageRepository,
  })  : _userProfileRepository = userProfileRepository,
        _storageRepository = storageRepository,
        _ref = ref,
        super(false);

  void editProfile({
    required File? profileFile,
    required File? bannerFile,
    required Uint8List? profileWebFile,
    required Uint8List? bannerWebFile,
    required BuildContext context,
    required String name,
  }) async {
    state = true;
    UserModel user = _ref.read(userProvider)!;

    if (profileFile != null || profileWebFile != null) {
      final res = await _storageRepository.storeFile(
        path: FirebaseConstants.usersProfile,
        id: user.uid,
        file: profileFile,
        webFile: profileWebFile,
      );
      res.fold(
        (l) => showSnackBar(context, l.message),
        (r) => user = user.copyWith(profilePic: r),
      );
    }

    if (bannerFile != null || bannerWebFile != null) {
      final res = await _storageRepository.storeFile(
        path: FirebaseConstants.usersBanner,
        id: user.uid,
        file: bannerFile,
        webFile: bannerWebFile,
      );
      res.fold(
        (l) => showSnackBar(context, l.message),
        (r) => user = user.copyWith(banner: r),
      );
    }

    user = user.copyWith(name: name);
    final res = await _userProfileRepository.editProfile(user);
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        _ref.read(userProvider.notifier).update((state) => user);
        Routemaster.of(context).pop();
      },
    );
  }
}
