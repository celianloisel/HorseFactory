import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:horse_factory/models/auth.dart';
import 'package:horse_factory/models/user.dart';
import 'package:horse_factory/pages/login_page.dart';

class EditProfilPage extends StatefulWidget {
  late User user;

  EditProfilPage({Key? key, required this.user}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilPage> {
  bool isObscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: MediaQuery.of(context).size.height * 0.40,
            pinned: true,
            title: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '${widget.user.userName}\n',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: '${widget.user.email}',
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
                tag: 'user_profile_image',
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: MemoryImage(widget.user.profileImageBytes!),
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
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(height: 30),
                buildTextField("name", "", false),
                buildTextField("Email", "", false),
                buildTextField("Age", "", false),
                buildTextField("Password", "", true),
                buildTextField("horse", "", false),
                buildTextField("FFE link", "", false),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton(
                      onPressed: () {},
                      child: Text(
                        "Cancel",
                        style: TextStyle(fontSize: 15, color: Colors.black),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: Text(
                        "Save",
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.black,
                        padding: EdgeInsets.symmetric(horizontal: 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTextField(
      String labelText, String placeholder, bool isPasswordTextField) {
    return Padding(
      padding: EdgeInsets.only(bottom: 30, left: 16, right: 16), // Ajoutez des marges gauche et droite
      child: TextField(
        obscureText: isObscurePassword ? isObscurePassword : false,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0),
          isDense: true,
          suffixIcon: isPasswordTextField
              ? IconButton(
            onPressed: () {
              setState(() {
                isObscurePassword = !isObscurePassword;
              });
            },
            icon: Icon(Icons.remove_red_eye, color: Colors.grey),
          )
              : null,
          labelText: labelText,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintText: placeholder,
          hintStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
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
