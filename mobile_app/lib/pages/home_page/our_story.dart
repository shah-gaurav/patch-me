import 'package:flutter/material.dart';

import 'patch_me_video.dart';

class OurStory extends StatelessWidget {
  const OurStory({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              'Our Story',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Dedicated to my daughter Aamani',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 5.0),
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
    );
  }
}
