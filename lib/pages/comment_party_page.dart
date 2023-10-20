import 'package:flutter/material.dart';
import 'package:horse_factory/models/party.dart';
import 'package:horse_factory/models/user.dart';
import 'package:horse_factory/utils/mongo_database.dart';

class CommentPartyPage extends StatefulWidget {
  const CommentPartyPage({
    Key? key,
    required this.title,
    required this.party,
    required this.user,
  }) : super(key: key);

  final String title;
  final Party party;
  final User user;

  @override
  _CommentPartyPageState createState() => _CommentPartyPageState();
}

class _CommentPartyPageState extends State<CommentPartyPage> {
  final TextEditingController _commentController = TextEditingController();
  List<String>? comments;

  Future<void> loadComments() async {
    final loadedComments = await MongoDatabase().getComments(widget.party.id);
    setState(() {
      comments = loadedComments;
    });
  }

  @override
  void initState() {
    super.initState();
    loadComments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 24),
            Text(
              "Commentaires",
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 24),
            TextField(
              controller: _commentController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Commentaire',
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                String comment = _commentController.text;
                MongoDatabase().addComment(
                    widget.party.id, "${widget.user.userName} : $comment");

                _commentController.clear();
                FocusScope.of(context).unfocus();

                loadComments();
              },
              child: Text('Envoyer'),
            ),
            SizedBox(height: 24),
            if (comments != null)
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: comments!.map((comment) => Text(comment)).toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _commentController.dispose(); // Dispose of the controller when done.
    super.dispose();
  }
}
