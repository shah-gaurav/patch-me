import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
  late List<Widget> screens;

  @override
  void initState() {
    super.initState();
    screens = [
      const Placeholder(),
      ProfilePage(childRecordKey: widget.recordKey)
    ];
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.read<AppState>();
    var child = appState.getChild(widget.recordKey);
    if (child == null) {
      return const SizedBox.shrink();
    }
    return Scaffold(
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
        ));
  }
}
