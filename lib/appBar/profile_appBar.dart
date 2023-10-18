import 'package:horse_factory/models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/auth.dart';
import '../pages/login_page.dart';
import '../services/authentication_service.dart';

class ProfileAppBar extends StatelessWidget {
  final User? user;
  final List<OverlayEntry> _overlayEntries;
  final AuthService _authService;

  const ProfileAppBar({
    this.user,
    required List<OverlayEntry> overlayEntries,
    required AuthService authService,
  }) : _overlayEntries = overlayEntries, _authService = authService;

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
                color: Colors.white, // Texte en blanc
                fontSize: 20, // Taille de la police
                fontWeight: FontWeight.bold, // Gras
              ),
            ),
            TextSpan(
              text: '${user!.email}',
              style: TextStyle(
                color: Colors.white, // Texte en blanc
                fontSize: 16, // Taille de la police
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
                image: NetworkImage(user!.profilePictureUrl!),
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
