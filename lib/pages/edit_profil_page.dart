import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:horse_factory/models/auth.dart';
import 'package:horse_factory/models/user.dart';
import 'package:horse_factory/pages/login_page.dart';
import '../utils/mongo_database.dart';

class EditProfilPage extends StatefulWidget {
  late User user;

  EditProfilPage({Key? key, required this.user}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilPage> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController ffeController = TextEditingController();
  bool isObscurePassword = true;

  final mongoDatabase = MongoDatabase();

  @override
  void initState() {
    super.initState();
    userNameController.text = widget.user.userName;
    emailController.text = widget.user.email;
    ageController.text = widget.user.age;
    phoneNumberController.text = widget.user.phoneNumber;
    ffeController.text = widget.user.ffe;
  }

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
                buildTextField("Pseudo", userNameController, false),
                buildTextField("Email", emailController, false),
                buildTextField("Mot de passe", passwordController, true),
                buildTextField("Age", ageController, false),
                buildTextField("Numéro de téléphone", phoneNumberController, false),
                buildTextField("FFE link", ffeController, false),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        // A faire
                      },
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
                      onPressed: () {
                        saveUserProfile();
                      },
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
      String labelText, TextEditingController controller, bool isPasswordTextField) {
    return Padding(
      padding: EdgeInsets.only(bottom: 30, left: 16, right: 16),
      child: TextField(
        controller: controller,
        obscureText: isPasswordTextField ? isObscurePassword : false,
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

  Future<void> saveUserProfile() async {
    final updateduserName = userNameController.text;
    final updatedEmail = emailController.text;
    final updatedAge = ageController.text;
    final updatedPassword = passwordController.text;
    final updatePhoneNumer = phoneNumberController.text;
    final updatedFfe = ffeController.text;

    final updatedUser = User(
      id: widget.user.id,
      userName: updateduserName,
      email: updatedEmail,
      password: updatedPassword,
      age: updatedAge,
      phoneNumber: updatePhoneNumer,
      ffe: updatedFfe,
      profileImageBytes: widget.user.profileImageBytes,
    );

    Provider.of<AuthModel>(context, listen: false).updateUser(updatedUser);

    await mongoDatabase.updateUserInDatabase(updatedUser, context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Profil mis à jour avec succès"),
      ),
    );

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => EditProfilPage(user: updatedUser),
      ),
    );
  }

}
