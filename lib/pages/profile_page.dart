import 'package:flutter/material.dart';
import 'package:horse_factory/models/user.dart';
import '../appBar/profile_appBar.dart';

class Profile extends StatelessWidget {
  late User user;

  Profile({required this.user});

  @override
  Widget build(BuildContext context) {
    final overlayEntries = <OverlayEntry>[];

    return CustomScrollView(
      slivers: <Widget>[
        ProfileAppBar(user: user, overlayEntries: overlayEntries),
        const SliverToBoxAdapter(
          child: SizedBox(height: 20),
        ),
      ],
    );
  }
}
