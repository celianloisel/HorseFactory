import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:horse_factory/models/auth.dart';
import 'package:horse_factory/models/user.dart';
import 'package:horse_factory/pages/login_page.dart';

class ProfileAppBar extends StatelessWidget {
  final User? user;

  const ProfileAppBar({
    this.user,
    required List<OverlayEntry> overlayEntries,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: MediaQuery.of(context).size.height * 0.40,
      pinned: true,
      title: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '${user!.userName}\n',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: '${user!.email}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Hero(
          tag: user!.profilePictureUrl!,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: FileImage(File(user!.profilePictureUrl!)),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white, Colors.transparent],
                  begin: Alignment.topLeft,
                ),
              ),
            ),
          ),
        ),
      ),
      leading: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(left: 8.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black,
        ),
        child: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back),
          tooltip: 'Retour vers la page d\'accueil',
        ),
      ),
      actions: [
        Container(
          width: 50,
          height: 50,
          margin: EdgeInsets.only(right: 8.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black,
          ),
          child: InkWell(
            onTap: () {
              signOut(context);
            },
            child: Center(
              child: Text(
                'Logout',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  Future<void> signOut(BuildContext context) async {
    print('Log out');
    Provider.of<AuthModel>(context, listen: false).logout();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
          (Route<dynamic> route) => false,
    );
  }
}
