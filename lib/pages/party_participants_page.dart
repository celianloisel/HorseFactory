import 'package:flutter/material.dart';
import 'package:horse_factory/models/party.dart';
import 'package:horse_factory/models/user.dart';
import 'package:horse_factory/utils/mongo_database.dart';

class PartyParticipantsPage extends StatefulWidget {
  const PartyParticipantsPage(
      {Key? key, required this.title, required this.party, required this.user})
      : super(key: key);

  final String title;
  final Party party;
  final User user;

  @override
  _PartyParticipantsPageState createState() => _PartyParticipantsPageState();
}

class _PartyParticipantsPageState extends State<PartyParticipantsPage> {
  bool isUserParticipant = false;

  @override
  void initState() {
    super.initState();
    isUserParticipant = isUserAlreadyParticipant();
  }

  bool isUserAlreadyParticipant() {
    return widget.party.participants?.contains(widget.user.id) ?? false;
  }

  void addUserAsParticipant() {
    if (!isUserParticipant) {
      MongoDatabase().addParticipant(widget.party.id, widget.user.id);

      setState(() {
        isUserParticipant = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              "Participants",
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 200.0,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.party.participants?.length ?? 0,
                itemBuilder: (context, index) {
                  final participant = widget.party.participants?[index];
                  return Card(
                    child: ListTile(
                      title: Text(participant.toString()),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: isUserParticipant
          ? null
          : FloatingActionButton(
              onPressed: addUserAsParticipant,
              tooltip: 'Ajouter un participant',
              child: const Icon(Icons.add),
            ),
    );
  }
}
