// loggedOut
// loggedIn

import 'package:flutter/material.dart';
import 'package:vlogify/core/common/board_screen.dart';
import 'package:vlogify/features/auth/login_screen.dart';
import 'package:vlogify/features/board/create_board_screen.dart';
import 'package:vlogify/features/board/edit_board_screen.dart';
import 'package:vlogify/features/home/home_screen.dart';
import 'package:vlogify/features/user_profile/edit_profile_screen.dart';
import 'package:routemaster/routemaster.dart';
import 'package:vlogify/features/user_profile/user_profile_screen.dart';
import 'package:vlogify/features/vlog/add_vlog_screen.dart';

final loggedOutRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: LoginScreen()),
});

final loggedInRoute = RouteMap(
  routes: {
    '/': (_) => const MaterialPage(child: HomeScreen()),
    '/create-board': (_) => const MaterialPage(child: CreateBoardScreen()),
    '/b/:name': (route) => MaterialPage(
          child: BoardScreen(
            boardId: route.pathParameters['id']!,
          ),
        ),
    '/edit-board/:name': (routeData) => MaterialPage(
          child: EditBoardScreen(
            boardId: routeData.pathParameters['id']!,
          ),
        ),
    '/u/:uid': (routeData) => MaterialPage(
          child: UserProfileScreen(
            uid: routeData.pathParameters['uid']!,
          ),
        ),
    '/edit-profile/:uid': (routeData) => MaterialPage(
          child: EditProfileScreen(
            uid: routeData.pathParameters['uid']!,
          ),
        ),
    // '/vlog/:vlogId/comments': (route) => MaterialPage(
    //       child: CommentsScreen(
    //         postId: route.pathParameters['postId']!,
    //       ),
    //     ),
    '/add-vlog': (routeData) => const MaterialPage(
          child: AddVlogScreen(),
        ),
  },
);
