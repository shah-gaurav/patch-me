import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:patch_me/state/app_state.dart';
import 'package:provider/provider.dart';

import 'home_page/children.dart';
import 'home_page/our_story.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    return LoaderOverlay(
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(80.0, 40.0, 80.0, 20.0),
                  child:
                      Image(image: AssetImage('assets/images/patch-me-logo.png')),
                ),
                Text(
                  'Patch Me',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Helping you track your child\'s eye patching',
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 10,
                ),
                if (appState.children.isEmpty)
                  const OurStory()
                else
                  Children(appState: appState),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    context.push('/add-child');
                  },
                  child: const Text('Add Your Child'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
