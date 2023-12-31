import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:patch_me/pages/components/patch_me_video.dart';
import 'package:patch_me/state/app_state.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    return Scaffold(
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
                height: 20,
              ),
              if (appState.children.isEmpty)
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Text(
                          'Our Story',
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 40.0, vertical: 15.0),
                          child: PatchMeVideo(),
                        ),
                        Text(
                          'Add your child to start tracking their eye patching progress',
                          style: Theme.of(context).textTheme.titleMedium,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                )
              else
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: ListView.builder(
                      itemCount: appState.children.length,
                      itemBuilder: (context, index) {
                        var child = appState.children[index];
                        return Card(
                          child: ListTile(
                            tileColor: Theme.of(context).colorScheme.secondary,
                            leading: const Icon(Icons.child_care),
                            title: Text(child.name),
                            trailing: const Icon(Icons.arrow_forward_ios),
                            onTap: () {
                              Navigator.pushNamed(context, '/child');
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
              const SizedBox(
                height: 20,
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
    );
  }
}
