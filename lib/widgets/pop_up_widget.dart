import 'package:flutter/material.dart';

class PopUpWidget extends StatefulWidget {
  const PopUpWidget({
    Key? key,
    required this.title,
    required this.content,
    required this.acceptButtonText,
    required this.acceptButtonFunction,
    cancelButtonText,
  }) : super(key: key);

  final String title;
  final Widget content;
  final String acceptButtonText;
  final Function() acceptButtonFunction;
  final String cancelButtonText = '';

  @override
  PopUpWidgetState createState() => PopUpWidgetState();
}

class PopUpWidgetState extends State<PopUpWidget> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Text(widget.title),
      content: widget.content,
      actions: [
        TextButton(
          child: Text(widget.acceptButtonText),
          onPressed: () {
            widget.acceptButtonFunction();
          },
        ),
        if (widget.cancelButtonText != '')
          TextButton(
            child: Text(widget.cancelButtonText),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
      ],
    );
  }
}
