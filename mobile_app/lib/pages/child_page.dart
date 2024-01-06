import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:patch_me/models/patch.dart';
import 'package:patch_me/pages/dashboard_page.dart';
import 'package:patch_me/pages/history_page.dart';
import 'package:patch_me/pages/profile_page.dart';
import 'package:patch_me/state/app_state.dart';
import 'package:provider/provider.dart';

class ChildPage extends StatefulWidget {
  final String recordKey;

  const ChildPage({super.key, required this.recordKey});

  @override
  State<ChildPage> createState() => _ChildPageState();
}

class _ChildPageState extends State<ChildPage> {
  int currentIndex = 0;
  late List<Widget> screens = [
    const DashboardPage(),
    const HistoryPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    var appState = context.read<AppState>();
    var child = appState.selectedChild;
    return StreamProvider<Patch>.value(
      value: appState.patchingData,
      initialData: appState.initialPatchingData,
      child: Scaffold(
          appBar: AppBar(
              title: Text(child.name),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  context.pop();
                },
              )),
          body: screens[currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.today),
                label: 'Today',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.history),
                label: 'History',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.child_care),
                label: 'Profile',
              ),
            ],
            currentIndex: currentIndex,
            onTap: (index) {
              setState(() {
                currentIndex = index;
              });
            },
          )),
    );
  }
}
