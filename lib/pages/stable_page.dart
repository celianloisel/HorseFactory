import 'package:flutter/material.dart';
import 'package:horse_factory/appBar/home_appBar.dart';
import 'package:horse_factory/models/party.dart';
import 'package:horse_factory/models/user.dart';
import 'package:horse_factory/pages/lessons_page.dart';
import 'package:horse_factory/pages/member_page.dart';
import 'package:horse_factory/pages/party_participants_page.dart';
import 'package:horse_factory/utils/mongo_database.dart';
import 'package:horse_factory/widgets/create_party_pop_up.dart';
import 'package:horse_factory/widgets/info_card.dart';
import 'package:intl/intl.dart';

class StablePage extends StatefulWidget {
  const StablePage({Key? key, required this.title, required this.user})
      : super(key: key);

  final String title;
  final User user;

  @override
  StablePageState createState() => StablePageState();
}

class StablePageState extends State<StablePage> {
  final MongoDatabase mongoDatabase = MongoDatabase();

  List<Party> parties = [];

  @override
  void initState() {
    super.initState();
    refreshParties();
  }

  Future<void> refreshParties() async {
    final partyList = await mongoDatabase.getParties();
    setState(() {
      parties = partyList.cast<Party>();
    });
  }

  Future<void> _showCreatePartyDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return CreatePartyPopUp(
          onPartyCreated: refreshParties,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: HomeAppBar(title: widget.title, user: widget.user),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Horse Factory',
                    style: TextStyle(
                      fontSize: 32, // Increase font size
                      fontWeight: FontWeight.bold,
                      color: Colors.blue, // Change text color
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Bienvenue dans l\'espace de l\'écurie',
                    style: TextStyle(
                      fontSize: 20, // Increase font size
                      color: Colors.grey, // Change text color
                    ),
                  ),
                  const SizedBox(height: 48),
                  InfoCard(
                    title: 'Membres de l\'écurie',
                    subtitle: 'Liste des membres de l\'écurie',
                    buttonText: 'Voir',
                    icon: Icons.people,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MemberPage(user: widget.user),
                        ),
                      );
                    },
                  ),
                  InfoCard(
                    title: 'Cours',
                    subtitle: 'Liste des cours',
                    buttonText: 'Voir',
                    icon: Icons.menu_book_outlined,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LessonsPage(user: widget.user),
                        ),
                      );
                    },
                  ),
                  Card(
                    elevation: 3,
                    color: Colors.grey[200],
                    child: parties.isEmpty
                        ? _buildNoPartiesContent(context)
                        : _buildPartiesList(context),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Widget _buildNoPartiesContent(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Text(
            "Liste des soirées",
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const Divider(
          thickness: 1,
          height: 0,
        ),
        const Padding(
          padding: EdgeInsets.symmetric(
            vertical: 48,
          ),
          child: Text(
            "Aucune soirée de prévue",
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const Divider(
          thickness: 1,
          height: 0,
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
            ),
            onPressed: () => _showCreatePartyDialog(context),
            child: const Text(
              "Proposer une soirée",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPartiesList(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Text(
            "Liste des soirées",
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const Divider(
          thickness: 1,
          height: 0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 8,
          ),
          child: SizedBox(
            height: 200.0,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: parties.length,
              itemBuilder: (context, index) {
                final party = parties[index];
                final user = widget.user;
                return Card(
                  child: ListTile(
                    style: ListTileStyle.drawer,
                    tileColor: Colors.white,
                    title: Text(party.name),
                    subtitle: Text(
                        "${party.dateTime.day}/${party.dateTime.month}/${party.dateTime.year} à ${party.dateTime.hour}h${party.dateTime.minute}"),
                    trailing: IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      onPressed: () =>
                          _showPartyDetailsDialog(context, party, user),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        const Divider(
          thickness: 2,
          height: 0,
        ),
        Container(
          padding: const EdgeInsets.all(8),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
            ),
            onPressed: () => _showCreatePartyDialog(context),
            child: const Text(
              "Proposer une soirée",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _showPartyDetailsDialog(
      BuildContext context, Party party, User user) async {
    final formattedDate =
        DateFormat('dd/MM/yyyy à HH:mm').format(party.dateTime);

    String imagePath;
    if (party.type == 'Apéro') {
      imagePath = 'assets/images/apero.jpg';
    } else {
      imagePath = 'assets/images/resto.jpg';
    }

    final user = widget.user;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Set to true to avoid scrolling
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (BuildContext context) {
        return SingleChildScrollView(
          // Wrap the contents in a SingleChildScrollView
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    height: 5,
                    decoration: const BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    width: 100,
                  ),
                ),
                const SizedBox(height: 24),
                Image(image: AssetImage(imagePath)),
                const SizedBox(height: 24),
                Center(
                  child: Text(
                    party.name,
                    style: const TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  "${party.type} le $formattedDate",
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                Card(
                  child: ListTile(
                    style: ListTileStyle.list,
                    tileColor: Colors.white,
                    title: const Text("Participants"),
                    trailing: IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PartyParticipantsPage(
                              title: 'Participants',
                              party: party,
                              user: user,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Card(
                  child: ListTile(
                    style: ListTileStyle.list,
                    tileColor: Colors.white,
                    title: const Text("Comments"),
                    trailing: IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      onPressed: () {},
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }
}
