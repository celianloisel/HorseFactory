import 'package:horse_factory/models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/auth.dart';

class ProfileAppBar extends StatelessWidget {
  final User? user;
  final List<OverlayEntry> _overlayEntries;

  const ProfileAppBar({this.user, required List<OverlayEntry> overlayEntries})
      : _overlayEntries = overlayEntries;

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
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: '${user!.email}',
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: Colors.black,
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
          tooltip: 'Retour vers la page accueil',
        ),
      ),
      actions: [
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(right: 8.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black,
          ),
          child: ElevatedButton(
            onPressed: () {
              Provider.of<AuthModel>(context, listen: false).logout(); // Déconnexion de l'utilisateur
            },
            child: Text('Logout'),
          )

        ),
      ],
    );
  }

  signOut(BuildContext context) {
    Navigator.popUntil(context, ModalRoute.withName('/'));
  }
}