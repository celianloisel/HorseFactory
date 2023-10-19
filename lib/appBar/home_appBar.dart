import 'dart:io';

import 'package:flutter/material.dart';
import 'package:horse_factory/models/user.dart';
import 'package:horse_factory/pages/profile_page.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final User? user;

  HomeAppBar({required this.user});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('Écuries'),
      actions: [
        if (user != null)
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => Profile(user: user!),
                  ),
                );
              },
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Tooltip(
                  message: 'Votre profil',
                  child: Hero(
                    tag: user!.profilePictureUrl,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: FileImage(File(user!.profilePictureUrl)),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}