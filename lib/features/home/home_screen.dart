import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vlogify/controllers/board_controller.dart';
import 'package:vlogify/core/common/boards_display.dart';
import 'package:vlogify/controllers/auth_controller.dart';
import 'package:vlogify/features/home/search_board_delegate.dart';
import 'package:vlogify/features/home/profile_drawer.dart';
import 'package:vlogify/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _page = 0;

  void displayEndDrawer(BuildContext context) {
    Scaffold.of(context).openEndDrawer();
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    final currentTheme = ref.watch(themeNotifierProvider);

    final tabWidgets = [
      BoardsTab(streamProvider: userBoardsProvider(user.uid)),
      BoardsTab(streamProvider: userFollwedBoardsProvider(user.uid)),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: SearchBoardDelegate(ref));
            },
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
              Routemaster.of(context).push('/add-vlog');
            },
            icon: const Icon(Icons.add),
          ),
          Builder(builder: (context) {
            return IconButton(
              icon: CircleAvatar(
                backgroundImage: NetworkImage(user.profilePic),
              ),
              onPressed: () => displayEndDrawer(context),
            );
          }),
        ],
      ),
      body: tabWidgets[_page],
      // drawer: const CommunityListDrawer(),
      endDrawer: const ProfileDrawer(),
      bottomNavigationBar: kIsWeb
          ? null
          : CupertinoTabBar(
              activeColor: currentTheme.iconTheme.color,
              backgroundColor: currentTheme.colorScheme.background,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.account_circle),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.auto_awesome),
                  label: '',
                ),
              ],
              onTap: onPageChanged,
              currentIndex: _page,
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // start video recording
          Routemaster.of(context).push('record');
        },
        tooltip: 'New Vlog',
        child: const Icon(Icons.video_camera_front),
      ),
    );
  }
}
