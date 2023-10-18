import 'package:image_picker/image_picker.dart';
import 'package:horse_factory/models/user.dart';
import 'package:flutter/material.dart';
import 'package:horse_factory/pages/login_page.dart';
import '../appBar/profile_appBar.dart';
import '../services/authentication_service.dart';

class Profile extends StatelessWidget {
  late User user;

  Profile({required this.user});

  bool isValidData(String username, String email) {
    return username == user.userName && email == user.email;
  }

  @override
  Widget build(BuildContext context) {
    final overlayEntries = <OverlayEntry>[];
    final authService = AuthService();

    return CustomScrollView(
      slivers: <Widget>[
        ProfileAppBar(user: user, overlayEntries: overlayEntries, authService: authService),
        SliverToBoxAdapter(
          child: SizedBox(height: 20), // Espace de 20 pixels
        ),
        SliverToBoxAdapter(
          child: Center(
            child: user != null
                ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: () async {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              leading: Icon(Icons.photo),
                              title: Text('Sélectionner une photo depuis la galerie'),
                              onTap: () async {
                                Navigator.pop(context);
                                final image = await ImagePicker().pickImage(source: ImageSource.gallery);
                                if (image != null) {
                                  String cheminImage = image.path;
                                }
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            )
                : Text('Utilisateur non trouvé'),
          ),
        ),
      ],
    );
  }
}
