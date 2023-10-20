import 'package:flutter/material.dart';
import 'package:horse_factory/models/user.dart';
import 'package:horse_factory/utils/mongo_database.dart';
import 'package:horse_factory/widgets/info_card.dart';

class MemberPage extends StatefulWidget {
  const MemberPage({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  _MemberPageState createState() => _MemberPageState();
}

class _MemberPageState extends State<MemberPage> {
  List<User> users = [];
  MongoDatabase mongoDatabase = MongoDatabase();
  bool isLoading = true;

  @override
  void initState() {
    loadUsers();
    super.initState();
  }

  Future<void> loadUsers() async {
    final usersList = await mongoDatabase.getUsers();
    setState(() {
      users = usersList;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isUserAdmin = widget.user.roles.contains('ADMIN');

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Member Page'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Membres'),
              Tab(text: 'Chevaux'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            isLoading
                ? const Center(
              child: CircularProgressIndicator(),
            )
                : SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(height: 20),
                    const Text(
                      'Liste des membres',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 20),
                    for (int index = 0; index < users.length; index++)
                      InfoCard(
                        title: users[index].userName,
                        subtitle: users[index].email,
                        icon: Icons.supervised_user_circle,
                        buttonText: (isUserAdmin && users[index].id != widget.user.id)
                            ? 'Supprimer'
                            : null,
                        onPressed: (isUserAdmin && users[index].id != widget.user.id)
                            ? () async {
                          await mongoDatabase.deleteUser(users[index].id);
                          loadUsers();
                        }
                            : null,
                      ),
                  ],
                ),
              ),
            ),
            const Center(
              child: Text('This is Page 2'),
            ),
          ],
        ),
      ),
    );
  }
}
